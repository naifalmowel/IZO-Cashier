// ignore_for_file: must_be_immutable

import 'package:cashier_app/controllers/info_controllers.dart';
import 'package:cashier_app/controllers/order_controller.dart';
import 'package:cashier_app/models/bill_model.dart';
import 'package:cashier_app/modules/bill/temp_order.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../utils/Theme/colors.dart';
import '../../utils/constant.dart';

class CustomSalesDialog extends StatefulWidget {
  BillModel? bill;
  String numberOfBill = "";
  String customer = '';
  String store = '';
  String costCenter = '';
  bool isAdmin = false;

  CustomSalesDialog({
    super.key,
    required this.bill,
    required this.isAdmin,
    required this.customer,
    required this.store,
    required this.costCenter,
    required this.numberOfBill,
  });

  @override
  State<CustomSalesDialog> createState() => _CustomSalesDialogState();
}

class _CustomSalesDialogState extends State<CustomSalesDialog> {
  dialogContent(BuildContext context) {
    return Container(
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
      child: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(Icons.cancel),
                iconSize: 30,
                color: errorColor.withOpacity(0.8),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // To make the card compact
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.bill!.formatNumber!,
                        style: ConstantApp.getTextStyle(
                            context: context,
                            color: textColor,
                            size: 15,
                            fontWeight: FontWeight.w500),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    'Customer :'.tr,
                                    style: ConstantApp.getTextStyle(
                                        context: context,
                                        fontWeight: FontWeight.w500,
                                        color: textColor),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  widget.costCenter == ""
                                      ? const SizedBox()
                                      : Text(
                                          'Cost Center :'.tr,
                                          style: ConstantApp.getTextStyle(
                                              context: context,
                                              fontWeight: FontWeight.w500,
                                              color: textColor),
                                        ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    'Store :'.tr,
                                    style: ConstantApp.getTextStyle(
                                        context: context,
                                        fontWeight: FontWeight.w500,
                                        color: textColor),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    widget.customer,
                                    style: ConstantApp.getTextStyle(
                                        context: context,
                                        color: textColor,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  widget.costCenter == ""
                                      ? const SizedBox()
                                      : Text(
                                          widget.costCenter,
                                          style: ConstantApp.getTextStyle(
                                              context: context,
                                              color: textColor,
                                              fontWeight: FontWeight.w500),
                                        ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    widget.store,
                                    style: ConstantApp.getTextStyle(
                                        context: context,
                                        color: textColor,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    '${'Date'.tr}:',
                                    style: ConstantApp.getTextStyle(
                                        context: context,
                                        fontWeight: FontWeight.w500,
                                        color: textColor),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    "${'Pay Type'.tr} :",
                                    style: ConstantApp.getTextStyle(
                                        context: context,
                                        fontWeight: FontWeight.w500,
                                        color: textColor),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    "${'Sales Type'.tr} :",
                                    style: ConstantApp.getTextStyle(
                                        context: context,
                                        fontWeight: FontWeight.w500,
                                        color: textColor),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    DateFormat('dd/MM/yyyy hh:mm aaa')
                                        .format(widget.bill!.createdAt!)
                                        .toString(),
                                    style: ConstantApp.getTextStyle(
                                        context: context,
                                        color: textColor,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    widget.bill!.payType!,
                                    style: ConstantApp.getTextStyle(
                                        context: context,
                                        color: textColor,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    widget.bill!.salesType!,
                                    style: ConstantApp.getTextStyle(
                                        context: context,
                                        color: textColor,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 1,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                GetBuilder<OrderController>(builder: (controller) {
                  var order = controller.orderView.where((element) {
                    return element.billNum
                        .toString()
                        .toLowerCase()
                        .contains(widget.numberOfBill.toString().toLowerCase());
                  }).toList();

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: order.isEmpty
                        ? const SizedBox()
                        : SizedBox(
                            width: double.infinity,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Flexible(
                                            flex: 1,
                                            fit: FlexFit.tight,
                                            child: Text(
                                              'Name'.tr,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )),
                                        Flexible(
                                            flex: 1,
                                            fit: FlexFit.tight,
                                            child: Text(
                                              'QTY'.tr,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )),
                                        Flexible(
                                            flex: 1,
                                            fit: FlexFit.tight,
                                            child: Text(
                                              'Unit'.tr,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )),
                                        Flexible(
                                            flex: 1,
                                            fit: FlexFit.tight,
                                            child: Text(
                                              'Price'.tr,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )),
                                        Flexible(
                                            flex: 1,
                                            fit: FlexFit.tight,
                                            child: Center(
                                              child: Text(
                                                'Number of order'.tr,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            )),
                                        Flexible(
                                            flex: 1,
                                            fit: FlexFit.tight,
                                            child: Center(
                                              child: Text(
                                                'Nu.bill'.tr,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            )),
                                        Flexible(
                                            flex: 1,
                                            fit: FlexFit.tight,
                                            child: Center(
                                              child: Text(
                                                'Employee'.tr,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            )),
                                        Flexible(
                                            flex: 1,
                                            fit: FlexFit.tight,
                                            child: Text(
                                              'Date'.tr,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                                ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: order.length,
                                    itemBuilder: (context, index) {
                                      String proName = '';
                                      var product = controller.products
                                          .firstWhere((element) =>
                                              element.id ==
                                              order[index].itemId);
                                      if (product.type == 'variable') {
                                        proName =
                                            '${product.englishName}/${controller.allVariable.firstWhere((element) => element.id == order[index].variableId).name!}';
                                      } else {
                                        proName = product.englishName!;
                                      }

                                      return TempOrderReport(
                                        name: proName,
                                        ident: order[index].ident,
                                        price: order[index].price,
                                        qty: order[index].quantity,
                                        guest: order[index].guest,
                                        date: order[index].createdAt,
                                        numberOfOrder: order[index].serial,
                                        numberBill: order[index].billNum!,
                                        edit: false,
                                        close: () {},
                                        dec: () {},
                                        inc: () {},
                                        editPrice: () {},
                                        unitWidget: Text(controller.units
                                            .firstWhere((element) =>
                                                element.id ==
                                                order[index].unitId)
                                            .name),
                                        onTapName: () {},
                                        employeeWidget: Text(
                                            (order[index].employeeId ?? 0) == 0
                                                ? '-'
                                                : Get.find<InfoController>()
                                                    .employees
                                                    .firstWhere((element) =>
                                                        element.id ==
                                                        order[index].employeeId)
                                                    .englishName),
                                      );
                                    }),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30.0, vertical: 30),
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        SizedBox(
                                            width: 250,
                                            child: Divider(
                                              color:
                                                  primaryColor.withOpacity(0.5),
                                            )),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${'Sub total'.tr} :',
                                                  style:
                                                      ConstantApp.getTextStyle(
                                                          context: context,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: textColor),
                                                ),
                                                widget.bill!.discountAmount == 0 ? const SizedBox():    Text(
                                                  '${'Discount'.tr} :',
                                                  style:
                                                      ConstantApp.getTextStyle(
                                                          context: context,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: textColor),
                                                  textAlign: TextAlign.center,
                                                ),
                                                (widget.bill!.vat ?? 0) != 0
                                                    ? Text(
                                                        '${'Vat'.tr} :',
                                                        style: ConstantApp
                                                            .getTextStyle(
                                                                context:
                                                                    context,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color:
                                                                    textColor),
                                                      )
                                                    : const SizedBox(),
                                                const SizedBox(
                                                  height: 17,
                                                ),
                                                Text(
                                                  '${'Total'.tr} :',
                                                  style:
                                                      ConstantApp.getTextStyle(
                                                          context: context,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: textColor),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${(widget.bill!.total)!.toStringAsFixed(2)} ${'AED'.tr}",
                                                  style:
                                                      ConstantApp.getTextStyle(
                                                    context: context,
                                                  ),
                                                ),
                                                widget.bill!.discountAmount == 0 ? const SizedBox():    Text(
                                                  "${(widget.bill!.discountAmount)!.toStringAsFixed(2)} ${'AED'.tr}",
                                                  style:
                                                      ConstantApp.getTextStyle(
                                                    context: context,
                                                  ),
                                                ),
                                                (widget.bill!.vat ?? 0) != 0
                                                    ? Text(
                                                        "${widget.bill!.vat!.toStringAsFixed(2)}  ${'AED'.tr}",
                                                        style: ConstantApp
                                                            .getTextStyle(
                                                          context: context,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      )
                                                    : const SizedBox(),
                                                SizedBox(
                                                    width: 150,
                                                    child: Divider(
                                                      color: primaryColor
                                                          .withOpacity(0.5),
                                                    )),
                                                Text(
                                                  "${(widget.bill!.finalTotal)!.toStringAsFixed(2)} ${'AED'.tr}",
                                                  style:
                                                      ConstantApp.getTextStyle(
                                                    context: context,
                                                  ),
                                                ),
                                              ],
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
                  );
                }),
                const SizedBox(
                  height: 60,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }
}
