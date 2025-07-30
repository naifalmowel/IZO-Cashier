import 'package:cashier_app/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/Theme/colors.dart';
import '../../../utils/constant.dart';
import '../database/app_db.dart';
import 'custom_app_button.dart';

class CustomCloseBoxDialog extends StatefulWidget {
  const CustomCloseBoxDialog({super.key});

  @override
  State<CustomCloseBoxDialog> createState() => _CustomCloseBoxDialogState();
}

class _CustomCloseBoxDialogState extends State<CustomCloseBoxDialog> {
  bool show1000 = true;
  bool show500 = true;
  bool show200 = true;
  bool show100 = true;
  bool show50 = true;
  bool show20 = true;
  bool show10 = true;
  bool show5 = true;
  bool show2 = true;
  bool show1 = true;
  bool show050 = true;
  bool show025 = true;
  bool show010 = true;
  bool show005 = true;
  bool show001 = true;

  var controller = Get.find<UserController>();

  @override
  void initState() {
    show1000 = controller.show1000.value;
    show500 = controller.show500.value;
    show200 = controller.show200.value;
    show100 = controller.show100.value;
    show50 = controller.show50.value;
    show20 = controller.show20.value;
    show10 = controller.show10.value;
    show5 = controller.show5.value;
    show2 = controller.show2.value;
    show1 = controller.show1.value;
    show050 = controller.show050.value;
    show025 = controller.show025.value;
    show010 = controller.show010.value;
    show005 = controller.show005.value;
    show001 = controller.show001.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Container(
      height: ConstantApp.getHeight(context) / 1.5,
      width: ConstantApp.getWidth(context) * 0.7,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Center(
                child: Text(
              "Choose Currency Categories",
              style: ConstantApp.getTextStyle(
                      context: context, size: 13, fontWeight: FontWeight.bold)
                  .copyWith(decoration: TextDecoration.underline),
            )),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Row(
                children: [
                  SizedBox(
                    width: ConstantApp.getWidth(context) * 0.3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 0.1,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Switch(
                                  value: show1000,
                                  onChanged: (value) {
                                    show1000 = value;
                                    setState(() {});
                                  },
                                  activeColor: primaryColor,
                                ),
                                Center(
                                  child: Text(
                                    'show Category 1000'.tr,
                                    style: ConstantApp.getTextStyle(
                                        context: context,
                                        color: secondaryColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Switch(
                                  value: show500,
                                  onChanged: (value) {
                                    show500 = value;
                                    setState(() {});
                                  },
                                  activeColor: primaryColor,
                                ),
                                Center(
                                  child: Text(
                                    'show Category 500'.tr,
                                    style: ConstantApp.getTextStyle(
                                        context: context,
                                        color: secondaryColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Switch(
                                  value: show200,
                                  onChanged: (value) {
                                    show200 = value;
                                    setState(() {});
                                  },
                                  activeColor: primaryColor,
                                ),
                                Center(
                                  child: Text(
                                    'show Category 200'.tr,
                                    style: ConstantApp.getTextStyle(
                                        context: context,
                                        color: secondaryColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Switch(
                                  value: show100,
                                  onChanged: (value) {
                                    show100 = value;
                                    setState(() {});
                                  },
                                  activeColor: primaryColor,
                                ),
                                Center(
                                  child: Text(
                                    'show Category 100'.tr,
                                    style: ConstantApp.getTextStyle(
                                        context: context,
                                        color: secondaryColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Switch(
                                  value: show50,
                                  onChanged: (value) {
                                    show50 = value;
                                    setState(() {});
                                  },
                                  activeColor: primaryColor,
                                ),
                                Center(
                                  child: Text(
                                    'show Category 50'.tr,
                                    style: ConstantApp.getTextStyle(
                                        context: context,
                                        color: secondaryColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Switch(
                                  value: show20,
                                  onChanged: (value) {
                                    show20 = value;
                                    setState(() {});
                                  },
                                  activeColor: primaryColor,
                                ),
                                Center(
                                  child: Text(
                                    'show Category 20'.tr,
                                    style: ConstantApp.getTextStyle(
                                        context: context,
                                        color: secondaryColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Switch(
                                  value: show10,
                                  onChanged: (value) {
                                    show10 = value;
                                    setState(() {});
                                  },
                                  activeColor: primaryColor,
                                ),
                                Center(
                                  child: Text(
                                    'show Category 10'.tr,
                                    style: ConstantApp.getTextStyle(
                                        context: context,
                                        color: secondaryColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Switch(
                                  value: show5,
                                  onChanged: (value) {
                                    show5 = value;
                                    setState(() {});
                                  },
                                  activeColor: primaryColor,
                                ),
                                Center(
                                  child: Text(
                                    'show Category 5'.tr,
                                    style: ConstantApp.getTextStyle(
                                        context: context,
                                        color: secondaryColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: ConstantApp.getWidth(context) * 0.3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 0.1,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Switch(
                                  value: show2,
                                  onChanged: (value) {
                                    show2 = value;
                                    setState(() {});
                                  },
                                  activeColor: primaryColor,
                                ),
                                Center(
                                  child: Text(
                                    'show Category 2'.tr,
                                    style: ConstantApp.getTextStyle(
                                        context: context,
                                        color: secondaryColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Switch(
                                  value: show1,
                                  onChanged: (value) {
                                    show1 = value;
                                    setState(() {});
                                  },
                                  activeColor: primaryColor,
                                ),
                                Center(
                                  child: Text(
                                    'show Category 1'.tr,
                                    style: ConstantApp.getTextStyle(
                                        context: context,
                                        color: secondaryColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Switch(
                                  value: show050,
                                  onChanged: (value) {
                                    show050 = value;
                                    setState(() {});
                                  },
                                  activeColor: primaryColor,
                                ),
                                Center(
                                  child: Text(
                                    'show Category show 0.5'.tr,
                                    style: ConstantApp.getTextStyle(
                                        context: context,
                                        color: secondaryColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Switch(
                                  value: show025,
                                  onChanged: (value) {
                                    show025 = value;
                                    setState(() {});
                                  },
                                  activeColor: primaryColor,
                                ),
                                Center(
                                  child: Text(
                                    'show Category show 0.25'.tr,
                                    style: ConstantApp.getTextStyle(
                                        context: context,
                                        color: secondaryColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Switch(
                                  value: show010,
                                  onChanged: (value) {
                                    show010 = value;
                                    setState(() {});
                                  },
                                  activeColor: primaryColor,
                                ),
                                Center(
                                  child: Text(
                                    'show Category show 0.10'.tr,
                                    style: ConstantApp.getTextStyle(
                                        context: context,
                                        color: secondaryColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Switch(
                                  value: show005,
                                  onChanged: (value) {
                                    show005 = value;
                                    setState(() {});
                                  },
                                  activeColor: primaryColor,
                                ),
                                Center(
                                  child: Text(
                                    'show Category show 0.05'.tr,
                                    style: ConstantApp.getTextStyle(
                                        context: context,
                                        color: secondaryColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Switch(
                                  value: show001,
                                  onChanged: (value) {
                                    show001 = value;
                                    setState(() {});
                                  },
                                  activeColor: primaryColor,
                                ),
                                Center(
                                  child: Text(
                                    'show Category show 0.01'.tr,
                                    style: ConstantApp.getTextStyle(
                                        context: context,
                                        color: secondaryColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: CustomAppButton(
                onPressed: () async {
                await  controller.updateCloseBoxSetting(CloseBoxSettingData(
                      id: 1,
                      show1000: show1000,
                      show500: show500,
                      show200: show200,
                      show100: show100,
                      show50: show50,
                      show20: show20,
                      show10: show10,
                      show5: show5,
                      show2: show2,
                      show1: show1,
                      show050: show050,
                      show025: show025,
                      show010: show010,
                      show005: show005,
                      show001: show001,
                      createAt: DateTime.now()));
                  Get.back();
                },
                title: 'Save'.tr,
                backgroundColor: secondaryColor,
                textColor: Colors.white,
                withPadding: true,
                width: ConstantApp.getWidth(context) / 5,
                height: ConstantApp.getHeight(context) / 15),
          ),
        ],
      ),
    );
  }
}
