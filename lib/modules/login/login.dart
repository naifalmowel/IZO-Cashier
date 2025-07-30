import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:cashier_app/controllers/info_controllers.dart';
import 'package:cashier_app/controllers/user_controller.dart';
import 'package:cashier_app/modules/qr_code/first_screen.dart';
import 'package:cashier_app/utils/constant.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controllers/internet_check_controller.dart';
import '../../utils/Theme/colors.dart';
import '../../controllers/order_controller.dart';
import '../widget/no_internet_widget.dart';
import 'control_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  MobileScannerController cameraController = MobileScannerController();
  FocusNode passwordFN = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool vis = false;
  int userId = 0;
  late TextEditingController passwordController;

  @override
  void initState() {
    passwordController = TextEditingController();
    userId = 0;
    vis = false;
    super.initState();
  }

  @override
  void dispose() {
    passwordController.dispose();
    passwordFN.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.grey.withOpacity(0.3)),
          ),
          Obx(() => Get.find<UserController>().isLogin.value
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
                  : Form(
            key: _formKey,
                    child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: SingleChildScrollView(
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  if (MediaQuery.of(context).size.width > 850)
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child:Obx(() => Get.find<InfoController>().isServerConnect.value ?  Center(
                                            child: Lottie.asset(
                                                'lottie/login.json',
                                                width: 650,
                                                height: 650),
                                          ) : Center(
                                            child: Lottie.asset(
                                                'lottie/serverF.json',
                                                width: 650,
                                                height: 650),
                                          )),
                                        ),
                                        Expanded(
                                            flex: 1,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: info(),
                                            )),
                                      ],
                                    ),
                                  if (MediaQuery.of(context).size.width < 850)
                                    Center(
                                      child: Lottie.asset(
                                        'lottie/login.json',
                                      ),
                                    ),
                                  if (MediaQuery.of(context).size.width < 850)
                                    info(),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: IconButton(
                                    onPressed: () {
                                      showAnimatedDialog(
                                          context: context,
                                          builder: (context) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 20),
                                              child: SingleChildScrollView(
                                                child: AlertDialog(
                                                  alignment: Alignment.topCenter,
                                                  backgroundColor: Colors.white
                                                      .withOpacity(0.9),
                                                  actionsPadding:
                                                      const EdgeInsets.all(20),
                                                  shape: const OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  30))),
                                                  title: Center(
                                                      child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Lottie.asset(
                                                          'lottie/question.json',
                                                          height: 200,
                                                          width: 200),
                                                      const Text(
                                                          'Are You Sure To Rescan QR Code ?',
                                                          textAlign:
                                                              TextAlign.center),
                                                    ],
                                                  )),
                                                  content: const Text(
                                                      'You Will Not Be Able To Return To This Page',
                                                      textAlign:
                                                          TextAlign.center),
                                                  actions: [
                                                    ElevatedButton(
                                                        onPressed: () {
                                                          Get.back();
                                                        },
                                                        style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateColor
                                                                    .resolveWith(
                                                                        (states) =>
                                                                            Colors
                                                                                .redAccent)),
                                                        child: const Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 20,
                                                                  right: 20),
                                                          child: Text(
                                                            'No',
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        )),
                                                    ElevatedButton(
                                                        onPressed: () {
                                                          Get.find<
                                                                  SharedPreferences>()
                                                              .remove('url');
                                                          Get.find<InfoController>().isLoading.value = false;
                                                          Get.back();
                                                          Get.offAll(() =>
                                                              const FirstScreen());
                                                        },
                                                        style: ButtonStyle(
                                                            backgroundColor: MaterialStateColor
                                                                .resolveWith((states) =>
                                                                    primaryColor
                                                                        .withOpacity(
                                                                            0.8))),
                                                        child: const Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 20,
                                                                  right: 20),
                                                          child: Text(
                                                            'Yes',
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                          barrierDismissible: true,
                                          animationType:
                                              DialogTransitionType.slideFromTop,
                                          curve: Curves.fastOutSlowIn,
                                          duration:
                                              const Duration(milliseconds: 400));
                                    },
                                    icon: const Icon(Icons.qr_code),
                                    color: primaryColor,
                                    tooltip: "Rescan QR Code",
                                    iconSize: 35),
                              )
                            ],
                          ),
                        ),
                      ),
                  ))
        ],
      ),
    );
  }

  Widget info() {
    return Column(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: Container(
              width: Get.width > 750
                  ? ConstantApp.getWidth(context) / 1.6
                  : ConstantApp.getWidth(context) / 1.2,
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
                  border:
                      Border.all(color: Colors.grey.withOpacity(0.8), width: 3),
                  color: Colors.grey.withOpacity(0.3)),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Gutter(),
                      Text('LOGIN'.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: ConstantApp.getTextStyle(
                              context: context,
                              size: 15,
                              color: Colors.grey[800]!.withOpacity(0.8),
                              fontWeight: FontWeight.bold)),
                      Divider(color: primaryColor, thickness: 3),
                      const Gutter(),
                      GetBuilder<UserController>(builder: (controller) {
                        return Container(
                            margin: const EdgeInsets.only(
                                right: 50, left: 50, bottom: 20),
                            child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(color: Colors.black45),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 16,
                                    right: 16,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex : 10,
                                        child: Obx(() => Get.find<UserController>().isLogin1.value
                                            ? Center(
                                            child: SpinKitFoldingCube(
                                              color: primaryColor,
                                              size: 50,
                                            ))
                                            : DropdownButton(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(30)),
                                          value: userId == 0 ? null : userId,

                                          items: controller.users
                                              .map((element) => DropdownMenuItem(
                                            value: element.id,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 16, right: 16),
                                              child: Text(element.name),
                                            ),
                                          ))
                                              .toList(),
                                          onChanged: (value) {
                                            userId = value!;
                                            setState(() {});
                                          },
                                          icon: const Padding(
                                            //Icon at tail, arrow bottom is default icon
                                              padding: EdgeInsets.only(left: 20),
                                              child:
                                              Icon(Icons.arrow_circle_down_sharp)),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black87),
                                          dropdownColor: Colors.white70,
                                          hint: Text(
                                            'Select User',
                                            style: TextStyle(color: primaryColor),
                                          ),
                                          underline: Container(),
                                          isExpanded: true,
                                        )),
                                      ),
                                      Expanded(   flex : 1,child: IconButton(onPressed: ()async{
                                        await Get.find<UserController>().getUsers();
                                      }, icon: const Icon(Icons.refresh) , tooltip: 'Refresh',))
                                    ],
                                  ),
                                )));
                      }),
                      Container(
                        margin: const EdgeInsets.only(
                            right: 50, left: 50, bottom: 50),
                        child: TextFormField(
                          autovalidateMode:AutovalidateMode.onUserInteraction ,
                          controller: passwordController,
                          obscureText: !vis,
                          obscuringCharacter: '*',
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Can Not Be Empty !!';
                            }
                            return null;
                          },
                          onChanged: (value){},
                          decoration: InputDecoration(
                              label: const Text('Password'),
                              labelStyle: TextStyle(color: primaryColor),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: primaryColor),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(30)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: primaryColor),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(30)),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black45),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                              ),
                              focusColor: primaryColor.withOpacity(0.5),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  vis = !vis;
                                  setState(() {});
                                },
                                icon: Icon(vis
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                              )),
                          onFieldSubmitted: (value){
                            login();
                          },
                        ),
                      ),
                      Align(
                        alignment: MediaQuery.of(context).size.width > 650
                            ? Alignment.bottomRight
                            : Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 50, right: 50),
                          child: ElevatedButton(
                              onPressed: () async {
                                login();
                              },
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(18),
                                          side: const BorderSide(
                                              color: Colors.black38))),
                                  backgroundColor: MaterialStateColor.resolveWith(
                                      (states) => primaryColor)),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text('LOGIN',
                                        style: TextStyle(
                                            fontFamily: 'bung',
                                            fontSize: 20,
                                            color: Colors.white)),
                                  ),
                                ],
                              )),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      Obx(() =>  Get.find<InfoController>().isServerConnect.value?const SizedBox(): Container(
          decoration: const BoxDecoration(color: Colors.redAccent , borderRadius: BorderRadius.all(Radius.circular(20))),
          child:  Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Make Sure You Are Connected To The Server !!' ,  style: ConstantApp.getTextStyle(
                context: context,
                size: 8,
                color: secondaryColor,
                fontWeight: FontWeight.bold),),
          )))
      ],
    );
  }
  login()async{

    Get.find<UserController>().isLogin(true);
    if (userId == 0) {
      ConstantApp.showSnakeBarError(
          context, 'Please , Select User !!');
      Get.find<UserController>().isLogin(false);
      return;
    }
    if (passwordController.text.isEmpty) {
      ConstantApp.showSnakeBarError(
          context, 'Please , Enter Password !!');
      Get.find<UserController>().isLogin(false);
      return;
    }
    if (_formKey.currentState!.validate()) {
      await Get.find<UserController>().getUsers();
      if(!Get.find<InfoController>().isServerConnect.value){
        Get.find<UserController>().isLogin(false);
        return;
      }
      var user = Get.find<UserController>()
          .users
          .where((p0) => p0.id == userId)
          .toList();
      if (user.isNotEmpty) {
        if (user.last.password ==
            passwordController.text) {
          Get.find<SharedPreferences>()
              .remove('name');
          Get.find<SharedPreferences>()
              .remove('userId');
          Get.find<SharedPreferences>()
              .remove('type');
          Get.find<SharedPreferences>()
              .setString('name', user.last.name);
          Get.find<SharedPreferences>()
              .setString('type', user.last.type);
          Get.find<SharedPreferences>()
              .setInt('userId', user.last.id);
          await Get.find<UserController>().getPermission(userId: userId);
          if (!mounted) return;
          ConstantApp.showSnakeBarSuccess(
              context, 'Success Login !!');
          await Get.find<OrderController>()
              .getAllProducts();
          await Get.find<OrderController>()
              .getAllOrders();
          await Get.find<InfoController>()
              .balanceSetting();
          await Get.find<InfoController>().getCompanyInfo();
          await Get.find<InfoController>().getAllTaxesSetting();
          await Get.find<InfoController>().getAllTaxes();
          await Get.find<InfoController>().getAppType();
          await Get.find<InfoController>().getAllEmployee();
          Timer.periodic(const Duration(seconds: 1),
                  (timer) async {

            String url = Get.find<SharedPreferences>().getString('url')??'';
            if(url == '' ){
              timer.cancel();
            }
            Get.find<InfoController>().isServerConnect.value ?  await Get.find<InfoController>()
                    .getAllInformation() : null;
            Get.find<InfoController>().isServerConnect.value ?   await Get.find<OrderController>()
                    .getCustomerOrderNumber() : null;

              });
          Future.delayed(
              const Duration(milliseconds: 800), () {
            Get.offAll(() => const ControlScreen());
            Get.find<UserController>().isLogin(false);
          });
          passwordController.clear();
          userId = 0;
        } else {
          Get.find<UserController>().isLogin(false);
          if (!mounted) return;
          ConstantApp.showSnakeBarError(
              context, 'invalid Password !!');
        }
      }
    }
  }
}
