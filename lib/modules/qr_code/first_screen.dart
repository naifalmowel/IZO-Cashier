import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:cashier_app/controllers/internet_check_controller.dart';
import 'package:cashier_app/controllers/user_controller.dart';
import '../../utils/Theme/colors.dart';
import '../../utils/constant.dart';
import '../../utils/input_format.dart';
import '../widget/no_internet_widget.dart';
import '/controllers/info_controllers.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

MobileScannerController cameraController = MobileScannerController();
TextEditingController ipController = TextEditingController();
class _FirstScreenState extends State<FirstScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.grey.withOpacity(0.3)),
          ),
          Obx(() => Get.find<InfoController>().isLoadingCheck.value
              ? Center(
                  child: SpinKitFoldingCube(
                  color: primaryColor,
                  size: 75,
                ))
              : Get.find<INetworkInfo>().connectionStatus.value == 0
                  ? EmptyFailureNoInternetView(
                      image: 'lottie/no_internet.json',
                      title: 'Network Error',
                      description: 'Internet Not Found !!',
                      buttonText: "Retry",
                      onPressed: () async {},
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            if (MediaQuery.of(context).size.width > 850)
                              Row(
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Lottie.asset(
                                        'lottie/db_server.json',
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: info(),
                                  )),
                                ],
                              ),
                            if (MediaQuery.of(context).size.width < 850)
                              Center(
                                child: Lottie.asset(
                                  'lottie/db_server.json',
                                ),
                              ),
                            if (MediaQuery.of(context).size.width < 850) info(),
                          ],
                        ),
                      ),
                    ))
        ],
      ),
    );
  }

  Widget info() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 50),
        child: Container(
          width: MediaQuery.of(context).size.width < 750
              ? ConstantApp.getWidth(context) / 1.1
              : ConstantApp.getWidth(context) / 1.6,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: -3,
                  blurRadius: 7,
                  offset: const Offset(0, 15), // changes position of shadow
                )
              ],
              border: Border.all(color: Colors.grey.withOpacity(0.8), width: 3),
              color: Colors.grey.withOpacity(0.3)),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 50, top: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome'.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: ConstantApp.getTextStyle(
                      context: context,
                      size: 20,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'To The IZO Cashier',
                  textAlign: TextAlign.center,
                  style: ConstantApp.getTextStyle(
                      context: context,
                      size: 15,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.only(
                      left: ConstantApp.getWidth(context) / 12,
                      right: ConstantApp.getWidth(context) / 12),
                  child: Text(
                    'Please open the desktop application (IZO) and type the IP found in the settings menu under the active mobile application',
                    textAlign: TextAlign.center,
                    style: ConstantApp.getTextStyle(
                        context: context,
                        size: 9,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const Gutter(),
                // Align(
                //   alignment: MediaQuery.of(context).size.width > 650
                //       ? Alignment.bottomRight
                //       : Alignment.bottomCenter,
                //   child: Padding(
                //     padding: EdgeInsets.only(
                //         left: ConstantApp.getWidth(context) / 12,
                //         right: ConstantApp.getWidth(context) / 12),
                //     child: ElevatedButton(
                //         onPressed: () async {
                //           if(GetPlatform.isWindows){
                //             ConstantApp.showSnakeBarError(context, 'Sorry , Can Not Find The Camera .. !!');
                //             return;
                //           }
                //           ConstantApp.type = "";
                //           Get.find<InfoController>().isLoading(false);
                //           Get.find<InfoController>().isLoadingCheck(false);
                //           Get.to(() => const MyHomePage());
                //           // Get.to(() => const LoginPage());
                //         },
                //         style: ButtonStyle(
                //             shape: MaterialStateProperty.all<
                //                     RoundedRectangleBorder>(
                //                 RoundedRectangleBorder(
                //                     borderRadius: BorderRadius.circular(18),
                //                     side: const BorderSide(
                //                         color: Colors.black38))),
                //             backgroundColor: MaterialStateColor.resolveWith(
                //                 (states) => primaryColor)),
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: [
                //             Padding(
                //               padding: const EdgeInsets.all(10),
                //               child: Text('Scan QR',
                //                   maxLines: 1,
                //                   overflow: TextOverflow.ellipsis,
                //                   style: ConstantApp.getTextStyle(
                //                       context: context,
                //                       color: Colors.white,
                //                       size: 8)),
                //             ),
                //             Icon(Icons.qr_code,
                //                 size: ConstantApp.getTextSize(context) * 13,
                //                 color: Colors.white),
                //           ],
                //         )),
                //   ),
                // ),
                // const SizedBox(
                //   height: 10,
                // ),
                Align(
                  alignment: MediaQuery.of(context).size.width > 650
                      ? Alignment.bottomRight
                      : Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: ConstantApp.getWidth(context) / 12,
                        right: ConstantApp.getWidth(context) / 12),
                    child: ElevatedButton(
                        onPressed: () async {
                          openAlertBox();
                        },
                        style: ButtonStyle(
                            shape: WidgetStateProperty.all<
                                RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                    side: const BorderSide(
                                        color: Colors.black38))),
                            backgroundColor: WidgetStateColor.resolveWith(
                                    (states) => primaryColor)),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text('Connect to the server ',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: ConstantApp.getTextStyle(
                                    context: context,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    size: 9)),
                          ),
                        )),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // TextButton(
                //     onPressed: (){
                //   ConstantApp.type = "guest";
                //   Get.find<InfoController>().getAllInformation();
                //   Get.to(()=>const HomeView());
                // }, child:  Text("Log In AS Guest",style: ConstantApp.getTextStyle(context: context,fontWeight: FontWeight.bold),)),
              ],
            ),
          ),
        ),
      ),
    );
  }
  openAlertBox() {
    ipController.clear();
    Get.find<InfoController>().isLoading.value = false;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            contentPadding: const EdgeInsets.only(top: 10.0),
            content: SizedBox(
              width: 300.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Write IP Address Here And Click Connect',
                    textAlign: TextAlign.center,
                    style: ConstantApp.getTextStyle(
                        context: context,
                        color: secondaryColor,
                        fontWeight: FontWeight.w600,
                        size: 10),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  const Divider(
                    color: Colors.grey,
                    height: 4.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 30.0, right: 30.0, top: 10, bottom: 10),
                    child: TextFormField(
                      controller: ipController,
                      inputFormatters: [
                        MyInputFormatters.ipAddressInputFilter(),
                        LengthLimitingTextInputFormatter(15),
                        IpAddressInputFormatter()
                      ],
                      onFieldSubmitted: (_){
                        Get.back();
                        ConstantApp.type = "";
                        Get.find<InfoController>().isLoadingCheck(true);
                        Future.microtask(() async{ if (ipController.text.isNotEmpty) {
                          await foundBarcode(BarcodeCapture(), context,ipController.text);
                          Get.find<InfoController>().isLoadingCheck(false);
                          Get.find<InfoController>().isLoading(false);
                        }
                        });
                      },
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        label: Text('IP Address'),
                        hintText: '192.168.1.1',
                        border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(20))),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      Get.back();
                      ConstantApp.type = "";
                      Get.find<InfoController>().isLoadingCheck(true);
                      Future.microtask(() async{ if (ipController.text.isNotEmpty) {
                        await foundBarcode(BarcodeCapture(), context,ipController.text);
                        Get.find<InfoController>().isLoadingCheck(false);
                        Get.find<InfoController>().isLoading(false);
                      }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(32.0),
                            bottomRight: Radius.circular(32.0)),
                      ),
                      child: Text(
                        "Connect",
                        style: ConstantApp.getTextStyle(
                            context: context,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            size: 10),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  MobileScannerController cameraController = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text("Mobile Scanner"),
        actions: [
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.torchState,
              builder: (context, state, child) {
                switch (state) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off, color: Colors.white);
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: Colors.yellow);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.cameraFacingState,
              builder: (context, state, child) {
                switch (state) {
                  case CameraFacing.front:
                    return const Icon(Icons.flip_camera_ios);
                  case CameraFacing.back:
                    return const Icon(Icons.flip_camera_ios_outlined);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: MobileScanner(
        startDelay: true,
        controller: cameraController,
        onDetect: (value) async {
          Get.find<InfoController>().isLoadingCheck(true);
          if (value.barcodes.isNotEmpty) {
            cameraController.stop();
            Get.back(canPop: true);
            await foundBarcode(value, context , '');
            Get.find<InfoController>().isLoadingCheck(false);
            Get.find<InfoController>().isLoading(false);
          }
        },
      ),
    );
  }


}
Future<void> foundBarcode(
    BarcodeCapture barcode, BuildContext context , String address) async {
  try {
    final String code =address == ''? (barcode.barcodes.last.rawValue ?? "---") : '$address-8080';
    debugPrint('Barcode found! $code');
    Get.find<SharedPreferences>().setString('url', code.replaceAll('-', ':'));
    bool check = await Get.find<InfoController>().checkQR();
    bool check1 = await Get.find<InfoController>().checkMobile();
    if (check1) {
      await Get.find<UserController>().getUsers();
      await Get.find<InfoController>().signUp();
      await Get.find<InfoController>().getAllInformation();
      await Get.find<InfoController>().getAllStore();
      await Get.find<InfoController>().getAllEmployee();
      Get.find<InfoController>().isLoadingCheck(false);
      Get.find<InfoController>().isLoading(false);
    }
    else {
      if (check) {
        await Get.find<UserController>().getUsers();
        await Get.find<InfoController>().signUp();
        await Get.find<InfoController>().getAllInformation();
        await Get.find<InfoController>().getAllStore();
        await Get.find<InfoController>().getAllEmployee();
        Get.find<InfoController>().isLoadingCheck(false);
        Get.find<InfoController>().isLoading(false);
      } else {
        if(!context.mounted){
          return;
        }
        ConstantApp.showSnakeBarError(context, 'SORRY , NO SERVER CONNECTION !!');
        Get.find<SharedPreferences>().remove('url');
        Get.find<InfoController>().isLoadingCheck(false);
        Get.find<InfoController>().isLoading(false);
      }
    }
  } catch (e) {
    if(!context.mounted){
      return;
    }
    ConstantApp.showSnakeBarError(context, 'SORRY , NO SERVER CONNECTION !!');
    Get.find<SharedPreferences>().remove('url');
  }
  Get.find<InfoController>().isLoading(false);
  Get.find<InfoController>().isLoadingCheck(false);
}