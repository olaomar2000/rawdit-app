import 'package:arabi/src/themes/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../utils/constants.dart';

class EntryFieldComponent extends StatefulWidget {
  final String title;
  String icon;
  bool isReadOnly;
  bool isSecure;
  bool hasHint;
  TextInputType keyboardType;
  String Function(String) validator;
  void Function(String) onSaved;
  void Function(String) onChanged;
  EdgeInsets contentPadding;
  TextEditingController textEditingController;

  EntryFieldComponent({
    Key key,
    @required this.title,
    this.icon,
    this.textEditingController,
    this.isReadOnly = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.isSecure = false,
    this.contentPadding,
    this.hasHint = false,
  }) : super(key: key);

  @override
  State<EntryFieldComponent> createState() => _EntryFieldComponentState();
}

class _EntryFieldComponentState extends State<EntryFieldComponent> {
  bool isShowPassword = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      // decoration:  BoxDecoration(
      //   color: Colors.white,
      //   border: Border.all(
      //
      //       color:Theme.of(context).primaryColor,
      //
      //   ),
      //   borderRadius: BorderRadius.circular(20)
      // ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextFormField(
                  onSaved: widget.onSaved,
                  onChanged: widget.onChanged,
                  obscureText: widget.isSecure ?? false,
                  // obscuringCharacter: '*',
                  controller: widget.textEditingController,
                  readOnly: widget.isReadOnly,
                  keyboardType: widget.keyboardType,
                  textAlignVertical: TextAlignVertical.center,
                  cursorColor: customBlue,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: customBlue,
                      ),
                    ),
                    prefixIcon: widget.icon == null
                        ? null
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.asset(
                              '${Constants.ASSETS_IMAGES_PATH}${widget.icon}.svg',
                            ),
                          ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    isCollapsed: true,
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: widget.contentPadding ??
                        const EdgeInsets.symmetric(vertical: 5),
                    hintText: widget.title ?? '',
                    hintStyle: TextStyle(
                      color: const Color(0xffA3A3A3),
                      fontSize: 15,
                    ),
                  ),
                  validator: widget.validator,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
