// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:intl/intl.dart';

import '../../utils/Theme/colors.dart';
import '../../utils/constant.dart';


class TempOrderReport extends StatelessWidget {
  TempOrderReport(
      {required this.name,
        required this.ident,
        required this.edit,
        required this.price,
        required this.qty,
        required this.guest,
        required this.close,
        required this.dec,
        required this.inc,
        this.numberOfOrder,
        required this.editPrice,
        required this.unitWidget,
        required this.onTapName,
        this.date,
        this.employeeWidget,
        Key? key,
        required this.numberBill})
      : super(key: key);
  final String ident;
  final String name;
  final double qty;
  final String guest;
  final String numberBill;
  final double price;
  int? numberOfOrder;
  DateTime? date;
  Callback close;
  Callback inc;
  Callback dec;
  Callback onTapName;
  Callback editPrice;
  Widget unitWidget ;
  Widget? employeeWidget ;

  bool edit;

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('E,d MMM yyyy HH:mm:ss').format(date!);
    return Card(
      color:qty.isNegative?errorColor: const Color(0xFFf1f1f1),
      child: Row(
        children: [
          Flexible(flex: 1, fit: FlexFit.tight, child: Text(name,style: ConstantApp.getTextStyle(context: context,color: textColor),)),
          edit
              ? Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: Row(
                children: [
                  Expanded(child: IconButton(onPressed: inc, icon: const Icon(Icons.add))),
                  Text('$qty'),
                  Expanded(child: IconButton(onPressed: dec, icon: const Icon(Icons.remove))),
                ],
              ))
              :
          Flexible(
              flex: 1, fit: FlexFit.tight, child: Text(qty.toString())),
          Flexible(
              flex: 1, fit: FlexFit.tight, child: unitWidget),
          edit
              ?  Flexible(flex: 1, fit: FlexFit.tight, child: GestureDetector(
            onTap:editPrice ,
            child: Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // ignore: deprecated_member_use
                  Expanded(child: Text('$price' , textScaleFactor: price.toString().length<10 ? 1 : 0.7 )),
                  Icon(Icons.edit , size: price.toString().length<10 ? 20 : 15,)
                ],
              ),
            ),
          )):Flexible(
              flex: 1, fit: FlexFit.tight, child: Text(price.toString())),
          Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Center(child: Text('$numberOfOrder'))),
          edit?const SizedBox():  Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Center(child: Text(numberBill))),
          Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Center(child: employeeWidget)),
          !edit?const SizedBox():  Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Center(child: Text((qty*price).toStringAsFixed(2)))),
          edit?const SizedBox(): Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Text(
                formattedDate,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 11),
              )),

          edit
              ? Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Row(
                children: [
                  IconButton(
                    icon:  const Icon(
                      Icons.close,
                      color: Colors.red,
                    ),
                    tooltip: 'Remove'.tr,
                    onPressed: close,
                  )
                ],
              ))
              : const SizedBox(),
        ],
      ),
    );
  }
}
