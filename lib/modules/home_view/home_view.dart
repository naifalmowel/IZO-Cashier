import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:cashier_app/controllers/info_controllers.dart';
import 'package:cashier_app/controllers/internet_check_controller.dart';
import 'package:cashier_app/utils/constant.dart';
import 'package:lottie/lottie.dart';
import '../../controllers/user_controller.dart';
import '../../utils/Theme/colors.dart';
import '../tables/delivery/delivery.dart';
import '../tables/dien_in/tables_view.dart';
import '../tables/takeaway/takeaway.dart';
import '../widget/no_internet_widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InfoController>(builder: (controller) {
      controller.isDelivery.value = ConstantApp.isDelivery;
      return Obx(() => PopScope(
            canPop: false,
            onPopInvoked: (_) async {
              bool isActive =
                  await Get.find<UserController>().checkUser(context: context);
              if (isActive) {
                return;
              }
              if (!context.mounted) {
                return;
              }
              showAnimatedDialog(
                  context: context,
                  builder: (context) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: SingleChildScrollView(
                        child: AlertDialog(
                          alignment: Alignment.topCenter,
                          backgroundColor: Colors.white.withOpacity(0.9),
                          actionsPadding: const EdgeInsets.all(20),
                          shape: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          title: Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Lottie.asset('lottie/question.json',
                                  height: 200, width: 200),
                              const Text('Are You Sure To Exit ?',
                                  textAlign: TextAlign.center),
                            ],
                          )),
                          actions: [
                            ElevatedButton(
                                onPressed: () {
                                  Get.back();
                                },
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateColor.resolveWith(
                                            (states) => Colors.redAccent)),
                                child: const Padding(
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  child: Text(
                                    'No',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )),
                            ElevatedButton(
                                onPressed: () {
                                  exit(0);
                                },
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateColor.resolveWith(
                                            (states) =>
                                                primaryColor.withOpacity(0.8))),
                                child: const Padding(
                                  padding: EdgeInsets.only(left: 20, right: 20),
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
            child: Scaffold(
              body: <Widget>[
                Get.find<INetworkInfo>().connectionStatus.value == 0
                    ? EmptyFailureNoInternetView(
                        image: 'lottie/no_internet.json',
                        title: 'Network Error',
                        description: 'Internet Not Found !!',
                        buttonText: "Retry",
                        onPressed: () async {},
                      )
                    : const TakeawayView(),
                Get.find<INetworkInfo>().connectionStatus.value == 0
                    ? EmptyFailureNoInternetView(
                        image: 'lottie/no_internet.json',
                        title: 'Network Error',
                        description: 'Internet Not Found !!',
                        buttonText: "Retry",
                        onPressed: () async {},
                      )
                    : controller.isDelivery.value
                        ? (ConstantApp.appType.name == "REST" ||
                                ConstantApp.appType.name == "MARKET")
                            ? const DeliveryView()
                            : Center(
                                child: Column(
                                children: [
                                  Lottie.asset('lottie/notAvailable.json'),
                                  Text(
                                    'Not available for this version !!',
                                    style: ConstantApp.getTextStyle(
                                        context: context, size: 15),
                                  ),
                                ],
                              ))
                        : Center(
                            child: Container(
                            width: ConstantApp.getWidth(context),
                            height: ConstantApp.getHeight(context),
                            decoration: BoxDecoration(
                              gradient: backgroundGradient,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Lottie.asset('lottie/setting.json',
                                    width: ConstantApp.getWidth(context) / 4.5,
                                    height:
                                        ConstantApp.getHeight(context) / 4.5),
                                Text(
                                  'Please , Activate It From Settings .. !!',
                                  style: ConstantApp.getTextStyle(
                                      context: context, size: 15),
                                ),
                              ],
                            ),
                          )),
                Get.find<INetworkInfo>().connectionStatus.value == 0
                    ? EmptyFailureNoInternetView(
                        image: 'lottie/no_internet.json',
                        title: 'Network Error',
                        description: 'Internet Not Found !!',
                        buttonText: "Retry",
                        onPressed: () async {},
                      )
                    : ConstantApp.appType.name == "REST"
                        ? const TablesView()
                        : const SizedBox(),
              ][currentPageIndex],
              bottomNavigationBar: NavigationBar(
                onDestinationSelected: (int index) async {
                  bool isActive = await Get.find<UserController>()
                      .checkUser(context: context);
                  if (isActive) {
                    return;
                  }
                  setState(() {
                    currentPageIndex = index;
                  });
                },
                indicatorColor: primaryColor.withOpacity(0.6),
                selectedIndex: currentPageIndex,
                elevation: 20,
                shadowColor: secondaryColor,
                destinations: <Widget>[
                  NavigationDestination(
                    icon: Badge(
                        label: Text(controller.badgeTakeaway.length.toString()),
                        isLabelVisible:
                            controller.badgeTakeaway.isEmpty ? false : true,
                        child: const Icon(FontAwesomeIcons.bagShopping)),
                    label: ConstantApp.appType.name != "REST"
                        ? "Sales".tr
                        : 'TakeAway'.tr,
                  ),
                  NavigationDestination(
                    icon: Badge(
                        label: Text(controller.badgeDelivery.length.toString()),
                        isLabelVisible:
                            controller.badgeDelivery.isEmpty ? false : true,
                        child: const Icon(
                          FontAwesomeIcons.truckFast,
                        )),
                    label: 'Delivery',
                  ),
                  if (ConstantApp.appType.name == "REST")
                    NavigationDestination(
                      icon: Badge(
                        label: Text(controller.badgeTables.length.toString()),
                        isLabelVisible:
                            controller.badgeTables.isEmpty ? false : true,
                        child: const Icon(FontAwesomeIcons.utensils),
                      ),
                      label: 'Dine In',
                    ),
                ],
              ),
            ),
          ));
    });
  }
}
