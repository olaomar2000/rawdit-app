import 'package:shared_preferences/shared_preferences.dart';

class SPHelper {
  SPHelper._();
  static SPHelper spHelper = SPHelper._();

  SharedPreferences sharedPreferences;

  Future<SharedPreferences> initSharedPrefrences() async {
    if (sharedPreferences == null) {
      sharedPreferences = await SharedPreferences.getInstance();
      return sharedPreferences;
    } else {
      return sharedPreferences;
    }
  }

  setToken(String value) async {
    sharedPreferences = await initSharedPrefrences();
    sharedPreferences.setString('token', value);
  }

  Future<String> getToken() async {
    sharedPreferences = await initSharedPrefrences();
    String accessToken = sharedPreferences.getString('token');
    return accessToken;
  }

  setOnboarding(bool value) async {
    sharedPreferences = await initSharedPrefrences();
    sharedPreferences.setBool('isView', value);
  }

  Future<bool> getOnboarding() async {
    sharedPreferences = await initSharedPrefrences();
    bool isView = sharedPreferences.getBool("isView");
    return isView;
  }

  setUId(String value) async {
    sharedPreferences = await initSharedPrefrences();
    sharedPreferences.setString('u_id', value);
  }

  Future<String> getUId() async {
    sharedPreferences = await initSharedPrefrences();
    String accessToken = sharedPreferences.getString('u_id');
    return accessToken;
  }

  setClassName(String value) async {
    sharedPreferences = await initSharedPrefrences();
    sharedPreferences.setString('class_name', value);
  }

  Future<String> getClassName() async {
    sharedPreferences = await initSharedPrefrences();
    String className = sharedPreferences.getString('class_name');
    return className;
  }

  Future<void> addKey(String key, String value) async {
    sharedPreferences = await initSharedPrefrences();
    await sharedPreferences.setString(key, value);
  }

  Future<String> getKey(String key) async {
    sharedPreferences = await initSharedPrefrences();
    return sharedPreferences.getString(key);
  }

  Future<void> deleteKey(String key) async {
    sharedPreferences = await initSharedPrefrences();
    await sharedPreferences.remove(key);
  }
}
