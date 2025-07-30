import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../../../../utils/Theme/colors.dart';
import '../../../../../../../utils/constant.dart';
import '../../../../../../../utils/scaled_dimensions.dart';
import '../../../controllers/order_controller.dart';
import '../../../global_widgets/custom_app_button.dart';
import '../../../global_widgets/custom_text_field.dart';


class BarcodeWidget extends StatelessWidget {
  final OrderController controller;
  TextEditingController barcodeController;
  FocusNode barcodeFN;
  VoidCallback setState;
  String hall;
  String table;
  BarcodeWidget(
      {required this.controller,
      required this.barcodeController,
      required this.barcodeFN,
      required this.setState,
      required this.table,
      required this.hall,
      super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        barcodeController.clear();
        showAnimatedDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                alignment: Alignment.center,
                actionsPadding: const EdgeInsets.all(20),
                title: Center(
                    child: Text(
                  'Enter Barcode'.tr,
                  style: const TextStyle(fontSize: 25),
                )),
                content: CustomTextFormField(
                    hint: 'Barcode'.tr,
                    autoFocus: true,
                    focusNode: barcodeFN,
                    onChange: (value) {},
                    onSubmit: (_)async{
                      Get.back();
                      if (barcodeController.text.isEmpty) return;
                      await controller.addProductFromBarcode(
                          barcodeController.text, context , hall , table);
                      setState();
                    },
                    textEditingController: barcodeController,
                    onSaved: (value) {},
                    validator: (value) {
                      return null;
                    }),
                actions: [
                  CustomAppButton(
                      height: ScaledDimensions.getScaledHeight(px: 60),
                      width: ScaledDimensions.getScaledWidth(px: 60),
                      onPressed: () async {
                        Get.back();
                        if (barcodeController.text.isEmpty) return;
                        await controller.addProductFromBarcode(
                            barcodeController.text, context , hall , table);
                        setState();
                      },
                      title: 'Add'.tr,
                      backgroundColor: primaryColor,
                      textColor: Colors.white,
                      withPadding: false),
                ],
              );
            },
            barrierDismissible: true,
            animationType: DialogTransitionType.sizeFade,
            curve: Curves.fastOutSlowIn,
            duration: const Duration(milliseconds: 400));
      },
      icon: Icon(
        FontAwesomeIcons.barcode,
        color: primaryColor.withOpacity(1),
      ),
      iconSize: ConstantApp.getTextSize(context) * 13,
    );
  }
}
