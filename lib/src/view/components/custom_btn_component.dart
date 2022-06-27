import 'package:arabi/src/styles/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../utils/constants.dart';

class CustomBtnComponent extends StatefulWidget {
  final String text;
  final Color color;
  final Color textColor;
  final Color borderColor;
  final double width;
  final Function onTap;
  final double height;
  final bool hasBorder;
  String iconName;
  bool isLoading;
  EdgeInsets padding;
  double borderRadius;
  MainAxisAlignment alignment;
  CustomBtnComponent({
    Key key,
    @required this.text,
    this.isLoading,
    this.color,
    this.borderColor,
    this.width,
    this.textColor,
    this.height,
    this.iconName,
    this.alignment,
    @required this.onTap,
    this.hasBorder = true,
    this.padding,
    this.borderRadius = 10,
  }) : super(key: key) {
    this.isLoading = isLoading ?? false;
  }

  @override
  _CustomBtnComponentState createState() => _CustomBtnComponentState();
}

class _CustomBtnComponentState extends State<CustomBtnComponent> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.isLoading ? null : widget.onTap as void Function(),
      child: Container(
        margin: const EdgeInsets.all(2),
        padding: widget.padding ?? AppStyles.defaultPadding5,
        width: widget.width,
        height: widget.height ?? 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          color: widget.isLoading
              ? Colors.grey
              : widget.color ?? Theme.of(context).primaryColor,
          border: widget.hasBorder
              ? Border.all(
                  color: widget.borderColor ?? Theme.of(context).primaryColor,
                )
              : null,
        ),
        child: Row(
          mainAxisAlignment: widget.alignment ?? MainAxisAlignment.center,
          children: <Widget>[
            widget.isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: const CircularProgressIndicator(),
                  )
                : Container(
                    child: widget.iconName == null
                        ? Container()
                        : SvgPicture.asset(
                            '${Constants.ASSETS_IMAGES_PATH}${widget.iconName}.svg',
                            width: 20,
                            height: 20,
                          ),
                  ),
            if (widget.isLoading || widget.iconName != null)
              const SizedBox(
                width: 10,
              ),
            Text(
              widget.text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: widget.textColor ?? Colors.white,
                fontSize: 20,
              ),
            ),

            // Transform(
            //     alignment: Alignment.center,
            //     transform: Matrix4.rotationY(
            //       Directionality.of(context) == TextDirection.rtl ? pi : 0,
            //     ),
            //     child: SvgPicture.asset(
            //         '${Constants.ASSETS_IMAGES_PATH}arraw.svg')),
          ],
        ),
      ),
    );
  }
}
