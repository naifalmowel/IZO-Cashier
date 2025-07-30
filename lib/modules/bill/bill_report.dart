import 'package:cashier_app/controllers/info_controllers.dart';
import 'package:cashier_app/controllers/order_controller.dart';
import 'package:cashier_app/controllers/user_controller.dart';
import 'package:cashier_app/models/bill_model.dart';
import 'package:cashier_app/models/order/order_model.dart';
import 'package:cashier_app/models/store_model.dart';
import 'package:cashier_app/modules/bill/edit_bill.dart';
import 'package:cashier_app/modules/bill/temp_bill.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../database/app_db_controller.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/scaled_dimensions.dart';
import '../../controllers/sales_controller.dart';
import '../../global_widgets/custom_app_button.dart';
import '../../utils/Theme/colors.dart';
import '../login/login.dart';
import 'custom_dialog_sales.dart';

class SalesReportPage extends StatefulWidget {
  const SalesReportPage({Key? key}) : super(key: key);

  @override
  State<SalesReportPage> createState() => _SalesReportPageState();
}

class _SalesReportPageState extends State<SalesReportPage> {
  final controller = Get.find<SalesBillController>();
  final ScrollController _scrollController = ScrollController();
  TextEditingController firstDateController = TextEditingController();
  TextEditingController lastDateController = TextEditingController();
  TextEditingController textEditingController = TextEditingController();
  RxList<BillModel> origenList = RxList();

  double total = 0.0;
  int section = 0;
  DateTime? pickedDate;
  List<String> type = [
    "Cash",
    "Visa",
    "Credit",
    "Cash_Visa",
  ];
  List<String> typeOrder = [
    "TakeAway",
    "DineIn",
    "Delivery",
    "SALES",
  ];
  Map<int, String> storeFilter = {};
  Map<int, String> userFilter = {};
  bool isAscending = false;
  bool aToZPrice = false;
  bool aToZExcVatPrice = false;
  bool aToZDisAmountPrice = false;
  bool aToZVatPrice = false;
  bool aToZVisaPrice = false;
  bool aToZCashPrice = false;

  @override
  void initState() {
    controller.firstDateController.text = '';
    controller.lastDateController.text = '';
    controller.onceDateController.text = '';
    origenList.value = controller.foundPlayers;
    controller.foundPlayers.sort((a, b) => b.id!.compareTo(a.id!));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(
            'Sales Report'.tr,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                  onPressed: () {
                    controller.isSearch.value = !controller.isSearch.value;
                    controller.update();
                  },
                  icon: const Icon(Icons.search)),
            ),
            PopupMenuButton(
              tooltip: "Action".tr,
              icon: const Icon(Icons.more_vert_rounded),
              itemBuilder: (BuildContext context) {
                return <PopupMenuItem<Widget>>[
                  PopupMenuItem<Widget>(
                    onTap: () {
                      Get.dialog(
                          Center(
                            child: SizedBox(
                              height: ScaledDimensions.getScaledHeight(
                                px: 200,
                              ),
                              width: ScaledDimensions.getScaledWidth(px: 100),
                              child: Material(
                                borderRadius: BorderRadius.circular(20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      child: CustomAppButton(
                                        onPressed: () async {
                                          Get.back();
                                          if (!context.mounted) return;
                                          if (controller.foundPlayers.isEmpty) {
                                            ConstantApp.showSnakeBarInfo(
                                                context, 'No Bills Found !! ');
                                            return;
                                          }
                                          var doc =
                                              await Get.find<UserController>()
                                                  .printUsersReport(
                                            printerName: '',
                                            list: controller.foundPlayers,
                                            user: 0,
                                            box: false,
                                            cat: false,
                                            item: false,
                                          );
                                          Get.to(() => PdfPreview(
                                                actions: [
                                                  IconButton(
                                                      onPressed: () {
                                                        Get.back();
                                                      },
                                                      icon: const Icon(
                                                          Icons.close))
                                                ],
                                                build: (format) => doc.save(),
                                              ));
                                        },
                                        title: 'View'.tr,
                                        backgroundColor: primaryColor,
                                        textColor: Colors.black,
                                        withPadding: true,
                                        height:
                                            ScaledDimensions.getScaledHeight(
                                                px: 50),
                                        width: ScaledDimensions.getScaledWidth(
                                            px: 60),
                                      ),
                                    ),
                                    Expanded(
                                      child: CustomAppButton(
                                        onPressed: () async {
                                          Get.back();
                                          if (!context.mounted) return;
                                          if (controller.foundPlayers.isEmpty) {
                                            ConstantApp.showSnakeBarInfo(
                                                context, 'No Bills Found !! ');
                                            return;
                                          }
                                          var doc =
                                              await Get.find<UserController>()
                                                  .printUsersReport(
                                            printerName: '',
                                            list: controller.foundPlayers,
                                            user: 0,
                                            box: false,
                                            cat: false,
                                            item: false,
                                          );
                                          var printer = await Get.find<
                                                  AppDataBaseController>()
                                              .appDataBase
                                              .getPrinterSetting(1);
                                          var allPrinters = await Get.find<
                                                  AppDataBaseController>()
                                              .appDataBase
                                              .getAllPrinter();
                                          if (printer!.reportPrinter != 0) {
                                            String name = allPrinters
                                                .firstWhere((element) =>
                                                    element.id ==
                                                    printer.reportPrinter)
                                                .printerName!;
                                            await Printing.directPrintPdf(
                                              usePrinterSettings: true,
                                              dynamicLayout: false,
                                              printer: Printer(
                                                url: name,
                                                name: name,
                                              ),
                                              onLayout: (format) async =>
                                                  doc.save(),
                                            );
                                          } else {
                                            if (!context.mounted) return;
                                            ConstantApp.showSnakeBarError(
                                                context,
                                                'ADD Printer From Printer Setting !!');
                                            return;
                                          }
                                        },
                                        title: 'Print'.tr,
                                        backgroundColor: primaryColor,
                                        textColor: Colors.black,
                                        withPadding: true,
                                        height:
                                            ScaledDimensions.getScaledHeight(
                                                px: 50),
                                        width: ScaledDimensions.getScaledWidth(
                                            px: 60),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          barrierColor: Colors.transparent.withOpacity(0.5));
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.print,
                          color: primaryColor,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(child: Text("Print".tr)),
                      ],
                    ),
                  ),
                  PopupMenuItem<Widget>(
                    onTap: () async {
                      await Get.find<UserController>().getUsers();
                      Get.find<SharedPreferences>().remove('name');
                      Get.find<SharedPreferences>().remove('userId');
                      Get.find<SharedPreferences>().remove('type');
                      Get.back();
                      Get.offAll(() => const LoginPage());
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.logout,
                          color: primaryColor,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(child: Text("Logout".tr)),
                      ],
                    ),
                  ),
                ];
              },
            ),
          ],
        ),
        body: Center(
          child: Scrollbar(
            controller: _scrollController,
            scrollbarOrientation: ScrollbarOrientation.top,
            thumbVisibility: true,
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              child: Container(
                width: ConstantApp.getWidth(context) > 900
                    ? ConstantApp.getWidth(context)
                    : 1200,
                decoration: BoxDecoration(
                  gradient: backgroundGradient,
                ),
                // child: productListUI(controller),
                child: productListUI(Get.find<SalesBillController>()),
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height / 12,
          decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.7),
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20), topLeft: Radius.circular(20))),
          child: Center(
            child: GetBuilder<SalesBillController>(
              builder: (controller) {
                return controller.bills.isEmpty
                    ? const SizedBox()
                    : Row(
                        children: [
                          Get.find<InfoController>().taxesSetting.isNotEmpty
                              ? Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Text(
                                          "TotalEX".tr,
                                          style: ConstantApp.getTextStyle(
                                              context: context,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Expanded(
                                          child: Text(
                                            controller.totalExcVat.value
                                                .toStringAsFixed(2),
                                            style: ConstantApp.getTextStyle(
                                                context: context,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))
                              : const SizedBox(),
                          Flexible(
                              flex: 1,
                              fit: FlexFit.tight,
                              child: Center(
                                child: Column(
                                  children: [
                                    Text(
                                      "Total DA".tr,
                                      style: ConstantApp.getTextStyle(
                                          context: context,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Expanded(
                                      child: Text(
                                        controller.totalDisAmo.value
                                            .toStringAsFixed(2),
                                        style: ConstantApp.getTextStyle(
                                            context: context,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          Get.find<InfoController>().taxesSetting.isNotEmpty
                              ? Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Text(
                                          "Total Vat".tr,
                                          style: ConstantApp.getTextStyle(
                                              context: context,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Expanded(
                                          child: Text(
                                            controller.totalVat.value
                                                .toStringAsFixed(2),
                                            style: ConstantApp.getTextStyle(
                                                context: context,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))
                              : const SizedBox(),
                          Flexible(
                              flex: 1,
                              fit: FlexFit.tight,
                              child: Center(
                                child: Column(
                                  children: [
                                    Text(
                                      "Final Total".tr,
                                      style: ConstantApp.getTextStyle(
                                          context: context,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Expanded(
                                      child: Text(
                                        controller.total.value
                                            .toStringAsFixed(2),
                                        style: ConstantApp.getTextStyle(
                                            context: context,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          Flexible(
                              flex: 1,
                              fit: FlexFit.tight,
                              child: Center(
                                child: Column(
                                  children: [
                                    Text(
                                      "Total Paid".tr,
                                      style: ConstantApp.getTextStyle(
                                          context: context,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Expanded(
                                      child: Text(
                                        controller.totalPaid.value
                                            .toStringAsFixed(2),
                                        style: ConstantApp.getTextStyle(
                                            context: context,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          Flexible(
                              flex: 1,
                              fit: FlexFit.tight,
                              child: Center(
                                child: Column(
                                  children: [
                                    Text(
                                      "Total Balance".tr,
                                      style: ConstantApp.getTextStyle(
                                          context: context,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Expanded(
                                      child: Text(
                                        controller.totalBalance.value
                                            .toStringAsFixed(2),
                                        style: ConstantApp.getTextStyle(
                                            context: context,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          Flexible(
                              flex: 1,
                              fit: FlexFit.tight,
                              child: Center(
                                child: Column(
                                  children: [
                                    Text(
                                      "Total Return".tr,
                                      style: ConstantApp.getTextStyle(
                                          context: context,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Expanded(
                                      child: Text(
                                        controller.totalReturn.value
                                            .toStringAsFixed(2),
                                        style: ConstantApp.getTextStyle(
                                            context: context,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          Flexible(
                              flex: 1,
                              fit: FlexFit.tight,
                              child: Center(
                                child: Column(
                                  children: [
                                    Text(
                                      "Total Tips".tr,
                                      style: ConstantApp.getTextStyle(
                                          context: context,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Expanded(
                                      child: Text(
                                        controller.totalTips.value
                                            .toStringAsFixed(2),
                                        style: ConstantApp.getTextStyle(
                                            context: context,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          Flexible(
                              flex: 1,
                              fit: FlexFit.tight,
                              child: Center(
                                child: Column(
                                  children: [
                                    Text(
                                      "Total Cash".tr,
                                      style: ConstantApp.getTextStyle(
                                          context: context,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Expanded(
                                      child: Text(
                                        controller.totalCash.value
                                            .toStringAsFixed(2),
                                        style: ConstantApp.getTextStyle(
                                            context: context,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          Flexible(
                              flex: 1,
                              fit: FlexFit.tight,
                              child: Center(
                                child: Column(
                                  children: [
                                    Text(
                                      "Total Visa".tr,
                                      style: ConstantApp.getTextStyle(
                                          context: context,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Expanded(
                                      child: Text(
                                        controller.totalVisa.value
                                            .toStringAsFixed(2),
                                        style: ConstantApp.getTextStyle(
                                            context: context,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      );
              },
            ),
          ),
        ),
      ),
    );
  }

  productListUI(SalesBillController controller) {
    BillModel billData;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GetBuilder<SalesBillController>(builder: (controller) {
        return controller.bills.isEmpty
            ? Center(
                child: Text(
                'No Bills'.tr,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
              ))
            :Get.find<UserController>().permission.value.viewSales ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedOpacity(
                    opacity: controller.isSearch.value ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 1000),
                    child: controller.isSearch.value
                        ? SizedBox(
                            width: ConstantApp.getWidth(context) * 0.25,
                            child: TextField(
                              onChanged: (value) =>
                                  controller.filterPlayer(value),
                              decoration: InputDecoration(
                                labelText: 'Search...'.tr,
                                suffixIcon: const Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Card(
                    child: Row(
                      children: [
                        Flexible(
                            flex: 2,
                            fit: FlexFit.tight,
                            child: Text(
                              'Nu.bill'.tr,
                              style: ConstantApp.getTextStyle(
                                  context: context,
                                  size: 7,
                                  color: secondaryColor,
                                  fontWeight: FontWeight.bold),
                            )),
                        Flexible(
                            flex: 2,
                            fit: FlexFit.tight,
                            child: Center(
                              child: Text(
                                'Customer'.tr,
                                style: ConstantApp.getTextStyle(
                                    context: context,
                                    size: 7,
                                    color: secondaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                        Flexible(
                            flex: 2,
                            fit: FlexFit.tight,
                            child: Center(
                                child: Text(
                              'Pay Type'.tr,
                              style: ConstantApp.getTextStyle(
                                  context: context,
                                  size: 7,
                                  color: secondaryColor,
                                  fontWeight: FontWeight.bold),
                            ))),
                        Flexible(
                            flex: 2,
                            fit: FlexFit.tight,
                            child: Center(
                              child: Text(
                                'Cashier'.tr,
                                style: ConstantApp.getTextStyle(
                                    context: context,
                                    size: 7,
                                    color: secondaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                        Flexible(
                            flex: 2,
                            fit: FlexFit.tight,
                            child: Text(
                              Get.find<InfoController>().taxesSetting.isNotEmpty
                                  ? 'Exc.vat'.tr
                                  : "Subtotal".tr,
                              style: ConstantApp.getTextStyle(
                                  context: context,
                                  size: 7,
                                  color: secondaryColor,
                                  fontWeight: FontWeight.bold),
                            )),
                        Flexible(
                            flex: 2,
                            fit: FlexFit.tight,
                            child: Center(
                              child: Text(
                                'Discount'.tr,
                                style: ConstantApp.getTextStyle(
                                    context: context,
                                    size: 7,
                                    color: secondaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                        Flexible(
                            flex: 2,
                            fit: FlexFit.tight,
                            child: Center(
                              child: Text(
                                'Dis.Amo'.tr,
                                style: ConstantApp.getTextStyle(
                                    context: context,
                                    size: 7,
                                    color: secondaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                        Flexible(
                            flex: 2,
                            fit: FlexFit.tight,
                            child: Center(
                              child: Text(
                                'Vat'.tr,
                                style: ConstantApp.getTextStyle(
                                    context: context,
                                    size: 7,
                                    color: secondaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                        Flexible(
                            flex: 2,
                            fit: FlexFit.tight,
                            child: Center(
                              child: Text(
                                'Final total'.tr,
                                style: ConstantApp.getTextStyle(
                                    context: context,
                                    size: 7,
                                    color: secondaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                        Flexible(
                            flex: 2,
                            fit: FlexFit.tight,
                            child: Center(
                              child: Text(
                                'Date'.tr,
                                style: ConstantApp.getTextStyle(
                                    context: context,
                                    size: 7,
                                    color: secondaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                        Flexible(
                            flex: 2,
                            fit: FlexFit.tight,
                            child: Center(
                              child: Text(
                                'Table'.tr,
                                style: ConstantApp.getTextStyle(
                                    context: context,
                                    size: 7,
                                    color: secondaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                        Flexible(
                            flex: 2,
                            fit: FlexFit.tight,
                            child: Center(
                              child: Text(
                                'Hall'.tr,
                                style: ConstantApp.getTextStyle(
                                    context: context,
                                    size: 7,
                                    color: secondaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                        Flexible(
                            flex: 2,
                            fit: FlexFit.tight,
                            child: Center(
                              child: Text(
                                'Type'.tr,
                                style: ConstantApp.getTextStyle(
                                    context: context,
                                    size: 7,
                                    color: secondaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                        Flexible(
                            flex: 2,
                            fit: FlexFit.tight,
                            child: Center(
                              child: Text(
                                'Paid'.tr,
                                style: ConstantApp.getTextStyle(
                                    context: context,
                                    size: 7,
                                    color: secondaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                        Flexible(
                            flex: 2,
                            fit: FlexFit.tight,
                            child: Center(
                              child: Text(
                                'Balance'.tr,
                                style: ConstantApp.getTextStyle(
                                    context: context,
                                    size: 7,
                                    color: secondaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                        Flexible(
                            flex: 2,
                            fit: FlexFit.tight,
                            child: Center(
                              child: Text(
                                'Return'.tr,
                                style: ConstantApp.getTextStyle(
                                    context: context,
                                    size: 7,
                                    color: secondaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                        Flexible(
                            flex: 2,
                            fit: FlexFit.tight,
                            child: Center(
                              child: Text(
                                'Tips'.tr,
                                style: ConstantApp.getTextStyle(
                                    context: context,
                                    size: 7,
                                    color: secondaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                        Flexible(
                            flex: 2,
                            fit: FlexFit.tight,
                            child: Center(
                              child: Text(
                                'Cash'.tr,
                                style: ConstantApp.getTextStyle(
                                    context: context,
                                    size: 7,
                                    color: secondaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                        Flexible(
                            flex: 2,
                            fit: FlexFit.tight,
                            child: Center(
                              child: Text(
                                'Visa'.tr,
                                style: ConstantApp.getTextStyle(
                                    context: context,
                                    size: 7,
                                    color: secondaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                        Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: IconButton(
                                onPressed: () async{
                                  await controller.getAllBills();
                                  await Get.find<OrderController>().getAllOrders();
                                },
                                icon: Icon(
                                  Icons.refresh,
                                  color: primaryColor,
                                ))),
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 4,
                    color: primaryColor,
                  ),
                  Expanded(
                      child: ListView.builder(
                    itemBuilder: (context, index) {
                      billData = controller.foundPlayers[index];
                      StoreModel? store = Get.find<InfoController>()
                          .stores
                          .firstWhereOrNull(
                              (element) => element.id == billData.storeId);
                      return TempBill(
                        nameOfCustom: billData.customerName!,
                        id: billData.id!,
                        cashier: billData.cashier!,
                        numberOfBill: billData.formatNumber!,
                        payType: billData.payType!,
                        totalPrice: billData.total!,
                        discount: billData.discountAmount!,
                        discountType: billData.disType!,
                        vat: billData.vat!,
                        priceWithVat: billData.finalTotal!,
                        date: billData.createdAt!,
                        disAmount: billData.discountAmount!,
                        total: billData.total! * 105 / 100,
                        table: billData.table!,
                        hall: billData.hall!,
                        type: billData.salesType ?? 'sales',
                        tips: billData.tips ?? 0.0,
                        deletePressed: () {
                          var cont =Get.find<UserController>();
                          bool result = cont.isPermission(cont.permission.value.deleteSales, context);
                          if(!result){
                            return;
                          }
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                    'Delete Bill?'.tr,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  content: Text(
                                    'Do you really want to delete this Bill ?'
                                        .tr,
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: Text(
                                        'Cancel'.tr,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        Get.back();
                                        var cashierName =
                                            Get.find<SharedPreferences>()
                                                    .getString('name') ??
                                                '';
                                        var cashierId =
                                            Get.find<SharedPreferences>()
                                                    .getInt('userId') ??
                                                0;
                                        var result =
                                            await controller.deleteBill(
                                                billId: billData.id ?? 0,
                                                cashierId: cashierId,
                                                format:
                                                    billData.formatNumber ?? '',
                                                cashierName: cashierName);
                                        if (!context.mounted) {
                                          return;
                                        }
                                        if (result) {
                                          ConstantApp.showSnakeBarSuccess(
                                              context, 'Delete Success !!');
                                        } else {
                                          ConstantApp.showSnakeBarError(context,
                                              'Sorry , Can Not Delete !!');
                                        }
                                        setState(() {
                                        });

                                      },
                                      child: Text('Delete'.tr,
                                          style: const TextStyle(
                                              color: Colors.redAccent)),
                                    ),
                                  ],
                                );
                              });
                          setState(() {
                          });
                        },
                        editPressed: () async {
                          var cont =Get.find<UserController>();
                          bool result = cont.isPermission(cont.permission.value.editSales, context);
                          if(!result){
                            return;
                          }
                          await Get.find<OrderController>().getAllProducts();
                          await Get.find<OrderController>().getAllOrders();
                          await Get.find<OrderController>().getCustomerOrderNumber();
                          await Get.find<SalesBillController>().getOrderWithBill(controller.foundPlayers[index].formatNumber!);
                          Get.to(()=>EditBill(bill: controller.foundPlayers[index]));
                        },
                        edit: true,
                        balance:
                            ((double.tryParse(billData.balance ?? '0') ?? 0.0) *
                                    -1)
                                .toStringAsFixed(2),
                        paid: billData.paid,
                        view: () async {},
                        print: () async {
                          billData = controller.foundPlayers[index];
                          Get.dialog(
                              Center(
                                child: SizedBox(
                                  height: ConstantApp.isTab(context)
                                      ? ScaledDimensions.getScaledHeight(
                                          px: 150,
                                        )
                                      : ScaledDimensions.getScaledHeight(
                                          px: 200,
                                        ),
                                  width: ConstantApp.isTab(context)
                                      ? ScaledDimensions.getScaledWidth(px: 150)
                                      : ScaledDimensions.getScaledWidth(
                                          px: 100),
                                  child: Material(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Expanded(
                                          child: CustomAppButton(
                                            onPressed: () async {
                                              Get.back();
                                              await Get.find<OrderController>()
                                                  .getAllOrders();
                                              var allOrders1 =
                                                  Get.find<OrderController>()
                                                      .orderView;
                                              List<OrderModel> order =
                                                  allOrders1
                                                      .where((element) =>
                                                          element.billNum ==
                                                          billData.formatNumber)
                                                      .toList();

                                              if (!mounted) return;
                                              var doc = await Get.find<
                                                      OrderController>()
                                                  .printBill(
                                                      orders: order,
                                                      bill: billData,
                                                      printerName: '',
                                                      customerAddress: null,
                                                      customerNum: null);
                                              Get.to(() => PdfPreview(
                                                    actions: [
                                                      IconButton(
                                                          onPressed: () {
                                                            Get.back();
                                                          },
                                                          icon: const Icon(
                                                              Icons.close))
                                                    ],
                                                    build: (format) =>
                                                        doc.save(),
                                                  ));
                                            },
                                            title: 'View'.tr,
                                            backgroundColor: primaryColor,
                                            textColor: Colors.black,
                                            withPadding: true,
                                            height: ScaledDimensions
                                                .getScaledHeight(px: 50),
                                            width:
                                                ScaledDimensions.getScaledWidth(
                                                    px: 60),
                                          ),
                                        ),
                                        Expanded(
                                          child: CustomAppButton(
                                            onPressed: () async {
                                              Get.back();
                                              await Get.find<OrderController>()
                                                  .getAllOrders();
                                              var allOrders1 =
                                                  Get.find<OrderController>()
                                                      .orderView;
                                              List<OrderModel> order =
                                                  allOrders1
                                                      .where((element) =>
                                                          element.billNum ==
                                                          billData.formatNumber)
                                                      .toList();

                                              if (!mounted) return;
                                              var doc = await Get.find<
                                                      OrderController>()
                                                  .printBill(
                                                      orders: order,
                                                      bill: billData,
                                                      printerName: '',
                                                      customerAddress: null,
                                                      customerNum: null);

                                              var printer = await Get.find<
                                                      AppDataBaseController>()
                                                  .appDataBase
                                                  .getPrinterSetting(1);
                                              var allPrinters = await Get.find<
                                                      AppDataBaseController>()
                                                  .appDataBase
                                                  .getAllPrinter();
                                              if (printer!.billPrinter != 0) {
                                                String name = allPrinters
                                                    .firstWhere((element) =>
                                                        element.id ==
                                                        printer.billPrinter)
                                                    .printerName!;
                                                await Printing.directPrintPdf(
                                                  usePrinterSettings: true,
                                                  dynamicLayout: false,
                                                  printer: Printer(
                                                    url: name,
                                                    name: name,
                                                  ),
                                                  onLayout: (format) async =>
                                                      doc.save(),
                                                );
                                              } else {
                                                if (!context.mounted) return;
                                                ConstantApp.showSnakeBarError(
                                                    context,
                                                    'ADD Printer From Printer Setting !!');
                                                return;
                                              }
                                            },
                                            title: 'Print'.tr,
                                            backgroundColor: primaryColor,
                                            textColor: Colors.black,
                                            withPadding: true,
                                            height: ScaledDimensions
                                                .getScaledHeight(px: 50),
                                            width:
                                                ScaledDimensions.getScaledWidth(
                                                    px: 60),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              barrierColor:
                                  Colors.transparent.withOpacity(0.5));
                        },
                        onTapNuBill: () async {
                          await Get.find<InfoController>().getAllStore();
                          await Get.find<InfoController>().getAllEmployee();
                          await Get.find<OrderController>().getAllProducts();
                          billData = controller.foundPlayers[index];
                          String store = "";
                          String costCenter = "";
                          for (var i in Get.find<InfoController>().stores) {
                            if (billData.storeId == i.id) {
                              store = i.name;
                            }
                          }
                          if (!context.mounted) return;
                          showDialog(
                              context: context,
                              builder: (context) {
                                return CustomSalesDialog(
                                  bill: billData,
                                  isAdmin: true,
                                  customer: billData.customerName!,
                                  store: store,
                                  numberOfBill: billData.formatNumber!,
                                  costCenter: costCenter,
                                );
                              });
                        },
                        cashTotal: billData.cashAmount!,
                        visaTotal: billData.visaAmount!,
                        store: store?.name ?? "",
                      );
                    },
                    itemCount: controller.foundPlayers.length,
                  )),
                ],
              ) : Center(
            child: Text(
              'NO Permission !! '.tr,
              style: const TextStyle(
                fontSize: 30,
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ));
      }),
    );
  }
}
