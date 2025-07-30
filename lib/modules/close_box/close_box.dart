import 'package:cashier_app/controllers/user_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../database/app_db_controller.dart';
import '../../global_widgets/custom_app_button.dart';
import '../../global_widgets/custom_close_box_dialog.dart';
import '../../utils/Theme/colors.dart';
import '../../utils/constant.dart';

class CloseBox extends StatefulWidget {
  const CloseBox({Key? key}) : super(key: key);

  @override
  State<CloseBox> createState() => _CloseBoxState();
}

class _CloseBoxState extends State<CloseBox> {
  TextEditingController oneSEditingController = TextEditingController();
  TextEditingController fiveHEditingController = TextEditingController();
  TextEditingController towHEditingController = TextEditingController();
  TextEditingController oneHEditingController = TextEditingController();
  TextEditingController fiftyEditingController = TextEditingController();
  TextEditingController twentyEditingController = TextEditingController();
  TextEditingController tenEditingController = TextEditingController();
  TextEditingController fiveEditingController = TextEditingController();
  TextEditingController twoEditingController = TextEditingController();
  TextEditingController oneEditingController = TextEditingController();
  TextEditingController fiftyFilsEditingController = TextEditingController();
  TextEditingController twentyFiveFilsEditingController =
      TextEditingController();
  TextEditingController tenFilsEditingController = TextEditingController();
  TextEditingController fiveFilsEditingController = TextEditingController();
  TextEditingController oneFilsEditingController = TextEditingController();
  TextEditingController totalEditingController = TextEditingController();
  TextEditingController textEditingController = TextEditingController();
  TextEditingController textEditingController1 = TextEditingController();
  TextEditingController visaEditingController = TextEditingController();
  int boxCashId = 0;
  int boxVisaId = 0;
  int section = 0;

  //final controllerCloseSetting = Get.find<CloseBoxController>();
  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Close Box'.tr),
          backgroundColor: secondaryColor.withOpacity(0.6),
          actions: [
            IconButton(
                onPressed: () {
                  showAnimatedDialog(
                      context: context,
                      alignment: Alignment.topCenter,
                      curve: Curves.bounceIn,
                      barrierDismissible: true,
                      builder: (context) {
                        return const CustomCloseBoxDialog();
                      });
                },
                icon: const Icon(Icons.settings)),
          ]),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.8),
              Colors.white.withOpacity(0.1),
              primaryColor.withOpacity(0.1),
              // secondaryColor.withOpacity(0.3),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.0, 0.9],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 25.0),
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(children: [
                      Expanded(
                          child: Column(
                        children: [
                          Text(
                            'Cash'.tr,
                            style: ConstantApp.getTextStyle(
                                context: context,
                                size: 20,
                                fontWeight: FontWeight.w600),
                          ),
                          const Divider(color: Colors.black38),
                        ],
                      )),
                      Expanded(
                          child: Column(
                        children: [
                          Text(
                            'Visa'.tr,
                            style: ConstantApp.getTextStyle(
                                context: context,
                                size: 20,
                                fontWeight: FontWeight.w600),
                          ),
                          const Divider(color: Colors.black38),
                        ],
                      )),
                    ]),
                    Row(
                      children: [
                        Expanded(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        GetBuilder<UserController>(
                                            builder: (controllerCloseSetting) {
                                          return Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                  child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        ConstantApp.getWidth(
                                                                context) *
                                                            0.02),
                                                child: Column(
                                                  children: [
                                                    !controllerCloseSetting
                                                            .show1000.value
                                                        ? const SizedBox()
                                                        : numOfCash(
                                                            hint: '1000',
                                                            controller:
                                                                oneSEditingController,
                                                            onSaved: (value) {
                                                              oneSEditingController
                                                                      .text =
                                                                  value!;
                                                            }),
                                                    const SizedBox(height: 10),
                                                    !controllerCloseSetting
                                                            .show500.value
                                                        ? const SizedBox()
                                                        : numOfCash(
                                                            hint: '500',
                                                            controller:
                                                                fiveHEditingController,
                                                            onSaved: (value) {
                                                              fiveHEditingController
                                                                      .text =
                                                                  value!;
                                                            }),
                                                    const SizedBox(height: 10),
                                                    !controllerCloseSetting
                                                            .show200.value
                                                        ? const SizedBox()
                                                        : numOfCash(
                                                            hint: '200',
                                                            controller:
                                                                towHEditingController,
                                                            onSaved: (value) {
                                                              towHEditingController
                                                                      .text =
                                                                  value!;
                                                            }),
                                                    const SizedBox(height: 10),
                                                    !controllerCloseSetting
                                                            .show100.value
                                                        ? const SizedBox()
                                                        : numOfCash(
                                                            hint: '100',
                                                            controller:
                                                                oneHEditingController,
                                                            onSaved: (value) {
                                                              oneHEditingController
                                                                      .text =
                                                                  value!;
                                                            }),
                                                    const SizedBox(height: 10),
                                                    !controllerCloseSetting
                                                            .show50.value
                                                        ? const SizedBox()
                                                        : const SizedBox(
                                                            height: 10),
                                                    !controllerCloseSetting
                                                            .show20.value
                                                        ? const SizedBox()
                                                        : numOfCash(
                                                            hint: '20',
                                                            controller:
                                                                twentyEditingController,
                                                            onSaved: (value) {
                                                              twentyEditingController
                                                                      .text =
                                                                  value!;
                                                            }),
                                                    const SizedBox(height: 10),
                                                    !controllerCloseSetting
                                                            .show10.value
                                                        ? const SizedBox()
                                                        : numOfCash(
                                                            hint: '10',
                                                            controller:
                                                                tenEditingController,
                                                            onSaved: (value) {
                                                              tenEditingController
                                                                      .text =
                                                                  value!;
                                                            }),
                                                    const SizedBox(height: 10),
                                                    !controllerCloseSetting
                                                            .show5.value
                                                        ? const SizedBox()
                                                        : numOfCash(
                                                            hint: '5',
                                                            controller:
                                                                fiveEditingController,
                                                            onSaved: (value) {
                                                              fiveEditingController
                                                                      .text =
                                                                  value!;
                                                            }),
                                                  ],
                                                ),
                                              )),
                                              Expanded(
                                                  child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        ConstantApp.getWidth(
                                                                context) *
                                                            0.02),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    !controllerCloseSetting
                                                            .show2.value
                                                        ? const SizedBox()
                                                        : numOfCash(
                                                            hint: '2',
                                                            controller:
                                                                twoEditingController,
                                                            onSaved: (value) {
                                                              twoEditingController
                                                                      .text =
                                                                  value!;
                                                            }),
                                                    const SizedBox(height: 10),
                                                    !controllerCloseSetting
                                                            .show1.value
                                                        ? const SizedBox()
                                                        : numOfCash(
                                                            hint: '1',
                                                            controller:
                                                                oneEditingController,
                                                            onSaved: (value) {
                                                              oneEditingController
                                                                      .text =
                                                                  value!;
                                                            }),
                                                    const SizedBox(height: 10),
                                                    !controllerCloseSetting
                                                            .show050.value
                                                        ? const SizedBox()
                                                        : numOfCash(
                                                            hint: '0.50',
                                                            controller:
                                                                fiftyFilsEditingController,
                                                            onSaved: (value) {
                                                              fiftyFilsEditingController
                                                                      .text =
                                                                  value!;
                                                            }),
                                                    const SizedBox(height: 10),
                                                    !controllerCloseSetting
                                                            .show025.value
                                                        ? const SizedBox()
                                                        : numOfCash(
                                                            hint: '0.25',
                                                            controller:
                                                                twentyFiveFilsEditingController,
                                                            onSaved: (value) {
                                                              twentyFiveFilsEditingController
                                                                      .text =
                                                                  value!;
                                                            }),
                                                    const SizedBox(height: 10),
                                                    !controllerCloseSetting
                                                            .show010.value
                                                        ? const SizedBox()
                                                        : numOfCash(
                                                            hint: '0.10',
                                                            controller:
                                                                tenFilsEditingController,
                                                            onSaved: (value) {
                                                              tenFilsEditingController
                                                                      .text =
                                                                  value!;
                                                            }),
                                                    const SizedBox(height: 10),
                                                    !controllerCloseSetting
                                                            .show005.value
                                                        ? const SizedBox()
                                                        : numOfCash(
                                                            hint: '0.05',
                                                            controller:
                                                                fiveFilsEditingController,
                                                            onSaved: (value) {
                                                              fiveFilsEditingController
                                                                      .text =
                                                                  value!;
                                                            }),
                                                    const SizedBox(height: 10),
                                                    !controllerCloseSetting
                                                            .show001.value
                                                        ? const SizedBox()
                                                        : numOfCash(
                                                            hint: '0.01',
                                                            controller:
                                                                oneFilsEditingController,
                                                            onSaved: (value) {
                                                              oneFilsEditingController
                                                                      .text =
                                                                  value!;
                                                            }),
                                                    const SizedBox(height: 10),
                                                  ],
                                                ),
                                              )),
                                            ],
                                          );
                                        }),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                CustomAppButton(
                                                    onPressed: () {
                                                      totalEditingController
                                                          .clear();
                                                      oneSEditingController
                                                          .clear();
                                                      fiveHEditingController
                                                          .clear();
                                                      towHEditingController
                                                          .clear();
                                                      oneHEditingController
                                                          .clear();
                                                      fiftyEditingController
                                                          .clear();
                                                      twentyEditingController
                                                          .clear();
                                                      tenEditingController
                                                          .clear();
                                                      fiveEditingController
                                                          .clear();
                                                      oneEditingController
                                                          .clear();
                                                      setState(() {});
                                                    },
                                                    title: 'Clear'.tr,
                                                    backgroundColor: Colors.red,
                                                    textColor: Colors.white,
                                                    withPadding: true,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            13,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            13),
                                                CustomAppButton(
                                                    onPressed: () {
                                                      totalEditingController
                                                          .clear();
                                                      int oneS =
                                                          oneSEditingController
                                                                  .text.isEmpty
                                                              ? 0
                                                              : int.parse(
                                                                  oneSEditingController
                                                                      .text);
                                                      int fiveH =
                                                          fiveHEditingController
                                                                  .text.isEmpty
                                                              ? 0
                                                              : int.parse(
                                                                  fiveHEditingController
                                                                      .text);
                                                      int towH =
                                                          towHEditingController
                                                                  .text.isEmpty
                                                              ? 0
                                                              : int.parse(
                                                                  towHEditingController
                                                                      .text);
                                                      int oneH =
                                                          oneHEditingController
                                                                  .text.isEmpty
                                                              ? 0
                                                              : int.parse(
                                                                  oneHEditingController
                                                                      .text);
                                                      int fifty =
                                                          fiftyEditingController
                                                                  .text.isEmpty
                                                              ? 0
                                                              : int.parse(
                                                                  fiftyEditingController
                                                                      .text);
                                                      int twenty =
                                                          twentyEditingController
                                                                  .text.isEmpty
                                                              ? 0
                                                              : int.parse(
                                                                  twentyEditingController
                                                                      .text);
                                                      int ten = tenEditingController
                                                              .text.isEmpty
                                                          ? 0
                                                          : int.parse(
                                                              tenEditingController
                                                                  .text);
                                                      int five =
                                                          fiveEditingController
                                                                  .text.isEmpty
                                                              ? 0
                                                              : int.parse(
                                                                  fiveEditingController
                                                                      .text);
                                                      int one = oneEditingController
                                                              .text.isEmpty
                                                          ? 0
                                                          : int.parse(
                                                              oneEditingController
                                                                  .text);
                                                      int two = twoEditingController
                                                              .text.isEmpty
                                                          ? 0
                                                          : int.parse(
                                                              twoEditingController
                                                                  .text);
                                                      int fiftyFils =
                                                          fiftyFilsEditingController
                                                                  .text.isEmpty
                                                              ? 0
                                                              : int.parse(
                                                                  fiftyFilsEditingController
                                                                      .text);
                                                      int twentyFiveFils =
                                                          twentyFiveFilsEditingController
                                                                  .text.isEmpty
                                                              ? 0
                                                              : int.parse(
                                                                  twentyFiveFilsEditingController
                                                                      .text);
                                                      int tenFils =
                                                          tenFilsEditingController
                                                                  .text.isEmpty
                                                              ? 0
                                                              : int.parse(
                                                                  tenFilsEditingController
                                                                      .text);
                                                      int fiveFils =
                                                          fiveFilsEditingController
                                                                  .text.isEmpty
                                                              ? 0
                                                              : int.parse(
                                                                  fiveFilsEditingController
                                                                      .text);
                                                      int oneFils =
                                                          oneFilsEditingController
                                                                  .text.isEmpty
                                                              ? 0
                                                              : int.parse(
                                                                  oneFilsEditingController
                                                                      .text);
                                                      totalEditingController
                                                          .text = (oneS * 1000 +
                                                              fiveH * 500 +
                                                              towH * 200 +
                                                              oneH * 100 +
                                                              fifty * 50 +
                                                              twenty * 20 +
                                                              ten * 10 +
                                                              five * 5 +
                                                              one * 1 +
                                                              two * 2 +
                                                              fiftyFils * 0.5 +
                                                              twentyFiveFils *
                                                                  0.25 +
                                                              tenFils * 0.1 +
                                                              fiveFils * 0.05 +
                                                              oneFils * 0.01)
                                                          .toStringAsFixed(2);
                                                      setState(() {});
                                                    },
                                                    title: 'SUM'.tr,
                                                    backgroundColor:
                                                        primaryColor
                                                            .withOpacity(1),
                                                    textColor: Colors.white,
                                                    withPadding: true,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            13,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            13),
                                              ],
                                            ),
                                            const SizedBox(
                                              width: 25,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      6,
                                                  child: TextFormField(
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .allow(RegExp(
                                                              r'(^\d*\.?\d*)'))
                                                    ],
                                                    controller:
                                                        totalEditingController,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black),
                                                    decoration: InputDecoration(
                                                      focusedErrorBorder:
                                                          OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30),
                                                              borderSide:
                                                                  const BorderSide(
                                                                      color: Colors
                                                                          .red)),
                                                      hintText: "Total".tr,
                                                      filled: true,
                                                      fillColor: Colors.white
                                                          .withOpacity(0.5),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30),
                                                              borderSide:
                                                                  BorderSide(
                                                                      color:
                                                                          primaryColor,
                                                                      width:
                                                                          2)),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30),
                                                              borderSide:
                                                                  BorderSide(
                                                                      color:
                                                                          primaryColor)),
                                                      errorBorder: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .red)),
                                                    ),
                                                    onSaved: (value) {
                                                      totalEditingController
                                                          .text = value!;
                                                    },
                                                    validator: (value) {
                                                      if (value!.isEmpty ||
                                                          value == '0.00') {
                                                        return 'Enter Value'.tr;
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  'AED'.tr,
                                                  style: const TextStyle(
                                                      fontSize: 25),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 2,
                          height: ConstantApp.getHeight(context) / 1.4,
                          color: Colors.black38,
                        ),
                        Expanded(
                          child: Form(
                            key: _formKey1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  6,
                                              child: TextFormField(
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .allow(RegExp(
                                                          r'(^\d*\.?\d*)'))
                                                ],
                                                controller:
                                                    visaEditingController,
                                                keyboardType:
                                                    TextInputType.number,
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black),
                                                decoration: InputDecoration(
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .red)),
                                                  hintText: "Visa Amount".tr,
                                                  filled: true,
                                                  fillColor: Colors.white
                                                      .withOpacity(0.5),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                          borderSide: BorderSide(
                                                              color:
                                                                  primaryColor,
                                                              width: 2)),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                          borderSide: BorderSide(
                                                              color:
                                                                  primaryColor)),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .red)),
                                                ),
                                                onSaved: (value) {
                                                  visaEditingController.text =
                                                      value!;
                                                },
                                                validator: (value) {
                                                  if (value!.isEmpty ||
                                                      value == '0.00') {
                                                    return 'Enter Value'.tr;
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              'AED'.tr,
                                              style:
                                                  const TextStyle(fontSize: 25),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: CustomAppButton(
                              onPressed: () async {
                                bool isActive = await Get.find<UserController>()
                                    .checkUser(context: context);
                                if (isActive) {
                                  return;
                                }
                                if (_formKey.currentState!.validate()) {
                                  if (!context.mounted) {
                                    return;
                                  }
                                  showAnimatedDialog(
                                      context: context,
                                      builder: (context) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: SingleChildScrollView(
                                            child: AlertDialog(
                                              alignment: Alignment.center,
                                              backgroundColor:
                                                  Colors.white.withOpacity(0.9),
                                              actionsPadding:
                                                  const EdgeInsets.all(20),
                                              shape: const OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(30))),
                                              title: const Center(
                                                  child: Text(
                                                      'Are You Sure To Close Your Box ?',
                                                      textAlign:
                                                          TextAlign.center)),
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
                                                      padding: EdgeInsets.only(
                                                          left: 20, right: 20),
                                                      child: Text(
                                                        'No',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    )),
                                                ElevatedButton(
                                                    onPressed: () async {
                                                      Get.back();
                                                      int userId = Get.find<
                                                                  SharedPreferences>()
                                                              .getInt(
                                                                  'userId') ??
                                                          0;
                                                      await Get.find<
                                                              UserController>()
                                                          .closeBox(
                                                              userId: userId,
                                                              amount: double.tryParse(
                                                                      totalEditingController
                                                                          .text) ??
                                                                  0.0,
                                                              type: 'cash');
                                                      var amount = double.tryParse(
                                                              totalEditingController
                                                                  .text) ??
                                                          0.0;
                                                      var balance = Get.find<
                                                              UserController>()
                                                          .balance
                                                          .value;
                                                      if (balance == 0) {
                                                        if (!context.mounted) {
                                                          return;
                                                        }
                                                        ConstantApp
                                                            .showSnakeBarError(
                                                                context,
                                                                'The Box Is Empty !!');
                                                        return;
                                                      }
                                                      if (!context.mounted) {
                                                        return;
                                                      }
                                                      ConstantApp
                                                          .showSnakeBarSuccess(
                                                              context,
                                                              'The box was Closed !!');
                                                      oneSEditingController
                                                          .clear();
                                                      fiveHEditingController
                                                          .clear();
                                                      towHEditingController
                                                          .clear();
                                                      oneHEditingController
                                                          .clear();
                                                      fiftyEditingController
                                                          .clear();
                                                      twentyEditingController
                                                          .clear();
                                                      tenEditingController
                                                          .clear();
                                                      fiveEditingController
                                                          .clear();
                                                      twoEditingController
                                                          .clear();
                                                      oneEditingController
                                                          .clear();
                                                      fiftyFilsEditingController
                                                          .clear();
                                                      twentyFiveFilsEditingController
                                                          .clear();
                                                      tenFilsEditingController
                                                          .clear();
                                                      fiveFilsEditingController
                                                          .clear();
                                                      oneFilsEditingController
                                                          .clear();
                                                      textEditingController
                                                          .clear();
                                                      textEditingController1
                                                          .clear();
                                                      totalEditingController
                                                          .clear();
                                                      var printer = await Get.find<
                                                              AppDataBaseController>()
                                                          .appDataBase
                                                          .getPrinterSetting(1);
                                                      if (printer == null) {
                                                        if (!context.mounted) {
                                                          return;
                                                        }
                                                        ConstantApp
                                                            .showSnakeBarError(
                                                                context,
                                                                'ADD Printer From Printer Setting !!'
                                                                    .tr);
                                                        return;
                                                      }
                                                      var allPrinters =
                                                          await Get.find<
                                                                  AppDataBaseController>()
                                                              .appDataBase
                                                              .getAllPrinter();
                                                      if (printer
                                                              .reportPrinter !=
                                                          0) {
                                                        String name = allPrinters
                                                                .firstWhere(
                                                                    (element) =>
                                                                        element
                                                                            .id ==
                                                                        printer
                                                                            .reportPrinter)
                                                                .printerName ??
                                                            '';

                                                        await Get.find<
                                                                UserController>()
                                                            .printCloseBox(
                                                                printerName:
                                                                    name,
                                                                date: DateTime
                                                                    .now(),
                                                                fromAcc: Get.find<
                                                                        UserController>()
                                                                    .fromAcc
                                                                    .value,
                                                                toAcc: Get.find<
                                                                        UserController>()
                                                                    .toAcc
                                                                    .value,
                                                                diffAmount:
                                                                    (amount -
                                                                        balance),
                                                                amount: amount,
                                                                boxAmount:
                                                                    balance);
                                                      } else {
                                                        if (!context.mounted) {
                                                          return;
                                                        }
                                                        ConstantApp
                                                            .showSnakeBarError(
                                                                context,
                                                                'ADD Printer From Printer Setting !!'
                                                                    .tr);
                                                        return;
                                                      }
                                                    },
                                                    style: ButtonStyle(
                                                        backgroundColor: MaterialStateColor
                                                            .resolveWith((states) =>
                                                                primaryColor
                                                                    .withOpacity(
                                                                        0.8))),
                                                    child: const Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 20, right: 20),
                                                      child: Text(
                                                        'Yes',
                                                        style: TextStyle(
                                                            color: Colors.white,
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
                                }
                              },
                              title: 'Close Cash Box'.tr,
                              backgroundColor: secondaryColor.withOpacity(0.7),
                              textColor: Colors.white,
                              withPadding: true,
                              width: MediaQuery.of(context).size.width / 8,
                              height: MediaQuery.of(context).size.height / 10),
                        ),
                        Expanded(
                          child: CustomAppButton(
                              onPressed: () async {
                                bool isActive = await Get.find<UserController>()
                                    .checkUser(context: context);
                                if (isActive) {
                                  return;
                                }
                                if (_formKey1.currentState!.validate()) {
                                  if (!context.mounted) {
                                    return;
                                  }
                                  showAnimatedDialog(
                                      context: context,
                                      builder: (context) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: SingleChildScrollView(
                                            child: AlertDialog(
                                              alignment: Alignment.center,
                                              backgroundColor:
                                                  Colors.white.withOpacity(0.9),
                                              actionsPadding:
                                                  const EdgeInsets.all(20),
                                              shape: const OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(30))),
                                              title: const Center(
                                                  child: Text(
                                                      'Are You Sure To Close Your Box ?',
                                                      textAlign:
                                                          TextAlign.center)),
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
                                                      padding: EdgeInsets.only(
                                                          left: 20, right: 20),
                                                      child: Text(
                                                        'No',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    )),
                                                ElevatedButton(
                                                    onPressed: () async {
                                                      Get.back();
                                                      int userId = Get.find<
                                                                  SharedPreferences>()
                                                              .getInt(
                                                                  'userId') ??
                                                          0;
                                                      await Get.find<
                                                              UserController>()
                                                          .closeBox(
                                                              userId: userId,
                                                              amount: double.tryParse(
                                                                      visaEditingController
                                                                          .text) ??
                                                                  0.0,
                                                              type: 'visa');
                                                      var amount = double.tryParse(
                                                              visaEditingController
                                                                  .text) ??
                                                          0.0;
                                                      var balance = Get.find<
                                                              UserController>()
                                                          .balance
                                                          .value;
                                                      if (balance == 0) {
                                                        if (!context.mounted) {
                                                          return;
                                                        }
                                                        ConstantApp
                                                            .showSnakeBarError(
                                                                context,
                                                                'The Box Is Empty !!');
                                                        return;
                                                      }
                                                      if (!context.mounted) {
                                                        return;
                                                      }
                                                      ConstantApp
                                                          .showSnakeBarSuccess(
                                                              context,
                                                              'The box was Closed !!');
                                                      oneSEditingController
                                                          .clear();
                                                      fiveHEditingController
                                                          .clear();
                                                      towHEditingController
                                                          .clear();
                                                      oneHEditingController
                                                          .clear();
                                                      fiftyEditingController
                                                          .clear();
                                                      twentyEditingController
                                                          .clear();
                                                      tenEditingController
                                                          .clear();
                                                      fiveEditingController
                                                          .clear();
                                                      twoEditingController
                                                          .clear();
                                                      oneEditingController
                                                          .clear();
                                                      fiftyFilsEditingController
                                                          .clear();
                                                      twentyFiveFilsEditingController
                                                          .clear();
                                                      tenFilsEditingController
                                                          .clear();
                                                      fiveFilsEditingController
                                                          .clear();
                                                      oneFilsEditingController
                                                          .clear();
                                                      textEditingController
                                                          .clear();
                                                      textEditingController1
                                                          .clear();
                                                      visaEditingController
                                                          .clear();
                                                      var printer = await Get.find<
                                                              AppDataBaseController>()
                                                          .appDataBase
                                                          .getPrinterSetting(1);
                                                      if (printer == null) {
                                                        if (!context.mounted) {
                                                          return;
                                                        }
                                                        ConstantApp
                                                            .showSnakeBarError(
                                                                context,
                                                                'ADD Printer From Printer Setting !!'
                                                                    .tr);
                                                        return;
                                                      }
                                                      var allPrinters =
                                                          await Get.find<
                                                                  AppDataBaseController>()
                                                              .appDataBase
                                                              .getAllPrinter();
                                                      if (printer
                                                              .reportPrinter !=
                                                          0) {
                                                        String name = allPrinters
                                                                .firstWhere(
                                                                    (element) =>
                                                                        element
                                                                            .id ==
                                                                        printer
                                                                            .reportPrinter)
                                                                .printerName ??
                                                            '';

                                                        await Get.find<
                                                                UserController>()
                                                            .printCloseBox(
                                                                printerName:
                                                                    name,
                                                                date: DateTime
                                                                    .now(),
                                                                fromAcc: Get.find<
                                                                        UserController>()
                                                                    .fromAcc
                                                                    .value,
                                                                toAcc: Get.find<
                                                                        UserController>()
                                                                    .toAcc
                                                                    .value,
                                                                diffAmount:
                                                                    (amount -
                                                                        balance),
                                                                amount: amount,
                                                                boxAmount:
                                                                    balance);
                                                      } else {
                                                        if (!context.mounted) {
                                                          return;
                                                        }
                                                        ConstantApp
                                                            .showSnakeBarError(
                                                                context,
                                                                'ADD Printer From Printer Setting !!'
                                                                    .tr);
                                                        return;
                                                      }
                                                    },
                                                    style: ButtonStyle(
                                                        backgroundColor: MaterialStateColor
                                                            .resolveWith((states) =>
                                                                primaryColor
                                                                    .withOpacity(
                                                                        0.8))),
                                                    child: const Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 20, right: 20),
                                                      child: Text(
                                                        'Yes',
                                                        style: TextStyle(
                                                            color: Colors.white,
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
                                }
                              },
                              title: 'Close Visa Box'.tr,
                              backgroundColor: secondaryColor.withOpacity(0.7),
                              textColor: Colors.white,
                              withPadding: true,
                              width: MediaQuery.of(context).size.width / 8,
                              height: MediaQuery.of(context).size.height / 10),
                        ),
                      ],
                    ),
                    const Divider(color: Colors.black38),
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget numOfCash(
      {required String hint,
      required TextEditingController controller,
      required Function(String?)? onSaved}) {
    return Row(
      children: [
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: Text(
            '$hint  ${'AED'.tr}',
            style: const TextStyle(fontSize: 20),
          ),
        ),
        Flexible(
          flex: 2,
          fit: FlexFit.tight,
          child: SizedBox(
            width: MediaQuery.of(context).size.width / 8,
            child: TextFormField(
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              controller: controller,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 16, color: Colors.black),
              decoration: InputDecoration(
                hintText: hint.tr,
                suffixIcon: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Icon(
                    Icons.money,
                    color: Colors.black,
                  ),
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.5),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: primaryColor, width: 2)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: primaryColor)),
              ),
              onSaved: onSaved,
              validator: (value) {
                return null;
              },
            ),
          ),
        ),
      ],
    );
  }
}
