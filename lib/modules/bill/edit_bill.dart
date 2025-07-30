import 'package:cashier_app/controllers/info_controllers.dart';
import 'package:cashier_app/models/customer_model.dart';
import 'package:cashier_app/models/unit_model.dart';
import 'package:cashier_app/modules/bill/temp_order.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../utils/Theme/colors.dart';
import '../../../../utils/constant.dart';
import '../../controllers/order_controller.dart';
import '../../controllers/sales_controller.dart';
import '../../global_widgets/custom_app_button.dart';
import '../../global_widgets/custom_app_drop_down_employee.dart';
import '../../global_widgets/custom_clock.dart';
import '../../global_widgets/custom_drop_down_button.dart';
import '../../global_widgets/custom_drop_down_driver.dart';
import '../../global_widgets/custom_text_field.dart';
import '../../global_widgets/drop_down_button_customers.dart';
import '../../global_widgets/drop_down_unit.dart';
import '../../global_widgets/keyboard.dart';
import '../../global_widgets/loader.dart';
import '../../models/bill_model.dart';
import '../../models/order/order_model.dart';
import '../../utils/scaled_dimensions.dart';
import '../order_view/widget/grid_item.dart';

class EditBill extends StatefulWidget {
  const EditBill({Key? key, required this.bill}) : super(key: key);
  final BillModel bill;

  @override
  State<EditBill> createState() => _EditBillState();
}

class _EditBillState extends State<EditBill> {
  final _formKey1 = GlobalKey<FormState>();

  var controllerOr = Get.find<OrderController>();
  var controllerS = Get.find<SalesBillController>();

  TextEditingController textEditingController3 = TextEditingController();
  TextEditingController textEditingController = TextEditingController();
  TextEditingController priceEditingController = TextEditingController();
  TextEditingController numController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController cashTextEditing = TextEditingController();
  TextEditingController visaTextEditing = TextEditingController();
  TextEditingController returnTextEditing = TextEditingController();
  TextEditingController discountTextEditing = TextEditingController();
  TextEditingController tipsTextEditing = TextEditingController();
  TextEditingController temp = TextEditingController();
  TextEditingController temp1 = TextEditingController();
  late TextEditingController storeTextEditingController =
      TextEditingController();

  DateTime? pickedDate;

  FocusNode cashFN = FocusNode();
  FocusNode visaFN = FocusNode();
  FocusNode dateFN = FocusNode();

  int taxD = 0;
  int selectDriver = 0;
  int storeId = ConstantApp.storeId;
  List<bool> isDecimal = [];
  List<String> listDis = Get.find<InfoController>().taxesSetting.isEmpty
      ? ['%', 'Value']
      : ['%', 'Fixed before Vat', 'Fixed After Vat'];
  bool negative = Get.find<SharedPreferences>().getBool('negative') ?? false;

  // Get.find<SharedPreferences>().getBool('negativeSelling') ?? false;

  @override
  void initState() {
    initFunction();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
          title: Text(
            'Edit Bill'.tr,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Center(
                child: Text(
                  ConstantApp.capitalizeFirstLetter(widget.bill.salesType!),
                  style: ConstantApp.getTextStyle(
                      context: context,
                      color: widget.bill.salesType!.contains('sales')
                          ? primaryColor
                          : errorColor,
                      fontWeight: FontWeight.w500),
                ),
              ),
            )
          ],
        ),
      ),
      backgroundColor: const Color(0xFFf1f1f1),
      body: SizedBox(
          width: ConstantApp.getWidth(context),
          height: ConstantApp.getHeight(context),
          child: ConstantApp.isTab(context)
              ? verticalWidget()
              : horizontalWidget()),
    ));
  }

  Widget horizontalWidget() {
    return Column(
      children: [
        Expanded(
            child: Row(
          children: [
            orderWidget(),
            productItemWidget(),
            Obx(() => !controllerOr.showSub.value
                ? const SizedBox()
                : supCategoryItemWidget()),
            Obx(() => !controllerOr.showMain.value
                ? const SizedBox()
                : mainCategoryItemWidget()),
          ],
        )),
      ],
    );
  }

  Widget verticalWidget() {
    return Column(
      children: [
        Expanded(
            child: Column(
          children: [
            Obx(() => !controllerOr.showMain.value
                ? const SizedBox()
                : supCategoryItemWidget()),
            Obx(() => !controllerOr.showSub.value
                ? const SizedBox()
                : mainCategoryItemWidget()),
            productItemWidget(),
            orderWidget(),
          ],
        )),
      ],
    );
  }

  Widget orderWidget() {
    return Obx(() => Expanded(
          flex: controllerOr.orderWidth.value,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: ConstantApp.getHeight(context) * 0.13,
                color: secondaryColor,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const CustomClock(),
                          Text(
                              '${'Table'.tr} - ${widget.bill.hall}-${widget.bill.table}',
                              style: const TextStyle(color: Colors.white)),
                          Text(
                            DateFormat('dd/MM/yyyy')
                                .format(widget.bill.createdAt!),
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            '${'Bill'.tr} - ${widget.bill.formatNumber}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomDropDownButtonCustomer(
                            title: '',
                            hint: 'Customers'.tr,
                            value: controllerOr.customerId.value == 0
                                ? null
                                : controllerOr.customerId.value,
                            items: controllerOr.customer,
                            onChange: (val) {
                              controllerOr.customerId.value = val!;
                            },
                            width: ConstantApp.isTab(context)
                                ? ConstantApp.getWidth(context) * 0.25
                                : ConstantApp.getWidth(context) * 0.1,
                            height: ScaledDimensions.getScaledHeight(px: 40),
                            textEditingController: textEditingController,
                          ),
                          widget.bill.hall == 'Delivery'
                              ? CustomDropDownButtonDriver(
                                  title: '',
                                  hint: 'Select Driver'.tr,
                                  value:
                                      selectDriver == 0 ? null : selectDriver,
                                  items: controllerOr.drivers,
                                  onChange: (val) {
                                    selectDriver = val!;
                                  },
                                  width: ConstantApp.isTab(context)
                                      ? ConstantApp.getWidth(context) * 0.25
                                      : ConstantApp.getWidth(context) * 0.1,
                                  height:
                                      ScaledDimensions.getScaledHeight(px: 40),
                                  textEditingController: textEditingController,
                                )
                              : const SizedBox(),
                          Form(
                            key: _formKey1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: ConstantApp.isTab(context)
                                      ? ConstantApp.getWidth(context) * 0.25
                                      : ConstantApp.getWidth(context) * 0.1,
                                  height:
                                      ScaledDimensions.getScaledHeight(px: 60),
                                  child: CustomTextFormField(
                                    textEditingController: dateController,
                                    focusNode: dateFN,
                                    hint: 'Date Sales'.tr,
                                    onChange: (value) {
                                      if (value!.isEmpty) {
                                        controllerS.disAmount.value = 0;
                                      }
                                      controllerS.getDetail();
                                    },
                                    validator: (value) {
                                      if (value!.isEmpty || value == '') {
                                        ConstantApp.showSnakeBarError(
                                            context, 'Add Date Please !!'.tr);
                                        return 'Add Date Please !!'.tr;
                                      }
                                      return null;
                                    },
                                    readOnly: true,
                                    onTap: () async {
                                      pickedDate = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2101));
                                      if (pickedDate != null) {
                                        //get the picked date in the format => 2022-07-04 00:00:00.000
                                        String formattedDate =
                                            DateFormat('yyyy-MM-dd')
                                                .format(pickedDate!);
                                        dateController.text = formattedDate;
                                      } else {}
                                    },
                                    onSaved: (value) {},
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {
                                      dateController.clear();
                                      pickedDate = null;
                                    },
                                    icon: Icon(
                                      Icons.close,
                                      color: primaryColor,
                                    ))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Flexible(
                      flex: 1,
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
                  Flexible(
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
                      )),
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
                          'Order No'.tr,
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
                          'Employee'.tr,
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
                  const Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: Text(
                        '',
                      )),
                ],
              ),
              Expanded(
                child: GetBuilder<SalesBillController>(builder: (controller) {
                  List<OrderModel> order = controller.order;
                  return order.isEmpty
                      ? Text('No Orders'.tr)
                      : Obx(
                          () => ListView.builder(
                              shrinkWrap: true,
                              itemCount: controller.order.length,
                              itemBuilder: (context, index) {
                                Map<int, double> map = {};
                                List<UnitModel> listUnit = [];
                                for (var i in controllerOr.products) {
                                  if (i.id == controller.order[index].itemId) {
                                    map.addIf(
                                        (i.unit != 0 && i.unit != null),
                                        i.unit ?? 0,
                                        double.tryParse(i.price ?? '0') ?? 0.0);
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
                                for (var i in controllerOr.units) {
                                  if (map.keys.contains(i.id)) {
                                    listUnit.add(i);
                                  }
                                }

                                isDecimal.clear();
                                for (var i in controller.order) {
                                  isDecimal.add(controllerOr.units
                                      .firstWhere(
                                          (element) => element.id == i.unitId)
                                      .acceptsDecimal);
                                }
                                return TempOrderReport(
                                  name: order[index].name,
                                  ident: order[index].ident,
                                  price: order[index].price,
                                  qty: order[index].quantity,
                                  guest: order[index].guest,
                                  date: order[index].createdAt,
                                  numberOfOrder: order[index].serial,
                                  numberBill: order[index].billNum!,
                                  edit: true,
                                  close: () {
                                    controller.order.removeAt(index);
                                    controller.getDetail();
                                    setState(() {});
                                  },
                                  dec: () {
                                    if (controller.order[index].quantity > 1) {
                                      controller.order[index].quantity--;
                                      controller.getDetail();
                                    }

                                    setState(() {});
                                  },
                                  inc: () async {
                                    double qty = 0.0;
                                    qty = await controllerOr.checkQty(
                                        variableId: controller
                                                .order[index].variableId ??
                                            0,
                                        id: controller.order[index].itemId);
                                    for (var i in controller.order) {
                                      if (i.itemId ==
                                          controller.order[index].itemId) {
                                        qty -= i.quantity;
                                      }
                                    }
                                    if (!controllerOr.negative.value) {
                                      if (qty <= 0) {
                                        if (!context.mounted) return;
                                        ConstantApp.showSnakeBarError(
                                            context, 'There Is No Quantity !!');
                                        return;
                                      }
                                    }

                                    controller.order[index].quantity =
                                        controller.order[index].quantity + 1;
                                    controller.getDetail();
                                    setState(() {});
                                  },
                                  editPrice: () {
                                    priceEditingController.text = controller
                                        .order[index].price
                                        .toStringAsFixed(1);
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(actions: [
                                            TextFormField(
                                              autofocus: true,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(
                                                        RegExp(r'(^\d*\.?\d*)'))
                                              ],
                                              decoration: const InputDecoration(
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                          borderSide: BorderSide
                                                              .none),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide.none)),
                                              controller:
                                                  priceEditingController,
                                              onChanged: (val) {
                                                if (val.isNotEmpty) {
                                                  if (double.parse(val) <= 0) {
                                                    controller.order[index]
                                                        .price = 1.00;
                                                  } else {
                                                    controller.order[index]
                                                            .price =
                                                        double.parse(val);
                                                  }
                                                }
                                                controller.getDetail();
                                                setState(() {});
                                              },
                                            ),
                                          ]);
                                        });
                                  },
                                  unitWidget: CustomDropDownButtonUnits(
                                      title: '',
                                      hint: 'Units'.tr,
                                      value: controller.order[index].unitId == 0
                                          ? null
                                          : controller.order[index].unitId,
                                      withOutValue: true,
                                      items: listUnit,
                                      onChange: (value) {
                                        controller.order[index].unitId = value!;
                                        controller.order[index].price =
                                            map[value]!;
                                        controller.order[index].quantity = 1;
                                        double taxQ = controllerOr.units.firstWhere((element) => element.id == value).qty;
                                        setState(() {});
                                      },
                                      width: ConstantApp.getWidth(context) / 20,
                                      height:
                                          ConstantApp.getHeight(context) / 20,
                                      showIconReset: false,
                                      textEditingController:
                                          textEditingController),
                                  onTapName: () {},
                                  employeeWidget: CustomDropDownButtonEmployee(
                                      title: 'Employee',
                                      hint: 'Employee',
                                      showIconReset: false,
                                      value: controller
                                                  .order[index].employeeId ==
                                              0
                                          ? null
                                          : controller.order[index].employeeId,
                                      items: Get.find<InfoController>()
                                          .employees
                                          .where((p0) => p0.isActive)
                                          .toList(),
                                      onChange: (value) {
                                        controller.order[index].employeeId =
                                            value ?? 0;
                                        for (var i in Get.find<InfoController>()
                                            .employees
                                            .where((p0) => p0.isActive)
                                            .toList()) {
                                          if (i.id ==
                                              controller
                                                  .order[index].employeeId) {
                                            controller.order[index].commission =
                                                i.commission;
                                          }
                                        }
                                        setState(() {});
                                      },
                                      width: ConstantApp.getWidth(context) / 20,
                                      height:
                                          ConstantApp.getHeight(context) / 20,
                                      textEditingController:
                                          textEditingController),
                                );
                              }),
                        );
                }),
              ),
              Container(
                width: double.infinity,
                height: ConstantApp.getHeight(context) * 0.22,
                decoration: BoxDecoration(
                    color: secondaryColor.withOpacity(0.7),
                    border: Border.all(color: Colors.white)),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Container(
                          color: Colors.white,
                          height: ConstantApp.getHeight(context) * 0.3,
                          // width: ConstantApp.getWidth(context) / 4,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: ConstantApp.getHeight(context) * 0.03,
                                ),
                                Text(
                                  'Discount',
                                  style: ConstantApp.getTextStyle(
                                    context: context,
                                    size: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomAppButton(
                                        onPressed: () {
                                          controllerS.discountType.value = '%';
                                          controllerS.discountValue.text = '5';
                                          controllerS.getDetail();
                                        },
                                        title: '5%',
                                        backgroundColor: Colors.white,
                                        textColor: primaryColor,
                                        height:
                                            ConstantApp.getHeight(context) / 25,
                                        width:
                                            ConstantApp.getWidth(context) / 4,
                                        withPadding: false,
                                      ),
                                    ),
                                    Expanded(
                                      child: CustomAppButton(
                                        onPressed: () {
                                          controllerS.discountType.value = '%';
                                          controllerS.discountValue.text = '10';
                                          controllerS.getDetail();
                                        },
                                        title: '10%',
                                        backgroundColor: Colors.white,
                                        textColor: primaryColor,
                                        height:
                                            ConstantApp.getHeight(context) / 25,
                                        width:
                                            ConstantApp.getWidth(context) / 4,
                                        withPadding: false,
                                      ),
                                    ),
                                    Expanded(
                                      child: CustomAppButton(
                                        onPressed: () {
                                          controllerS.discountType.value = '%';
                                          controllerS.discountValue.text = '20';
                                          controllerS.getDetail();
                                        },
                                        title: '20%',
                                        backgroundColor: Colors.white,
                                        textColor: primaryColor,
                                        height:
                                            ConstantApp.getHeight(context) / 25,
                                        width:
                                            ConstantApp.getWidth(context) / 4,
                                        withPadding: false,
                                      ),
                                    ),
                                    Expanded(
                                      child: CustomAppButton(
                                        onPressed: () {
                                          controllerS.discountType.value = '%';
                                          controllerS.discountValue.text = '25';
                                          controllerS.getDetail();
                                        },
                                        title: '25%',
                                        backgroundColor: Colors.white,
                                        textColor: primaryColor,
                                        height:
                                            ConstantApp.getHeight(context) / 25,
                                        width:
                                            ConstantApp.getWidth(context) / 4,
                                        withPadding: false,
                                      ),
                                    ),
                                    Expanded(
                                      child: CustomAppButton(
                                        onPressed: () {
                                          controllerS.discountType.value = '%';
                                          controllerS.discountValue.text = '50';
                                          controllerS.getDetail();
                                        },
                                        title: '50%',
                                        backgroundColor: Colors.white,
                                        textColor: primaryColor,
                                        height:
                                            ConstantApp.getHeight(context) / 25,
                                        width:
                                            ConstantApp.getWidth(context) / 4,
                                        withPadding: false,
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16, right: 16),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: Obx(
                                          () => CustomDropDownButton(
                                            title: 'Select type'.tr,
                                            hint: '%',
                                            items: listDis,
                                            value:
                                                controllerS.discountType.value,
                                            withOutValue: true,
                                            onChange: (value) {
                                              if (value != null) {
                                                controllerS.discountType.value =
                                                    value;
                                              }
                                              controllerS.getDetail();
                                            },
                                            height:
                                                ConstantApp.getHeight(context) /
                                                    25,
                                            width:
                                                ConstantApp.getWidth(context) /
                                                    4,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      Expanded(
                                        child: SizedBox(
                                          height:
                                              ConstantApp.getHeight(context) /
                                                  16,
                                          width:
                                              ConstantApp.getWidth(context) / 4,
                                          child: CustomTextFormField(
                                            textEditingController:
                                                controllerS.discountValue,
                                            focusNode: controllerS
                                                .discountValueFocusNode,
                                            hint: 'Enter Dis Value'.tr,
                                            onChange: (value) {
                                              if (value!.isEmpty) {
                                                controllerS.disAmount.value = 0;
                                              }
                                              controllerS.getDetail();
                                            },
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Enter Dis Value'.tr;
                                              }
                                              return null;
                                            },
                                            isNum: true,
                                            onSaved: (value) {},
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width:
                                      ScaledDimensions.getScaledWidth(px: 50),
                                  child: Text(
                                    '${'Total Price'.tr} : ',
                                    style: ConstantApp.getTextStyle(
                                      context: context,
                                      fontWeight: FontWeight.w500,
                                      size: 8,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Obx(
                                  () => SizedBox(
                                    width:
                                        ScaledDimensions.getScaledWidth(px: 40),
                                    child: Text(
                                        controllerS.totalOrders.value
                                            .toStringAsFixed(2),
                                        style: ConstantApp.getTextStyle(
                                          context: context,
                                          color: Colors.white,
                                          size: 8,
                                          fontWeight: FontWeight.w500,
                                        )),
                                  ),
                                )
                              ],
                            ),
                            const Divider(
                              color: Colors.white,
                            ),
                            Get.find<InfoController>().taxesSetting.isEmpty
                                ? const SizedBox()
                                : Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          SizedBox(
                                            width:
                                                ScaledDimensions.getScaledWidth(
                                                    px: 50),
                                            child: Text(
                                              '${'Sub total'.tr} :',
                                              style: ConstantApp.getTextStyle(
                                                context: context,
                                                fontWeight: FontWeight.w500,
                                                size: 8,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          Obx(
                                            () => SizedBox(
                                              width: ScaledDimensions
                                                  .getScaledWidth(px: 40),
                                              child: Text(
                                                  controllerS
                                                      .totalExcVatOrders.value
                                                      .toStringAsFixed(2),
                                                  style:
                                                      ConstantApp.getTextStyle(
                                                    context: context,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                    size: 8,
                                                  )),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Divider(
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  width:
                                      ScaledDimensions.getScaledWidth(px: 50),
                                  child: Text(
                                    '${'Discount'.tr} :',
                                    style: ConstantApp.getTextStyle(
                                      context: context,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      size: 8,
                                    ),
                                  ),
                                ),
                                Obx(
                                  () => SizedBox(
                                    width:
                                        ScaledDimensions.getScaledWidth(px: 40),
                                    child: Text(
                                        (controllerS.disAmount.value)
                                            .toStringAsFixed(2),
                                        style: ConstantApp.getTextStyle(
                                          context: context,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          size: 8,
                                        )),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(
                              color: Colors.white,
                            ),
                            Get.find<InfoController>().taxesSetting.isEmpty
                                ? const SizedBox()
                                : Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          SizedBox(
                                            width:
                                                ScaledDimensions.getScaledWidth(
                                                    px: 50),
                                            child: Text(
                                              '${'Vat'.tr} 5% :',
                                              style: ConstantApp.getTextStyle(
                                                context: context,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                size: 8,
                                              ),
                                            ),
                                          ),
                                          Obx(
                                            () => SizedBox(
                                              width: ScaledDimensions
                                                  .getScaledWidth(px: 40),
                                              child: Text(
                                                  controllerS.vat.value
                                                      .toStringAsFixed(2),
                                                  style:
                                                      ConstantApp.getTextStyle(
                                                    context: context,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                    size: 8,
                                                  )),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Divider(
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  width:
                                      ScaledDimensions.getScaledWidth(px: 50),
                                  child: Text(
                                    '${'Final total'.tr} : ',
                                    style: ConstantApp.getTextStyle(
                                      context: context,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      size: 8,
                                    ),
                                  ),
                                ),
                                Obx(
                                  () => SizedBox(
                                    width:
                                        ScaledDimensions.getScaledWidth(px: 40),
                                    child: Text(
                                        controllerS.finalTotal.value
                                            .toStringAsFixed(2),
                                        style: ConstantApp.getTextStyle(
                                          context: context,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          size: 8,
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              CustomAppButton(
                onPressed: () async {
                  if (controllerS.order.isEmpty) {
                    ConstantApp.showSnakeBarError(
                        context, "Can't save, add some products .. ".tr);
                    return;
                  }
                  for (var i in controllerS.order) {
                    if (i.quantity <= 0) {
                      ConstantApp.showSnakeBarError(
                          context, "The Quantity Cannot Be Zero !!".tr);
                      return;
                    }
                  }
                  if (_formKey1.currentState!.validate()) {
                    double cash = widget.bill.cashAmount ?? 0.0;
                    double visa = widget.bill.visaAmount ?? 0.0;
                    if (cash != 0 && visa != 0) {
                      controllerS.cashVisa(true);
                      controllerS.cash(true);
                      controllerS.visa(true);
                      temp = cashTextEditing;
                    } else if (cash == 0 && visa == 0) {
                      controllerS.cashVisa(false);
                      controllerS.cash(false);
                      controllerS.visa(false);
                      temp = TextEditingController();
                    } else if (cash != 0 && visa == 0) {
                      controllerS.cashVisa(false);
                      controllerS.cash(true);
                      controllerS.visa(false);
                      temp = cashTextEditing;
                    } else if (cash == 0 && visa != 0) {
                      controllerS.cashVisa(false);
                      controllerS.cash(false);
                      controllerS.visa(true);
                      temp = cashTextEditing;
                    }
                    cashTextEditing.text = widget.bill.cashAmount.toString();
                    visaTextEditing.text = widget.bill.visaAmount.toString();
                    tipsTextEditing.text = widget.bill.tips.toString();
                   await getDetails();
                    showDialogSave();
                  }
                },
                title: 'Save'.tr,
                backgroundColor: primaryColor,
                textColor: Colors.white,
                withPadding: true,
                width: ConstantApp.isTab(context) ? 150 : 100,
                height: 50,
              ),
              const SizedBox(),
            ],
          ),
        ));
  }

  Widget productItemWidget() {
    return Obx(() => Expanded(
        flex: ConstantApp.isTab(context)
            ? controllerOr.productWidth.value - 1
            : controllerOr.productWidth.value,
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
                          vertical: BorderSide(color: Colors.white, width: 1))),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 6,
                          child: TextField(
                            controller: textEditingController3,
                            onChanged: (value) =>
                                controllerOr.filterProductPlayer(value),
                            cursorColor: Colors.white,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              suffixIconColor: Colors.white,
                              border: const UnderlineInputBorder(
                                  borderSide: BorderSide.none),
                              hintText: 'Search...'.tr,
                              hintStyle: const TextStyle(color: Colors.white),
                              suffixIcon: const Icon(Icons.search),
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 1,
                            child: TextButton(
                                onPressed: () async {
                                  textEditingController3.clear();
                                  await controllerOr.getAllProducts();
                                },
                                child: Text(
                                  'All',
                                  style: TextStyle(color: primaryColor),
                                )))
                      ],
                    ),
                  ),
                )),
            Expanded(
              flex: ConstantApp.isTab(context) ? 6 : 15,
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
                                          // childAspectRatio: 1.2,
                                          crossAxisCount: ConstantApp.isTab(
                                                  context)
                                              ? controller.productItem.value + 3
                                              : controller.productItem.value,
                                          // GetPlatform.isDesktop ? 6 : 2,
                                          crossAxisSpacing:
                                              ScaledDimensions.getScaledWidth(
                                                  px: 2),
                                          mainAxisSpacing:
                                              ScaledDimensions.getScaledHeight(
                                                  px: 5)),
                                  itemCount:
                                      controller.productDataPlayer.length,
                                  itemBuilder: ((context, index) {
                                    return GridItem(
                                      maxLine: 2,
                                      onLongPress: () {},
                                      color: Color(int.parse(controller
                                                  .productDataPlayer[index]
                                                  .colorProduct ??
                                              '0x00ee6800'))
                                          .withOpacity(0.7),
                                      onTap: () async {
                                        if (controller.productDataPlayer[index]
                                                .type ==
                                            'variable') {
                                          controllerOr.getVariable(controller
                                              .productDataPlayer[index].id!);
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
                                                      builder: (controllerP) {
                                                        return GridView.builder(
                                                          padding: EdgeInsets.all(
                                                              ScaledDimensions
                                                                  .getScaledWidth(
                                                                      px: 5)),
                                                          gridDelegate:
                                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                            childAspectRatio: 1,
                                                            crossAxisCount: 2,
                                                            crossAxisSpacing:
                                                                ScaledDimensions
                                                                    .getScaledWidth(
                                                                        px: 10),
                                                            mainAxisSpacing: 10,
                                                          ),
                                                          itemCount: controllerP
                                                              .productsVariable
                                                              .length,
                                                          itemBuilder:
                                                              ((context,
                                                                  index1) {
                                                            return GridItem(
                                                                onTap:
                                                                    () async {
                                                                  await controllerS
                                                                      .addOrder(
                                                                    controller
                                                                            .productDataPlayer[
                                                                        index],
                                                                    widget.bill,
                                                                    controllerP
                                                                            .productsVariable[
                                                                        index1],
                                                                    controllerP
                                                                        .productsVariable[
                                                                            index1]
                                                                        .id!,
                                                                  );
                                                                  controllerS
                                                                          .total
                                                                          .value =
                                                                      0.0;
                                                                  for (var i
                                                                      in controllerS
                                                                          .order) {
                                                                    controllerS
                                                                        .total
                                                                        .value += (i
                                                                            .quantity *
                                                                        i.price);
                                                                  }
                                                                  Get.back();
                                                                  setState(
                                                                      () {});
                                                                },
                                                                name: controllerP
                                                                    .productsVariable[
                                                                        index1]
                                                                    .name!,
                                                                image: "",
                                                                imageBytes: controllerP
                                                                    .productsVariable[
                                                                        index1]
                                                                    .image,
                                                                color:
                                                                    primaryColor);
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
                                        }
                                        setState(() {});
                                      },
                                      name: controller.productDataPlayer[index]
                                          .englishName!,
                                      image: "",
                                      imageBytes: controller
                                          .productDataPlayer[index].image,
                                      price: controller
                                          .productDataPlayer[index].price!,
                                    );
                                  }))),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )));
  }

  Widget supCategoryItemWidget() {
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

  Widget mainCategoryItemWidget() {
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

  void initFunction() {
    controllerOr.tempOrder.clear();
    Future.delayed(
        const Duration(
          milliseconds: 10,
        ), () {
      CustomerModel? element = Get.find<OrderController>()
          .customer
          .firstWhereOrNull((element) => element.id == widget.bill.customerId);
      if (element == null) {
        controllerOr.customerId.value = 0;
      } else {
        controllerOr.customerId.value = widget.bill.customerId??0;
      }
      //controllerOr.customerId.value = widget.bill.customerId;
      // controllerOr.customerId.value = 0;
    });
    controllerS.discountValue.text = widget.bill.disValue??'0';
    controllerS.discountType.value = widget.bill.disType??'%';
    controllerS.disAmount.value = widget.bill.discountAmount??0;
    controllerOr.salesType.value = widget.bill.salesType!;
    cashTextEditing.text = (widget.bill.cashAmount ?? 0).toStringAsFixed(2);
    visaTextEditing.text = (widget.bill.visaAmount ?? 0).toStringAsFixed(2);
    tipsTextEditing.text = (widget.bill.tips ?? 0).toStringAsFixed(2);
    dateController.text =
        DateFormat('yyyy-MM-dd').format(widget.bill.dateSales??DateTime.now());
    pickedDate = widget.bill.dateSales;
    var taxDefault = Get.find<InfoController>().taxesSetting.isEmpty
        ? 0
        : Get.find<InfoController>().taxesSetting.last.taxId;
    taxD = taxDefault == 0
        ? 0
        : Get.find<InfoController>()
            .taxes
            .firstWhere((element) => element.id == taxDefault)
            .taxValue??0;
    storeId = widget.bill.storeId??0;
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
                          '${controllerS.finalTotal.value.toStringAsFixed(2)} ${'AED'.tr}',
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
                                  autofocus: controllerS.cash.value,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'(^\d*\.?\d*)'))
                                  ],
                                  readOnly: !controllerS.cash.value,
                                  controller: cashTextEditing,
                                  onChanged: (val) {
                                    tipsTextEditing.text = '0';
                                    getDetails();
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Cash'.tr,
                                    icon: const Icon(Icons.attach_money),
                                    suffixIcon: controllerS.cashVisa.value
                                        ? IconButton(
                                            onPressed: () {
                                              if (controllerS.cashVisa.value) {
                                                if (controllerS
                                                        .finalTotal.value <
                                                    double.parse(
                                                        visaTextEditing.text)) {
                                                  cashTextEditing.text = "0";
                                                  getDetails();
                                                  setState1;
                                                  return;
                                                }
                                                cashTextEditing.text =
                                                    (controllerS.finalTotal
                                                                .value -
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
                                  readOnly: !controllerS.visa.value,
                                  controller: visaTextEditing,
                                  onChanged: (val) {
                                    tipsTextEditing.text = '0';
                                    getDetails();
                                    setState1(() {});
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Visa'.tr,
                                    icon: const Icon(Icons.credit_card),
                                    suffixIcon: controllerS.cashVisa.value
                                        ? IconButton(
                                            onPressed: () {
                                              if (controllerS.cashVisa.value) {
                                                if (controllerS
                                                        .finalTotal.value <
                                                    double.parse(
                                                        cashTextEditing.text)) {
                                                  visaTextEditing.text = "0";
                                                  getDetails();
                                                  setState1;
                                                  return;
                                                }
                                                visaTextEditing.text =
                                                    (controllerS.finalTotal
                                                                .value -
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
                                  enabled: !controllerS.cash.value &&
                                          !controllerS.visa.value
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
                                    if (tips >
                                        double.parse(returnTextEditing.text)) {
                                      returnTextEditing.text = '0';
                                      tipsTextEditing.text = ((visa + cash) -
                                              controllerS.finalTotal.value)
                                          .toStringAsFixed(2);
                                      return;
                                    }
                                    if (tips == 0) {
                                      returnTextEditing.text = ((visa + cash) -
                                              controllerS.finalTotal.value)
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
                                            double returned = 0.0;
                                            if (controllerS.cash.value &&
                                                !controllerS.visa.value) {
                                              returned = ((controllerS
                                                          .finalTotal.value -
                                                      double.parse(
                                                          cashTextEditing
                                                              .text)) *
                                                  -1);
                                            } else if (controllerS.visa.value &&
                                                !controllerS.cash.value) {
                                              returned = ((controllerS
                                                          .finalTotal.value -
                                                      double.parse(
                                                          visaTextEditing
                                                              .text)) *
                                                  -1);
                                            } else if (controllerS.visa.value &&
                                                controllerS.cash.value) {
                                              returned = ((controllerS
                                                          .finalTotal.value -
                                                      (double.parse(
                                                              cashTextEditing
                                                                  .text) +
                                                          double.parse(
                                                              visaTextEditing
                                                                  .text))) *
                                                  -1);
                                            } else if (!controllerS
                                                    .visa.value &&
                                                !controllerS.cash.value) {
                                              returned = 0.0;
                                            }
                                            tipsTextEditing.text =
                                                returned.toStringAsFixed(2);
                                            returnTextEditing.text = '0.0';
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
                                    controllerS.cash.value = true;

                                    controllerS.visa.value = false;
                                    controllerS.cashVisa.value = false;
                                    if (controllerS.cash.value) {
                                      temp = cashTextEditing;
                                    } else if (controllerS.visa.value) {
                                      temp = visaTextEditing;
                                    }
                                  });
                                  cashTextEditing.clear();
                                  visaTextEditing.clear();
                                  returnTextEditing.clear();
                                  cashTextEditing.text =
                                      controllerS.finalTotal.toStringAsFixed(2);
                                  visaTextEditing.text = '0';
                                  returnTextEditing.text = '0';
                                  tipsTextEditing.text = '0';
                                },
                                title: 'Cash'.tr,
                                backgroundColor: controllerS.cash.value
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
                                    controllerS.cash.value = false;
                                    controllerS.cashVisa.value = false;
                                    controllerS.visa.value = true;

                                    if (controllerS.cash.value) {
                                      temp = cashTextEditing;
                                    } else if (controllerS.visa.value) {
                                      temp = visaTextEditing;
                                    }
                                  });
                                  cashTextEditing.clear();
                                  visaTextEditing.clear();
                                  returnTextEditing.clear();
                                  visaTextEditing.text =
                                      controllerS.finalTotal.toStringAsFixed(2);
                                  cashTextEditing.text = '0';
                                  returnTextEditing.text = '0';
                                  tipsTextEditing.text = '0';
                                },
                                title: 'Visa'.tr,
                                backgroundColor: controllerS.visa.value
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
                                    controllerS.cash.value = false;
                                    controllerS.visa.value = false;
                                    controllerS.cashVisa.value = false;
                                    if (controllerS.cash.value) {
                                      temp = cashTextEditing;
                                    } else if (controllerS.visa.value) {
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
                                      (-controllerS.finalTotal)
                                          .toStringAsFixed(2);
                                },
                                title: 'Credit'.tr,
                                backgroundColor: !controllerS.cash.value &&
                                        !controllerS.visa.value &&
                                        !controllerS.cashVisa.value
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
                                  controllerS.cash.value = true;
                                  controllerS.visa.value = true;
                                  controllerS.cashVisa.value = true;
                                  temp = cashTextEditing;
                                  cashTextEditing.clear();
                                  visaTextEditing.clear();
                                  returnTextEditing.clear();
                                  cashTextEditing.text = '1';
                                  visaTextEditing.text = '1';
                                  tipsTextEditing.text = '0';
                                  returnTextEditing.text =
                                      (2 - controllerS.finalTotal.value)
                                          .toStringAsFixed(2);
                                },
                                title: '${'Cash'.tr} & ${'Visa'.tr}',
                                backgroundColor: controllerS.cashVisa.value
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
                              if ((double.tryParse(cashTextEditing.text) ??
                                      0.0) <
                                  (double.tryParse(returnTextEditing.text) ??
                                      0.0)) {
                                ConstantApp.showSnakeBarError(
                                    context,
                                    'The Return Can Not Be Greater Than The Cash .. !'
                                        .tr);
                                return;
                              }
                              double cash =
                                  double.tryParse(cashTextEditing.text) ?? 0.0;
                              double visa =
                                  double.tryParse(visaTextEditing.text) ?? 0.0;
                              double paid = cash + visa;
                              String payType = '';
                              if (paid == 0) {
                                payType = 'Credit';
                              } else {
                                if (cash == 0 && visa != 0) {
                                  payType = 'Visa';
                                } else if (cash != 0 && visa == 0) {
                                  payType = 'Cash';
                                } else {
                                  payType = 'Cash_Visa';
                                }
                              }
                              String receiptStatus = '';
                              double receiptDue = 0.0;
                              if (cash + visa == 0) {
                                receiptStatus = 'due';
                                receiptDue = controllerS.finalTotal.value;
                              } else if (cash + visa >=
                                  controllerS.finalTotal.value) {
                                receiptStatus = 'paid';
                                receiptDue = 0;
                              } else if (cash + visa <
                                      controllerS.finalTotal.value &&
                                  cash + visa > 0) {
                                receiptStatus = 'partial';
                                receiptDue =
                                    controllerS.finalTotal.value - cash + visa;
                              }

                              await controllerS.editBill(BillModel(
                                  id: widget.bill.id,
                                  invoice: widget.bill.invoice,
                                  formatNumber: widget.bill.formatNumber,
                                  typeInvoice: widget.bill.typeInvoice,
                                  numberOfBill: widget.bill.numberOfBill,
                                  customerId: controllerOr.customerId.value,
                                  storeId: storeId,
                                  payType: payType,
                                  total: controllerS.totalExcVatOrders.value,
                                  discountAmount: controllerS.disAmount.value,
                                  disType: controllerS.discountType.value,
                                  cashier: widget.bill.cashier,
                                  vat: controllerS.vat.value,
                                  finalTotal: controllerS.finalTotal.value,
                                  createdAt: widget.bill.createdAt,
                                  table: widget.bill.table,
                                  hall: widget.bill.hall,
                                  salesType: controllerOr.salesType.value,
                                  paid: paid.toString(),
                                  balance: returnTextEditing.text,
                                  receiptStatus: receiptStatus,
                                  receiptDue: receiptDue,
                                  disValue: controllerS.discountValue.text,
                                  cashAmount: double.tryParse(cashTextEditing.text) ?? 0.0,
                                  visaAmount: double.tryParse(visaTextEditing.text) ?? 0.0,
                                  dateSales: DateFormat("yyyy-MM-dd").parse(dateController.text),
                                  patternId: widget.bill.patternId,
                                  tips: double.tryParse(tipsTextEditing.text) ?? 0.0,
                                  customerName: '',
                                  noteOrder: ''));
                              await Get.find<SalesBillController>().getAllBills();
                              await Get.find<OrderController>().getAllOrders();
                              await Get.find<SalesBillController>().getOrderWithBill(widget.bill.formatNumber!);
                              Get.back();
                              if (!context.mounted) return;
                              ConstantApp.showSnakeBarSuccess(
                                  context, 'Edit Success !!'.tr);
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

  getDetails() {
    double cash = double.tryParse(cashTextEditing.text) ?? 0.0;
    double visa = double.tryParse(visaTextEditing.text) ?? 0.0;
    double tips = double.tryParse(tipsTextEditing.text) ?? 0.0;
    returnTextEditing.text =
        ((visa + cash - tips) - controllerS.finalTotal.value)
            .toStringAsFixed(2);
    controllerS.paid.value = (cash + visa);
    controllerS.balance.value =
        ((visa + cash - tips) - controllerS.finalTotal.value);
    setState(() {});
  }
}
