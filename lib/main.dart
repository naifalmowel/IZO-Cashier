import 'dart:io';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:cashier_app/utils/Theme/light_theme.dart';
import 'package:cashier_app/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:window_manager/window_manager.dart';
import '/controllers/info_controllers.dart';
import 'package:get/get.dart';
import '/controllers/internet_check_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'controllers/printer_controller.dart';
import 'controllers/sales_controller.dart';
import 'controllers/tables_controller.dart';
import 'controllers/user_controller.dart';
import 'database/app_db_controller.dart';
import 'modules/login/controller/login_controller.dart';
import 'controllers/order_controller.dart';
import 'modules/login/login.dart';
import 'modules/qr_code/first_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  Get.put(prefs);
  initController();
  initSharedPreferenceValue(prefs);
  PackageInfo info = await PackageInfo.fromPlatform();
  Get.find<SharedPreferences>().remove('version');
  Get.find<SharedPreferences>().setString('version', info.version);

  if (Platform.isWindows) {
    WindowOptions windowOptions = const WindowOptions(
      minimumSize: Size(800, 600),
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.setMinimumSize(const Size(800, 600));
      await windowManager.show();
      await windowManager.focus();
    });
  }
  runApp(const MyApp());
}

void initSharedPreferenceValue(SharedPreferences prefs) {
  Get.find<OrderController>().enableGuests.value =
      prefs.getBool("enableGuests") ?? false;
  ConstantApp.enableColor =
      Get.find<SharedPreferences>().getBool('enableColor') ?? false;
  ConstantApp.isDelivery =
      Get.find<SharedPreferences>().getBool('delivery') ?? false;
}

void initController() {
  Get.put(AppDataBaseController());
  Get.put(InfoController());
  Get.put(UserController());
  Get.put(OrderController());
  Get.put(LoginController());
  Get.put(INetworkInfo());
  Get.put(TableController());
  Get.put(PrinterController());
  Get.put(SalesBillController());
}

bool isE = false;
String urlServer = Get.find<SharedPreferences>().getString('url') ?? '';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      onInit: () async {
        if (urlServer.isNotEmpty) {
          try {
            isE = await Get.find<InfoController>().checkMobile();
            await Get.find<InfoController>().getAllInformation();
            await Get.find<UserController>().getUsers();
          } catch (e) {
            isE = false;
            Get.find<InfoController>().isLoading(false);
            Get.find<InfoController>().isLoadingCheck(false);
          }
        }
        Future.delayed(Duration(seconds: GetPlatform.isWindows ? 2 : 5), () {});
      },
      theme: lightTheme,
      defaultTransition: Transition.cupertino,
      debugShowCheckedModeBanner: false,
      title: 'cashier_app',
      home: Stack(
        children: [
          AnimatedSplashScreen(
            duration: 500,
            splash: 'assets/images/IZO.png',
            splashTransition: SplashTransition.slideTransition,
            animationDuration: const Duration(seconds: 3),
            backgroundColor: Colors.white,
            nextScreen: urlServer == ''
                ? const FirstScreen():const LoginPage(),
            splashIconSize: 200,
          ),
          Positioned(
            bottom: 10,
            right: 10,
            left: 10,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: SpinKitWave(
                color: Colors.black.withOpacity(0.9),
                size: 50,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
