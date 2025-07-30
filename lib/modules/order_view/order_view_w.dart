import 'package:barcode_scan2/platform_wrapper.dart';
import 'package:cashier_app/controllers/user_controller.dart';
import 'package:cashier_app/modules/order_view/widget/barcode_widget.dart';
import 'package:cashier_app/modules/order_view/widget/cash_drawer_widget.dart';
import 'package:cashier_app/modules/order_view/widget/show_dialog_%20note.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cashier_app/models/customer_model.dart';
import 'package:cashier_app/models/product/product_model.dart';
import 'package:cashier_app/modules/order_view/widget/custom_dialog_pos_setting.dart';
import 'package:cashier_app/modules/order_view/widget/grid_item.dart';
import 'package:cashier_app/modules/order_view/widget/order_item.dart';
import 'package:cashier_app/modules/order_view/widget/temp_order_items.dart';
import 'package:cashier_app/server/dio_services.dart';
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';
import '../../controllers/info_controllers.dart';
import '../../controllers/internet_check_controller.dart';
import '../../controllers/tables_controller.dart';
import '../../database/app_db_controller.dart';
import '../../global_widgets/custom_app_button.dart';
import '../../global_widgets/custom_app_drop_down_employee.dart';
import '../../global_widgets/custom_clock.dart';
import '../../global_widgets/custom_drop_down_button.dart';
import '../../global_widgets/custom_drop_down_driver.dart';
import '../../global_widgets/custom_text_field.dart';
import '../../global_widgets/drop_down_button_customers.dart';
import '../../global_widgets/drop_down_button_users.dart';
import '../../global_widgets/drop_down_unit.dart';
import '../../global_widgets/keyboard.dart';
import '../../global_widgets/loader.dart';
import '../../models/order/order_model.dart';
import '../../models/table_model.dart';
import '../../models/unit_model.dart';
import '../../utils/Theme/colors.dart';
import '../../utils/constant.dart';
import '../../utils/scaled_dimensions.dart';
import '../widget/no_internet_widget.dart';
import '../../controllers/order_controller.dart';

class OrderViewW extends StatefulWidget {
  const OrderViewW({
    super.key,
    required this.hall,
    required this.table,
    required this.customerId,
    required this.billRequest,
  });

  final String hall;
  final String table;
  final int customerId;
  final bool billRequest;

  @override
  State<OrderViewW> createState() => _OrderViewWState();
}

class _OrderViewWState extends State<OrderViewW> with WindowListener {
  var controller = Get.find<OrderController>();
  var infoController = Get.find<InfoController>();
  final formKey = GlobalKey<FormState>();
  final formKey1 = GlobalKey<FormState>();
  int val = 1;
  var focusNode = FocusNode();
  var barcodeFN = FocusNode();
  var discountValueNode = FocusNode();
  TextEditingController numController = TextEditingController();
  TextEditingController deliveryManController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController busNameController = TextEditingController();
  TextEditingController address1Controller = TextEditingController();
  TextEditingController mobileTextEditing = TextEditingController();
  TextEditingController temp = TextEditingController();
  TextEditingController temp1 = TextEditingController();
  TextEditingController quantityVoidController = TextEditingController();
  TextEditingController textEditingController = TextEditingController();
  TextEditingController textEditingController1 = TextEditingController();
  TextEditingController textEditingController2 = TextEditingController();
  TextEditingController textEditingController3 = TextEditingController();
  TextEditingController priceEditingController = TextEditingController();
  TextEditingController guestNameController = TextEditingController();
  TextEditingController newAddressController = TextEditingController();
  TextEditingController newMobileController = TextEditingController();
  TextEditingController noteOrderController = TextEditingController();
  TextEditingController barcodeController = TextEditingController();
  TextEditingController cashTextEditing = TextEditingController();
  TextEditingController visaTextEditing = TextEditingController();
  TextEditingController returnTextEditing = TextEditingController();
  TextEditingController discountTextEditing = TextEditingController();
  TextEditingController tipsTextEditing = TextEditingController();
  TextEditingController password = TextEditingController();
  late TextEditingController storeTextEditingController =
      TextEditingController();
  int section = 1;
  bool show = false;
  List<bool> isDecimal = [];
  String addressCustomer = "";
  String? customerNumber;
  double width = 3;
  String noteOrder = "";
  int storeId = ConstantApp.storeId;
  int userId = 1;
  bool negative =
      Get.find<SharedPreferences>().getBool('negativeSelling') ?? false;

  String hallName = "";
  bool isClose = true;
  double limitDiscount = 0.0;
  double discount = 0;
  List<String> listDis = [];

  @override
  void initState() {
    controller.tempOrder.clear();
    controller.discountValue!.clear();
    controller.discountType.value = '%';
    controller.saveDiscount();
    controller.enableGuests(
        Get.find<SharedPreferences>().getBool('enableGuests') ?? false);
    controller
        .showUnit(Get.find<SharedPreferences>().getBool('showUnit') ?? false);
    initTableName();
    var name = Get.find<SharedPreferences>().getString('name');
    discount = name == null
        ? 0.0
        : Get.find<UserController>()
            .users
            .firstWhere((element) => element.name == name)
            .discount;
    controller.customerId.value =
        widget.customerId == 0 ? 1 : widget.customerId;
    storeId = ConstantApp.storeId;
    controller.getOrderSetting();
    controller.selected1.value = 100;
    controller.requstingBill.value = widget.billRequest;
    controller.priceType.value = '';
    controller.listGuest.value =
        Get.find<SharedPreferences>().getStringList('listGuest') ?? ['Global'];
    listDis =  Get
        .find<InfoController>()
        .taxesSetting
        .isEmpty
        ? ['%', 'Value']
        : ['%', 'Fixed before Vat', 'Fixed After Vat'];
    windowManager.addListener(this);
    windowManager.setPreventClose(true);
    super.initState();
  }

  @override
  void dispose() {
    newAddressController.dispose();
    noteOrderController.dispose();
    barcodeController.dispose();
    barcodeFN.dispose();
    discountValueNode.dispose();
    password.dispose();
    windowManager.removeListener(this);
    windowManager.setPreventClose(false);
    super.dispose();
  }

  @override
  void onWindowClose() async {
    bool isPreventClose = await windowManager.isPreventClose();
    if (isPreventClose) {
      if (!context.mounted) return;
      Get.dialog(AlertDialog(
        title: Text('Are you sure you want to close this App?'.tr),
        actions: [
          TextButton(
            child: Text('No'.tr),
            onPressed: () {
              Get.back();
            },
          ),
          TextButton(
            onPressed: () async {
              isClose ? Get.back() : null;
              isClose
                  ? await Get.find<TableController>().exitFromTable(data: {
                      "number": widget.table,
                      "hall": widget.hall,
                      "cashier":
                          Get.find<SharedPreferences>().getString('name') ?? '',
                    })
                  : null;
              isClose ? await windowManager.destroy() : null;
            },
            child: Text('Yes'.tr),
          ),
        ],
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (_) async {
        if (ConstantApp.type == "guest") {
        } else {
          await Get.find<TableController>().exitFromTable(data: {
            "number": widget.table,
            "hall": widget.hall,
            "cashier": Get.find<SharedPreferences>().getString('name') ?? '',
          });
        }
        Get.back();
      },
      child: SafeArea(
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: AppBar(
                  title: Center(
                    child: Text(
                      'POS'.tr,
                      style: ConstantApp.getTextStyle(
                          context: context,
                          size: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                  leading: IconButton(
                    onPressed: () async {
                      if (ConstantApp.type == "guest") {
                      } else {
                        if (controller.tempOrder.isNotEmpty) {
                          Get.dialog(AlertDialog(
                            title: Text("Save Changes".tr),
                            content: Text(
                                "Are you sure you want to leave the page?".tr),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateColor.resolveWith(
                                              (states) => errorColor)),
                                  child: Text(
                                    "Cansel".tr,
                                    style: ConstantApp.getTextStyle(
                                        context: context, color: Colors.white),
                                  )),
                              ElevatedButton(
                                  onPressed: () async {
                                    Get.back();
                                    bool isActive =
                                        await Get.find<UserController>()
                                            .checkUser(context: context);
                                    if (isActive) {
                                      return;
                                    }
                                    await Get.find<TableController>()
                                        .exitFromTable(data: {
                                      "number": widget.table,
                                      "hall": widget.hall,
                                      "cashier": Get.find<SharedPreferences>()
                                              .getString('name') ??
                                          '',
                                    });
                                    Get.back();
                                  },
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateColor.resolveWith(
                                              (states) => primaryColor)),
                                  child: Text(
                                    "Leave".tr,
                                    style: ConstantApp.getTextStyle(
                                        context: context, color: Colors.white),
                                  )),
                              ElevatedButton(
                                  onPressed: () async {
                                    await sendFunction();
                                    Get.back();
                                    if (!context.mounted) {
                                      return;
                                    }
                                    bool isActive =
                                        await Get.find<UserController>()
                                            .checkUser(context: context);
                                    if (isActive) {
                                      return;
                                    }
                                    await Get.find<TableController>()
                                        .exitFromTable(data: {
                                      "number": widget.table,
                                      "hall": widget.hall,
                                      "cashier": Get.find<SharedPreferences>()
                                              .getString('name') ??
                                          '',
                                    });
                                    Get.back();
                                  },
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateColor.resolveWith(
                                              (states) => primaryColor)),
                                  child: Text(
                                    "Save & Leave".tr,
                                    style: ConstantApp.getTextStyle(
                                        context: context, color: Colors.white),
                                  )),
                            ],
                          ));
                        } else {
                          bool isActive = await Get.find<UserController>()
                              .checkUser(context: context);
                          if (isActive) {
                            return;
                          }
                          await Get.find<TableController>()
                              .exitFromTable(data: {
                            "number": widget.table,
                            "hall": widget.hall,
                            "cashier": Get.find<SharedPreferences>()
                                    .getString('name') ??
                                '',
                          });
                          Get.back();
                        }
                      }
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  actions: [
                    Get.width > 800
                        ? IconButton(
                            onPressed: () async {
                              if (!mounted) return;
                              showAnimatedDialog(
                                  context: context,
                                  builder: (context) {
                                    return const CustomPOSSettingDialog();
                                  },
                                  alignment: Alignment.topCenter,
                                  curve: Curves.bounceIn,
                                  barrierDismissible: true);
                            },
                            icon: const Icon(FontAwesomeIcons.sliders),
                            tooltip: 'Page Setting'.tr,
                          )
                        : const SizedBox(),
                  if(Get.find<UserController>().permission.value.returnSales)  GetBuilder<OrderController>(builder: (controllerOrd) {
                      return (controllerOrd.orders.isEmpty)
                          ? CustomDropDownButton(
                              title: '',
                              hint: 'Select type'.tr,
                              items: const ['sales', 'returned'],
                              value: controller.salesType.value,
                              withOutValue: true,
                              onChange: (value) async {
                                controller.salesType.value = value!;
                                setState(() {});
                              },
                              width: ScaledDimensions.getScaledWidth(px: 40),
                              height: ScaledDimensions.getScaledHeight(px: 50))
                          : const SizedBox();
                    })
                  ],
                ),
              ),
              backgroundColor: const Color(0xFFf1f1f1),
              body: BarcodeKeyboardListener(
                  bufferDuration: const Duration(milliseconds: 200),
                  onBarcodeScanned: (barcode) async {
                    if (barcode.isEmpty) {
                      return;
                    }
                    await controller.addProductFromBarcode(
                        barcode, context, widget.hall, widget.table);
                    setState(() {});
                  },
                  child: Obx(
                    () => Get.find<INetworkInfo>().connectionStatus.value == 0
                        ? EmptyFailureNoInternetView(
                            image: 'lottie/no_internet.json',
                            title: 'Network Error',
                            description: 'Internet Not Found !!',
                            buttonText: "Retry",
                            onPressed: () async {},
                          )
                        : SizedBox(
                            width: ConstantApp.getWidth(context),
                            height: ConstantApp.getHeight(context),
                            child: ConstantApp.isTab(context)
                                ? verticalOrderView()
                                : horizontalOrderView(),
                          ),
                  )))),
    );
  }

  Widget horizontalOrderView() {
    return Column(children: [
      Expanded(
        child: Row(
          children: [
            orderWidget(),
            productItemsWidget(),
            Obx(
              () => !controller.showSub.value
                  ? const SizedBox()
                  : supCategoryWidget(),
            ),
            Obx(() => !controller.showMain.value
                ? const SizedBox()
                : mainCategoryWidget()),
          ],
        ),
      ),
    ]);
  }

  Widget verticalOrderView() {
    return Column(children: [
      Expanded(
        child: Column(
          children: [
            orderWidget(),
          ],
        ),
      ),
    ]);
  }

  Widget orderWidget() {
    return Obx(
      () => Expanded(
          flex: controller.orderWidth.value,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: ConstantApp.isTab(context)
                    ? ConstantApp.getHeight(context) * 0.09
                    : ConstantApp.getHeight(context) * 0.17,
                color: secondaryColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          settingWidgetOrderView(),
                          const Expanded(child: CustomClock()),
                          Expanded(
                            child: Text(hallName,
                                style: const TextStyle(color: Colors.white)),
                          ),
                          Expanded(
                            child: Obx(
                              () => Text(
                                '${'Orders'.tr} - ${controller.orderNumber}',
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Obx(
                            () {
                              return controller.orders.isNotEmpty &&
                                      !controller.requstingBill.value
                                  ? const Expanded(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.soup_kitchen_outlined,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  : const SizedBox();
                            },
                          ),
                          Obx(() => controller.requstingBill.value
                              ? const Expanded(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.attach_money,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              : const SizedBox()),
                          Expanded(
                            child: Text(
                              DateFormat('yyyy-MM-dd').format(DateTime.now()),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          Expanded(
                              child: BarcodeWidget(
                            controller: controller,
                            barcodeController: barcodeController,
                            barcodeFN: barcodeFN,
                            setState: () {
                              setState(() {});
                            },
                            table: widget.table,
                            hall: widget.hall,
                          )),
                          const Expanded(child: CashDrawerWidget()),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                widgetAddCustomer(),
                                GetBuilder<OrderController>(
                                    builder: (controller) {
                                  return CustomDropDownButtonCustomer(
                                    title: '',
                                    hint: 'Customers'.tr,
                                    value: controller.customerId.value == 0
                                        ? null
                                        : controller.customerId.value,
                                    items: controller.customer,
                                    onChange: (val) {
                                      controller.customerId.value = val!;
                                      for (var element in controller.customer) {
                                        if (element.id == val) {
                                          customerNumber =
                                              element.mobileList[0];
                                          addressCustomer =
                                              element.address[0].toString();
                                          customerNumber = customerNumber == ""
                                              ? element.mobileList[0]
                                              : customerNumber;
                                          addressCustomer = addressCustomer ==
                                                  ""
                                              ? element.address[0].toString()
                                              : addressCustomer;
                                          if (controller.customerId.value !=
                                              1) {
                                            dialogAddress(
                                                address: element.address,
                                                id: val,
                                                mobilNumber: element.mobileList,
                                                name: element.businessName);
                                          }
                                        }
                                      }
                                    },
                                    width: GetPlatform.isWindows
                                        ? Get.width / 10
                                        : Get.width > 800
                                            ? Get.width / 15
                                            : Get.width / 2,
                                    height: ScaledDimensions.getScaledHeight(
                                        px: 50),
                                    textEditingController:
                                        textEditingController,
                                  );
                                }),
                              ],
                            ),
                          ),
                          controller.tempOrder.isEmpty
                              ? const SizedBox()
                              : Expanded(
                                  child: Row(
                                    children: [
                                      CustomDropDownButton(
                                          title: '',
                                          hint: 'Price',
                                          value: controller.priceType.isEmpty
                                              ? null
                                              : controller.priceType.value,
                                          withOutValue: false,
                                          items:  [
                                           if (Get.find<UserController>().permission.value.choseWholePrice) 'Whole Price',
                                            if (Get.find<UserController>().permission.value.choseOfferPrice)  'Min price',
                                            'Max Price',
                                            if (Get.find<UserController>().permission.value.choseCostPrice) 'Cost Price'
                                          ],
                                          onChange: (value) {
                                            controller.priceType.value = value!;
                                            controller.totalPrice.value = 0;
                                            if (controller.priceType
                                                .contains('Whole')) {
                                              for (var i
                                                  in controller.tempOrder) {
                                                i.price = i.wholePrice!;
                                                controller.totalPrice.value +=
                                                    (i.price * i.quantity);
                                              }
                                            } else if (controller.priceType
                                                .contains('Min')) {
                                              for (var i
                                                  in controller.tempOrder) {
                                                i.price = i.minPrice!;
                                                controller.totalPrice.value +=
                                                    (i.price * i.quantity);
                                              }
                                            } else if (controller.priceType
                                                .contains('Max')) {
                                              for (var i
                                                  in controller.tempOrder) {
                                                i.price = i.maxPrice!;
                                                controller.totalPrice.value +=
                                                    (i.price * i.quantity);
                                              }
                                            } else if (controller.priceType
                                                .contains('Cost')) {
                                              for (var i
                                                  in controller.tempOrder) {
                                                i.price = i.costPrice!;
                                                controller.totalPrice.value +=
                                                    (i.price * i.quantity);
                                              }
                                            }
                                            setState(() {});
                                          },
                                          width: GetPlatform.isWindows
                                              ? Get.width / 10
                                              : Get.width > 800
                                                  ? Get.width / 15
                                                  : Get.width / 6,
                                          height:
                                              ScaledDimensions.getScaledHeight(
                                                  px: 50)),
                                      IconButton(
                                          onPressed: () {
                                            controller.priceType.value = '';
                                            controller.totalPrice.value = 0;
                                            for (var i
                                                in controller.tempOrder) {
                                              i.price = i.firstPrice!;
                                              controller.totalPrice.value +=
                                                  (i.quantity * i.price);
                                            }
                                            setState(() {});
                                          },
                                          icon: const Icon(
                                            Icons.close,
                                            color: Colors.white,
                                          ))
                                    ],
                                  ),
                                ),
                          !controller.enableGuests.value
                              ? const SizedBox()
                              : (int.tryParse(widget.hall) ?? 0) <= 0
                                  ? const SizedBox()
                                  : Expanded(
                                      child: Row(
                                        children: [
                                          Expanded(
                                      flex: 1,
                                            child: IconButton(
                                              icon: const Icon(Icons.add),
                                              tooltip: 'Add Guest'.tr,
                                              color: Colors.white,
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      guestNameController.text =
                                                          'Guest ${controller.listGuest.length}';
                                                      return AlertDialog(
                                                        scrollable: true,
                                                        title:
                                                            Text('Add Guest'.tr),
                                                        content: Form(
                                                          key: formKey,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: TextFormField(
                                                              controller:
                                                                  guestNameController,
                                                              onSaved: (val) {
                                                                guestNameController
                                                                    .text = val!;
                                                              },
                                                              decoration:
                                                                  InputDecoration(
                                                                labelText:
                                                                    'Name'.tr,
                                                                icon: const Icon(Icons
                                                                    .account_box),
                                                              ),
                                                              validator: (value) {
                                                                if (value ==
                                                                        null ||
                                                                    value
                                                                        .isEmpty) {
                                                                  return 'Enter name'
                                                                      .tr;
                                                                }
                                                                for (var i
                                                                    in controller
                                                                        .listGuest) {
                                                                  if (value ==
                                                                      i) {
                                                                    return 'The name is already in use !!'
                                                                        .tr;
                                                                  }
                                                                }
                                                                return null;
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                              onPressed: () {
                                                                Get.back();
                                                              },
                                                              child: Text(
                                                                'Cancel'.tr,
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .red),
                                                              )),
                                                          TextButton(
                                                              child: Text(
                                                                "Add".tr,
                                                                style: const TextStyle(
                                                                    color: Color(
                                                                        0xffee680e)),
                                                              ),
                                                              onPressed: () {
                                                                if (formKey
                                                                    .currentState!
                                                                    .validate()) {
                                                                  formKey
                                                                      .currentState!
                                                                      .save();
                                                                  controller
                                                                      .listGuest
                                                                      .add(guestNameController
                                                                          .text);
                                                                  Get.find<
                                                                          SharedPreferences>()
                                                                      .remove(
                                                                          'listGuest');
                                                                  Get.find<
                                                                          SharedPreferences>()
                                                                      .setStringList(
                                                                          'listGuest',
                                                                          controller
                                                                              .listGuest);
                                                                  Get.back();
                                                                  guestNameController
                                                                      .clear();
                                                                  setState(() {});
                                                                }
                                                              }),
                                                        ],
                                                        icon: Container(
                                                          color: secondaryColor
                                                              .withOpacity(0.5),
                                                          width: 100,
                                                          height: 100,
                                                          child: Obx(
                                                              () => ListView
                                                                      .builder(
                                                                    itemBuilder:
                                                                        (context,
                                                                            index) {
                                                                      return Card(
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              left:
                                                                                  10,
                                                                              right:
                                                                                  10),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                controller.listGuest[index],
                                                                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                                                                              ),
                                                                              IconButton(
                                                                                  onPressed: () {
                                                                                    if (index > 0) {
                                                                                      controller.listGuest.removeAt(index);
                                                                                      guestNameController.text = 'Guest ${controller.listGuest.length}';
                                                                                      setState(() {});
                                                                                    }
                                                                                  },
                                                                                  iconSize: 20,
                                                                                  icon: const Icon(Icons.clear))
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                    itemCount:
                                                                        controller
                                                                            .listGuest
                                                                            .length,
                                                                  )),
                                                        ),
                                                      );
                                                    });
                                              },
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: CustomDropDownButton(
                                                title: '',
                                                hint: 'Guest',
                                                value: controller.guest.isEmpty
                                                    ? null
                                                    : controller.guest,
                                                withOutValue: false,
                                                items: controller.listGuest,
                                                onChange: (value) {
                                                  controller.guest = value!;
                                                },
                                                width: Get.width > 800
                                                    ? Get.width / 15
                                                    : Get.width / 6,
                                                height: ScaledDimensions
                                                    .getScaledHeight(px: 50)),
                                          ),
                                        ],
                                      ),
                                    ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              addressCustomer == ""
                  ? const SizedBox()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Address : $addressCustomer",
                            style: ConstantApp.getTextStyle(
                                context: context, color: secondaryColor),
                          ),
                        ),
                      ],
                    ),
              noteOrder == ""
                  ? const SizedBox()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              showDialogNote1(noteOrder);
                            },
                            child: Text(
                              "Note : $noteOrder",
                              style: ConstantApp.getTextStyle(
                                  context: context, color: secondaryColor),
                            ),
                          ),
                        ),
                      ],
                    ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Flexible(
                        flex: 2,
                        fit: FlexFit.tight,
                        child: Text(
                          'Name'.tr,
                          style: ConstantApp.getTextStyle(
                              context: context,
                              color: secondaryColor,
                              fontWeight: FontWeight.bold),
                        )),
                    Flexible(
                        flex: 2,
                        fit: FlexFit.tight,
                        child: Center(
                          child: Text(
                            'Qty'.tr,
                            style: ConstantApp.getTextStyle(
                                context: context,
                                color: secondaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                    controller.showUnit.value
                        ? Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: Center(
                              child: Text(
                                'Units'.tr,
                                style: ConstantApp.getTextStyle(
                                    context: context,
                                    color: secondaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ))
                        : const SizedBox(),
                    Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: Center(
                          child: Text(
                            'Price'.tr,
                            style: ConstantApp.getTextStyle(
                                context: context,
                                color: secondaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                    Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: Center(
                          child: Text(
                            'Total'.tr,
                            style: ConstantApp.getTextStyle(
                                context: context,
                                color: secondaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                    ConstantApp.appType.name == "REST"
                        ? Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: Center(
                              child: Text(
                                'Guest'.tr,
                                style: ConstantApp.getTextStyle(
                                    context: context,
                                    color: secondaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ))
                        : const SizedBox(),
                    if( Get.find<UserController>().permission.value.showEmployeePos )  Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: Center(
                          child: Text(
                            'Emp.'.tr,
                            style: ConstantApp.getTextStyle(
                                context: context,
                                color: secondaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                    Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: Text(
                          ''.tr,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        )),
                  ],
                ),
              ),
              Expanded(
                child: GetBuilder<OrderController>(builder: (controller) {
                  isDecimal.clear();
                  return controller.loadingOrders.value
                      ? Center(
                          child: SpinKitFoldingCube(
                          color: primaryColor,
                          size: 75,
                        ))
                      : controller.orders.isEmpty &&
                              controller.tempOrder.isEmpty
                          ? Center(
                              child: Text(
                              'No Order'.tr,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ))
                          : controller.tempOrder.isNotEmpty
                              ? ListView.builder(
                                  itemBuilder: (context, index) {
                                    Map<int, double> map = {};
                                    List<UnitModel> listUnit = <UnitModel>[];
                                    for (var i
                                        in controller.productDataPlayer) {
                                      if (i.id ==
                                          controller.tempOrder[index].itemId) {
                                        map.addIf(
                                            (i.unit != 0 && i.unit != null),
                                            i.unit ?? 0,
                                            double.tryParse(i.price ?? '0') ??
                                                0.0);
                                        map.addIf(
                                            (i.unit2 != 0 && i.unit2 != null),
                                            i.unit2 ?? 0,
                                            double.tryParse(i.price2 ?? '0') ??
                                                0.0);
                                        map.addIf(
                                            (i.unit3 != 0 && i.unit3 != null),
                                            i.unit3 ?? 0,
                                            double.tryParse(i.price3 ?? '0') ??
                                                0.0);
                                      }
                                    }
                                    for (var i in controller.units) {
                                      if (map.keys.contains(i.id)) {
                                        listUnit.add(i);
                                      }
                                    }
                                    isDecimal.add(controller.units
                                        .firstWhere((element) =>
                                            element.id ==
                                            controller.tempOrder[index].unitId)
                                        .acceptsDecimal);
                                    return TempOrderItem(
                                      name: controller.tempOrder[index].name,
                                      ident: controller.tempOrder[index].ident,
                                      price: controller.tempOrder[index].price,
                                      qty: controller.tempOrder[index].quantity,
                                      guest: controller.tempOrder[index].guest,
                                      note: controller.tempOrder[index].note,
                                      onPressed: () {
                                        var cont =Get.find<UserController>();
                                        bool result = cont.isPermission(cont.permission.value.removeItemOrder, context);
                                        if(!result){
                                          return;
                                        }
                                        controller.tempOrder.removeAt(index);
                                        if (controller.tempOrder.isEmpty) {
                                          controller.getOrderForTable(
                                              widget.hall, widget.table);
                                        } else {
                                          controller.totalPrice.value = 0.0;
                                          controller.qty.value = 0.0;
                                          for (var i in controller.tempOrder) {
                                            controller.totalPrice.value +=
                                                (i.price * i.quantity);
                                            controller.qty.value += i.quantity;
                                          }
                                        }
                                        setState(() {});
                                      },
                                      iconVis: true,
                                      onChange: (val) {
                                        controller.tempOrder[index].note = val;
                                        setState(() {});
                                      },
                                      select: () {},
                                      index: index,
                                      changPrice: () async {
                                        priceEditingController.text = controller
                                            .tempOrder[index].price
                                            .toStringAsFixed(2);
                                        double whole = 0;
                                        double min = 0;
                                        double max = 0;
                                        double cost = 0;
                                        double price = double.tryParse(
                                                controller
                                                    .tempOrder[index].firstPrice!
                                                    .toStringAsFixed(2)) ??
                                            0.0;
                                        ProductModel product = controller
                                            .products
                                            .firstWhere((element) =>
                                                element.id ==
                                                controller
                                                    .tempOrder[index].itemId);
                                        if (controller
                                                .tempOrder[index].unitId ==
                                            product.unit) {
                                          whole = product.wholePrice ?? 0;
                                          min = product.minPrice ?? 0;
                                          max = product.maxPrice ?? 0;
                                          cost = product.costPrice ?? 0;
                                        } else if (controller
                                                .tempOrder[index].unitId ==
                                            product.unit2) {
                                          whole = product.wholePrice2 ?? 0;
                                          min = product.minPrice2 ?? 0;
                                          max = product.maxPrice2 ?? 0;
                                          cost = product.costPrice2 ?? 0;
                                        } else if (controller
                                                .tempOrder[index].unitId ==
                                            product.unit3) {
                                          whole = product.wholePrice3 ?? 0;
                                          min = product.minPrice3 ?? 0;
                                          max = product.maxPrice3 ?? 0;
                                          cost = product.costPrice3 ?? 0;
                                        }
                                        if (!mounted) return;
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                  title: Row(children: [
                                                    Expanded(
                                                      child: CustomAppButton(
                                                          onPressed: () {
                                                            controller
                                                                .tempOrder[
                                                                    index]
                                                                .price = price;
                                                            controller
                                                                .totalPrice
                                                                .value = 0;
                                                            for (var i
                                                                in controller
                                                                    .tempOrder) {
                                                              controller
                                                                  .totalPrice
                                                                  .value += (i
                                                                      .price *
                                                                  i.quantity);
                                                            }
                                                            setState(() {});
                                                            priceEditingController
                                                                    .text =
                                                                price
                                                                    .toString();
                                                          },
                                                          title:
                                                              'Price/$price AED',
                                                          backgroundColor: primaryColor
                                                              .withOpacity(0.5),
                                                          textColor: textColor,
                                                          withPadding: false,
                                                          width: ConstantApp
                                                                  .getWidth(
                                                                      context) /
                                                              10,
                                                          height: ConstantApp
                                                                  .getHeight(
                                                                      context) /
                                                              15),
                                                    ),
                                                    if (Get.find<UserController>().permission.value.choseWholePrice)   Expanded(
                                                      child: CustomAppButton(
                                                          onPressed: () {
                                                            controller
                                                                .tempOrder[
                                                                    index]
                                                                .price = whole;
                                                            controller
                                                                .totalPrice
                                                                .value = 0;
                                                            for (var i
                                                                in controller
                                                                    .tempOrder) {
                                                              controller
                                                                  .totalPrice
                                                                  .value += (i
                                                                      .price *
                                                                  i.quantity);
                                                            }
                                                            setState(() {});
                                                            priceEditingController
                                                                    .text =
                                                                whole
                                                                    .toString();
                                                          },
                                                          title:
                                                              'Whole/$whole AED',
                                                          backgroundColor: primaryColor
                                                              .withOpacity(0.5),
                                                          textColor: textColor,
                                                          withPadding: false,
                                                          width: ConstantApp
                                                                  .getWidth(
                                                                      context) /
                                                              10,
                                                          height: ConstantApp
                                                                  .getHeight(
                                                                      context) /
                                                              15),
                                                    ),
                                                    if (Get.find<UserController>().permission.value.choseOfferPrice)  Expanded(
                                                      child: CustomAppButton(
                                                          onPressed: () {
                                                            controller
                                                                .tempOrder[
                                                                    index]
                                                                .price = min;
                                                            controller
                                                                .totalPrice
                                                                .value = 0;
                                                            for (var i
                                                                in controller
                                                                    .tempOrder) {
                                                              controller
                                                                  .totalPrice
                                                                  .value += (i
                                                                      .price *
                                                                  i.quantity);
                                                            }
                                                            setState(() {});
                                                            priceEditingController
                                                                    .text =
                                                                min.toString();
                                                          },
                                                          title: 'Min/$min AED',
                                                          backgroundColor: primaryColor
                                                              .withOpacity(0.5),
                                                          textColor: textColor,
                                                          withPadding: true,
                                                          width: ConstantApp
                                                                  .getWidth(
                                                                      context) /
                                                              10,
                                                          height: ConstantApp
                                                                  .getHeight(
                                                                      context) /
                                                              15),
                                                    ),
                                                    Expanded(
                                                      child: CustomAppButton(
                                                          onPressed: () {
                                                            controller
                                                                .tempOrder[
                                                                    index]
                                                                .price = max;
                                                            controller
                                                                .totalPrice
                                                                .value = 0;
                                                            for (var i
                                                                in controller
                                                                    .tempOrder) {
                                                              controller
                                                                  .totalPrice
                                                                  .value += (i
                                                                      .price *
                                                                  i.quantity);
                                                            }
                                                            setState(() {});
                                                            priceEditingController
                                                                    .text =
                                                                max.toString();
                                                          },
                                                          title: 'Max/$max AED',
                                                          backgroundColor: primaryColor
                                                              .withOpacity(0.5),
                                                          textColor: textColor,
                                                          withPadding: true,
                                                          width: ConstantApp
                                                                  .getWidth(
                                                                      context) /
                                                              10,
                                                          height: ConstantApp
                                                                  .getHeight(
                                                                      context) /
                                                              15),
                                                    ),
                                                    if (Get.find<UserController>().permission.value.choseCostPrice)  Expanded(
                                                      child: CustomAppButton(
                                                          onPressed: () {
                                                            controller
                                                                .tempOrder[
                                                                    index]
                                                                .price = cost;
                                                            controller
                                                                .totalPrice
                                                                .value = 0;
                                                            for (var i
                                                                in controller
                                                                    .tempOrder) {
                                                              controller
                                                                  .totalPrice
                                                                  .value += (i
                                                                      .price *
                                                                  i.quantity);
                                                            }
                                                            setState(() {});
                                                            priceEditingController
                                                                    .text =
                                                                cost.toString();
                                                          },
                                                          title:
                                                              'Cost/$cost AED',
                                                          backgroundColor: primaryColor
                                                              .withOpacity(0.5),
                                                          textColor: textColor,
                                                          withPadding: true,
                                                          width: ConstantApp
                                                                  .getWidth(
                                                                      context) /
                                                              10,
                                                          height: ConstantApp
                                                                  .getHeight(
                                                                      context) /
                                                              15),
                                                    ),
                                                  ]),
                                                  actions: [
                                                    Center(
                                                      child:
                                                          CustomTextFormField(
                                                        isNum: true,
                                                        readOnly:! Get.find<UserController>().permission.value.editPrice,
                                                        onChange: (val) {
                                                          if(val!.isNotEmpty){
                                                            controller
                                                                .tempOrder[
                                                            index]
                                                                .price = double.tryParse(val)??0.0;

                                                          }else{
                                                            controller
                                                                .tempOrder[
                                                            index]
                                                                .price = 0;
                                                          }
                                                          controller
                                                              .totalPrice
                                                              .value = 0;
                                                          for (var i
                                                          in controller
                                                              .tempOrder) {
                                                            controller
                                                                .totalPrice
                                                                .value += (i
                                                                .price *
                                                                i.quantity);
                                                          }
                                                          setState(() {
                                                          });
                                                        },
                                                        hint: 'Price',
                                                        focusNode: FocusNode(),
                                                        textEditingController:
                                                            priceEditingController,
                                                        onSaved: (val) {},
                                                        validator: (val) {
                                                          return null;
                                                        },
                                                      ),
                                                    ),
                                                  ]);
                                            });
                                      },
                                      unitWidget: CustomDropDownButtonUnits(
                                          title: '',
                                          hint: 'Units'.tr,
                                          value: controller.tempOrder[index]
                                                      .unitId ==
                                                  0
                                              ? null
                                              : controller
                                                  .tempOrder[index].unitId,
                                          withOutValue: true,
                                          items: listUnit,
                                          onChange: (value) {
                                            controller.tempOrder[index].unitId =
                                                value!;
                                            controller.tempOrder[index].price =
                                                map[value]!;
                                            controller.totalPrice.value = 0.0;
                                            controller.qty.value = 0;
                                            for (var i
                                                in controller.tempOrder) {
                                              controller.totalPrice.value +=
                                                  (i.price * i.quantity);
                                              controller.qty.value +=
                                                  i.quantity;
                                            }
                                            setState(() {});
                                          },
                                          width: Get.width > 800
                                              ? ConstantApp.getWidth(context) /
                                                  20
                                              : ConstantApp.getWidth(context) /
                                                  10,
                                          height: Get.width > 800
                                              ? ConstantApp.getHeight(context) /
                                                  20
                                              : ConstantApp.getHeight(context) /
                                                  35,
                                          showIconReset: false,
                                          textEditingController:
                                              textEditingController),
                                      changQty: () {
                                        priceEditingController.text = controller
                                            .tempOrder[index].quantity
                                            .toStringAsFixed(1);
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(actions: [
                                                TextFormField(
                                                  autofocus: true,
                                                  inputFormatters:
                                                      isDecimal[index] == true
                                                          ? [
                                                              FilteringTextInputFormatter
                                                                  .allow(RegExp(
                                                                      r'(^\d*\.?\d*)'))
                                                            ]
                                                          : [
                                                              FilteringTextInputFormatter
                                                                  .allow(RegExp(
                                                                      r'[0-9]')),
                                                            ],
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration: InputDecoration(
                                                      labelText: 'QTY'.tr,
                                                      enabledBorder:
                                                          const UnderlineInputBorder(
                                                              borderSide:
                                                                  BorderSide
                                                                      .none),
                                                      focusedBorder:
                                                          const OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide
                                                                      .none)),
                                                  controller:
                                                      priceEditingController,
                                                  onChanged: (val) {
                                                    if (val.isNotEmpty) {
                                                      if (double.parse(val) <=
                                                          0) {
                                                        controller
                                                            .tempOrder[index]
                                                            .quantity = 1.00;
                                                      } else {
                                                        controller
                                                                .tempOrder[index]
                                                                .quantity =
                                                            double.parse(val);
                                                      }
                                                    }
                                                    controller
                                                        .totalPrice.value = 0.0;
                                                    controller.qty.value = 0;
                                                    for (var i in controller
                                                        .tempOrder) {
                                                      controller.totalPrice
                                                              .value +=
                                                          (i.price *
                                                              i.quantity);
                                                      controller.qty.value +=
                                                          i.quantity;
                                                    }
                                                    setState(() {});
                                                  },
                                                ),
                                              ]);
                                            });
                                      },
                                      addQty: () async {
                                        double qty = await controller.checkQty(
                                            variableId: controller
                                                .tempOrder[index].variableId!,
                                            id: controller
                                                .tempOrder[index].itemId);
                                        for (var i in controller.tempOrder) {
                                          if (i.itemId ==
                                                  controller.tempOrder[index]
                                                      .itemId &&
                                              i.variableId ==
                                                  controller.tempOrder[index]
                                                      .variableId) {
                                            qty -= i.quantity;
                                          }
                                        }
                                        if (!controller.negative.value) {
                                          if (qty <= 0) {
                                            if (!mounted) {
                                              return;
                                            }
                                            if (!context.mounted) return;
                                            ConstantApp.showSnakeBarError(
                                                context,
                                                'There Is No Quantity !!');
                                            return;
                                          }
                                        }
                                        controller.tempOrder[index].quantity++;
                                        controller.tempOrder[index]
                                            .totalPrice = controller
                                                .tempOrder[index].quantity *
                                            controller.tempOrder[index].price;
                                        controller.totalPrice.value = 0.0;
                                        controller.qty.value = 0;
                                        for (var i in controller.tempOrder) {
                                          controller.totalPrice.value +=
                                              (i.price * i.quantity);
                                          controller.qty.value += i.quantity;
                                        }
                                        setState(() {});
                                      },
                                      subQty: () {
                                        if (controller
                                                .tempOrder[index].quantity >
                                            1) {
                                          controller
                                              .tempOrder[index].quantity--;
                                          controller.tempOrder[index]
                                              .totalPrice = controller
                                                  .tempOrder[index].quantity *
                                              controller.tempOrder[index].price;
                                          controller.totalPrice.value = 0.0;
                                          controller.qty.value = 0;
                                          for (var i in controller.tempOrder) {
                                            controller.totalPrice.value +=
                                                (i.price * i.quantity);
                                            controller.qty.value += i.quantity;
                                          }
                                        }
                                        setState(() {});
                                      },
                                      employeeWidget:
                                          CustomDropDownButtonEmployee(
                                              title: 'Employee',
                                              hint: 'Employee',
                                              showIconReset: false,
                                              value: controller.tempOrder[index]
                                                          .employeeId ==
                                                      0
                                                  ? null
                                                  : controller.tempOrder[index]
                                                      .employeeId,
                                              items: Get.find<InfoController>()
                                                  .employees
                                                  .where((p0) => p0.isActive)
                                                  .toList(),
                                              onChange: (value) {
                                                controller.tempOrder[index]
                                                    .employeeId = value ?? 0;
                                                for (var i in Get.find<
                                                        InfoController>()
                                                    .employees
                                                    .where((p0) => p0.isActive)
                                                    .toList()) {
                                                  if (i.id ==
                                                      controller
                                                          .tempOrder[index]
                                                          .employeeId) {
                                                    controller.tempOrder[index]
                                                            .commission =
                                                        i.commission;
                                                  }
                                                }
                                                setState(() {});
                                              },
                                              width: ConstantApp.getWidth(
                                                      context) /
                                                  20,
                                              height: ConstantApp.getHeight(
                                                      context) /
                                                  20,
                                              textEditingController:
                                                  textEditingController),
                                    );
                                  },
                                  itemCount: controller.tempOrder.length,
                                )
                              : Obx(
                                  () => ListView.builder(
                                    itemBuilder: (context, index) =>
                                        OrderItemWidget(
                                      items: controller.orders[index].orders,
                                      orderDate:
                                          controller.orders[index].orderDate,
                                      orderId: controller.orders[index].id,
                                      setStateMore: () {
                                        setState(() {});
                                      },
                                    ),
                                    itemCount: controller.orders.length,
                                  ),
                                );
                }),
              ),
              SizedBox(
                height: Get.width > 800 ? 100 : 175,
                width: Get.width,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Get.width > 800 || GetPlatform.isWindows
                              ? const SizedBox()
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FloatingActionButton(
                                      onPressed: () {
                                        Get.dialog(Dialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          elevation: 0.0,
                                          backgroundColor: Colors.transparent,
                                          child: addButton(context),
                                        ));
                                      },
                                      backgroundColor:
                                          secondaryColor.withOpacity(0.8),
                                      child: const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      )),
                                ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  height: 100,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.white,
                                      ),
                                      color: Colors.white),
                                  child: Obx(
                                    () => Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              height: 25,
                                              color: secondaryColor
                                                  .withOpacity(0.8),
                                              child: Center(
                                                child: Text(
                                                    '${controller.qty} \t ${'QTY'.tr}',
                                                    style: const TextStyle(
                                                        color: Colors.white)),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Center(
                                              child: Text(
                                                '${(controller.tempOrder.isNotEmpty ? controller.totalPrice.toStringAsFixed(2) : controller.fTotal.toStringAsFixed(2))} ${'AED'.tr}',
                                                style: ConstantApp.getTextStyle(
                                                  context: context,
                                                  color: textColor,
                                                  size: 13,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ]),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  height: 100,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.white,
                                      ),
                                      color: Colors.white),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Flexible(
                                                  flex: 1,
                                                  fit: FlexFit.tight,
                                                  child: Text(
                                                    'Subtotal :',
                                                    style: ConstantApp
                                                        .getTextStyle(
                                                            context: context,
                                                            size: 8,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color:
                                                                secondaryColor),
                                                  )),
                                              Flexible(
                                                  flex: 1,
                                                  fit: FlexFit.tight,
                                                  child: Text(
                                                    'Discount :',
                                                    style: ConstantApp
                                                        .getTextStyle(
                                                            context: context,
                                                            size: 8,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color:
                                                                secondaryColor),
                                                  )),
                                              Obx(
                                                () =>
                                                    Get.find<InfoController>()
                                                            .taxesSetting
                                                            .isEmpty
                                                        ? const SizedBox()
                                                        : Flexible(
                                                            flex: 1,
                                                            fit: FlexFit.tight,
                                                            child: Text(
                                                              'Vat :',
                                                              style: ConstantApp.getTextStyle(
                                                                  context:
                                                                      context,
                                                                  size: 8,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color:
                                                                      secondaryColor),
                                                            )),
                                              ),
                                              Flexible(
                                                  flex: 1,
                                                  fit: FlexFit.tight,
                                                  child: Text(
                                                    'Final Total :',
                                                    style: ConstantApp
                                                        .getTextStyle(
                                                            context: context,
                                                            size: 8,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color:
                                                                secondaryColor),
                                                  )),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 20),
                                          child: GetBuilder<OrderController>(
                                              builder: (controller) {
                                            return Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Flexible(
                                                    flex: 1,
                                                    fit: FlexFit.tight,
                                                    child: Text(
                                                      controller.priceWithOutVat
                                                          .toStringAsFixed(2),
                                                      style: ConstantApp
                                                          .getTextStyle(
                                                              context: context,
                                                              size: 8,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color:
                                                                  secondaryColor),
                                                    )),
                                                Flexible(
                                                    flex: 1,
                                                    fit: FlexFit.tight,
                                                    child: Text(
                                                      controller.disAmount
                                                          .toStringAsFixed(2),
                                                      style: ConstantApp
                                                          .getTextStyle(
                                                              context: context,
                                                              size: 8,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color:
                                                                  secondaryColor),
                                                    )),
                                                Obx(
                                                  () =>
                                                      Get.find<InfoController>()
                                                              .taxesSetting
                                                              .isEmpty
                                                          ? const SizedBox()
                                                          : Flexible(
                                                              flex: 1,
                                                              fit:
                                                                  FlexFit.tight,
                                                              child: Text(
                                                                controller.vat
                                                                    .toStringAsFixed(
                                                                        2),
                                                                style: ConstantApp.getTextStyle(
                                                                    context:
                                                                        context,
                                                                    size: 8,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color:
                                                                        secondaryColor),
                                                              )),
                                                ),
                                                Flexible(
                                                    flex: 1,
                                                    fit: FlexFit.tight,
                                                    child: Text(
                                                      controller.fTotal
                                                          .toStringAsFixed(2),
                                                      style: ConstantApp
                                                          .getTextStyle(
                                                              context: context,
                                                              size: 8,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color:
                                                                  secondaryColor),
                                                    )),
                                              ],
                                            );
                                          }),
                                        ),
                                      ]),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ConstantApp.appType.name == "REST"
                          ? Flexible(
                              flex: 2,
                              child: CustomAppButton(
                                height:
                                    ScaledDimensions.getScaledHeight(px: 60),
                                width: ScaledDimensions.getScaledWidth(px: 100),
                                onPressed: sendFunction,
                                title: 'Send'.tr,
                                backgroundColor: Colors.white,
                                textColor: Colors.black,
                                withPadding: false,
                              ),
                            )
                          : const SizedBox(),
                      ConstantApp.appType.name != "REST"
                          ? Flexible(
                              flex: 2,
                              child: CustomAppButton(
                                height:
                                    ScaledDimensions.getScaledHeight(px: 60),
                                width: ScaledDimensions.getScaledWidth(px: 100),
                                onPressed: sendFunction,
                                title: 'Save Changes'.tr,
                                backgroundColor: Colors.white,
                                textColor: Colors.black,
                                withPadding: false,
                              ),
                            )
                          : const SizedBox(),
                      ConstantApp.appType.name == "REST"
                          ? Flexible(
                              flex: 2,
                              child: CustomAppButton(
                                height:
                                    ScaledDimensions.getScaledHeight(px: 60),
                                width: ScaledDimensions.getScaledWidth(px: 100),
                                onPressed: printBillFunction,
                                title: 'Bill Request'.tr,
                                backgroundColor: Colors.white,
                                textColor: Colors.black,
                                withPadding: false,
                              ),
                            )
                          : const SizedBox(),
                      Flexible(
                        flex: 2,
                        child: CustomAppButton(
                          height: ScaledDimensions.getScaledHeight(px: 60),
                          width: ScaledDimensions.getScaledWidth(px: 100),
                          onPressed: discountFunction,
                          title: 'Discount'.tr,
                          backgroundColor: Colors.white,
                          textColor: Colors.black,
                          withPadding: false,
                        ),
                      ),
                      Get.find<SharedPreferences>().getString('type') ==
                                  "Captain" ||
                              Get.find<SharedPreferences>().getString('type') ==
                                  "User"
                          ? const SizedBox()
                          : Flexible(
                              flex: 2,
                              child: CustomAppButton(
                                height:
                                    ScaledDimensions.getScaledHeight(px: 60),
                                width: ScaledDimensions.getScaledWidth(px: 100),
                                onPressed: saveFunction,
                                title: 'Save'.tr,
                                backgroundColor: Colors.white,
                                textColor: Colors.black,
                                withPadding: false,
                              ),
                            ),
                      ConstantApp.appType.name == "REST"
                          ? Flexible(
                              flex: 2,
                              child: Center(
                                child: TextButton(
                                  onPressed: voidFun,
                                  child: Text(
                                    'Void'.tr,
                                    style: ConstantApp.getTextStyle(
                                        context: context,
                                        color: secondaryColor,
                                        size: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ))
                          : const SizedBox(),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Widget productItemsWidget() {
    return Obx(
      () => Expanded(
          flex: Get.width > 800
              ? ConstantApp.isTab(context)
                  ? controller.productWidth.value - 1
                  : controller.productWidth.value
              : 5,
          child: Column(
            children: [
              Expanded(
                  flex: 1,
                  child: Container(
                    width: double.infinity,
                    height: ScaledDimensions.getScaledHeight(px: 100),
                    decoration: BoxDecoration(
                        color: secondaryColor,
                        border: const Border.symmetric(
                            vertical:
                                BorderSide(color: Colors.white, width: 1))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 6,
                            child: TextField(
                              controller: textEditingController3,
                              onChanged: (value) =>
                                  controller.filterProductPlayer(value),
                              cursorColor: Colors.white,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  icon: GetPlatform.isWindows
                                      ? const SizedBox()
                                      : IconButton(
                                          icon: const Icon(
                                              FontAwesomeIcons.barcode,
                                              color: Colors.white),
                                          onPressed: () async {
                                            isClose = false;
                                            var result =
                                                await BarcodeScanner.scan();
                                            if (!mounted) {
                                              return;
                                            }
                                            await controller
                                                .addProductFromBarcode(
                                                    result.rawContent,
                                                    context,
                                                    widget.hall,
                                                    widget.table);
                                            isClose = true;
                                            setState(() {});
                                          }),
                                  suffixIconColor: Colors.white,
                                  hintText: 'Search...'.tr,
                                  hintStyle:
                                      const TextStyle(color: Colors.white),
                                  suffixIcon: const Icon(Icons.search),
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide.none)),
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: IconButton(
                                  onPressed: () async {
                                    textEditingController3.clear();
                                    await controller.getAllProducts();
                                    await Get.find<InfoController>()
                                        .getAllEmployee();

                                    await Get.find<InfoController>()
                                        .getAllTaxesSetting();
                                    await Get.find<InfoController>()
                                        .getAllInformation();
                                  },
                                  icon: Icon(
                                    Icons.refresh_outlined,
                                    color: primaryColor,
                                    size: ConstantApp.getTextSize(context) * 15,
                                  )))
                        ],
                      ),
                    ),
                  )),
              Expanded(
                flex: Get.width > 800 ? 11 : 15,
                child: Column(
                  children: [
                    Expanded(
                      child: GetBuilder<OrderController>(
                        builder: (controller) => Container(
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.2),
                                border: const Border.symmetric(
                                    vertical: BorderSide(
                                        color: Colors.black, width: 2))),
                            child: controller.productsLoading.value
                                ? const DefaultLoader()
                                : GridView.builder(
                                    padding: EdgeInsets.zero,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: Get.width > 800
                                                ? ConstantApp.isTab(context)
                                                    ? controller
                                                            .productItem.value +
                                                        3
                                                    : controller
                                                        .productItem.value
                                                : 3,
                                            crossAxisSpacing:
                                                ScaledDimensions.getScaledWidth(
                                                    px: 2),
                                            mainAxisSpacing: ScaledDimensions
                                                .getScaledHeight(px: 5)),
                                    itemCount:
                                        controller.productDataPlayer.length,
                                    itemBuilder: ((context, index) {
                                      return GridItem(
                                        maxLine: 2,
                                        onTap: () async {
                                          if (controller
                                                  .productDataPlayer[index]
                                                  .type ==
                                              'variable') {
                                            await controller.getVariable(
                                                controller
                                                    .productDataPlayer[index]
                                                    .id!);
                                            if (!context.mounted) return;
                                            showAnimatedDialog(
                                              context: context,
                                              builder: (context) {
                                                return SimpleDialog(
                                                  backgroundColor: Colors.white,
                                                  children: [
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              3,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              1.6,
                                                      child: GetBuilder<
                                                          OrderController>(
                                                        builder: (controller) {
                                                          return GridView
                                                              .builder(
                                                            padding: EdgeInsets.all(
                                                                ScaledDimensions
                                                                    .getScaledWidth(
                                                                        px: 5)),
                                                            gridDelegate:
                                                                SliverGridDelegateWithFixedCrossAxisCount(
                                                              childAspectRatio:
                                                                  1,
                                                              crossAxisCount: 2,
                                                              crossAxisSpacing:
                                                                  ScaledDimensions
                                                                      .getScaledWidth(
                                                                          px: 10),
                                                              mainAxisSpacing:
                                                                  10,
                                                            ),
                                                            itemCount: controller
                                                                .productsVariable
                                                                .length,
                                                            itemBuilder:
                                                                ((context,
                                                                    index1) {
                                                              return GridItem(
                                                                onTap:
                                                                    () async {
                                                                  double qty = await controller.checkQty(
                                                                      variableId: controller
                                                                          .productsVariable[
                                                                              index1]
                                                                          .id!,
                                                                      id: controller
                                                                          .productDataPlayer[
                                                                              index]
                                                                          .id!);
                                                                  for (var i
                                                                      in controller
                                                                          .tempOrder) {
                                                                    if (i.itemId ==
                                                                            controller
                                                                                .productDataPlayer[
                                                                                    index]
                                                                                .id &&
                                                                        i.variableId ==
                                                                            controller.productsVariable[index1].id) {
                                                                      qty -= i
                                                                          .quantity;
                                                                    }
                                                                  }
                                                                  if (!controller
                                                                      .negative
                                                                      .value) {
                                                                    if (qty <=
                                                                        0) {
                                                                      if (!context
                                                                          .mounted) {
                                                                        return;
                                                                      }
                                                                      ConstantApp.showSnakeBarError(
                                                                          context,
                                                                          'There Is No Quantity !!');
                                                                      return;
                                                                    }
                                                                  }

                                                                  await controller.addOrder(
                                                                      controller.productDataPlayer[
                                                                          index],
                                                                      controller
                                                                          .productsVariable[
                                                                              index1]
                                                                          .id!,
                                                                      null,
                                                                      null,
                                                                      widget
                                                                          .hall,
                                                                      widget
                                                                          .table);

                                                                  if (!context
                                                                      .mounted) {
                                                                    return;
                                                                  }
                                                                  ConstantApp
                                                                      .showSnakeBarInfo(
                                                                          context,
                                                                          'Add Items Success !!');
                                                                  Get.back();
                                                                },
                                                                name: controller
                                                                    .productsVariable[
                                                                        index1]
                                                                    .name!,
                                                                image: "",
                                                                imageBytes: controller
                                                                    .productsVariable[
                                                                        index1]
                                                                    .image,
                                                              );
                                                            }),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                              barrierDismissible: true,
                                              animationType:
                                                  DialogTransitionType.sizeFade,
                                              curve: Curves.fastOutSlowIn,
                                              duration: const Duration(
                                                  milliseconds: 400),
                                            );
                                          } else {
                                            double qty = 0.0;
                                            qty = await controller.checkQty(
                                                variableId: 0,
                                                id: controller
                                                    .productDataPlayer[index]
                                                    .id!);
                                            for (var i
                                                in controller.tempOrder) {
                                              if (i.itemId ==
                                                  controller
                                                      .productDataPlayer[index]
                                                      .id) {
                                                qty -= i.quantity;
                                              }
                                            }
                                            if (!controller.negative.value) {
                                              if (qty <= 0) {
                                                if (!context.mounted) return;
                                                ConstantApp.showSnakeBarError(
                                                    context,
                                                    'There Is No Quantity !!');
                                                return;
                                              }
                                            }

                                            controller.addOrder(
                                                controller
                                                    .productDataPlayer[index],
                                                0,
                                                null,
                                                null,
                                                widget.hall,
                                                widget.table);
                                            if (!context.mounted) return;
                                            ConstantApp.showSnakeBarInfo(
                                                context,
                                                'Add Items Success !!');
                                          }
                                          setState(() {});
                                        },
                                        name: controller
                                            .productDataPlayer[index]
                                            .englishName!,
                                        image: "",
                                        imageBytes: controller
                                            .productDataPlayer[index].image,
                                        price: controller
                                            .productDataPlayer[index].price,
                                        onLongPress: () {},
                                        color: Color(int.parse(controller
                                                .productDataPlayer[index]
                                                .colorProduct!))
                                            .withOpacity(0.7),
                                      );
                                    }))),
                      ),
                    ),
                    !controller.keyboardVis.value
                        ? const SizedBox()
                        : Expanded(
                            child: Container(
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.2),
                                border: const Border.symmetric(
                                    vertical: BorderSide(
                                        color: Colors.black, width: 2))),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      width: 250,
                                      child: TextFormField(
                                        readOnly: true,
                                        textAlign: TextAlign.center,
                                        controller: numController,
                                        keyboardType: TextInputType.none,
                                        showCursor: false,
                                      ),
                                    ),
                                    NumPad(
                                        delete: () {
                                          if (numController.text.isEmpty) {
                                            return;
                                          }
                                          numController.text =
                                              numController.text.substring(
                                                  0,
                                                  numController.text.length -
                                                      1);
                                        },
                                        onSubmit: () {},
                                        controller: numController,
                                        buttonSize: 35,
                                        buttonColor: Colors.black,
                                        iconColor: Colors.black,
                                        onPressed: () {}),
                                  ],
                                ),
                              ),
                            ),
                          ))
                  ],
                ),
              ),
            ],
          )),
    );
  }

  Widget supCategoryWidget() {
    return GetBuilder<OrderController>(builder: (controller) {
      return Expanded(
          flex: Get.width > 800 ? controller.subWidth.value : 2,
          child: Column(
            children: [
              Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                        color: secondaryColor,
                        border: const Border.symmetric(
                            vertical:
                                BorderSide(color: Colors.black, width: 2))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        style: const TextStyle(color: Colors.white),
                        onChanged: (value) => controller.filterSubPlayer(value),
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          suffixIconColor: Colors.white,
                          border: const UnderlineInputBorder(
                              borderSide: BorderSide.none),
                          hintText: 'Search...'.tr,
                          hintStyle: const TextStyle(
                            color: Colors.white,
                          ),
                          suffixIcon: const Icon(Icons.search),
                        ),
                      ),
                    ),
                  )),
              Expanded(
                flex: Get.width > 800 ? 11 : 15,
                child: GetBuilder<OrderController>(
                  builder: (controller) => controller.productsLoading.value
                      ? const DefaultLoader()
                      : Container(
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.2),
                              border: const Border.symmetric(
                                  vertical: BorderSide(
                                      color: Colors.black, width: 2))),
                          child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: 1.5,
                                      crossAxisCount: Get.width > 800
                                          ? ConstantApp.isTab(context)
                                              ? controller.subItem.value + 5
                                              : controller.subItem.value
                                          : 1,
                                      // GetPlatform.isDesktop ? 6 : 2,
                                      crossAxisSpacing:
                                          ScaledDimensions.getScaledWidth(
                                              px: 4),
                                      mainAxisSpacing: 0),
                              itemCount: controller.subCategoriesPlayer.length,
                              itemBuilder: ((context, index) => GridItem(
                                    icon: ConstantApp.appType.name == "RETAIL"
                                        ? Get.find<OrderController>()
                                                .iconsRetail[
                                            controller
                                                .subCategoriesPlayer[index]
                                                .icon]
                                        : ConstantApp.appType.name == "Salon"
                                            ? Get.find<OrderController>()
                                                    .iconsSalon[
                                                controller
                                                    .subCategoriesPlayer[index]
                                                    .icon]
                                            : Get.find<OrderController>().icons[
                                                controller
                                                    .subCategoriesPlayer[index]
                                                    .icon],
                                    onTap: () {
                                      controller.fillProduct(controller
                                          .subCategoriesPlayer[index].id);
                                    },
                                    name: controller.subCategoriesPlayer[index]
                                        .englishName!,
                                    image: "",
                                    imageBytes: controller
                                        .subCategoriesPlayer[index].image,
                                    onLongPress: () {},
                                    color: Color(int.parse(controller
                                            .subCategoriesPlayer[index].color!))
                                        .withOpacity(0.7),
                                  ))),
                        ),
                ),
              ),
            ],
          ));
    });
  }

  Widget mainCategoryWidget() {
    return GetBuilder<OrderController>(builder: (controller) {
      return Expanded(
        flex: Get.width > 800 ? controller.mainWidth.value : 2,
        child: Column(
          children: [
            Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                      color: secondaryColor,
                      border: const Border.symmetric(
                          vertical: BorderSide(color: Colors.black, width: 2))),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      onChanged: (value) => controller.filterMainPlayer(value),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        suffixIconColor: Colors.white,
                        border: const UnderlineInputBorder(
                            borderSide: BorderSide.none),
                        hintText: 'Search...'.tr,
                        hintStyle: const TextStyle(
                          color: Colors.white,
                        ),
                        suffixIcon: const Icon(Icons.search),
                      ),
                    ),
                  ),
                )),
            Expanded(
              flex: Get.width > 800 ? 11 : 15,
              child: GetBuilder<OrderController>(
                builder: (controller) => Container(
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      border: const Border.symmetric(
                          vertical: BorderSide(color: Colors.black, width: 2))),
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 1.5,
                          crossAxisCount: Get.width > 800
                              ? ConstantApp.isTab(context)
                                  ? controller.mainItem.value + 5
                                  : controller.mainItem.value
                              : 1,
                          crossAxisSpacing:
                              ScaledDimensions.getScaledWidth(px: 4),
                          mainAxisSpacing: 0),
                      itemCount: controller.mainCategoryPlayer.length,
                      itemBuilder: ((context, index) => GridItem(
                            icon: ConstantApp.appType.name == "RETAIL"
                                ? Get.find<OrderController>().iconsRetail[
                                    controller.mainCategoryPlayer[index].icon]
                                : ConstantApp.appType.name == "Salon"
                                    ? Get.find<OrderController>().iconsSalon[
                                        controller
                                            .mainCategoryPlayer[index].icon]
                                    : Get.find<OrderController>().icons[
                                        controller
                                            .mainCategoryPlayer[index].icon],
                            onTap: () {
                              controller.fillMain(
                                  controller.mainCategoryPlayer[index].id);
                              setState(() {});
                            },
                            name: controller
                                .mainCategoryPlayer[index].englishName!,
                            image: "",
                            imageBytes:
                                controller.mainCategoryPlayer[index].image,
                            onLongPress: () {},
                            color: Color(int.parse(controller
                                    .mainCategoryPlayer[index].color!))
                                .withOpacity(0.7),
                          ))),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget widgetAddCustomer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        controller.customerId.value != 1
            ? IconButton(
                icon: const Icon(Icons.remove_red_eye_rounded),
                tooltip: 'View Details'.tr,
                color: Colors.white,
                onPressed: () {
                  customerNumber = customerNumber;
                  addressCustomer = addressCustomer;
                  CustomerModel? element = Get.find<OrderController>()
                      .customer
                      .firstWhereOrNull((element) =>
                          element.id == controller.customerId.value);

                  dialogAddress(
                      address: element?.address ?? [],
                      id: element?.id ?? 0,
                      mobilNumber: element?.mobileList ?? [],
                      name: element?.businessName ?? "");

                  // dialogAddress(
                  //     address: element?.address ?? [],
                  //     id: element?.id ?? 0,
                  //     mobilNumber: element?.mobileList ?? [],
                  //     name: element?.businessName ?? "");
                },
              )
            : const SizedBox(),
        IconButton(
          icon: const Icon(Icons.add),
          tooltip: 'Add Customer'.tr,
          color: Colors.white,
          onPressed: () async {
            var cont =Get.find<UserController>();
              bool result = cont.isPermission(cont.permission.value.addContact, context);
              if(!result){
                return;
              }

            bool isActive =
                await Get.find<UserController>().checkUser(context: context);
            if (isActive) {
              return;
            }
            if (!mounted) {
              return;
            }
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    scrollable: true,
                    title: Text('Add Customer'.tr),
                    content: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: busNameController,
                              onSaved: (val) {
                                busNameController.text = val!;
                              },
                              decoration: InputDecoration(
                                labelText: 'Business name'.tr,
                                icon: const Icon(Icons.business),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter name'.tr;
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: firstNameController,
                              onSaved: (val) {
                                firstNameController.text = val!;
                              },
                              decoration: InputDecoration(
                                labelText: 'Name'.tr,
                                icon: const Icon(Icons.account_box),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter name'.tr;
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: mobileTextEditing,
                              onSaved: (val) {
                                mobileTextEditing.text = val!;
                              },
                              decoration: InputDecoration(
                                labelText: "${'Mobile Number'.tr}*",
                                icon: const Icon(Icons.phone),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Mobile number'.tr;
                                }
                                return null;
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                              ],
                            ),
                            TextFormField(
                              controller: address1Controller,
                              onSaved: (val) {
                                address1Controller.text = val!;
                              },
                              decoration: InputDecoration(
                                labelText: 'Address'.tr,
                                icon: const Icon(Icons.location_on),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter Address'.tr;
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text(
                            'Cancel'.tr,
                            style: const TextStyle(color: Colors.red),
                          )),
                      TextButton(
                          child: Text(
                            "Add".tr,
                            style: const TextStyle(color: Color(0xffee680e)),
                          ),
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              String message = await controller.addCustomer(
                                  firstName: firstNameController.text,
                                  busName: busNameController.text,
                                  address: address1Controller.text,
                                  mobile: mobileTextEditing.text);
                              if (message == 'Error') {
                                if (!context.mounted) return;
                                ConstantApp.showSnakeBarError(
                                  context,
                                  'Some Thing Wrong !!'.tr,
                                );
                              }
                              if (!context.mounted) return;
                              ConstantApp.showSnakeBarSuccess(
                                context,
                                'Add Success !!'.tr,
                              );
                              customerNumber = mobileTextEditing.text;
                              addressCustomer = address1Controller.text;
                              firstNameController.clear();
                              busNameController.clear();
                              mobileTextEditing.clear();
                              address1Controller.clear();
                              Get.back();
                              setState(() {});
                            }
                          }),
                    ],
                  );
                });
          },
        ),
      ],
    );
  }

  Widget settingWidgetOrderView() {
    return PopupMenuButton(
        tooltip: 'Settings'.tr,
        iconSize: 20,
        icon: Icon(
          Icons.menu,
          color: primaryColor.withOpacity(0.8),
        ),
        color: Colors.white.withOpacity(0.8),
        onSelected: (value) async {
          bool isActive =
              await Get.find<UserController>().checkUser(context: context);
          if (isActive) {
            return;
          }
          setState(() {});
        },
        itemBuilder: (BuildContext bc) {
          List<PopupMenuItem> items = [
            PopupMenuItem(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Unit".tr),
                  const SizedBox(
                    width: 20,
                  ),
                  Obx(
                    () => Switch(
                      activeColor: primaryColor,
                      value: controller.showUnit.value,
                      onChanged: (value) {
                        controller.showUnit.value = value;
                        Get.find<SharedPreferences>().remove('showUnit');
                        Get.find<SharedPreferences>()
                            .setBool('showUnit', value);
                        setState(() {});
                      },
                    ),
                  )
                ],
              ),
            ),
            PopupMenuItem(
              onTap: () {
                showDialogNote(
                  context: context,
                  formKey: formKey,
                  noteOrderController: noteOrderController,
                  addUpdateNote: () {
                    if (formKey.currentState!.validate()) {
                      noteOrder = noteOrderController.text;
                      Get.back();
                      noteOrderController.clear();
                      setState(() {});
                    }
                  },
                  note: null,
                );
              },
              child: Text("Add Note".tr),
            ),
          ];

          if (controller.type != "TakeAway" && controller.type != "Delivery") {
            items.add(
              PopupMenuItem(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Guests".tr),
                    const SizedBox(
                      width: 20,
                    ),
                    Obx(
                      () => Switch(
                        activeColor: primaryColor,
                        value: controller.enableGuests.value,
                        onChanged: (value) {
                          controller.enableGuests.value = value;
                          Get.find<SharedPreferences>().remove('enableGuests');
                          Get.find<SharedPreferences>()
                              .setBool('enableGuests', value);
                          setState(() {});
                        },
                      ),
                    )
                  ],
                ),
              ),
            );
          }

          if (controller.type != "TakeAway" && controller.type != "Delivery") {
            items.add(PopupMenuItem(
              child: Text("Change Table".tr),
              onTap: () {
                var cont =Get.find<UserController>();
                bool result = cont.isPermission(cont.permission.value.tableChange, context);
                if(!result){
                  return;
                }
                controller.allChange.value =
                    controller.selected1.value == 100 ? true : false;
                controller.guestChange.value = false;
                controller.singleChange.value =
                    controller.selected1.value != 100 ? true : false;
                showAnimatedDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        alignment: Alignment.center,
                        actionsPadding: const EdgeInsets.all(20),
                        title: Column(
                          children: [
                            const Text(
                              'Change Table',
                              style: TextStyle(fontSize: 25),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Obx(
                              () => Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    MaterialButton(
                                      onPressed: () {
                                        controller.allChange.value = true;
                                        controller.guestChange.value = false;
                                        controller.singleChange.value = false;
                                      },
                                      color: controller.allChange.value
                                          ? primaryColor
                                          : Colors.grey,
                                      child: const Text(
                                        'All',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    MaterialButton(
                                      onPressed: () {
                                        controller.allChange.value = false;
                                        controller.guestChange.value = true;
                                        controller.singleChange.value = false;
                                      },
                                      color: controller.guestChange.value
                                          ? primaryColor
                                          : Colors.grey,
                                      child: const Text(
                                        'Guest',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    MaterialButton(
                                      onPressed: () {
                                        controller.allChange.value = false;
                                        controller.guestChange.value = false;
                                        controller.singleChange.value = true;
                                      },
                                      color: controller.singleChange.value
                                          ? primaryColor
                                          : Colors.grey,
                                      child: const Text(
                                        'Single',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ]),
                            ),
                          ],
                        ),
                        content: SizedBox(
                          width:
                              Get.width > 800 ? Get.width / 3 : Get.width / 2,
                          height:
                              Get.width > 800 ? Get.height / 2 : Get.height / 3,
                          child: Column(
                            children: [
                              Obx(
                                () => controller.guestChange.value
                                    ? CustomDropDownButton(
                                        title: '',
                                        hint: 'Guest',
                                        value: controller.guest.isEmpty
                                            ? null
                                            : controller.guest,
                                        withOutValue: false,
                                        items: controller.listGuest,
                                        onChange: (value) {
                                          controller.guest = value!;
                                        },
                                        width: ScaledDimensions.getScaledWidth(
                                            px: 30),
                                        height:
                                            ScaledDimensions.getScaledHeight(
                                                px: 50))
                                    : const SizedBox(),
                              ),
                              Expanded(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: infoController.halls
                                        .where((p0) => p0.id > 0)
                                        .toList()
                                        .length,
                                    itemBuilder: (context, index) {
                                      return ExpansionTile(
                                          collapsedBackgroundColor:
                                              backgroundColorDropDown
                                                  .withOpacity(0.8),
                                          title: Text(
                                              '${infoController.halls.where((p0) => p0.id > 0).toList()[index].name} / ${infoController.halls.where((p0) => p0.id > 0).toList()[index].id}'),
                                          childrenPadding:
                                              const EdgeInsets.only(
                                                  left: 40, right: 20),
                                          children: infoController.halls
                                              .where((p0) => p0.id > 0)
                                              .toList()[index]
                                              .tables
                                              .map((element) {
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  element.number,
                                                  style: const TextStyle(
                                                      fontSize: 20),
                                                ),
                                                widget.table ==
                                                            element.number &&
                                                        widget.hall ==
                                                            element.hall
                                                    ? const Icon(
                                                        Icons.block,
                                                        color: Colors.red,
                                                      )
                                                    : IconButton(
                                                        onPressed: () async {
                                                          if (controller
                                                                  .singleChange
                                                                  .value &&
                                                              controller
                                                                      .selected1
                                                                      .value ==
                                                                  100) {
                                                            ConstantApp
                                                                .showSnakeBarError(
                                                                    context,
                                                                    'Select Order please !!');
                                                            Get.back();
                                                            return;
                                                          }
                                                          await changeTable(
                                                              element);
                                                          await controller
                                                              .getAllOrders();
                                                          Get.back();
                                                          await controller
                                                              .getOrderForTable(
                                                                  widget.hall,
                                                                  widget.table);
                                                          setState(() {});
                                                        },
                                                        icon: const Icon(
                                                            Icons.move_down),
                                                        color: element.cost != 0
                                                            ? primaryColor
                                                            : Colors.green,
                                                      )
                                              ],
                                            );
                                          }).toList());
                                    }),
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          CustomAppButton(
                              height: ScaledDimensions.getScaledHeight(px: 40),
                              width: ScaledDimensions.getScaledWidth(px: 40),
                              onPressed: () async {
                                Get.back();
                              },
                              title: 'Cancel'.tr,
                              backgroundColor: Colors.red,
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
            ));
          }

          return items;
        });
  }

  Future sendFunction() async {
    if (controller.tempOrder.isEmpty) {
      ConstantApp.showSnakeBarError(context, 'Please , Add Some Products !!');
      return;
    }
    bool isActive =
        await Get.find<UserController>().checkUser(context: context);
    if (isActive) {
      return;
    }
    await controller.sendOrder();
    await controller.getAllOrders();
    await controller.getOrderForTable(widget.hall, widget.table);
    controller.tempOrder.clear();
  }

  void printBillFunction() async {
    if (controller.orders.isEmpty) {
      ConstantApp.showSnakeBarError(context,
          'Select Sum Items And Press Send After That You Can Request The Bill !!');
      return;
    } else if (controller.orders.isNotEmpty &&
        controller.tempOrder.isNotEmpty) {
      ConstantApp.showSnakeBarError(context, 'Press Send Please !!');
      return;
    }
    bool isActive =
        await Get.find<UserController>().checkUser(context: context);
    if (isActive) {
      return;
    }
    await Get.find<UserController>().getDriver();
    String message = '';
    if (controller.type == 'Delivery') {
      if (!mounted) return;
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: GetBuilder<UserController>(builder: (controllerUser) {
                return CustomDropDownButtonDriver(
                  title: '',
                  hint: 'Select Driver'.tr,
                  value: controller.selectDriver.value == 0
                      ? null
                      : controller.selectDriver.value,
                  items: controllerUser.drivers,
                  onChange: (val) {
                    controller.selectDriver.value = val!;
                  },
                  width: MediaQuery.of(context).size.width / 6,
                  height: MediaQuery.of(context).size.height / 10,
                  textEditingController: textEditingController1,
                );
              }),
              actions: [
                TextButton(
                    onPressed: () async {
                      Get.back();
                    },
                    child: Text(
                      'Close'.tr,
                      style: TextStyle(color: errorColor),
                    )),
                TextButton(
                    onPressed: () async {
                      Get.back();
                      message = await controller.billRequest(
                          address: addressCustomer,
                          customerNo: customerNumber ?? '',
                          hall: widget.hall,
                          table: widget.table,
                          total: controller.totalPrice.value,
                          driver: controller.selectDriver.value);
                    },
                    child: Text('Next'.tr)),
              ],
            );
          });
    } else {
      message = await controller.billRequest(
          address: addressCustomer,
          customerNo: customerNumber ?? '',
          hall: widget.hall,
          table: widget.table,
          total: controller.totalPrice.value,
          driver: 0);
    }
    if (message == 'Success') {
      if (!mounted) return;
      ConstantApp.showSnakeBarSuccess(context, 'Bill Requested !!');
    } else if (message == 'Error') {
      if (!mounted) return;
      ConstantApp.showSnakeBarError(context, 'Some Thing Wrong !! ');
    } else if (message == 'printer error') {
      if (!mounted) return;
      ConstantApp.showSnakeBarSuccess(context, 'Bill Requested !!');
      Future.delayed(const Duration(milliseconds: 500), () {
        ConstantApp.showSnakeBarError(context, 'Add Printer From Setting !!');
      });
    }
  }

  voidFun() async {
    if (controller.selected1.value == 100) {
      return;
    }
    var cont =Get.find<UserController>();
    bool result = cont.isPermission(cont.permission.value.voidPer, context);
    if(!result){
      return;
    }
    bool isActive =
        await Get.find<UserController>().checkUser(context: context);
    if (isActive) {
      return;
    }
    double qtyVoid = controller.orderTemp.quantity;
    controller.voidReason.value = '';
    controller.voidReason.value = 'By Mistake';
    controller.byMistake.value = false;
    controller.cold.value = false;
    controller.changeHisMind.value = false;
    controller.delay.value = false;
    controller.notLike.value = false;
    var x = controller.order
        .where((p0) =>
            p0.hall == controller.orderTemp.hall &&
            p0.table == controller.orderTemp.table)
        .toList();
    for (var i in x) {
      if (i.itemId == controller.orderTemp.itemId &&
          i.serial == controller.orderTemp.serial) {
        qtyVoid += i.quantity;
      } else {}
    }
    qtyVoid -= controller.orderTemp.quantity;
    quantityVoidController.text = qtyVoid.toString();
    if (!mounted) {
      return;
    }
    if (qtyVoid <= 0) {
      ConstantApp.showSnakeBarError(context, 'The Quantity is Zero !!');
      return;
    }

    Get.dialog(
        Center(
          child: SizedBox(
            width: Get.width > 800
                ? ConstantApp.getWidth(context) / 2
                : ConstantApp.getWidth(context) / 1.3,
            child: Material(
              borderRadius: BorderRadius.circular(20),
              child: Obx(
                () {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: CustomAppButton(
                                  onPressed: () {
                                    controller.voidReason.value = '';
                                    controller.voidReason.value = 'By Mistake';
                                    controller.byMistake.value = true;
                                    controller.cold.value = false;
                                    controller.changeHisMind.value = false;
                                    controller.delay.value = false;
                                    controller.notLike.value = false;
                                  },
                                  title: 'BY MISTAKE'.tr,
                                  backgroundColor: controller.byMistake.value
                                      ? Colors.black38
                                      : Colors.white,
                                  textColor: Colors.black,
                                  height:
                                      ScaledDimensions.getScaledHeight(px: 80),
                                  width:
                                      ScaledDimensions.getScaledWidth(px: 60),
                                  withPadding: false,
                                ),
                              ),
                              Expanded(
                                child: CustomAppButton(
                                  onPressed: () {
                                    controller.voidReason.value = '';
                                    controller.voidReason.value =
                                        'Change His Mind';
                                    controller.byMistake.value = false;
                                    controller.cold.value = false;
                                    controller.changeHisMind.value = true;
                                    controller.delay.value = false;
                                    controller.notLike.value = false;
                                  },
                                  title: 'CHANGE'.tr,
                                  backgroundColor:
                                      controller.changeHisMind.value
                                          ? Colors.black38
                                          : Colors.white,
                                  textColor: Colors.black,
                                  height:
                                      ScaledDimensions.getScaledHeight(px: 80),
                                  width:
                                      ScaledDimensions.getScaledWidth(px: 60),
                                  withPadding: false,
                                ),
                              ),
                              Expanded(
                                child: CustomAppButton(
                                  onPressed: () {
                                    controller.voidReason.value = '';
                                    controller.voidReason.value = 'COLD';
                                    controller.byMistake.value = false;
                                    controller.cold.value = true;
                                    controller.changeHisMind.value = false;
                                    controller.delay.value = false;
                                    controller.notLike.value = false;
                                  },
                                  title: 'COLD'.tr,
                                  backgroundColor: controller.cold.value
                                      ? Colors.black38
                                      : Colors.white,
                                  textColor: Colors.black,
                                  height:
                                      ScaledDimensions.getScaledHeight(px: 80),
                                  width:
                                      ScaledDimensions.getScaledWidth(px: 60),
                                  withPadding: false,
                                ),
                              ),
                              Expanded(
                                child: CustomAppButton(
                                  onPressed: () {
                                    controller.voidReason.value = '';
                                    controller.voidReason.value = 'DELAY';
                                    controller.byMistake.value = false;
                                    controller.cold.value = false;
                                    controller.changeHisMind.value = false;
                                    controller.delay.value = true;
                                    controller.notLike.value = false;
                                  },
                                  title: 'DELAY'.tr,
                                  backgroundColor: controller.delay.value
                                      ? Colors.black38
                                      : Colors.white,
                                  textColor: Colors.black,
                                  height:
                                      ScaledDimensions.getScaledHeight(px: 80),
                                  width:
                                      ScaledDimensions.getScaledWidth(px: 60),
                                  withPadding: false,
                                ),
                              ),
                              Expanded(
                                child: CustomAppButton(
                                  onPressed: () {
                                    controller.voidReason.value = '';
                                    controller.voidReason.value =
                                        'DID NOT LIKE THE FOOD';
                                    controller.byMistake.value = false;
                                    controller.cold.value = false;
                                    controller.changeHisMind.value = false;
                                    controller.delay.value = false;
                                    controller.notLike.value = true;
                                  },
                                  title: 'NOT LIKE'.tr,
                                  backgroundColor: controller.notLike.value
                                      ? Colors.black38
                                      : Colors.white,
                                  textColor: Colors.black,
                                  height:
                                      ScaledDimensions.getScaledHeight(px: 80),
                                  width:
                                      ScaledDimensions.getScaledWidth(px: 60),
                                  withPadding: false,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                controller: quantityVoidController,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'(^\d*\.?\d*)'))
                                ],
                                keyboardType: TextInputType.number,
                                onChanged: (val) {
                                  if (val.isNotEmpty) {
                                    if (double.parse(val) >
                                        controller.orderTemp.quantity) {
                                      quantityVoidController.text = controller
                                          .orderTemp.quantity
                                          .toStringAsFixed(1);
                                    }
                                  }
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Can't Be Empty !!";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: 'QTY'.tr,
                                  icon: const Icon(Icons.numbers),
                                ),
                              ),
                            ),
                            Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          if ((double.tryParse(
                                                      quantityVoidController
                                                          .text) ??
                                                  1) >=
                                              controller.orderTemp.quantity) {
                                            ConstantApp.showSnakeBarError(
                                                context,
                                                'It cannot be increased more !!');
                                            return;
                                          } else {
                                            quantityVoidController
                                                .text = ((double.tryParse(
                                                            quantityVoidController
                                                                .text) ??
                                                        1) +
                                                    1)
                                                .toString();
                                          }
                                          setState(() {});
                                        },
                                        icon: const Icon(Icons.add)),
                                    IconButton(
                                        onPressed: () {
                                          if ((double.tryParse(
                                                      quantityVoidController
                                                          .text) ??
                                                  1) <=
                                              1) {
                                            ConstantApp.showSnakeBarError(
                                                context,
                                                'It cannot be Decreased more !!');
                                            return;
                                          } else {
                                            quantityVoidController
                                                .text = ((double.tryParse(
                                                            quantityVoidController
                                                                .text) ??
                                                        1) -
                                                    1)
                                                .toString();
                                          }
                                          setState(() {});
                                        },
                                        icon: const Icon(Icons.remove))
                                  ],
                                )),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.resolveWith(
                                                (states) => errorColor)),
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: Text(
                                      'Cancel'.tr,
                                      style: const TextStyle(fontSize: 25),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (qtyVoid == 0) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                              'Can\'t be Void !! QTY most be bigger than zero !'
                                                  .tr),
                                          backgroundColor: Colors.red,
                                        ));
                                        return;
                                      }

                                      await controller.voidOrder(
                                          order: controller.orderTemp,
                                          reason: controller.voidReason.value,
                                          qty1: (double.tryParse(
                                                  quantityVoidController
                                                      .text) ??
                                              0.0));
                                      await controller.getAllOrders();
                                      await controller.getOrderForTable(
                                          widget.hall, widget.table);
                                      Get.back();
                                      setState(() {});
                                    },
                                    child: Text(
                                      'Void'.tr,
                                      style: const TextStyle(
                                        fontSize: 25,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        barrierColor: Colors.transparent.withOpacity(0.5));
  }

  void showDialogNote1(String? note) {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        if (note != null) {
          noteOrderController.text = note;
        }
        return SimpleDialog(
          backgroundColor: Colors.white,
          alignment: Alignment.center,
          titleTextStyle: ConstantApp.getTextStyle(context: context, size: 15),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SizedBox(
                    child: TextFormField(
                      controller: noteOrderController,
                      decoration: InputDecoration(
                        labelText: "Note Order".tr,
                        icon: const Icon(FontAwesomeIcons.noteSticky),
                      ),
                    ),
                  ),
                ),
                TextButton(
                    onPressed: () {
                      noteOrder = noteOrderController.text;
                      Get.back();
                      noteOrderController.clear();
                      setState(() {});
                    },
                    child: note == null
                        ? Text("Add Note".tr)
                        : Text("Update Note".tr)),
              ],
            ),
          ],
        );
      },
      barrierDismissible: true,
      animationType: DialogTransitionType.sizeFade,
      curve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 400),
    );
  }

  void dialogAddress(
      {required List<String?> address,
      required int id,
      required List<String?> mobilNumber,
      required String name}) {
    String addressDialog = addressCustomer;
    String mobileNumberDialog = customerNumber.toString();

    showAnimatedDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          backgroundColor: Colors.white,
          title: Center(
              child: Text(
            "Chose Address and Mobil Number".tr,
            style: ConstantApp.getTextStyle(
                context: context, fontWeight: FontWeight.bold, size: 12),
          )),
          alignment: Alignment.center,
          titleTextStyle: ConstantApp.getTextStyle(context: context, size: 15),
          children: [
            const SizedBox(
              height: 10,
            ),
            StatefulBuilder(
              builder: (BuildContext context,
                  void Function(void Function()) setState1) {
                return Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Address".tr,
                                style: ConstantApp.getTextStyle(
                                  context: context,
                                  color: secondaryColor,
                                  fontWeight: FontWeight.bold,
                                ).copyWith(
                                    decoration: TextDecoration.underline),
                              ),
                              IconButton(
                                  onPressed: () {
                                    Get.back();
                                    dialogAddNewAddress(address, id);
                                  },
                                  icon: const Icon(Icons.add)),
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Divider(
                              thickness: 4,
                              color: primaryColor,
                            ),
                          ),
                          SizedBox(
                            height: ConstantApp.getHeight(context) * 0.3,
                            width: ConstantApp.getWidth(context) * 0.2,
                            child: ListView.separated(
                              // shrinkWrap: true,
                              // physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Center(
                                  child: address[index] == ""
                                      ? SizedBox(
                                          child: Center(
                                              child: Text(
                                            "There is no address to add".tr,
                                            style: ConstantApp.getTextStyle(
                                                context: context,
                                                color: secondaryColor),
                                          )),
                                        )
                                      : CheckboxListTile(
                                          title: Text(
                                            address[index] ?? "",
                                            style: ConstantApp.getTextStyle(
                                                context: context,
                                                color: textColor),
                                            textAlign: TextAlign.center,
                                          ),
                                          activeColor: primaryColor,
                                          value:
                                              addressDialog == address[index],
                                          onChanged: (bool? value) {
                                            setState1(() {
                                              if (value != null && value) {
                                                addressDialog =
                                                    address[index].toString();
                                              } else {
                                                addressDialog = "";
                                              }
                                            });
                                          },
                                        ),
                                  //     InkWell(
                                  //   onTap: () {
                                  //     Get.back();
                                  //     addressCustomer = address[index] ?? "";
                                  //     setState(() {});
                                  //   },
                                  //   child: Text(
                                  //     address[index] ?? "",
                                  //     style: ConstantApp.getTextStyle(
                                  //         context: context, color: secondaryColor),
                                  //   ),
                                  // )
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const SizedBox(
                                  height: 10,
                                );
                              },
                              itemCount: address.length,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Mobile Number".tr,
                                  style: ConstantApp.getTextStyle(
                                    context: context,
                                    color: secondaryColor,
                                    fontWeight: FontWeight.bold,
                                  ).copyWith(
                                      decoration: TextDecoration.underline)),
                              IconButton(
                                  onPressed: () {
                                    Get.back();
                                    dialogAddNewMobile(mobilNumber, id);
                                  },
                                  icon: const Icon(Icons.add)),
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Divider(
                              thickness: 4,
                              color: primaryColor,
                            ),
                          ),
                          SizedBox(
                            height: ConstantApp.getHeight(context) * 0.3,
                            width: ConstantApp.getWidth(context) * 0.2,
                            child: ListView.separated(
                              // shrinkWrap: true,
                              // physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Center(
                                  child: mobilNumber[index] == ""
                                      ? const SizedBox()
                                      : CheckboxListTile(
                                          title: Text(
                                            mobilNumber[index] ?? "",
                                            style: ConstantApp.getTextStyle(
                                                context: context,
                                                color: textColor),
                                            textAlign: TextAlign.center,
                                          ),
                                          activeColor: primaryColor,
                                          value: mobileNumberDialog ==
                                              mobilNumber[index],
                                          onChanged: (bool? value) {
                                            setState1(() {
                                              if (value != null && value) {
                                                mobileNumberDialog =
                                                    mobilNumber[index]
                                                        .toString();
                                              } else {
                                                mobileNumberDialog = "";
                                              }
                                            });
                                          },
                                        ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const SizedBox(
                                  height: 10,
                                );
                              },
                              itemCount: mobilNumber.length,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            CustomAppButton(
                height: ScaledDimensions.getScaledHeight(px: 30),
                width: ScaledDimensions.getScaledWidth(px: 50),
                onPressed: () async {
                  if (addressDialog == "" || mobileNumberDialog == "") {
                    ConstantApp.showSnakeBarError(
                        context, "Chose Address and Mobil Number".tr);
                  } else {
                    setState(() {
                      addressCustomer = addressDialog;
                      customerNumber = mobileNumberDialog;
                    });
                    Get.back();
                  }
                },
                title: 'Add'.tr,
                backgroundColor: secondaryColor,
                textColor: Colors.white,
                withPadding: false),
          ],
        );
      },
      barrierDismissible: true,
      animationType: DialogTransitionType.sizeFade,
      curve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 400),
    );
  }

  void dialogAddNewAddress(List<String?> address, int id) {
    newAddressController.clear();
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          backgroundColor: Colors.white,
          title: Center(child: Text("New Address".tr)),
          alignment: Alignment.center,
          titleTextStyle: ConstantApp.getTextStyle(context: context, size: 15),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SizedBox(
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: newAddressController,
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return 'Can Not Be Empty !!';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'New Address'.tr,
                        icon: const Icon(Icons.location_on_outlined),
                      ),
                    ),
                  ),
                ),
                TextButton(
                    onPressed: () async {
                      if (newAddressController.text.trim().isEmpty) {
                        return;
                      }
                      final message = await controller.addNewAddressMobile(
                          id: id,
                          address: newAddressController.text,
                          mobile: '');
                      if (!context.mounted) return;
                      if (message == 'Success') {
                        ConstantApp.showSnakeBarSuccess(
                            context, 'Add New Address !!');
                      } else {
                        ConstantApp.showSnakeBarError(
                            context, 'Some Thing Wrong !!');
                      }
                      Get.back();
                    },
                    child: Text("Add Address".tr)),
              ],
            ),
          ],
        );
      },
      barrierDismissible: true,
      animationType: DialogTransitionType.sizeFade,
      curve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 400),
    );
  }

  void dialogAddNewMobile(List<String?> mobile, int id) {
    newMobileController.clear();
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          backgroundColor: Colors.white,
          title: Center(child: Text("New Mobile Number".tr)),
          alignment: Alignment.center,
          titleTextStyle: ConstantApp.getTextStyle(context: context, size: 15),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SizedBox(
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: newMobileController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return 'Can Not Be Empty !!';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'New Mobile Number'.tr,
                        icon: const Icon(FontAwesomeIcons.mobile),
                      ),
                    ),
                  ),
                ),
                TextButton(
                    onPressed: () async {
                      final message = await controller.addNewAddressMobile(
                          id: id,
                          address: '',
                          mobile: newMobileController.text);
                      if (!context.mounted) return;
                      if (message == 'Success') {
                        ConstantApp.showSnakeBarSuccess(
                            context, 'Add New Mobile Number !!');
                      } else {
                        ConstantApp.showSnakeBarError(
                            context, 'Some Thing Wrong !!');
                      }
                      Get.back();
                    },
                    child: Text("Add".tr)),
              ],
            ),
          ],
        );
      },
      barrierDismissible: true,
      animationType: DialogTransitionType.sizeFade,
      curve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 400),
    );
  }

  void initTableName() {
    if (widget.hall == "-1") {
      hallName = "TakeAway - ${widget.table}";
      controller.type = "TakeAway";
    } else if (widget.hall == "0") {
      hallName = "Delivery - ${widget.table}";
      controller.type = "Delivery";
    } else if (widget.hall == "-2") {
      hallName = "Sales";
      controller.type = "Sales";
    } else {
      hallName =
          "Hall ${Get.find<InfoController>().halls.firstWhere((element) => element.id.toString() == widget.hall).name} - ${widget.table}";
      controller.type = "Table";
    }
  }

  changeTable(TableModel element) async {
    bool isActive =
        await Get.find<UserController>().checkUser(context: context);
    if (isActive) {
      return;
    }
    DioClient dio = DioClient();
    var data = {
      "hall": element.hall,
      "table": element.number,
      "oldTable": widget.table,
      "oldHall": widget.hall,
      "guest": controller.guest,
      "all": controller.allChange.value.toString(),
      "guestCh": controller.guestChange.value.toString(),
      "single": controller.singleChange.value.toString(),
      "orderId":
          (controller.singleChange.value ? (controller.orderTemp.id ?? 0) : 0)
              .toString(),
      "orderPrice": controller.singleChange.value
          ? controller.orderTemp.price.toString()
          : '0',
      "orderQuantity": controller.singleChange.value
          ? controller.orderTemp.quantity.toString()
          : '0',
    };
    final response = await dio.postDio(path: '/change-table', data1: data);
    if (response.statusCode == 200) {
      debugPrint(response.data["message"]);
    }
  }

  addButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Row(
          children: [
            productItemsWidget(),
            supCategoryWidget(),
            mainCategoryWidget()
          ],
        ),
      ),
    );
  }

  void discountFunction() async {
    if (controller.orders.isEmpty) {
      ConstantApp.showSnakeBarError(context,
          'Can Not Add Discount , Add Some Products And click Send Button then Discount Button !!');
      return;
    }
    if (discount == 0) {
      ConstantApp.showSnakeBarError(
          context, 'Can Not Add Discount , No Permission !!');
      return;
    }
    var cont =Get.find<UserController>();
    bool result = cont.isPermission(cont.permission.value.discount, context);
    if(!result){
      return;
    }
    bool isActive =
        await Get.find<UserController>().checkUser(context: context);
    if (isActive) {
      return;
    }
    limitDiscount = (discount * controller.totalPrice.value) / 100;
    Get.dialog(
        Center(
          child: SizedBox(
            height: ScaledDimensions.getScaledHeight(
              px: 300,
            ),
            width: ScaledDimensions.getScaledWidth(px: 150),
            child: Material(
              borderRadius: BorderRadius.circular(9),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      discount / 100 >= 0.05
                          ? Expanded(
                              child: CustomAppButton(
                                onPressed: () {
                                  controller.discountType.value = '%';
                                  controller.discountValue!.text = '5';
                                },
                                title: '5%',
                                backgroundColor: Colors.white,
                                textColor: primaryColor,
                                height:
                                    ScaledDimensions.getScaledHeight(px: 50),
                                width: ScaledDimensions.getScaledWidth(px: 60),
                                withPadding: false,
                              ),
                            )
                          : const SizedBox(),
                      discount / 100 >= 0.1
                          ? Expanded(
                              child: CustomAppButton(
                                onPressed: () {
                                  controller.discountType.value = '%';
                                  controller.discountValue!.text = '10';
                                },
                                title: '10%',
                                backgroundColor: Colors.white,
                                textColor: primaryColor,
                                height:
                                    ScaledDimensions.getScaledHeight(px: 50),
                                width: ScaledDimensions.getScaledWidth(px: 60),
                                withPadding: false,
                              ),
                            )
                          : const SizedBox(),
                      discount / 100 >= 0.2
                          ? Expanded(
                              child: CustomAppButton(
                                onPressed: () {
                                  controller.discountType.value = '%';
                                  controller.discountValue!.text = '20';
                                },
                                title: '20%',
                                backgroundColor: Colors.white,
                                textColor: primaryColor,
                                height:
                                    ScaledDimensions.getScaledHeight(px: 50),
                                width: ScaledDimensions.getScaledWidth(px: 60),
                                withPadding: false,
                              ),
                            )
                          : const SizedBox(),
                      discount / 100 >= 0.25
                          ? Expanded(
                              child: CustomAppButton(
                                onPressed: () {
                                  controller.discountType.value = '%';
                                  controller.discountValue!.text = '25';
                                },
                                title: '25%',
                                backgroundColor: Colors.white,
                                textColor: primaryColor,
                                height:
                                    ScaledDimensions.getScaledHeight(px: 50),
                                width: ScaledDimensions.getScaledWidth(px: 60),
                                withPadding: false,
                              ),
                            )
                          : const SizedBox(),
                      discount / 100 >= 0.5
                          ? Expanded(
                              child: CustomAppButton(
                                onPressed: () {
                                  controller.discountType.value = '%';
                                  controller.discountValue!.text = '50';
                                },
                                title: '50%',
                                backgroundColor: Colors.white,
                                textColor: primaryColor,
                                height:
                                    ScaledDimensions.getScaledHeight(px: 50),
                                width: ScaledDimensions.getScaledWidth(px: 60),
                                withPadding: false,
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: CustomDropDownButton(
                              title: 'Select type'.tr,
                              hint: '%',
                              items: listDis,
                              value: controller.discountType.value,
                              withOutValue: true,
                              onChange: (value) {
                                if (value != null) {
                                  controller.discountType.value = value;
                                }
                              },
                              width: ScaledDimensions.getScaledWidth(px: 40),
                              height: ScaledDimensions.getScaledHeight(px: 40)),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Form(
                            key: formKey1,
                            child: CustomTextFormField(
                              textEditingController: controller.discountValue!,
                              focusNode: discountValueNode,
                              isNum: true,
                              hint: 'Enter Dis Value'.tr,
                              onSaved: (value) {},
                              onChange: (value) {},
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter Dis Value'.tr;
                                }
                                if (controller.discountType.value == "%" &&
                                    discount <
                                        (double.tryParse(controller
                                                .discountValue!.text) ??
                                            0.0)) {
                                  return 'The discount cannot exceed $discount';
                                }
                                if ((controller.discountType.value
                                                .toLowerCase() ==
                                            "value" ||
                                        controller.discountType.value
                                            .toLowerCase()
                                            .contains('fixed')) &&
                                    limitDiscount <
                                        double.parse(
                                            controller.discountValue!.text)) {
                                  return 'The discount cannot exceed $limitDiscount';
                                }
                                return null;
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomAppButton(
                        onPressed: () async {
                          controller.discountValue!.clear();
                          controller.discountType.value = '%';
                          await controller.saveDiscount();
                          setState(() {});
                          Get.back();
                        },
                        title: 'Remove'.tr,
                        backgroundColor: errorColor,
                        textColor: Colors.white,
                        height: ScaledDimensions.getScaledHeight(px: 50),
                        width: ScaledDimensions.getScaledWidth(px: 60),
                        withPadding: false,
                      ),
                      CustomAppButton(
                        onPressed: () {
                          if (formKey1.currentState!.validate()) {
                            show = true;

                              if (controller.discountType.value == "%" &&
                                  discount >=
                                      (double.tryParse(
                                              controller.discountValue!.text) ??
                                          0.0)) {
                                controller.saveDiscount();
                                setState(() {});
                                Get.back();
                              } else if ((controller.discountType.value
                                              .toLowerCase() ==
                                          "value" ||
                                      controller.discountType.value
                                          .toLowerCase()
                                          .contains('fixed')) &&
                                  limitDiscount >=
                                      double.parse(
                                          controller.discountValue!.text)) {
                                controller.saveDiscount();
                                setState(() {});
                                Get.back();

                            } else {
                              ConstantApp.showSnakeBarError(
                                  context, 'No Permission !!'.tr);
                              Get.back();
                              controller.obscure(true);
                              Get.dialog(Center(
                                child: SizedBox(
                                  width: ConstantApp.getWidth(context) / 3,
                                  child: AlertDialog(
                                    title: SingleChildScrollView(
                                        child: Column(
                                      children: [
                                        CustomDropDownButtonUsers(
                                          value: userId == 0 ? null : userId,
                                          title: '',
                                          hint: 'Users'.tr,
                                          items: Get.find<UserController>()
                                              .users
                                              .where(
                                                  (p0) => p0.isActive == true)
                                              .toList(),
                                          onChange: (value) {
                                            userId = value!;
                                          },
                                          width: ConstantApp.getWidth(context) /
                                              3.5,
                                          height: 50,
                                          textEditingController:
                                              textEditingController,
                                        ),
                                        Obx(
                                          () => Container(
                                            color:
                                                Colors.white.withOpacity(0.7),
                                            height: ScaledDimensions
                                                .getScaledHeight(px: 60),
                                            width:
                                                ConstantApp.getWidth(context) /
                                                    3.5,
                                            child: TextFormField(
                                              onFieldSubmitted: (value) async {
                                                if (userId == 0) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                    content: Text(
                                                        'Pleas chose user'.tr),
                                                    backgroundColor: Colors.red,
                                                  ));
                                                  return;
                                                }
                                                String passwordU = '';
                                                var x =
                                                    Get.find<UserController>()
                                                        .users;
                                                if (x.isNotEmpty) {
                                                  for (var i in x) {
                                                    if (i.id == userId) {
                                                      passwordU = i.password;
                                                    }
                                                  }
                                                  if (passwordU ==
                                                      password.text) {
                                                    Get.back();
                                                  } else {
                                                    if (!mounted) {
                                                      return;
                                                    }
                                                    ConstantApp
                                                        .showSnakeBarError(
                                                      context,
                                                      'Invalid username or password.. !!'
                                                          .tr,
                                                    );
                                                  }
                                                }
                                              },
                                              controller: password,
                                              obscureText:
                                                  controller.obscure.value,
                                              autofocus: true,
                                              cursorColor:
                                                  const Color(0xffee680e),
                                              decoration: InputDecoration(
                                                  border:
                                                      const OutlineInputBorder(),
                                                  hintText: 'PIN'.tr,
                                                  focusColor:
                                                      const Color(0xffee680e),
                                                  focusedBorder:
                                                      const OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Color(
                                                                  0xffee680e))),
                                                  suffixIcon: controller
                                                          .obscure.value
                                                      ? IconButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              controller.obscure
                                                                      .value =
                                                                  !controller
                                                                      .obscure
                                                                      .value;
                                                            });
                                                          },
                                                          icon: const Icon(
                                                              Icons.visibility,
                                                              color:
                                                                  Colors.black),
                                                          tooltip:
                                                              'Show Password'
                                                                  .tr,
                                                        )
                                                      : IconButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              controller.obscure
                                                                      .value =
                                                                  !controller
                                                                      .obscure
                                                                      .value;
                                                            });
                                                          },
                                                          icon: const Icon(
                                                              Icons
                                                                  .visibility_off,
                                                              color:
                                                                  Colors.black),
                                                          tooltip:
                                                              'Hide Password'
                                                                  .tr,
                                                        )),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                                    actions: [
                                      MaterialButton(
                                        color: Colors.red,
                                        onPressed: () {
                                          Get.back();
                                          return;
                                        },
                                        child: const Text(
                                          'Cancel',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                      MaterialButton(
                                        color: primaryColor,
                                        onPressed: () async {
                                          String passwordU = '';
                                          var x =
                                              Get.find<UserController>().users;
                                          if (x.isNotEmpty) {
                                            for (var i in x) {
                                              if (i.id == userId) {
                                                passwordU = i.password;
                                              }
                                            }
                                            if (passwordU == password.text) {
                                              Get.back();
                                              if (controller
                                                          .discountType.value ==
                                                      "%" &&
                                                  discount >=
                                                      (double.tryParse(controller
                                                              .discountValue!
                                                              .text) ??
                                                          0.0)) {
                                                controller.saveDiscount();
                                                setState(() {});
                                                Get.back();
                                              } else if ((controller
                                                              .discountType
                                                              .value
                                                              .toLowerCase() ==
                                                          "value" ||
                                                      controller
                                                          .discountType.value
                                                          .toLowerCase()
                                                          .contains('fixed')) &&
                                                  limitDiscount >=
                                                      double.parse(controller
                                                          .discountValue!
                                                          .text)) {
                                                controller.saveDiscount();
                                                setState(() {});
                                                Get.back();
                                              }
                                            } else {
                                              if (!mounted) {
                                                return;
                                              }
                                              ConstantApp.showSnakeBarError(
                                                context,
                                                'Invalid username or password.. !!'
                                                    .tr,
                                              );
                                            }
                                          }
                                        },
                                        child: const Text(
                                          'Accept',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ));
                            }
                          }
                        },
                        title: 'Save'.tr,
                        backgroundColor: secondaryColor,
                        textColor: Colors.white,
                        height: ScaledDimensions.getScaledHeight(px: 50),
                        width: ScaledDimensions.getScaledWidth(px: 60),
                        withPadding: false,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        barrierColor: Colors.transparent.withOpacity(0.5));
  }

  void saveFunction() async {
    bool isActive =
        await Get.find<UserController>().checkUser(context: context);
    if (isActive) {
      return;
    }
    visaTextEditing.clear();
    returnTextEditing.clear();
    tipsTextEditing.clear();
    cashTextEditing.clear();
    cashTextEditing.text = controller.fTotal.value.toStringAsFixed(2);
    visaTextEditing.text = '0';
    returnTextEditing.text = '0';
    tipsTextEditing.text = '0';
    controller.cash.value = true;
    controller.visa.value = false;
    controller.cashVisa.value = false;
    temp = cashTextEditing;
    getDetails();
    if (!mounted) {
      return;
    }
    if (controller.orders.isEmpty && controller.tempOrder.isNotEmpty) {
      ConstantApp.showSnakeBarError(
          context, 'Press Save Changes After That You Can Save Bill !!'.tr);
      return;
    }
    if (controller.orders.isEmpty && controller.tempOrder.isEmpty) {
      ConstantApp.showSnakeBarError(context,
          'Select Sum Items And Press Send After That You Can Request The Bill !!');
      return;
    }
    if (controller.tempOrder.isNotEmpty && ConstantApp.appType.name == 'REST') {
      ConstantApp.showSnakeBarInfo(
          context, 'Press Send After That You Can Save Bill !!'.tr);
      return;
    }
    if (controller.tempOrder.isNotEmpty && ConstantApp.appType.name != 'REST') {
      if (!mounted) {
        return;
      }
      ConstantApp.showSnakeBarInfo(
          context, 'Press Save Changes After That You Can Save Bill !!'.tr);
      return;
    }
    try {
      showDialogSave();
    } catch (e) {
      return;
    }
  }

  void saveFunctionReturn() async {
    if (controller.tempOrder.isEmpty && controller.orders.isEmpty) {
      return;
    } else if (controller.tempOrder.isNotEmpty &&
        controller.orders.isNotEmpty) {
      ConstantApp.showSnakeBarError(
          context, 'Please click Save Changes .. !!'.tr);
      return;
    }
    visaTextEditing.clear();
    returnTextEditing.clear();
    tipsTextEditing.clear();
    cashTextEditing.clear();
    cashTextEditing.text = controller.fTotal.value.toStringAsFixed(2);
    visaTextEditing.text = '0';
    returnTextEditing.text = '0';
    tipsTextEditing.text = '0';
    controller.cash.value = true;
    controller.visa.value = false;
    controller.cashVisa.value = false;
    temp = cashTextEditing;
    try {
      if (Get.find<SharedPreferences>().getString('type') == "Captain" ||
          Get.find<SharedPreferences>().getString('type') == "User") {
        if (!context.mounted) return;
        ConstantApp.showSnakeBarError(context, 'No Permission !!'.tr);
      } else {
        showDialogSave();
      }
    } catch (e) {
      return;
    }
  }

  getDetails() {
    double cash = double.tryParse(cashTextEditing.text) ?? 0.0;
    double visa = double.tryParse(visaTextEditing.text) ?? 0.0;
    double tips = double.tryParse(tipsTextEditing.text) ?? 0.0;
    returnTextEditing.text =
        ((visa + cash - tips) - controller.fTotal.value).toStringAsFixed(2);
    controller.paid.value = (cash + visa);
    controller.balance.value = ((visa + cash - tips) - controller.fTotal.value);
    setState(() {});
  }

  void showDialogSave() {
    Get.dialog(StatefulBuilder(
      builder:
          (BuildContext context, void Function(void Function()) setState1) {
        return Center(
          child: SizedBox(
            width: ConstantApp.isTab(context)
                ? ScaledDimensions.getScaledWidth(px: 250)
                : ScaledDimensions.getScaledWidth(px: 150),
            child: Material(
              borderRadius: BorderRadius.circular(20),
              child: Obx(
                () {
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${controller.fTotal.value.toStringAsFixed(2)} ${'AED'.tr}',
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  onTap: () {
                                    temp = cashTextEditing;
                                    cashTextEditing.selection = TextSelection(
                                        baseOffset: 0,
                                        extentOffset:
                                            cashTextEditing.value.text.length);
                                    setState1(() {});
                                  },
                                  autofocus: controller.cash.value,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'(^\d*\.?\d*)'))
                                  ],
                                  readOnly: !controller.cash.value,
                                  controller: cashTextEditing,
                                  onChanged: (val) {
                                    tipsTextEditing.text = '0';
                                    getDetails();
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Cash'.tr,
                                    icon: const Icon(Icons.attach_money),
                                    suffixIcon: controller.cashVisa.value
                                        ? IconButton(
                                            onPressed: () {
                                              if (controller.cashVisa.value) {
                                                if (controller.fTotal.value <
                                                    double.parse(
                                                        visaTextEditing.text)) {
                                                  cashTextEditing.text = "0";
                                                  getDetails();
                                                  setState1;
                                                  return;
                                                }
                                                cashTextEditing.text =
                                                    (controller.fTotal.value -
                                                            double.parse(
                                                                visaTextEditing
                                                                    .text))
                                                        .toString();
                                                getDetails();
                                                setState1;
                                              }
                                            },
                                            icon: const Icon(
                                                Icons.compare_arrows))
                                        : const SizedBox(),
                                  ),
                                  validator: (val) {
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: TextFormField(
                                  onTap: () {
                                    temp = visaTextEditing;
                                    visaTextEditing.selection = TextSelection(
                                        baseOffset: 0,
                                        extentOffset:
                                            visaTextEditing.value.text.length);
                                    setState1(() {});
                                  },
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'(^\d*\.?\d*)'))
                                  ],
                                  readOnly: !controller.visa.value,
                                  controller: visaTextEditing,
                                  onChanged: (val) {
                                    tipsTextEditing.text = '0';
                                    getDetails();
                                    setState1(() {});
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Visa'.tr,
                                    icon: const Icon(Icons.credit_card),
                                    suffixIcon: controller.cashVisa.value
                                        ? IconButton(
                                            onPressed: () {
                                              if (controller.cashVisa.value) {
                                                if (controller.fTotal.value <
                                                    double.parse(
                                                        cashTextEditing.text)) {
                                                  visaTextEditing.text = "0";
                                                  getDetails();
                                                  setState1;
                                                  return;
                                                }
                                                visaTextEditing.text =
                                                    (controller.fTotal.value -
                                                            double.parse(
                                                                cashTextEditing
                                                                    .text))
                                                        .toString();
                                                getDetails();
                                                setState1;
                                              }
                                            },
                                            icon: const Icon(
                                                Icons.compare_arrows))
                                        : const SizedBox(),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'(^\d*\.?\d*)'))
                                  ],
                                  readOnly: true,
                                  controller: returnTextEditing,
                                  onChanged: (val) {},
                                  decoration: InputDecoration(
                                    labelText: 'returned'.tr,
                                    icon: const Icon(Icons.money),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  onTap: () {
                                    temp = tipsTextEditing;
                                    tipsTextEditing.selection = TextSelection(
                                        baseOffset: 0,
                                        extentOffset:
                                            tipsTextEditing.value.text.length);
                                    setState1(() {});
                                  },
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'(^\d*\.?\d*)'))
                                  ],
                                  enabled: !controller.cash.value &&
                                          !controller.visa.value
                                      ? false
                                      : true,
                                  controller: tipsTextEditing,
                                  onChanged: (val) {
                                    double cash =
                                        double.tryParse(cashTextEditing.text) ??
                                            0.0;
                                    double visa =
                                        double.tryParse(visaTextEditing.text) ??
                                            0.0;
                                    double tips =
                                        double.tryParse(tipsTextEditing.text) ??
                                            0.0;
                                    if ((double.tryParse(
                                                returnTextEditing.text) ??
                                            0.0) <
                                        0) {
                                      tipsTextEditing.text = '0.0';
                                      return;
                                    }
                                    if (tips >
                                        double.parse(returnTextEditing.text)) {
                                      returnTextEditing.text = '0';
                                      tipsTextEditing.text = ((visa + cash) -
                                              controller.fTotal.value)
                                          .toStringAsFixed(2);
                                      return;
                                    }
                                    if (tips == 0) {
                                      returnTextEditing.text = ((visa + cash) -
                                              controller.fTotal.value)
                                          .toStringAsFixed(2);
                                      return;
                                    }
                                    getDetails();
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Tips'.tr,
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          if (returnTextEditing
                                              .text.isNotEmpty) {
                                            if ((double.tryParse(
                                                        returnTextEditing
                                                            .text) ??
                                                    0.0) >=
                                                0) {
                                              double returned = 0.0;
                                              if (controller.cash.value &&
                                                  !controller.visa.value) {
                                                returned =
                                                    ((controller.fTotal.value -
                                                            double.parse(
                                                                cashTextEditing
                                                                    .text)) *
                                                        -1);
                                              } else if (controller
                                                      .visa.value &&
                                                  !controller.cash.value) {
                                                returned =
                                                    ((controller.fTotal.value -
                                                            double.parse(
                                                                visaTextEditing
                                                                    .text)) *
                                                        -1);
                                              } else if (controller
                                                      .visa.value &&
                                                  controller.cash.value) {
                                                returned = ((controller
                                                            .fTotal.value -
                                                        (double.parse(
                                                                cashTextEditing
                                                                    .text) +
                                                            double.parse(
                                                                visaTextEditing
                                                                    .text))) *
                                                    -1);
                                              } else if (!controller
                                                      .visa.value &&
                                                  !controller.cash.value) {
                                                returned = 0.0;
                                              }
                                              tipsTextEditing.text =
                                                  returned.toStringAsFixed(2);
                                              returnTextEditing.text = '0.0';
                                            }
                                          }
                                        },
                                        icon: const Icon(Icons.compare_arrows)),
                                    icon: const Icon(Icons.monetization_on),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: CustomAppButton(
                                onPressed: () {
                                  setState1(() {
                                    controller.cash.value = true;

                                    controller.visa.value = false;
                                    controller.cashVisa.value = false;
                                    if (controller.cash.value) {
                                      temp = cashTextEditing;
                                    } else if (controller.visa.value) {
                                      temp = visaTextEditing;
                                    }
                                  });
                                  cashTextEditing.clear();
                                  visaTextEditing.clear();
                                  returnTextEditing.clear();
                                  cashTextEditing.text =
                                      controller.fTotal.toStringAsFixed(2);
                                  visaTextEditing.text = '0';
                                  returnTextEditing.text = '0';
                                  tipsTextEditing.text = '0';
                                },
                                title: 'Cash'.tr,
                                backgroundColor: controller.cash.value
                                    ? Colors.black38
                                    : Colors.white,
                                textColor: Colors.black,
                                height:
                                    ScaledDimensions.getScaledHeight(px: 50),
                                width: ScaledDimensions.getScaledWidth(px: 60),
                                withPadding: false,
                              ),
                            ),
                            Expanded(
                              child: CustomAppButton(
                                onPressed: () {
                                  setState1(() {
                                    controller.cash.value = false;
                                    controller.cashVisa.value = false;
                                    controller.visa.value = true;

                                    if (controller.cash.value) {
                                      temp = cashTextEditing;
                                    } else if (controller.visa.value) {
                                      temp = visaTextEditing;
                                    }
                                  });
                                  cashTextEditing.clear();
                                  visaTextEditing.clear();
                                  returnTextEditing.clear();
                                  visaTextEditing.text =
                                      controller.fTotal.toStringAsFixed(2);
                                  cashTextEditing.text = '0';
                                  returnTextEditing.text = '0';
                                  tipsTextEditing.text = '0';
                                },
                                title: 'Visa'.tr,
                                backgroundColor: controller.visa.value
                                    ? Colors.black38
                                    : Colors.white,
                                textColor: Colors.black,
                                height:
                                    ScaledDimensions.getScaledHeight(px: 50),
                                width: ScaledDimensions.getScaledWidth(px: 60),
                                withPadding: false,
                              ),
                            ),
                            Expanded(
                              child: CustomAppButton(
                                onPressed: () {
                                  setState1(() {
                                    controller.cash.value = false;
                                    controller.visa.value = false;
                                    controller.cashVisa.value = false;

                                    if (controller.cash.value) {
                                      temp = cashTextEditing;
                                    } else if (controller.visa.value) {
                                      temp = visaTextEditing;
                                    } else {
                                      temp = temp1;
                                    }
                                  });
                                  cashTextEditing.clear();
                                  visaTextEditing.clear();
                                  returnTextEditing.clear();
                                  cashTextEditing.text = '0';
                                  visaTextEditing.text = '0';
                                  tipsTextEditing.text = '0';
                                  returnTextEditing.text =
                                      (controller.fTotal * -1)
                                          .toStringAsFixed(2);
                                },
                                title: 'Credit'.tr,
                                backgroundColor: !controller.cash.value &&
                                        !controller.visa.value &&
                                        !controller.cashVisa.value
                                    ? Colors.black38
                                    : Colors.white,
                                textColor: Colors.black,
                                height:
                                    ScaledDimensions.getScaledHeight(px: 50),
                                width: ScaledDimensions.getScaledWidth(px: 60),
                                withPadding: false,
                              ),
                            ),
                            Expanded(
                              child: CustomAppButton(
                                onPressed: () {
                                  controller.cash.value = true;
                                  controller.visa.value = true;
                                  controller.cashVisa.value = true;
                                  temp = cashTextEditing;
                                  cashTextEditing.clear();
                                  visaTextEditing.clear();
                                  returnTextEditing.clear();
                                  cashTextEditing.text = '1';
                                  visaTextEditing.text = '1';
                                  tipsTextEditing.text = '0';
                                  returnTextEditing.text =
                                      (2 - controller.fTotal.value)
                                          .toStringAsFixed(2);
                                },
                                title: '${'Cash'.tr} & ${'Visa'.tr}',
                                backgroundColor: controller.cashVisa.value
                                    ? Colors.black38
                                    : Colors.white,
                                textColor: Colors.black,
                                height:
                                    ScaledDimensions.getScaledHeight(px: 50),
                                width: ScaledDimensions.getScaledWidth(px: 60),
                                withPadding: false,
                              ),
                            ),
                          ],
                        ),
                        NumPad(
                            onPressed: () {
                              getDetails();
                              setState1(() {});
                            },
                            delete: () {
                              if (temp.text.isEmpty) {
                                return;
                              }
                              temp.text =
                                  temp.text.substring(0, temp.text.length - 1);
                              setState1(() {
                                getDetails();
                              });
                            },
                            onSubmit: () async {
                              var cont =Get.find<UserController>();
                              bool result = cont.isPermission(cont.permission.value.addSales, context);
                              if(!result){
                                return;
                              }
                              String paid = '0.0';
                              if ((double.tryParse(cashTextEditing.text) ??
                                      0.0) <
                                  (double.tryParse(returnTextEditing.text) ??
                                      0.0)) {
                                ConstantApp.showSnakeBarError(context,
                                    'The Return Can Not Be Greater Than The Cash .. !');
                                return;
                              }
                              if (ConstantApp.appType.name != 'REST' &&
                                  controller.orders.isEmpty) {
                                try {
                                  for (var i in controller.tempOrder) {
                                    if (i.quantity <= 0) {
                                      ConstantApp.showSnakeBarError(context,
                                          'The Quantity Cannot Be Zero !!');
                                      return;
                                    }
                                  }
                                  await controller.sendOrder();
                                  controller.selected1.value = 100;
                                  setState(() {});
                                  limitDiscount =
                                      (discount * controller.totalPrice.value) /
                                          100;
                                  controller.tempOrder.clear();
                                } catch (e) {
                                  return;
                                }
                                controller.tempOrder.clear();
                                await controller.getAllOrders();
                                await controller.getOrderForTable(
                                    widget.hall, widget.table);
                              }
                              double cashAmount = 0;
                              double visaAmount = 0;
                              if (cashTextEditing.text.isNotEmpty &&
                                  visaTextEditing.text.isEmpty) {
                                paid = cashTextEditing.text;
                                cashAmount = double.parse(cashTextEditing.text);
                                visaAmount = 0;
                              } else if (cashTextEditing.text.isEmpty &&
                                  visaTextEditing.text.isNotEmpty) {
                                paid = visaTextEditing.text;
                                cashAmount = 0;
                                visaAmount = double.parse(visaTextEditing.text);
                              } else if (cashTextEditing.text.isNotEmpty &&
                                  visaTextEditing.text.isNotEmpty) {
                                paid = (double.parse(visaTextEditing.text) +
                                        double.parse(cashTextEditing.text))
                                    .toStringAsFixed(2);
                                visaAmount = double.parse(visaTextEditing.text);
                                cashAmount = double.parse(cashTextEditing.text);
                              }
                              if (paid == '0.0') {
                                returnTextEditing.text =
                                    controller.totalPrice.toStringAsFixed(2);
                              }
                              double tips = tipsTextEditing.text.isEmpty
                                  ? 0.0
                                  : double.parse(tipsTextEditing.text);
                              await controller.saveBill(
                                paid: paid,
                                balance: returnTextEditing.text,
                                tips: tips,
                                cashAmount: cashAmount,
                                visaAmount: visaAmount,
                                note: noteOrder,
                                date: DateTime.now(),
                                cashier: Get.find<SharedPreferences>()
                                        .getString('name') ??
                                    '',
                                customerS: controller.customerId.value,
                                disAmountS: controller.disAmount.value,
                                discountTypeS: controller.discountType.value,
                                discountValueS: controller.discountValue!.text,
                                fTotalS: controller.fTotal.value,
                                hallS: widget.hall,
                                listOrdersS: controller.orders,
                                priceWithOutVatS:
                                    controller.priceWithOutVat.value,
                                tableS: widget.table,
                                totalPriceS: controller.totalPrice.value,
                                vatAfterDisS: controller.vatAfterDis.value,
                                vatS: controller.vat.value,
                                storeIdS: ConstantApp.storeId,
                                salesTypeS: 'sales',
                                salesType: controller.salesType.value,
                              );

                              controller.orders.clear();
                              controller.totalPrice.value = 0;
                              controller.priceWithOutVat.value = 0;
                              controller.vat.value = 0;
                              controller.discount.value = 0;
                              controller.disAmount.value = 0;
                              controller.vatAfterDis.value = 0;
                              controller.fTotal.value = 0;
                              controller.requstingBill.value = false;
                              Get.back();
                              cashTextEditing.clear();
                              visaTextEditing.clear();
                              returnTextEditing.clear();
                              controller.qty.value = 0;
                              await controller.getAllOrders();
                              await Get.find<InfoController>()
                                  .getAllInformation();
                              List<OrderModel> order = controller.orderView
                                  .where((element) =>
                                      element.billNum ==
                                      Get.find<InfoController>()
                                          .bills
                                          .last
                                          .formatNumber)
                                  .toList();
                              var doc = await controller.printBill(
                                  orders: order,
                                  bill: Get.find<InfoController>().bills.last,
                                  printerName: '',
                                  driverName: '',
                                  customerAddress: addressCustomer,
                                  customerNum: customerNumber);
                              var printer =
                                  await Get.find<AppDataBaseController>()
                                      .appDataBase
                                      .getPrinterSetting(1);
                              if (printer == null) {
                                if (!context.mounted) return;
                                ConstantApp.showSnakeBarError(context,
                                    'ADD Printer From Printer Setting !!'.tr);
                                return;
                              }
                              var allPrinters =
                                  await Get.find<AppDataBaseController>()
                                      .appDataBase
                                      .getAllPrinter();
                              if (printer.billPrinter != 0) {
                                String name = allPrinters
                                        .firstWhere((element) =>
                                            element.id == printer.billPrinter)
                                        .printerName ??
                                    '';
                                await Printing.directPrintPdf(
                                  usePrinterSettings: true,
                                  dynamicLayout: false,
                                  printer: Printer(
                                    url: name,
                                    name: name,
                                  ),
                                  onLayout: (format) async => doc.save(),
                                );
                              } else {
                                if (!context.mounted) return;
                                ConstantApp.showSnakeBarError(context,
                                    'ADD Printer From Printer Setting !!'.tr);
                                return;
                              }
                            },
                            controller: temp,
                            buttonSize: 30,
                            showPoint: true,
                            iconColor: Colors.black,
                            buttonColor: Colors.black),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    ), barrierColor: Colors.transparent.withOpacity(0.5));
  }
}
