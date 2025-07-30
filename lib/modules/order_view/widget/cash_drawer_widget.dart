import 'package:cashier_app/controllers/order_controller.dart';
import 'package:cashier_app/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printing/printing.dart';
import '../../../../../../../database/app_db_controller.dart';
import '../../../../../../../utils/Theme/colors.dart';
import '../../../../../../../utils/constant.dart';


class CashDrawerWidget extends StatelessWidget {
  const CashDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        var cont =Get.find<UserController>();
          bool result = cont.isPermission(cont.permission.value.cashDrawer, context);
          if(!result){
            return;
          }

          var doc = await Get.find<OrderController>().printStoriesReport1();
          var printer = await Get.find<AppDataBaseController>()
              .appDataBase
              .getPrinterSetting(1);
          if (printer == null) {
            if (!context.mounted) return;
            ConstantApp.showSnakeBarError(
                context, 'ADD Printer From Printer Setting !!'.tr);
            return;
          }
          var allPrinters = await Get.find<AppDataBaseController>()
              .appDataBase
              .getAllPrinter();
          if (printer.billPrinter != 0) {
            String name = allPrinters
                .firstWhere((element) => element.id == printer.billPrinter)
                .printerName ??
                '';

            await Printing.directPrintPdf(
              usePrinterSettings: true,
              printer: Printer(
                url: name,
                name: name,
              ),
              onLayout: (format) async => doc.save(),
            );
          } else {
            if (!context.mounted) return;
            ConstantApp.showSnakeBarError(
                context, 'ADD Printer From Printer Setting !!'.tr);
            return;
          }
      },
      icon: Icon(Icons.point_of_sale, color: primaryColor.withOpacity(1)),
      iconSize: ConstantApp.getTextSize(context) * 13,
    );
  }
}
