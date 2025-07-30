import 'package:cashier_app/controllers/info_controllers.dart';
import 'package:cashier_app/controllers/sales_controller.dart';
import 'package:cashier_app/models/bill_model.dart';
import 'package:cashier_app/modules/home_view/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/Theme/colors.dart';
import '../../../utils/scaled_dimensions.dart';
import '../../controllers/user_controller.dart';
import '../../database/app_db_controller.dart';
import '../../global_widgets/custom_app_button.dart';
import '../../global_widgets/custom_app_button_icon.dart';
import '../../utils/constant.dart';
import '../bill/bill_report.dart';
import '../close_box/close_box.dart';
import '../setting/setting_page.dart';
import 'login.dart';

class ControlScreen extends StatefulWidget {
  const ControlScreen({super.key});

  @override
  State<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            width: ConstantApp.getWidth(context),
            height: ConstantApp.getHeight(context),
            decoration: BoxDecoration(
              gradient: backgroundGradient,
            ),
            child: Stack(
              children: [
                Opacity(
                  opacity: 0.7,
                  child: SizedBox(
                    height: ConstantApp.getHeight(context),
                    width: ConstantApp.getWidth(context),
                    child: ConstantApp.appType.backImage != null
                        ? Image.memory(
                            ConstantApp.appType.backImage!,
                            fit: BoxFit.fill,
                          )
                        : Image.asset(
                            ConstantApp.appType.backgroundImage ??
                                "assets/background/restaurant.jpg",
                            fit: BoxFit.fill,
                          ),
                  ),
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomAppButtonIcon(
                        height: ConstantApp.getHeight(context) / 5.5,
                        width: ConstantApp.getWidth(context) / 6.5,
                        onPressed: () async {
                          var cont =Get.find<UserController>();
                          bool result = cont.isPermission(cont.permission.value.closeBox, context);
                          if(!result){
                            return;
                          }
                          bool isActive = await Get.find<UserController>()
                              .checkUser(context: context);
                          if (isActive) {
                            return;
                          }
                          Get.to(() => const CloseBox());
                        },
                        title: 'Close Box'.tr,
                        backgroundColor: primaryColor,
                        textColor: Colors.white,
                        withPadding: true,
                        icon: FontAwesomeIcons.boxArchive,
                        iconImage: '',
                      ),
                      CustomAppButtonIcon(
                        height: ConstantApp.getHeight(context) / 5.5,
                        width: ConstantApp.getWidth(context) / 6.5,
                        onPressed: () async {
                          bool isActive = await Get.find<UserController>()
                              .checkUser(context: context);
                          if (isActive) {
                            return;
                          }
                          var bill = Get.find<InfoController>().bills;
                          var users = Get.find<UserController>().users;
                          int userId =
                              Get.find<SharedPreferences>().getInt('userId') ??
                                  0;
                          List<BillModel> billFilter = [];
                          billFilter = bill.where((element) {
                            return (element.createdAt!.year ==
                                        DateTime.now().year &&
                                    element.createdAt!.month ==
                                        DateTime.now().month &&
                                    element.createdAt!.day ==
                                        DateTime.now().day) &&
                                (userId == 0
                                    ? true
                                    : element.cashier ==
                                        users
                                            .firstWhere((element) =>
                                                element.id == userId)
                                            .name);
                          }).toList();
                          if (billFilter.isEmpty) {
                            if (!context.mounted) return;
                            ConstantApp.showSnakeBarInfo(
                                context, 'NO BILLS FOUND');
                            return;
                          }

                          if (!context.mounted) {
                            return;
                          }
                          showAnimatedDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  alignment: Alignment.center,
                                  actionsPadding: const EdgeInsets.all(20),
                                  content: Text(
                                    'Sales Report',
                                    textAlign: TextAlign.center,
                                    style: ConstantApp.getTextStyle(
                                        context: context,
                                        size: 12,
                                        color: secondaryColor,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  title: Obx(() => Get.find<UserController>()
                                          .loading
                                          .value
                                      ? const Center(
                                          child: CircularProgressIndicator())
                                      : const SizedBox()),
                                  actions: [
                                    CustomAppButton(
                                        height:
                                            ScaledDimensions.getScaledHeight(
                                                px: 60),
                                        width: ScaledDimensions.getScaledWidth(
                                            px: 60),
                                        onPressed: () async {
                                          bool isActive =
                                              await Get.find<UserController>()
                                                  .checkUser(context: context);
                                          if (isActive) {
                                            return;
                                          }
                                          Get.find<UserController>()
                                              .loading
                                              .value = true;
                                          var doc =
                                              await Get.find<UserController>()
                                                  .printUsersReport(
                                            printerName: '',
                                            list: billFilter,
                                            user: userId,
                                            box: true,
                                            cat: true,
                                            item: true,
                                          );
                                          Get.back();
                                          Get.find<UserController>()
                                              .loading
                                              .value = false;
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
                                        textColor: Colors.white,
                                        withPadding: false),
                                    CustomAppButton(
                                        height:
                                            ScaledDimensions.getScaledHeight(
                                                px: 60),
                                        width: ScaledDimensions.getScaledWidth(
                                            px: 60),
                                        onPressed: () async {
                                          bool isActive =
                                              await Get.find<UserController>()
                                                  .checkUser(context: context);
                                          if (isActive) {
                                            return;
                                          }
                                          Get.find<UserController>()
                                              .loading
                                              .value = true;
                                          var doc =
                                              await Get.find<UserController>()
                                                  .printUsersReport(
                                            printerName: '',
                                            list: billFilter,
                                            user: userId,
                                            box: true,
                                            cat: true,
                                            item: true,
                                          );
                                          Get.back();
                                          Get.find<UserController>()
                                              .loading
                                              .value = false;
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
                                                'ADD Printer From Printer Setting !!'
                                                    .tr);
                                            return;
                                          }
                                        },
                                        title: 'Print'.tr,
                                        backgroundColor: primaryColor,
                                        textColor: Colors.white,
                                        withPadding: false),
                                  ],
                                );
                              },
                              barrierDismissible: true,
                              animationType: DialogTransitionType.slideFromTop,
                              curve: Curves.fastOutSlowIn,
                              duration: const Duration(milliseconds: 400));
                        },
                        title: 'Sales Report'.tr,
                        backgroundColor: primaryColor,
                        textColor: Colors.white,
                        withPadding: true,
                        icon: Icons.fact_check,
                        iconImage: '',
                      ),
                      CustomAppButtonIcon(
                        height: ConstantApp.getHeight(context) / 5.5,
                        width: ConstantApp.getWidth(context) / 6.5,
                        onPressed: () async {
                          await Get.find<SalesBillController>().getAllBills();
                          Get.to(() => const SalesReportPage());
                        },
                        title: 'Bills'.tr,
                        backgroundColor: primaryColor,
                        textColor: Colors.white,
                        withPadding: true,
                        icon: Icons.list_alt,
                        iconImage: '',
                      ),
                      CustomAppButtonIcon(
                        height: ConstantApp.getHeight(context) / 5.5,
                        width: ConstantApp.getWidth(context) / 6.5,
                        onPressed: () async {
                          bool isActive = await Get.find<UserController>()
                              .checkUser(context: context);
                          if (isActive) {
                            return;
                          }
                          Get.off(() => const HomeView());
                        },
                        title: 'POS'.tr,
                        backgroundColor: primaryColor,
                        textColor: Colors.white,
                        withPadding: true,
                        icon: FontAwesomeIcons.tv,
                        iconImage: '',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () async {
                      bool isActive = await Get.find<UserController>()
                          .checkUser(context: context);
                      if (isActive) {
                        return;
                      }
                      await Get.find<InfoController>().getAllStore();
                      Get.to(() => const AppSetting());
                    },
                    tooltip: 'Setting',
                    iconSize: 30,
                    icon: Icon(
                      Icons.settings,
                      color: secondaryColor,
                    )),
                IconButton(
                    onPressed: () {
                      showAnimatedDialog(
                          context: context,
                          builder: (context) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: SingleChildScrollView(
                                child: AlertDialog(
                                  alignment: Alignment.topCenter,
                                  backgroundColor:
                                      Colors.white.withOpacity(0.9),
                                  actionsPadding: const EdgeInsets.all(20),
                                  shape: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30))),
                                  title: Center(
                                      child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Lottie.asset('lottie/question.json',
                                          height: 200, width: 200),
                                      const Text('Are You Sure To Logout ?',
                                          textAlign: TextAlign.center),
                                    ],
                                  )),
                                  content: const Text(
                                      'You Will Not Be Able To Return To This Page',
                                      textAlign: TextAlign.center),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateColor.resolveWith(
                                                    (states) =>
                                                        Colors.redAccent)),
                                        child: const Padding(
                                          padding: EdgeInsets.only(
                                              left: 20, right: 20),
                                          child: Text(
                                            'No',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        )),
                                    ElevatedButton(
                                        onPressed: () async {
                                          await Get.find<UserController>()
                                              .getUsers();
                                          Get.find<SharedPreferences>()
                                              .remove('name');
                                          Get.find<SharedPreferences>()
                                              .remove('userId');
                                          Get.find<SharedPreferences>()
                                              .remove('type');
                                          Get.back();
                                          Get.offAll(() => const LoginPage());
                                        },
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateColor.resolveWith(
                                                    (states) => primaryColor
                                                        .withOpacity(0.8))),
                                        child: const Padding(
                                          padding: EdgeInsets.only(
                                              left: 20, right: 20),
                                          child: Text(
                                            'Yes',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            );
                          },
                          barrierDismissible: true,
                          animationType: DialogTransitionType.slideFromTop,
                          curve: Curves.fastOutSlowIn,
                          duration: const Duration(milliseconds: 400));
                    },
                    tooltip: 'Logout',
                    iconSize: 30,
                    icon: Icon(Icons.logout, color: secondaryColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
