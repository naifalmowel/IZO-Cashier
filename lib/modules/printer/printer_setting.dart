// ignore_for_file: file_names


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/printer_controller.dart';
import '../../database/app_db.dart';
import '../../global_widgets/custom_app_button.dart';
import '../../global_widgets/custom_drop_down_printer.dart';
import '../../global_widgets/custom_text_field.dart';
import '../../utils/Theme/colors.dart';
import '../../utils/constant.dart';

class PrinterSetting extends StatefulWidget {
  const PrinterSetting({super.key});
  @override
  State<PrinterSetting> createState() => _PrinterSettingState();
}

class _PrinterSettingState extends State<PrinterSetting> {
  final _formKey = GlobalKey<FormState>();

  late FocusNode textPrintFocusNode;
  late FocusNode fontSizeFocusNode;
  late FocusNode headerFocusNode;
  late TextEditingController textPrintController;

  bool isFullOrder = false;
  bool showUnit = false;
  bool showVat = false;
  bool showProductDescription = false;
  TextEditingController billPrinterController = TextEditingController();
  TextEditingController reportPrinterController = TextEditingController();
  TextEditingController fontSizeController = TextEditingController();
  TextEditingController headerController = TextEditingController();
  int? billPrinter;
  int? reportPrinter;

  @override
  void initState() {
    textPrintFocusNode = FocusNode();
    fontSizeFocusNode = FocusNode();
    headerFocusNode = FocusNode();
    textPrintController = TextEditingController();
    textPrintController.text =
        Get.find<PrinterController>().printerSetting.value.tailPrint.toString();
    fontSizeController.text =
        Get.find<PrinterController>().printerSetting.value.fontSize.toString();
    headerController.text = Get.find<PrinterController>()
        .printerSetting
        .value
        .headerPrint
        .toString();
    isFullOrder =
        Get.find<PrinterController>().printerSetting.value.isFullOrder;
    showUnit = Get.find<PrinterController>().printerSetting.value.showUnit;
    showVat = Get.find<PrinterController>().printerSetting.value.showVat;
    showProductDescription = Get.find<PrinterController>()
        .printerSetting
        .value
        .showProductDescription;

    billPrinter =
        Get.find<PrinterController>().printerSetting.value.billPrinter;
    reportPrinter =
        Get.find<PrinterController>().printerSetting.value.reportPrinter;
    if (Get.find<PrinterController>()
        .printers
        .firstWhereOrNull((element) => element.id == billPrinter) ==
        null) {
      billPrinter = 0;
    }
    super.initState();
  }

  @override
  void dispose() {
    textPrintFocusNode.dispose();
    textPrintController.dispose();
    billPrinterController.dispose();
    reportPrinterController.dispose();
    headerController.dispose();
    fontSizeFocusNode.dispose();
    headerFocusNode.dispose();
    fontSizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        height: ConstantApp.getHeight(context),
        width: ConstantApp.getWidth(context),
        decoration: BoxDecoration(
          gradient: backgroundGradient,
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: ConstantApp.getHeight(context) * 0.08,
                ),
                SizedBox(
                  width: ConstantApp.getWidth(context) * 0.49,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Bill Printer : ".tr,
                        style: ConstantApp.getTextStyle(
                            context: context,
                            size: 13,
                            color: textColor.withOpacity(0.7),
                            fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          CustomDropDownButtonPrinter(
                              title: "Printer".tr,
                              hint: "Chose printer".tr,
                              items: Get.find<PrinterController>().printers,
                              value: billPrinter == 0 ? null : billPrinter,
                              onChange: (value) {
                                billPrinter = value!;
                              },
                              width: ConstantApp.getWidth(context) * 0.15,
                              height: ConstantApp.getHeight(context) * 0.05,
                              textEditingController: billPrinterController),
                          IconButton(
                              onPressed: () {
                                billPrinter = 0;
                                setState(() {});
                              },
                              icon: const Icon(Icons.close))
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: ConstantApp.getWidth(context) * 0.49,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Report Printer : ".tr,
                        style: ConstantApp.getTextStyle(
                            context: context,
                            size: 13,
                            color: textColor.withOpacity(0.7),
                            fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          CustomDropDownButtonPrinter(
                              title: "Printer".tr,
                              hint: "Chose printer".tr,
                              items: Get.find<PrinterController>().printers,
                              value: reportPrinter == 0 ? null : reportPrinter,
                              onChange: (value) {
                                reportPrinter = value!;
                              },
                              width: ConstantApp.getWidth(context) * 0.15,
                              height: ConstantApp.getHeight(context) * 0.05,
                              textEditingController: reportPrinterController),
                          IconButton(
                              onPressed: () {
                                reportPrinter = 0;
                                setState(() {});
                              },
                              icon: const Icon(Icons.close))
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: ConstantApp.getWidth(context) * 0.51,
                  child: SwitchListTile(
                    title: Text(
                      'Show Full Order'.tr,
                      style: ConstantApp.getTextStyle(
                          context: context,
                          size: 13,
                          color: textColor.withOpacity(0.7),
                          fontWeight: FontWeight.bold),
                    ),
                    activeColor: primaryColor,
                    value: isFullOrder,
                    onChanged: (bool value) {
                      isFullOrder = value;
                      setState(() {});
                    },
                  ),
                ),
                SizedBox(
                  width: ConstantApp.getWidth(context) * 0.51,
                  child: SwitchListTile(
                    title: Text(
                      'Show Unit Column'.tr,
                      style: ConstantApp.getTextStyle(
                          context: context,
                          size: 13,
                          color: textColor.withOpacity(0.7),
                          fontWeight: FontWeight.bold),
                    ),
                    activeColor: primaryColor,
                    value: showUnit,
                    onChanged: (bool value) {
                      showUnit = value;
                      setState(() {});
                    },
                  ),
                ),
                SizedBox(
                  width: ConstantApp.getWidth(context) * 0.51,
                  child: SwitchListTile(
                    title: Text(
                      'Show Vat Column'.tr,
                      style: ConstantApp.getTextStyle(
                          context: context,
                          size: 13,
                          color: textColor.withOpacity(0.7),
                          fontWeight: FontWeight.bold),
                    ),
                    activeColor: primaryColor,
                    value: showVat,
                    onChanged: (bool value) {
                      showVat = value;
                      setState(() {});
                    },
                  ),
                ),
                SizedBox(
                  width: ConstantApp.getWidth(context) * 0.51,
                  child: SwitchListTile(
                    title: Text(
                      'Show Product Description Column'.tr,
                      style: ConstantApp.getTextStyle(
                          context: context,
                          size: 13,
                          color: textColor.withOpacity(0.7),
                          fontWeight: FontWeight.bold),
                    ),
                    activeColor: primaryColor,
                    value: showProductDescription,
                    onChanged: (bool value) {
                      showProductDescription = value;
                      setState(() {});
                    },
                  ),
                ),
                SizedBox(
                  width: ConstantApp.getWidth(context) * 0.5,
                  child: CustomTextFormField(
                    hint: 'Font Size'.tr,
                    focusNode: fontSizeFocusNode,
                    textEditingController: fontSizeController,
                    isNum: true,
                    validator: (value) {
                      if (value!.isEmpty || value == '') {
                        return 'Can\'t Be Empty'.tr;
                      }
                      if (!(double.parse(value) < 13 &&
                          double.parse(value) > 5)) {
                        return 'They must between 12 and 6'.tr;
                      }
                      return null;
                    },
                    textInputType: TextInputType.number,
                    onSaved: (val) {},
                  ),
                ),
                // SizedBox(
                //   width: ConstantApp.getWidth(context) * 0.5,
                //   child: CustomTextFormField(
                //     hint: 'Header Print'.tr,
                //     focusNode: headerFocusNode,
                //     textEditingController: headerController,
                //     validator: (value) {
                //       return null;
                //     },
                //     textInputType: TextInputType.text,
                //     onSaved: (val) {},
                //   ),
                // ),
                SizedBox(
                  width: ConstantApp.getWidth(context) * 0.5,
                  child: CustomTextFormField(
                    hint: 'Tail Print'.tr,
                    maxLin: 5,
                    focusNode: textPrintFocusNode,
                    textEditingController: textPrintController,
                    validator: (value) {
                      return null;
                    },
                    textInputType: TextInputType.text,
                    onSaved: (val) {},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomAppButton(
                          height: ConstantApp.getHeight(context) * 0.09,
                          width: ConstantApp.getWidth(context) * 0.23,
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if (billPrinter != null &&
                                  reportPrinter != null) {
                                Get.find<PrinterController>()
                                    .updatePrintSetting(
                                    PrinterSettingEntityData(
                                      id: 1,
                                      isFullOrder: isFullOrder,
                                      billPrinter: billPrinter,
                                      reportPrinter: reportPrinter,
                                      tailPrint: textPrintController.text,
                                      showUnit: showUnit,
                                      showVat: showVat,
                                      fontSize: double.tryParse(
                                          fontSizeController.text) ??
                                          8,
                                      headerPrint: headerController.text,
                                      showProductDescription:
                                      showProductDescription,
                                    ));
                                ConstantApp.showSnakeBarSuccess(
                                    context, "Update Success".tr);
                                textPrintController.clear();
                                Get.back();
                              } else {
                                ConstantApp.showSnakeBarError(context,
                                    "Chose printer for bill and report".tr);
                              }
                            }
                          },
                          title: 'Save'.tr,
                          backgroundColor: secondaryColor,
                          textColor: Colors.white,
                          withPadding: false),
                      // TextButton(
                      //     onPressed: printBillButton,
                      //     child: const Text("Test Print")),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

// Future<void> printBillButton() async {
//   String type1 = 'TakeAway';
//   String? driverName = 'Ali Ahmad';
//   BillEntityData bill = BillEntityData(
//       id: 0,
//       invoice: '',
//       formatNumber: "#5555",
//       typeInvoice: '',
//       numberOfBill: 0,
//       customerId: 1,
//       storeId: 1,
//       payType: '-',
//       total: 100,
//       discountAmount: 0,
//       disType: '',
//       disValue: '',
//       cashier: Get.find<SharedPreferences>().getString('name')!,
//       receiptStatus: '',
//       vat: 1,
//       receiptDue: 0,
//       finalTotal: 100,
//       createdAt: DateTime.now(),
//       table: "1",
//       hall: type1,
//       dateSales: DateTime.now(),
//       patternId: 0);
//   var doc = await printBill(
//       orders: [
//         OrdersTableViewEntityData(
//             id: 1,
//             name: "Pepsi",
//             amount: 2,
//             price: 5,
//             classId: 1,
//             itemId: 1,
//             createdAt: DateTime.now(),
//             total: 2,
//             serial: 1,
//             table: "1",
//             hall: "1",
//             ident: "1",
//             vatId: 1,
//             addBill: false),
//         OrdersTableViewEntityData(
//             id: 2,
//             name: "Dew",
//             amount: 2,
//             price: 5,
//             classId: 1,
//             itemId: 1,
//             createdAt: DateTime.now(),
//             total: 2,
//             serial: 1,
//             table: "1",
//             hall: "1",
//             ident: "1",
//             vatId: 1,
//             addBill: false)
//       ],
//       bill: bill,
//       printerName: '',
//       customerAddress: "Dubai",
//       driverName: driverName,
//       customerNum: "1");
//   var printer = await Get.find<AppDataBaseController>()
//       .appDataBase
//       .getPrinterSetting(1);
//   var allPrinters =
//       await Get.find<AppDataBaseController>().appDataBase.getAllPrinter();
//   if (printer!.billPrinter != 0) {
//     String name = allPrinters
//         .firstWhere((element) => element.id == printer.billPrinter)
//         .printerName!;
//     await Printing.directPrintPdf(
//       usePrinterSettings: true,
//       dynamicLayout: false,
//       printer: Printer(
//         url: name,
//         name: name,
//       ),
//       onLayout: (format) async => doc.save(),
//     );
//   }
// }
}
