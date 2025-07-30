import 'package:cashier_app/modules/printer/add_printer.dart';
import 'package:cashier_app/modules/printer/printer_setting.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/Theme/colors.dart';
import '../../../utils/scaled_dimensions.dart';
import '../../controllers/printer_controller.dart';
import '../../global_widgets/custom_app_button.dart';
import '../../utils/constant.dart';

class PrinterPage extends StatefulWidget {
  const PrinterPage({super.key});

  @override
  State<PrinterPage> createState() => _PrinterPageState();
}

class _PrinterPageState extends State<PrinterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
              'Printer'.tr,
            )),
      ),
      body: Container(
        width: ConstantApp.getWidth(context),
        height: ConstantApp.getHeight(context),
        decoration: BoxDecoration(
          gradient: backgroundGradient,
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomAppButton(
                height: ScaledDimensions.getScaledHeight(px: 120),
                width: ScaledDimensions.getScaledWidth(px: 60),
                onPressed: ()async {
                  await Get.find<PrinterController>().viewPrinter();
                  await Get.find<PrinterController>().getPrintSettingData(1);
                  Get.to(()=>const AddPrinter());
                },
                title: 'Add Printer'.tr,
                backgroundColor: primaryColor,
                textColor: Colors.white,
                withPadding: true,
              ),
              CustomAppButton(
                height: ScaledDimensions.getScaledHeight(px: 120),
                width: ScaledDimensions.getScaledWidth(px: 60),
                onPressed: () async{
                  await Get.find<PrinterController>().viewPrinter();
                  await Get.find<PrinterController>().getPrintSettingData(1);
                  Get.to(() => const PrinterSetting());
                },
                title: 'Printer Setting'.tr,
                backgroundColor: primaryColor,
                textColor: Colors.white,
                withPadding: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
