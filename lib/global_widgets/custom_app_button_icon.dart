// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

import '../utils/Theme/colors.dart';
import '../utils/constant.dart';
import '../utils/scaled_dimensions.dart';

class CustomAppButtonIcon extends StatelessWidget {
  const CustomAppButtonIcon(
      {required this.onPressed,
        required this.title,
        required this.backgroundColor,
        required this.textColor,
        required this.withPadding,
        required this.width,
        required this.height,
        required this.icon,
        required this.iconImage,
        this.colorBorder = Colors.grey,
        Key? key})
      : super(key: key);

  final Callback onPressed;
  final String title;
  final Color backgroundColor;
  final Color textColor;
  final bool withPadding;
  final double width;
  final double height;
  final Color colorBorder;
  final IconData icon;
  final String iconImage;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.resolveWith<Color>(
                  (_) => Colors.grey.withOpacity(0.1)),
        ),
        child: Container(
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
              border: Border.all(color: colorBorder.withOpacity(0.4)),
              color: backgroundColor,
              borderRadius: BorderRadius.circular(7)),
          margin: withPadding
              ? EdgeInsets.symmetric(
              vertical: ScaledDimensions.getScaledHeight(px: 10))
              : null,
          width: ConstantApp.isTab(context) ? width * 1.3 : width,
          // ,
          height: ConstantApp.isTab(context) ? height * 0.85 : height,
          child: Center(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Align(
                          alignment: Alignment.topCenter,
                          child: Icon(
                            icon,
                            size: ConstantApp.isTab(context)
                                ? 60
                                : width / height * 35,
                            color: Colors.white,
                          )),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: ConstantApp.getWidth(context),
                    height: ConstantApp.getHeight(context) * 0.07,
                    decoration: BoxDecoration(color: secondaryColor),
                    child: Center(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: ConstantApp.getTextSize(context) * 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
