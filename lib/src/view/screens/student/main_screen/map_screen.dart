import 'dart:async';
import 'dart:typed_data';

import 'package:arabi/src/models/student.dart';
import 'package:arabi/src/models/teacher.dart';
import 'package:arabi/src/notifiers/main_screen_notifiers.dart';
import 'package:arabi/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  StreamSubscription _locationSubscription;
  Location _locationTracker = Location();
  Marker marker;
  Circle circle;
  GoogleMapController _controller;

  String notificationBody = "";

  bool thereIsStd = false;
  bool inBus = false;
  bool _loaded = false;

  List<students> allStd = [];
  teachers teacher;

  Map sentNotification = {};

  MainScreenNotifiers provider = Provider.of<MainScreenNotifiers>(
      Constants.navKey.currentContext,
      listen: false);

  final Marker school = Marker(
    markerId: MarkerId('school'),
    position: LatLng(
      31.489574208854606,
      34.44918003130784,
    ),
    infoWindow: InfoWindow(title: 'روضة دنيا الالوان', snippet: '*'),
  );

  Future<void> getData() async {
    teacher = await provider.getTeacherInBus();

    if (teacher != null) {
      inBus = true;
      toast('المعلم ${teacher.name} في الباص في هذه اللحظة');
    } else {
      toast('لم يتم التعرف على وجود احد المعلمين في أي باص');
    }
    thereIsStd = await provider.isStdsStillExist();
    if (thereIsStd) {
      toast('لا زال هناك طلاب في الروضة');
    } else {
      toast('جميع الطلاب في منازلهم');
    }

    allStd = await provider.getAllStds();
    allStd.forEach((e) => sentNotification[e.id] = false);
    print('sentNotification ${sentNotification}');
    if (thereIsStd && inBus) {
      toast('جاري عملية التتبع');
    } else {
      toast('لا يمكنك تتبع المعلم في هذه اللحظة');
    }

    print('inBus ${inBus}');
    print('thereIsStd ${thereIsStd}');
  }

  Future<Uint8List> getMarker() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load("assets/icon/5.png");
    return byteData.buffer.asUint8List();
  }

  void updateMarkerAndCircle(LocationData newLocalData, Uint8List imageData) {
    LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);
    if (!mounted) return;
    this.setState(() {
      marker = Marker(
          markerId: MarkerId("home"),
          position: latlng,
          rotation: newLocalData.heading,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(imageData));
      circle = Circle(
          circleId: CircleId("car"),
          radius: newLocalData.accuracy,
          zIndex: 1,
          strokeColor: Colors.blue,
          center: latlng,
          fillColor: Colors.blue.withAlpha(70));
    });
  }

  void getCurrentLocation() async {
    try {
      Uint8List imageData = await getMarker();
      var location = await _locationTracker.getLocation();
      updateMarkerAndCircle(location, imageData);

      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }

      _locationSubscription =
          _locationTracker.onLocationChanged.listen((newLocalData) async {
        // send notification for the user
        double approximateIncLat =
            newLocalData.latitude + .00200000000000; // approximate increse Lat
        double approximateDecLat =
            newLocalData.latitude - .00200000000000; // approximate decrease Lat

        double approximateIncLong =
            newLocalData.longitude + .00200000000000; // approximate increse Lat
        double approximateDecLong = newLocalData.longitude -
            .00200000000000; // approximate decrease Lat

        allStd.forEach((e) async {
          // print('id ${e.id}');
          // print('approximateIncLat $approximateIncLat');
          // print('approximateDecLat $approximateDecLat');
          // print('approximateIncLong $approximateIncLong');
          // print('approximateDecLong $approximateDecLong');
          // print('e.lat ${e.lat}');
          // print('e.long ${e.long}');
          if (double.parse(e.lat) >= approximateDecLat &&
              double.parse(e.lat) <= approximateIncLat &&
              double.parse(e.long) >= approximateDecLong &&
              double.parse(e.long) <= approximateIncLong) {
            if (!sentNotification[e.id]) {
              print('YES');
              sentNotification[e.id] = true;
              await provider.sendNotidication(
                  e.id,
                  "لقد أوشك الباص على الوصول أرسل/استقبل ابنك/ابنتك ${e.name}",
                  '');
            }
            return;
          }
        });
// location of school
        if (31.489574208854606 >= approximateDecLat &&
            31.489574208854606 <= approximateIncLat &&
            34.44918003130784 >= approximateDecLong &&
            34.44918003130784 <= approximateIncLong) {
          inBus = false;
          await provider.updateTeacherInBus(teacher.id, inBus);
          toast('لقد وصلت المعلمة الروضة ولهذا توقفت عملية التتبع');
          allStd.forEach((e) => sentNotification[e.id] = false);

          if (!mounted) return;
          setState(() {});
        }
        if (inBus && thereIsStd) {
          if (_controller != null) {
            _controller.animateCamera(CameraUpdate.newCameraPosition(
                new CameraPosition(
                    bearing: 192.8334901395799,
                    target:
                        LatLng(newLocalData.latitude, newLocalData.longitude),
                    tilt: 10,
                    zoom: 18.00)));

            updateMarkerAndCircle(newLocalData, imageData);
          }
        }
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    super.dispose();
  }

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      getData().then((value) {
        _loaded = true;
        if (!mounted) return;
        setState(() {});
      });
    }
    return Scaffold(
      body: !_loaded
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GoogleMap(
              mapType: MapType.hybrid,
              initialCameraPosition: Constants.kGooglePosition,
              markers: Set.of((marker != null) ? [marker, school] : [school]),
              circles: Set.of((circle != null) ? [circle] : []),
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
              },
            ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.location_searching),
          onPressed: () {
            getCurrentLocation();
          }),
    );
  }
}
