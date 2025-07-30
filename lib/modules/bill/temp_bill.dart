import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:intl/intl.dart';

import '../../../../utils/Theme/colors.dart';
import '../../utils/constant.dart';

class TempBill extends StatelessWidget {
  const TempBill(
      {required this.nameOfCustom,
        required this.id,
        required this.cashier,
        required this.numberOfBill,
        required this.payType,
        Key? key,
        required this.totalPrice,
        required this.discount,
        required this.discountType,
        required this.vat,
        required this.priceWithVat,
        required this.date,
        required this.disAmount,
        required this.total,
        required this.cashTotal,
        required this.visaTotal,
        required this.table,
        required this.hall,
        required this.deletePressed,
        required this.editPressed,
        required this.view,
        required this.type,
        required this.print,
        required this.edit,
        required this.store,
        required this.onTapNuBill,
        this.paid,
        this.tips,
        this.balance})
      : super(key: key);
  final int id;
  final String nameOfCustom;
  final String numberOfBill;
  final String payType;
  final String cashier;
  final double totalPrice;
  final double discount;
  final String discountType;
  final String store;
  final double vat;
  final double priceWithVat;
  final DateTime date;
  final double disAmount;
  final double? tips;
  final double total;
  final double cashTotal;
  final double visaTotal;
  final String table;
  final String hall;
  final String type;
  final String? paid;
  final String? balance;
  final Callback deletePressed;
  final Callback editPressed;
  final Callback view;
  final Callback print;
  final Callback onTapNuBill;
  final bool edit;

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd/MM/yyyy hh:mm aaa').format(date);
    return Card(
      elevation: 3,
      child: Row(
        children: [
          Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: InkWell(
                  onTap: onTapNuBill,
                  child: Text(
                    numberOfBill,
                    textAlign: TextAlign.center,
                    style: ConstantApp.getTextStyle(context: context, size: 7)
                        .copyWith(decoration: TextDecoration.underline),
                  ))),
          Flexible(
            flex: 37,
            child: Row(
              children: [
                Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: Text(
                      nameOfCustom,
                      textAlign: TextAlign.center,
                      style: ConstantApp.getTextStyle(
                          context: context, size: 7, color: secondaryColor),
                      maxLines: 2,
                    )),
                Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: Text(
                      payType.tr,
                      textAlign: TextAlign.center,
                      style: ConstantApp.getTextStyle(
                          context: context, size: 7, color: secondaryColor),
                      maxLines: 2,
                    )),
                Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: Text(
                      cashier,
                      textAlign: TextAlign.center,
                      style: ConstantApp.getTextStyle(
                          context: context, size: 7, color: secondaryColor),
                      maxLines: 2,
                    )),
                Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: Text(
                      totalPrice.toStringAsFixed(2),
                      textAlign: TextAlign.center,
                      style: ConstantApp.getTextStyle(
                          context: context, size: 7, color: secondaryColor),
                      maxLines: 2,
                    )),
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: Text(
                    discountType == '%'
                        ? '${(discount * 100 / totalPrice).toStringAsFixed(2)}%' ==
                        "NaN%"
                        ? "0.00%"
                        : '${(discount * 100 / totalPrice).toStringAsFixed(2)}%'
                        : '${discount.toStringAsFixed(2)} ${'AED'.tr}',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: ConstantApp.getTextStyle(
                        context: context, size: 7, color: secondaryColor),
                  ),
                ),
                Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: Text(
                      disAmount.toStringAsFixed(2),
                      textAlign: TextAlign.center,
                      style: ConstantApp.getTextStyle(
                          context: context, size: 7, color: secondaryColor),
                      maxLines: 2,
                    )),
               Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: Text(
                     vat == 0 ? '-' :  vat.toStringAsFixed(2),
                      textAlign: TextAlign.center,
                      style: ConstantApp.getTextStyle(
                          context: context, size: 7, color: secondaryColor),
                      maxLines: 2,
                    )),
                Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: Text(
                      priceWithVat.toStringAsFixed(2),
                      textAlign: TextAlign.center,
                      style: ConstantApp.getTextStyle(
                          context: context, size: 7, color: secondaryColor),
                      maxLines: 2,
                    )),
                Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: Text(
                      formattedDate,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: ConstantApp.getTextStyle(
                          context: context, size: 7, color: secondaryColor),
                    )),
                Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: Center(
                        child: Text(
                          hall == 'TakeAway' || hall == 'Delivery'
                              ? hall.tr
                              : table.tr,
                          textAlign: TextAlign.center,
                          style: ConstantApp.getTextStyle(
                              context: context, size: 7, color: secondaryColor),
                          maxLines: 2,
                        ))),
                Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: Center(
                        child: Text(
                          hall == 'TakeAway' ||
                              hall == 'Delivery' ||
                              hall == 'SALES'
                              ? hall.tr
                              : "${"Dine In".tr}\\$hall",
                          textAlign: TextAlign.center,
                          style: ConstantApp.getTextStyle(
                              context: context, size: 7, color: secondaryColor),
                          maxLines: 2,
                        ))),
                Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: Center(
                        child: type == 'sales'
                            ? Text(
                          type.tr,
                          textAlign: TextAlign.center,
                          style: ConstantApp.getTextStyle(
                              context: context,
                              size: 7,
                              color: secondaryColor),
                          maxLines: 2,
                        )
                            : Text(type.tr,
                            style: ConstantApp.getTextStyle(
                                context: context,
                                size: 7,
                                color: errorColor),
                            textAlign: TextAlign.center))),
                Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: Center(
                        child: Text(
                          paid!,
                          textAlign: TextAlign.center,
                          style: ConstantApp.getTextStyle(
                              context: context, size: 7, color: secondaryColor),
                          maxLines: 2,
                        ))),
                Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: Center(
                        child: Text(
                          payType == "Credit"
                              ? (balance == '-0.00' ? '0.00' : balance!)
                              : "0.0",
                          textAlign: TextAlign.center,
                          style: ConstantApp.getTextStyle(
                              context: context, size: 7, color: secondaryColor),
                          maxLines: 2,
                        ))),
                Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: Center(
                        child: Text(
                          payType != "Credit"
                              ? (balance == '-0.00' ? '0.00' : balance!)
                              : "0.0",
                          textAlign: TextAlign.center,
                          style: ConstantApp.getTextStyle(
                              context: context, size: 7, color: secondaryColor),
                          maxLines: 2,
                        ))),
                Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: Center(
                        child: Text(
                          (tips ?? 0).toStringAsFixed(2),
                          textAlign: TextAlign.center,
                          style: ConstantApp.getTextStyle(
                              context: context, size: 7, color: secondaryColor),
                          maxLines: 2,
                        ))),
                Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: Center(
                        child: Text(
                          (cashTotal).toStringAsFixed(2),
                          textAlign: TextAlign.center,
                          style: ConstantApp.getTextStyle(
                              context: context, size: 7, color: secondaryColor),
                          maxLines: 2,
                        ))),
                Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: Center(
                        child: Text(
                          (visaTotal).toStringAsFixed(2),
                          textAlign: TextAlign.center,
                          style: ConstantApp.getTextStyle(
                              context: context, size: 7, color: secondaryColor),
                          maxLines: 2,
                        ))),
                edit
                    ? Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: PopupMenuButton(
                      tooltip: "Action".tr,
                      icon: const Icon(Icons.more_vert_rounded),
                      itemBuilder: (BuildContext context) {
                        return <PopupMenuItem<Widget>>[
                          PopupMenuItem<Widget>(
                            onTap: print,
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
                            onTap: editPressed,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.edit,
                                  color: primaryColor,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(child: Text("Edit".tr)),
                              ],
                            ),
                          ),
                          PopupMenuItem<Widget>(
                            onTap: deletePressed,
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(child: Text("Delete".tr)),
                              ],
                            ),
                          ),
                        ];
                      },
                    ))
                    : const SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
