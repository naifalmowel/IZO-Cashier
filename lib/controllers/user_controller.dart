import 'dart:convert';
import 'package:cashier_app/controllers/order_controller.dart';
import 'package:cashier_app/models/bill_model.dart';
import 'package:cashier_app/models/driver_model.dart';
import 'package:cashier_app/models/permission.dart';
import 'package:cashier_app/modules/login/login.dart';
import 'package:cashier_app/modules/qr_code/first_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cashier_app/models/user_model.dart';
import 'package:cashier_app/server/dio_services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/app_db.dart';
import '../database/app_db_controller.dart';
import '../global_widgets/drop_down_button_users.dart';
import '../utils/Theme/colors.dart';
import '../utils/constant.dart';
import '../utils/scaled_dimensions.dart';
import 'info_controllers.dart';

class UserController extends GetxController {
  RxBool isLogin = false.obs;
  RxBool isLogin1 = false.obs;
  RxBool loading = false.obs;
  RxList<UserModel> allUsers = RxList([]);
  RxList<UserModel> users = RxList([]);
  RxList<DriverModel> drivers = RxList([]);
  RxBool show1000 = true.obs;
  RxBool show500 = true.obs;
  RxBool show200 = true.obs;
  RxBool show100 = true.obs;
  RxBool show50 = true.obs;
  RxBool show20 = true.obs;
  RxBool show10 = true.obs;
  RxBool show5 = true.obs;
  RxBool show2 = true.obs;
  RxBool show1 = true.obs;
  RxBool show050 = true.obs;
  RxBool show025 = true.obs;
  RxBool show010 = true.obs;
  RxBool show005 = true.obs;
  RxBool show001 = true.obs;
  RxBool obscure = true.obs;
  RxInt usersId = 1.obs;
  Rx<CloseBoxSettingData> closeBoxSettingData = CloseBoxSettingData(
    id: 1,
    show1000: true,
    show500: true,
    show200: true,
    show100: true,
    show50: true,
    show20: true,
    show10: true,
    show5: true,
    show2: false,
    show1: true,
    show050: true,
    show025: true,
    show010: false,
    show005: false,
    show001: false,
    createAt: DateTime.now(),
  ).obs;
  RxString fromAcc = RxString('');
  RxString toAcc = RxString('');
  RxDouble balance = RxDouble(0.0);
  Rx<PermissionModel> permission =PermissionModel(
      cashDrawer: false,
      addContact: false,
      closeBox: false,
      choseOfferPrice: false,
      choseWholePrice: false,
      choseMinPrice: false,
      choseCostPrice: false,
      viewDriver: false,
      discount: false,
      showEmployeePos: false,
      removeItemOrder: false,
      addSales: false,
      deleteSales: false,
      editSales: false,
      returnSales: false,
      viewSales: false,
      printPage: false,
      tableChange: false,
      voidPer: false,
      userId: 0, editPrice: false,
  ).obs;
TextEditingController textEditingController = TextEditingController();
TextEditingController password = TextEditingController();
  Future<RxList<UserModel>> getUsers() async {
    isLogin1(true);

    users.clear();
    allUsers.clear();
    DioClient dio = DioClient();
    try {
      final response = await dio.getDio(path: '/users');
      if (response.statusCode == 200) {
        var allUser = jsonDecode(response.data);
        for (var i in allUser['users']) {
          allUsers.add(UserModel(
            id: int.tryParse(i['id']) ?? 0,
            name: i['name'],
            password: i['password'],
            type: i['type'],
            isActive: true,
            discount: double.tryParse(i['discount'].toString()) ?? 0.0,
          ));
        }
        users.value = allUsers.where((p0) => p0.id > 0).toList();
        Get.find<InfoController>().isServerConnect.value = true;
      } else {
        Get.find<InfoController>().isServerConnect.value = false;
      }
      isLogin1(false);
    } catch (e) {
      Get.find<InfoController>().isServerConnect.value = false;
      isLogin1(false);
    }
    return allUsers;
  }

  Future<void> getDriver() async {
    drivers.clear();
    DioClient dio = DioClient();
    try {
      final response = await dio.getDio(path: '/driver');

      if (response.statusCode == 200) {
        var allDriver = response.data;
        for (var i in allDriver['driver']) {
          drivers.add(DriverModel(
            id: int.tryParse(i['id']) ?? 0,
            name: i['name'],
            mobile: i['mobile'],
            createdAt: DateTime.tryParse(i['createdAt']) ?? DateTime.now(),
            vehicle: i['vehicle'],
            vehicleNo: i['vehicleNo'],
          ));
        }
      } else {}
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<pw.Document> printUsersReport({
    required List<BillModel> list,
    required String printerName,
    required int user,
    required bool box,
    required bool cat,
    required bool item,
  }) async {
    final ttf = await fontFromAssetBundle('assets/fonts/Dubai-Regular.ttf');
    final doc = pw.Document();
    final prefs = await SharedPreferences.getInstance();
    double totalTakeaway = 0;
    double totalDelivery = 0;
    double totalTable = 0;
    double cashAmount = 0.0;
    double visaAmount = 0.0;
    double debitAmount = 0.0;
    double disAmount = 0.0;
    double subTotal = 0.0;
    double returnTotal = 0.0;
    double vat = 0.0;
    double tips = 0.0;
    Map<String, List<double>> mapProduct = {};
    Map<String?, List<double>> mapCat = {};
    var controller = Get.find<OrderController>();
    await controller.getAllOrders();
    await controller.getAllProducts();
    var allOrder = controller.orderView;

    var allItems = controller.products;

    var allIVariable = controller.allVariable;
    var allCat = controller.subCategories;
    for (var i in list) {
      i.salesType == 'sales'
          ? cashAmount += i.cashAmount!
          : cashAmount -= i.cashAmount!;
      i.salesType == 'sales'
          ? visaAmount += i.visaAmount!
          : visaAmount -= i.visaAmount!;
      i.salesType == 'sales'
          ? disAmount += i.discountAmount ?? 0
          : disAmount -= i.discountAmount ?? 0;
      i.salesType == 'sales' ? subTotal += (i.total ?? 0) : null;
      i.salesType == 'sales' ? vat += (i.vat ?? 0) : vat -= (i.vat ?? 0);
      i.salesType == 'sales' ? tips += (i.tips ?? 0) : tips -= (i.tips ?? 0);
      i.salesType == 'returned' ? returnTotal += i.total ?? 0 : null;
      if (i.hall == 'TakeAway') {
        i.salesType == 'sales'
            ? totalTakeaway += i.finalTotal ?? 0
            : totalTakeaway -= i.finalTotal ?? 0;
      } else if (i.hall == 'Delivery') {
        i.salesType == 'sales'
            ? totalDelivery += i.finalTotal ?? 0
            : totalDelivery -= i.finalTotal ?? 0;
      } else {
        i.salesType == 'sales'
            ? totalTable += i.finalTotal ?? 0
            : totalTable -= i.finalTotal ?? 0;
      }
      if (i.payType == 'Credit') {
        debitAmount += i.finalTotal ?? 0;
      }
      for (var j in allOrder) {
        if (j.billNum == i.formatNumber) {
          if (mapProduct.keys.contains('${j.itemId}:${j.variableId}')) {
            mapProduct['${j.itemId}:${j.variableId}'] = [
              mapProduct['${j.itemId}:${j.variableId}']![0] +
                  (i.salesType == 'sales' ? j.quantity : -j.quantity),
              mapProduct['${j.itemId}:${j.variableId}']![1] +
                  ((i.salesType == 'sales' ? j.quantity : -j.quantity) *
                      j.price)
            ];
          } else {
            mapProduct['${j.itemId}:${j.variableId}'] = [
              (i.salesType == 'sales' ? j.quantity : -j.quantity),
              ((i.salesType == 'sales' ? j.quantity : -j.quantity) * j.price)
            ];
          }
          for (var k in allItems) {
            if (k.id == j.itemId) {
              if (mapCat.keys.contains(k.subId)) {
                mapCat[k.subId] = [
                  mapCat[k.subId]![0] +
                      (i.salesType == 'sales' ? j.quantity : -j.quantity),
                  mapCat[k.subId]![1] +
                      ((i.salesType == 'sales' ? j.quantity : -j.quantity) *
                          j.price)
                ];
              } else {
                mapCat[k.subId] = [
                  (i.salesType == 'sales' ? j.quantity : -j.quantity),
                  ((i.salesType == 'sales' ? j.quantity : -j.quantity) *
                      j.price)
                ];
              }
            }
          }
        }
      }
    }
    var allQ = 0.0;
    var allP = 0.0;
    for (var i in mapProduct.keys) {
      allQ += mapProduct[i]![0];
      allP += mapProduct[i]![1];
    }
    var allQCat = 0.0;
    var allPCat = 0.0;
    for (var i in mapCat.keys) {
      allQCat += mapCat[i]![0];
      allPCat += mapCat[i]![1];
    }
    var mapProductSort = Map.fromEntries(mapProduct.entries.toList()
      ..sort((e1, e2) => e2.value[0].compareTo(e1.value[0])));
    var mapCatSort = Map.fromEntries(mapCat.entries.toList()
      ..sort((e1, e2) => e2.value[0].compareTo(e1.value[0])));

    await Get.find<InfoController>().getCompanyInfo();
    await Get.find<InfoController>().getAllTaxesSetting();
    await Get.find<InfoController>().getAllTaxes();
    var tax = Get.find<InfoController>().taxesSetting;
    var companyInfo = Get.find<InfoController>().companyInfo;
    final image = companyInfo?.companyImage == null
        ? await imageFromAssetBundle('assets/images/whiteBackground.jpg')
        : await flutterImageProvider(MemoryImage(companyInfo!.companyImage!));
    doc.addPage(pw.Page(
        pageFormat: PdfPageFormat.roll80,
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.only(right: 10),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                companyInfo!.companyImage == null
                    ? pw.SizedBox()
                    : pw.Image(image, width: 100, height: 100),
                pw.Text(
                  companyInfo.companyName ?? '',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.normal,
                      fontSize: 20,
                      font: ttf),
                ),
                pw.Text(
                  'Address :  ${companyInfo.address}',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.normal,
                      fontSize: 10,
                      font: ttf),
                ),
                companyInfo.anotherAddress == "" ||
                        companyInfo.anotherAddress == null
                    ? pw.SizedBox()
                    : pw.Text(
                        'Another Address :  ${companyInfo.anotherAddress}',
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.normal,
                            fontSize: 10,
                            font: ttf),
                      ),
                pw.Text(
                  ' Mobile :  ${companyInfo.number}',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.normal,
                      fontSize: 10,
                      font: ttf),
                ),
                companyInfo.additionalNumber == "" ||
                        companyInfo.additionalNumber == null
                    ? pw.SizedBox()
                    : pw.Text(
                        'Another Mobile :  ${companyInfo.additionalNumber}',
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.normal,
                            fontSize: 10,
                            font: ttf),
                      ),
                tax.isEmpty
                    ? pw.SizedBox()
                    : pw.Text(
                        'TRN : ${tax.last.taxNumber} ',
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.normal,
                            fontSize: 10,
                            font: ttf),
                      ),
                pw.SizedBox(height: 10),
                pw.Text(
                  'Sales Report',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 18, font: ttf),
                ),
                pw.SizedBox(height: 10), // pw.Row(children: [
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('By:',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal,
                              fontSize: 10,
                              font: ttf)),
                      pw.Text(prefs.getString('name')!,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal,
                              fontSize: 10,
                              font: ttf))
                    ]),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('USER :',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal,
                              fontSize: 10,
                              font: ttf)),
                      pw.Text(prefs.getString('name') ?? '',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal,
                              fontSize: 10,
                              font: ttf))
                    ]),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('From Date :',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal,
                              fontSize: 10,
                              font: ttf)),
                      pw.Text(
                          DateFormat('dd-MM-yyyy hh:mm aaa')
                              .format(list.first.createdAt ?? DateTime.now()),
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal,
                              fontSize: 10,
                              font: ttf))
                    ]),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('To Date :',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal,
                              fontSize: 10,
                              font: ttf)),
                      pw.Text(
                          DateFormat('dd-MM-yyyy hh:mm aaa')
                              .format(list.last.createdAt!),
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal,
                              fontSize: 10,
                              font: ttf))
                    ]),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('From Invoice :',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal,
                              fontSize: 10,
                              font: ttf)),
                      pw.Text(list.first.formatNumber.toString(),
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal,
                              fontSize: 10,
                              font: ttf))
                    ]),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('To Invoice :',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal,
                              fontSize: 10,
                              font: ttf)),
                      pw.Text(list.last.formatNumber.toString(),
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal,
                              fontSize: 10,
                              font: ttf))
                    ]),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Number Of Bill :',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal,
                              fontSize: 10,
                              font: ttf)),
                      pw.Text(
                          list
                              .where((element) =>
                                  element.salesType!.contains('sale'))
                              .length
                              .toString(),
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal,
                              fontSize: 10,
                              font: ttf))
                    ]),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Number Of Returned :',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal,
                              fontSize: 10,
                              font: ttf)),
                      pw.Text(
                          list
                              .where((element) =>
                                  !element.salesType!.contains('sale'))
                              .length
                              .toString(),
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal,
                              fontSize: 10,
                              font: ttf))
                    ]),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Cash :',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal,
                              fontSize: 10,
                              font: ttf)),
                      pw.Text(cashAmount.toStringAsFixed(2),
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal,
                              fontSize: 10,
                              font: ttf))
                    ]),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Visa :',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal,
                              fontSize: 10,
                              font: ttf)),
                      pw.Text(visaAmount.toStringAsFixed(2),
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal,
                              fontSize: 10,
                              font: ttf))
                    ]),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Grand Total :',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal,
                              fontSize: 10,
                              font: ttf)),
                      pw.Text((cashAmount + visaAmount).toStringAsFixed(2),
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal,
                              fontSize: 10,
                              font: ttf))
                    ]),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Debits :',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal,
                              fontSize: 10,
                              font: ttf)),
                      pw.Text(debitAmount.toStringAsFixed(2),
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal,
                              fontSize: 10,
                              font: ttf))
                    ]),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Subtotal :',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal,
                              fontSize: 10,
                              font: ttf)),
                      pw.Text(subTotal.toStringAsFixed(2),
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal,
                              fontSize: 10,
                              font: ttf))
                    ]),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Tips :',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal,
                              fontSize: 10,
                              font: ttf)),
                      pw.Text(tips.toStringAsFixed(2),
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal,
                              fontSize: 10,
                              font: ttf))
                    ]),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Returned :',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal,
                              fontSize: 10,
                              font: ttf)),
                      pw.Text((returnTotal).toStringAsFixed(2),
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal,
                              fontSize: 10,
                              font: ttf))
                    ]),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Discount :',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal,
                              fontSize: 10,
                              font: ttf)),
                      pw.Text(disAmount.toStringAsFixed(2),
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal,
                              fontSize: 10,
                              font: ttf))
                    ]),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Vat 5% :',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal,
                              fontSize: 10,
                              font: ttf)),
                      pw.Text(vat.toStringAsFixed(2),
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal,
                              fontSize: 10,
                              font: ttf))
                    ]),
                pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Net Sales',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 20,
                              font: ttf)),
                      pw.Text(
                          (subTotal - disAmount - returnTotal + vat + tips)
                              .toStringAsFixed(2),
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 20,
                              font: ttf))
                    ]),
                pw.Column(children: [
                  ConstantApp.appType.name == "REST"
                      ? pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                              pw.Text('Tables :',
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.normal,
                                      fontSize: 10,
                                      font: ttf)),
                              pw.Text(totalTable.toStringAsFixed(2),
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.normal,
                                      fontSize: 10,
                                      font: ttf))
                            ])
                      : pw.SizedBox(),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                            ConstantApp.appType.name == "REST"
                                ? 'TakeAway :'
                                : "Sales :",
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.normal,
                                fontSize: 10,
                                font: ttf)),
                        pw.Text(totalTakeaway.toStringAsFixed(2),
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.normal,
                                fontSize: 10,
                                font: ttf))
                      ]),
                  ConstantApp.appType.name == "REST"
                      ? pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                              pw.Text('Delivery :',
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.normal,
                                      fontSize: 10,
                                      font: ttf)),
                              pw.Text(totalDelivery.toStringAsFixed(2),
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.normal,
                                      fontSize: 10,
                                      font: ttf))
                            ])
                      : pw.SizedBox(),
                ]),
                pw.SizedBox(height: 10),
                pw.Divider(
                    thickness: 2,
                    borderStyle: const pw.BorderStyle(pattern: [1, 2])),
                !box
                    ? pw.SizedBox()
                    : pw.Column(children: [
                        pw.Container(
                            child: pw.Row(
                                mainAxisAlignment:
                                    pw.MainAxisAlignment.spaceBetween,
                                children: [
                                  pw.Expanded(
                                    child: pw.Container(
                                      height: 30,
                                      padding: const pw.EdgeInsets.symmetric(
                                          horizontal: 5),
                                      decoration: const pw.BoxDecoration(
                                          border: pw.Border.symmetric(
                                              vertical: pw.BorderSide(
                                                  color: PdfColors.black))),
                                      child: pw.Center(
                                          child: pw.Text('BOX',
                                              style: pw.TextStyle(
                                                  fontWeight:
                                                      pw.FontWeight.bold,
                                                  fontSize: 15,
                                                  font: ttf))),
                                    ),
                                  ),
                                  pw.Expanded(
                                      child: pw.Container(
                                          height: 30,
                                          padding:
                                              const pw.EdgeInsets.symmetric(
                                                  horizontal: 5),
                                          decoration: const pw.BoxDecoration(
                                              border: pw.Border.symmetric(
                                                  vertical: pw.BorderSide(
                                                      color: PdfColors.black))),
                                          child: pw.Center(
                                              child: pw.Text('AMOUNT',
                                                  style: pw.TextStyle(
                                                      fontWeight:
                                                          pw.FontWeight.bold,
                                                      fontSize: 15,
                                                      font: ttf)))))
                                ]),
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(color: PdfColors.black),
                            )),
                      ]),

                !box ? pw.SizedBox() : pw.SizedBox(height: 10),
                !box
                    ? pw.SizedBox()
                    : pw.Container(
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(color: PdfColors.black),
                        ),
                        child: pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Expanded(
                                child: pw.Container(
                                  height: 30,
                                  padding: const pw.EdgeInsets.symmetric(
                                      horizontal: 5),
                                  decoration: const pw.BoxDecoration(
                                      border: pw.Border.symmetric(
                                          vertical: pw.BorderSide(
                                              color: PdfColors.black))),
                                  child: pw.Center(
                                      child: pw.Text('TOTAL',
                                          style: pw.TextStyle(
                                              fontWeight: pw.FontWeight.normal,
                                              fontSize: 10,
                                              font: ttf))),
                                ),
                              ),
                              pw.Expanded(
                                child: pw.Container(
                                  height: 30,
                                  padding: const pw.EdgeInsets.symmetric(
                                      horizontal: 5),
                                  decoration: const pw.BoxDecoration(
                                      border: pw.Border.symmetric(
                                          vertical: pw.BorderSide(
                                              color: PdfColors.black))),
                                  child: pw.Center(
                                      child: pw.Text(
                                          (cashAmount + visaAmount)
                                              .toStringAsFixed(2),
                                          style: pw.TextStyle(
                                              fontWeight: pw.FontWeight.normal,
                                              fontSize: 10,
                                              font: ttf))),
                                ),
                              ),
                            ])),
                !box ? pw.SizedBox() : pw.SizedBox(height: 10),
                !box
                    ? pw.SizedBox()
                    : pw.Divider(
                        thickness: 2,
                        borderStyle: const pw.BorderStyle(pattern: [1, 2])),
                !cat
                    ? pw.SizedBox()
                    : pw.Text(
                        'Sales By Category',
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 12,
                            font: ttf),
                      ),

                !cat
                    ? pw.SizedBox()
                    : pw.Column(children: [
                        pw.Container(
                          decoration: pw.BoxDecoration(
                            border: pw.Border.all(color: PdfColors.black),
                          ),
                          child: pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Expanded(
                                  child: pw.Container(
                                    height: 30,
                                    padding: const pw.EdgeInsets.symmetric(
                                        horizontal: 5),
                                    decoration: const pw.BoxDecoration(
                                        border: pw.Border.symmetric(
                                            vertical: pw.BorderSide(
                                                color: PdfColors.black))),
                                    child: pw.Center(
                                        child: pw.Text('CATEGORY',
                                            style: pw.TextStyle(
                                                fontWeight: pw.FontWeight.bold,
                                                fontSize: 11,
                                                font: ttf))),
                                  ),
                                ),
                                pw.Expanded(
                                  child: pw.Container(
                                    height: 30,
                                    padding: const pw.EdgeInsets.symmetric(
                                        horizontal: 5),
                                    decoration: const pw.BoxDecoration(
                                        border: pw.Border.symmetric(
                                            vertical: pw.BorderSide(
                                                color: PdfColors.black))),
                                    child: pw.Center(
                                        child: pw.Text('QTY',
                                            style: pw.TextStyle(
                                                fontWeight: pw.FontWeight.bold,
                                                fontSize: 11,
                                                font: ttf))),
                                  ),
                                ),
                                pw.Expanded(
                                  child: pw.Container(
                                    height: 30,
                                    padding: const pw.EdgeInsets.symmetric(
                                        horizontal: 5),
                                    decoration: const pw.BoxDecoration(
                                        border: pw.Border.symmetric(
                                            vertical: pw.BorderSide(
                                                color: PdfColors.black))),
                                    child: pw.Center(
                                        child: pw.Text('AMOUNT',
                                            style: pw.TextStyle(
                                                fontWeight: pw.FontWeight.bold,
                                                fontSize: 11,
                                                font: ttf))),
                                  ),
                                ),
                              ]),
                        ),
                        pw.ListView.builder(
                            itemBuilder: (context, index) {
                              var key = mapCatSort.keys.elementAt(index);
                              var name = allCat
                                  .firstWhere(
                                      (element) => element.id.toString() == key)
                                  .englishName;
                              return pw.Container(
                                  decoration: pw.BoxDecoration(
                                    border:
                                        pw.Border.all(color: PdfColors.black),
                                  ),
                                  child: pw.Row(
                                      mainAxisAlignment:
                                          pw.MainAxisAlignment.spaceBetween,
                                      children: [
                                        pw.Expanded(
                                          child: pw.Container(
                                            height: 30,
                                            padding:
                                                const pw.EdgeInsets.symmetric(
                                                    horizontal: 5),
                                            decoration: const pw.BoxDecoration(
                                                border: pw.Border.symmetric(
                                                    vertical: pw.BorderSide(
                                                        color:
                                                            PdfColors.black))),
                                            child: pw.Center(
                                                child: pw.Text(name!,
                                                    style: pw.TextStyle(
                                                        fontWeight: pw
                                                            .FontWeight.normal,
                                                        fontSize: 10,
                                                        font: ttf))),
                                          ),
                                        ),
                                        pw.Expanded(
                                          child: pw.Container(
                                            height: 30,
                                            padding:
                                                const pw.EdgeInsets.symmetric(
                                                    horizontal: 5),
                                            decoration: const pw.BoxDecoration(
                                                border: pw.Border.symmetric(
                                                    vertical: pw.BorderSide(
                                                        color:
                                                            PdfColors.black))),
                                            child: pw.Center(
                                                child: pw.Text(
                                                    mapCatSort[key]![0]
                                                        .toStringAsFixed(2),
                                                    style: pw.TextStyle(
                                                        fontWeight: pw
                                                            .FontWeight.normal,
                                                        fontSize: 10,
                                                        font: ttf))),
                                          ),
                                        ),
                                        pw.Expanded(
                                          child: pw.Container(
                                            height: 30,
                                            padding:
                                                const pw.EdgeInsets.symmetric(
                                                    horizontal: 5),
                                            decoration: const pw.BoxDecoration(
                                                border: pw.Border.symmetric(
                                                    vertical: pw.BorderSide(
                                                        color:
                                                            PdfColors.black))),
                                            child: pw.Center(
                                                child: pw.Text(
                                                    mapCatSort[key]![1]
                                                        .toStringAsFixed(2),
                                                    style: pw.TextStyle(
                                                        fontWeight: pw
                                                            .FontWeight.normal,
                                                        fontSize: 10,
                                                        font: ttf))),
                                          ),
                                        ),
                                      ]));
                            },
                            itemCount: mapCatSort.length)
                      ]),
                !cat ? pw.SizedBox() : pw.SizedBox(height: 10),
                !cat
                    ? pw.SizedBox()
                    : pw.Container(
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(color: PdfColors.black),
                        ),
                        child: pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Expanded(
                                child: pw.Container(
                                  height: 30,
                                  padding: const pw.EdgeInsets.symmetric(
                                      horizontal: 5),
                                  decoration: const pw.BoxDecoration(
                                      border: pw.Border.symmetric(
                                          vertical: pw.BorderSide(
                                              color: PdfColors.black))),
                                  child: pw.Center(
                                      child: pw.Text('ALL',
                                          style: pw.TextStyle(
                                              fontWeight: pw.FontWeight.normal,
                                              fontSize: 10,
                                              font: ttf))),
                                ),
                              ),
                              pw.Expanded(
                                child: pw.Container(
                                  height: 30,
                                  padding: const pw.EdgeInsets.symmetric(
                                      horizontal: 5),
                                  decoration: const pw.BoxDecoration(
                                      border: pw.Border.symmetric(
                                          vertical: pw.BorderSide(
                                              color: PdfColors.black))),
                                  child: pw.Center(
                                      child: pw.Text(allQCat.toStringAsFixed(2),
                                          style: pw.TextStyle(
                                              fontWeight: pw.FontWeight.normal,
                                              fontSize: 10,
                                              font: ttf))),
                                ),
                              ),
                              pw.Expanded(
                                child: pw.Container(
                                  height: 30,
                                  padding: const pw.EdgeInsets.symmetric(
                                      horizontal: 5),
                                  decoration: const pw.BoxDecoration(
                                      border: pw.Border.symmetric(
                                          vertical: pw.BorderSide(
                                              color: PdfColors.black))),
                                  child: pw.Center(
                                      child: pw.Text(allPCat.toStringAsFixed(2),
                                          style: pw.TextStyle(
                                              fontWeight: pw.FontWeight.normal,
                                              fontSize: 10,
                                              font: ttf))),
                                ),
                              ),
                            ])),
                !cat ? pw.SizedBox() : pw.SizedBox(height: 10),
                !cat
                    ? pw.SizedBox()
                    : pw.Divider(
                        thickness: 2,
                        borderStyle: const pw.BorderStyle(pattern: [1, 2])),
                pw.Text(
                  'Sales By Items',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 12, font: ttf),
                ),
                item
                    ? pw.SizedBox()
                    : pw.Column(children: [
                        pw.Container(
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(color: PdfColors.black),
                            ),
                            child: pw.Row(
                                mainAxisAlignment:
                                    pw.MainAxisAlignment.spaceBetween,
                                children: [
                                  pw.Expanded(
                                    child: pw.Container(
                                      height: 30,
                                      padding: const pw.EdgeInsets.symmetric(
                                          horizontal: 5),
                                      decoration: const pw.BoxDecoration(
                                          border: pw.Border.symmetric(
                                              vertical: pw.BorderSide(
                                                  color: PdfColors.black))),
                                      child: pw.Center(
                                          child: pw.Text('ITEM',
                                              style: pw.TextStyle(
                                                  fontWeight:
                                                      pw.FontWeight.bold,
                                                  fontSize: 11,
                                                  font: ttf))),
                                    ),
                                  ),
                                  pw.Expanded(
                                    child: pw.Container(
                                      height: 30,
                                      padding: const pw.EdgeInsets.symmetric(
                                          horizontal: 5),
                                      decoration: const pw.BoxDecoration(
                                          border: pw.Border.symmetric(
                                              vertical: pw.BorderSide(
                                                  color: PdfColors.black))),
                                      child: pw.Center(
                                          child: pw.Text('QTY',
                                              style: pw.TextStyle(
                                                  fontWeight:
                                                      pw.FontWeight.bold,
                                                  fontSize: 11,
                                                  font: ttf))),
                                    ),
                                  ),
                                  pw.Expanded(
                                    child: pw.Container(
                                      height: 30,
                                      padding: const pw.EdgeInsets.symmetric(
                                          horizontal: 5),
                                      decoration: const pw.BoxDecoration(
                                          border: pw.Border.symmetric(
                                              vertical: pw.BorderSide(
                                                  color: PdfColors.black))),
                                      child: pw.Center(
                                          child: pw.Text('AMOUNT',
                                              style: pw.TextStyle(
                                                  fontWeight:
                                                      pw.FontWeight.bold,
                                                  fontSize: 11,
                                                  font: ttf))),
                                    ),
                                  ),
                                ])),
                        pw.Container(
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(color: PdfColors.black),
                            ),
                            child: pw.Row(
                                mainAxisAlignment:
                                    pw.MainAxisAlignment.spaceBetween,
                                children: [
                                  pw.Expanded(
                                    child: pw.Container(
                                      height: 30,
                                      padding: const pw.EdgeInsets.symmetric(
                                          horizontal: 5),
                                      decoration: const pw.BoxDecoration(
                                          border: pw.Border.symmetric(
                                              vertical: pw.BorderSide(
                                                  color: PdfColors.black))),
                                      child: pw.Center(
                                          child: pw.Text('ALL',
                                              style: pw.TextStyle(
                                                  fontWeight:
                                                      pw.FontWeight.normal,
                                                  fontSize: 10,
                                                  font: ttf))),
                                    ),
                                  ),
                                  pw.Expanded(
                                    child: pw.Container(
                                      height: 30,
                                      padding: const pw.EdgeInsets.symmetric(
                                          horizontal: 5),
                                      decoration: const pw.BoxDecoration(
                                          border: pw.Border.symmetric(
                                              vertical: pw.BorderSide(
                                                  color: PdfColors.black))),
                                      child: pw.Center(
                                          child: pw.Text(
                                              allQ.toStringAsFixed(2),
                                              style: pw.TextStyle(
                                                  fontWeight:
                                                      pw.FontWeight.normal,
                                                  fontSize: 10,
                                                  font: ttf))),
                                    ),
                                  ),
                                  pw.Expanded(
                                    child: pw.Container(
                                      height: 30,
                                      padding: const pw.EdgeInsets.symmetric(
                                          horizontal: 5),
                                      decoration: const pw.BoxDecoration(
                                          border: pw.Border.symmetric(
                                              vertical: pw.BorderSide(
                                                  color: PdfColors.black))),
                                      child: pw.Center(
                                          child: pw.Text(
                                              allP.toStringAsFixed(2),
                                              style: pw.TextStyle(
                                                  fontWeight:
                                                      pw.FontWeight.normal,
                                                  fontSize: 10,
                                                  font: ttf))),
                                    ),
                                  ),
                                ])),
                      ]),
                pw.SizedBox(height: 10),
                !item
                    ? pw.SizedBox()
                    : pw.Column(children: [
                        pw.Container(
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(color: PdfColors.black),
                            ),
                            child: pw.Row(
                                mainAxisAlignment:
                                    pw.MainAxisAlignment.spaceBetween,
                                children: [
                                  pw.Expanded(
                                    child: pw.Container(
                                      height: 30,
                                      padding: const pw.EdgeInsets.symmetric(
                                          horizontal: 5),
                                      decoration: const pw.BoxDecoration(
                                          border: pw.Border.symmetric(
                                              vertical: pw.BorderSide(
                                                  color: PdfColors.black))),
                                      child: pw.Center(
                                          child: pw.Text('ITEM',
                                              style: pw.TextStyle(
                                                  fontWeight:
                                                      pw.FontWeight.bold,
                                                  fontSize: 11,
                                                  font: ttf))),
                                    ),
                                  ),
                                  pw.Expanded(
                                    child: pw.Container(
                                      height: 30,
                                      padding: const pw.EdgeInsets.symmetric(
                                          horizontal: 5),
                                      decoration: const pw.BoxDecoration(
                                          border: pw.Border.symmetric(
                                              vertical: pw.BorderSide(
                                                  color: PdfColors.black))),
                                      child: pw.Center(
                                          child: pw.Text('QTY',
                                              style: pw.TextStyle(
                                                  fontWeight:
                                                      pw.FontWeight.bold,
                                                  fontSize: 11,
                                                  font: ttf))),
                                    ),
                                  ),
                                  pw.Expanded(
                                    child: pw.Container(
                                      height: 30,
                                      padding: const pw.EdgeInsets.symmetric(
                                          horizontal: 5),
                                      decoration: const pw.BoxDecoration(
                                          border: pw.Border.symmetric(
                                              vertical: pw.BorderSide(
                                                  color: PdfColors.black))),
                                      child: pw.Center(
                                          child: pw.Text('AMOUNT',
                                              style: pw.TextStyle(
                                                  fontWeight:
                                                      pw.FontWeight.bold,
                                                  fontSize: 11,
                                                  font: ttf))),
                                    ),
                                  ),
                                ])),
                        pw.ListView.builder(
                            itemBuilder: (context, index) {
                              var key = mapProductSort.keys.elementAt(index);
                              String proName = allItems
                                      .firstWhere((element) =>
                                          element.id ==
                                          (int.tryParse(key.split(':').first) ??
                                              0))
                                      .englishName ??
                                  '';
                              int variableId =
                                  int.tryParse(key.split(':').last) ?? 0;
                              String name = variableId == 0
                                  ? proName
                                  : '$proName/${allIVariable.firstWhere((element) => element.id == (int.tryParse(key.split(':').last) ?? 0)).name}';
                              return pw.Container(
                                  decoration: pw.BoxDecoration(
                                    border:
                                        pw.Border.all(color: PdfColors.black),
                                  ),
                                  child: pw.Row(
                                      mainAxisAlignment:
                                          pw.MainAxisAlignment.spaceBetween,
                                      children: [
                                        pw.Expanded(
                                          child: pw.Container(
                                            height: 30,
                                            padding:
                                                const pw.EdgeInsets.symmetric(
                                                    horizontal: 5),
                                            decoration: const pw.BoxDecoration(
                                                border: pw.Border.symmetric(
                                                    vertical: pw.BorderSide(
                                                        color:
                                                            PdfColors.black))),
                                            child: pw.Center(
                                                child: pw.Text(name,
                                                    style: pw.TextStyle(
                                                        fontWeight: pw
                                                            .FontWeight.normal,
                                                        fontSize: 10,
                                                        font: ttf))),
                                          ),
                                        ),
                                        pw.Expanded(
                                          child: pw.Container(
                                            height: 30,
                                            padding:
                                                const pw.EdgeInsets.symmetric(
                                                    horizontal: 5),
                                            decoration: const pw.BoxDecoration(
                                                border: pw.Border.symmetric(
                                                    vertical: pw.BorderSide(
                                                        color:
                                                            PdfColors.black))),
                                            child: pw.Center(
                                                child: pw.Text(
                                                    mapProductSort[key]![0]
                                                        .toStringAsFixed(2),
                                                    style: pw.TextStyle(
                                                        fontWeight: pw
                                                            .FontWeight.normal,
                                                        fontSize: 10,
                                                        font: ttf))),
                                          ),
                                        ),
                                        pw.Expanded(
                                          child: pw.Container(
                                            height: 30,
                                            padding:
                                                const pw.EdgeInsets.symmetric(
                                                    horizontal: 5),
                                            decoration: const pw.BoxDecoration(
                                                border: pw.Border.symmetric(
                                                    vertical: pw.BorderSide(
                                                        color:
                                                            PdfColors.black))),
                                            child: pw.Center(
                                                child: pw.Text(
                                                    mapProductSort[key]![1]
                                                        .toStringAsFixed(2),
                                                    style: pw.TextStyle(
                                                        fontWeight: pw
                                                            .FontWeight.normal,
                                                        fontSize: 10,
                                                        font: ttf))),
                                          ),
                                        ),
                                      ]));
                            },
                            itemCount: mapProductSort.length)
                      ]),
                !item ? pw.SizedBox() : pw.SizedBox(height: 10),
                !item
                    ? pw.SizedBox()
                    : pw.Container(
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(color: PdfColors.black),
                        ),
                        child: pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Expanded(
                                child: pw.Container(
                                  height: 30,
                                  padding: const pw.EdgeInsets.symmetric(
                                      horizontal: 5),
                                  decoration: const pw.BoxDecoration(
                                      border: pw.Border.symmetric(
                                          vertical: pw.BorderSide(
                                              color: PdfColors.black))),
                                  child: pw.Center(
                                      child: pw.Text('ALL',
                                          style: pw.TextStyle(
                                              fontWeight: pw.FontWeight.normal,
                                              fontSize: 10,
                                              font: ttf))),
                                ),
                              ),
                              pw.Expanded(
                                child: pw.Container(
                                  height: 30,
                                  padding: const pw.EdgeInsets.symmetric(
                                      horizontal: 5),
                                  decoration: const pw.BoxDecoration(
                                      border: pw.Border.symmetric(
                                          vertical: pw.BorderSide(
                                              color: PdfColors.black))),
                                  child: pw.Center(
                                      child: pw.Text(allQ.toStringAsFixed(2),
                                          style: pw.TextStyle(
                                              fontWeight: pw.FontWeight.normal,
                                              fontSize: 10,
                                              font: ttf))),
                                ),
                              ),
                              pw.Expanded(
                                child: pw.Container(
                                  height: 30,
                                  padding: const pw.EdgeInsets.symmetric(
                                      horizontal: 5),
                                  decoration: const pw.BoxDecoration(
                                      border: pw.Border.symmetric(
                                          vertical: pw.BorderSide(
                                              color: PdfColors.black))),
                                  child: pw.Center(
                                      child: pw.Text(allP.toStringAsFixed(2),
                                          style: pw.TextStyle(
                                              fontWeight: pw.FontWeight.normal,
                                              fontSize: 10,
                                              font: ttf))),
                                ),
                              ),
                            ])),
                pw.Divider(
                    thickness: 2,
                    borderStyle: const pw.BorderStyle(pattern: [1, 3])),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                    children: [
                      companyInfo.showLocation == true
                          ? pw.Expanded(
                              child: pw.Column(children: [
                              pw.BarcodeWidget(
                                barcode: pw.Barcode.qrCode(),
                                data: companyInfo.locationUrl ?? '',
                                width: 50,
                                height: 50,
                              ),
                              pw.Text('Location',
                                  style: const pw.TextStyle(
                                    fontSize: 8,
                                  ))
                            ]))
                          : pw.SizedBox(),
                      companyInfo.showWeb == true
                          ? pw.Expanded(
                              child: pw.Column(children: [
                              pw.BarcodeWidget(
                                barcode: pw.Barcode.qrCode(),
                                data: companyInfo.webSite ?? '',
                                width: 50,
                                height: 50,
                              ),
                              pw.Text('Website',
                                  style: const pw.TextStyle(
                                    fontSize: 8,
                                  ))
                            ]))
                          : pw.SizedBox(),
                    ]),
                pw.SizedBox(height: 10),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      companyInfo.showFace == true
                          ? pw.Expanded(
                              child: pw.Column(children: [
                              pw.BarcodeWidget(
                                barcode: pw.Barcode.qrCode(),
                                data: companyInfo.facebookUrl ?? '',
                                width: 50,
                                height: 50,
                              ),
                              pw.Text('FaceBook',
                                  style: const pw.TextStyle(
                                    fontSize: 8,
                                  ))
                            ]))
                          : pw.SizedBox(),
                      companyInfo.showInstagram == true
                          ? pw.Expanded(
                              child: pw.Column(children: [
                              pw.BarcodeWidget(
                                barcode: pw.Barcode.qrCode(),
                                data: companyInfo.instagramUrl ?? '',
                                width: 50,
                                height: 50,
                              ),
                              pw.Text('Instagram',
                                  style: const pw.TextStyle(
                                    fontSize: 8,
                                  ))
                            ]))
                          : pw.SizedBox(),
                    ]),
                pw.SizedBox(height: 10),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      companyInfo.showTwitter == true
                          ? pw.Expanded(
                              child: pw.Column(children: [
                              pw.BarcodeWidget(
                                barcode: pw.Barcode.qrCode(),
                                data: companyInfo.twitterUrl ?? '',
                                width: 50,
                                height: 50,
                              ),
                              pw.Text('Twitter',
                                  style: const pw.TextStyle(
                                    fontSize: 8,
                                  ))
                            ]))
                          : pw.SizedBox(),
                      companyInfo.showSnapShat == true
                          ? pw.Expanded(
                              child: pw.Column(children: [
                              pw.BarcodeWidget(
                                barcode: pw.Barcode.qrCode(),
                                data: companyInfo.snapShatUrl ?? '',
                                width: 50,
                                height: 50,
                              ),
                              pw.Text('SnapShat',
                                  style: const pw.TextStyle(
                                    fontSize: 8,
                                  ))
                            ]))
                          : pw.SizedBox(),
                    ]),
                pw.SizedBox(height: 10),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      companyInfo.showTiktok == true
                          ? pw.Expanded(
                              child: pw.Column(children: [
                              pw.BarcodeWidget(
                                barcode: pw.Barcode.qrCode(),
                                data: companyInfo.tiktokUrl ?? '',
                                width: 50,
                                height: 50,
                              ),
                              pw.Text('TikTok',
                                  style: const pw.TextStyle(
                                    fontSize: 8,
                                  ))
                            ]))
                          : pw.SizedBox(),
                    ]),
                pw.Divider(
                    thickness: 2,
                    borderStyle: const pw.BorderStyle(pattern: [1, 3])),
                pw.Text(
                  '  Finish Report ',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.normal,
                      fontSize: 10,
                      font: ttf),
                ),
                pw.Container(margin: const pw.EdgeInsets.only(bottom: 40))
              ],
            ),
          );
        }));

    return doc;
  }

  Future<pw.Document> printCloseBox({
    required String printerName,
    required DateTime date,
    required String fromAcc,
    required String toAcc,
    required double diffAmount,
    required double amount,
    required double boxAmount,
  }) async {
    final ttf = await fontFromAssetBundle('assets/fonts/Dubai-Regular.ttf');
    final doc = pw.Document();
    final prefs = await SharedPreferences.getInstance();

    await Get.find<InfoController>().getCompanyInfo();
    await Get.find<InfoController>().getAllTaxesSetting();
    await Get.find<InfoController>().getAllTaxes();
    var tax = Get.find<InfoController>().taxesSetting;
    var companyInfo = Get.find<InfoController>().companyInfo;
    final image = companyInfo?.companyImage == null
        ? await imageFromAssetBundle('assets/images/whiteBackground.jpg')
        : await flutterImageProvider(MemoryImage(companyInfo!.companyImage!));
    doc.addPage(pw.Page(
        pageFormat: PdfPageFormat.roll80,
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.only(right: 10),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                companyInfo!.image!.isEmpty
                    ? pw.SizedBox()
                    : pw.Image(image, width: 100, height: 100),
                pw.Text(
                  'Restaurant ',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.normal,
                      fontSize: 20,
                      font: ttf),
                ),
                pw.Text(
                  'Address :  ${companyInfo.address}',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.normal,
                      fontSize: 10,
                      font: ttf),
                ),
                companyInfo.anotherAddress == "" ||
                        companyInfo.anotherAddress == null
                    ? pw.SizedBox()
                    : pw.Text(
                        'Another Address :  ${companyInfo.anotherAddress}',
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.normal,
                            fontSize: 10,
                            font: ttf),
                      ),
                pw.Text(
                  ' Mobile :  ${companyInfo.number}',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.normal,
                      fontSize: 10,
                      font: ttf),
                ),
                companyInfo.additionalNumber == "" ||
                        companyInfo.additionalNumber == null
                    ? pw.SizedBox()
                    : pw.Text(
                        'Another Mobile :  ${companyInfo.additionalNumber}',
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.normal,
                            fontSize: 10,
                            font: ttf),
                      ),
                tax.isEmpty
                    ? pw.SizedBox()
                    : pw.Text(
                        'TRN : ${tax.last.taxNumber} ',
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.normal,
                            fontSize: 10,
                            font: ttf),
                      ),
                pw.SizedBox(height: 10),
                pw.Text(
                  'Close Box',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 18, font: ttf),
                ),
                pw.SizedBox(height: 10),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('By:',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal,
                              fontSize: 10,
                              font: ttf)),
                      pw.Text(prefs.getString('name')!,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal,
                              fontSize: 10,
                              font: ttf))
                    ]),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Date :',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal,
                              fontSize: 10,
                              font: ttf)),
                      pw.Text(DateFormat('dd-MM-yyyy hh:mm aaa').format(date),
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal,
                              fontSize: 10,
                              font: ttf))
                    ]),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('From Box :',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal,
                              fontSize: 10,
                              font: ttf)),
                      pw.Text(fromAcc,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal,
                              fontSize: 10,
                              font: ttf))
                    ]),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('To Box :',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal,
                              fontSize: 10,
                              font: ttf)),
                      pw.Text(toAcc,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal,
                              fontSize: 10,
                              font: ttf))
                    ]),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Box Amount : ',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal,
                              fontSize: 10,
                              font: ttf)),
                      pw.Text(boxAmount.toStringAsFixed(2),
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal,
                              fontSize: 10,
                              font: ttf))
                    ]),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Closing Amount :',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal,
                              fontSize: 10,
                              font: ttf)),
                      pw.Text(amount.toStringAsFixed(2),
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal,
                              fontSize: 10,
                              font: ttf))
                    ]),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Diff Amount :',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal,
                              fontSize: 10,
                              font: ttf)),
                      pw.Text(diffAmount.toStringAsFixed(2),
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal,
                              fontSize: 10,
                              font: ttf))
                    ]),
                pw.Text(
                  '  Finish Report ',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.normal,
                      fontSize: 10,
                      font: ttf),
                ),
                pw.Container(margin: const pw.EdgeInsets.only(bottom: 40))
              ],
            ),
          );
        }));
    await Printing.directPrintPdf(
        dynamicLayout: true,
        printer: Printer(url: printerName, name: printerName),
        onLayout: (format) async => doc.save(),
        usePrinterSettings: true);
    return doc;
  }

  Future<void> getCloseBoxSetting() async {
    closeBoxSettingData.value = (await Get.find<AppDataBaseController>()
        .appDataBase
        .getCloseBoxSetting())!;
    show1000.value = closeBoxSettingData.value.show1000;
    show500.value = closeBoxSettingData.value.show500;
    show200.value = closeBoxSettingData.value.show200;
    show100.value = closeBoxSettingData.value.show100;
    show50.value = closeBoxSettingData.value.show50;
    show20.value = closeBoxSettingData.value.show20;
    show10.value = closeBoxSettingData.value.show10;
    show5.value = closeBoxSettingData.value.show5;
    show2.value = closeBoxSettingData.value.show2;
    show1.value = closeBoxSettingData.value.show1;
    show050.value = closeBoxSettingData.value.show050;
    show025.value = closeBoxSettingData.value.show025;
    show010.value = closeBoxSettingData.value.show010;
    show005.value = closeBoxSettingData.value.show005;
    show001.value = closeBoxSettingData.value.show001;
    update();
  }

  Future<void> updateCloseBoxSetting(CloseBoxSettingData c) async {
    await Get.find<AppDataBaseController>()
        .appDataBase
        .updateCloseBoxSetting(c);
    await getCloseBoxSetting();
  }

  Future closeBox({
    required int userId,
    required double amount,
    required String type,
  }) async {
    DioClient dio = DioClient();
    var data = {
      "userId": userId.toString(),
      "amount": amount.toString(),
      "type": type,
    };
    final response = await dio.postDio(path: '/close-box', data1: data);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.data['message']);
      fromAcc.value = data['fromAcc'];
      toAcc.value = data['toAcc'];
      balance.value = double.tryParse(data['balance']) ?? 0.0;
    } else {
      var data = jsonDecode(response.data['message']);
      fromAcc.value = data['fromAcc'];
      toAcc.value = data['toAcc'];
      balance.value = double.tryParse(data['balance']) ?? 0.0;
    }
    update();
  }

  Future checkUser({required BuildContext context}) async {
    bool check = await Get.find<InfoController>().checkMobile();
    if (!check) {
      if (!context.mounted) {
        return;
      }
      ConstantApp.showSnakeBarError(context,
          'The Server Cannot Be Accessed. Please Reconnect Or Contact The Support');
      Get.offAll(() => const FirstScreen());
      return true;
    }
    await getUsers();
    var name = Get.find<SharedPreferences>().getString('name') ?? '';
    if (!users.map((element) => element.name).contains(name)) {
      if (!context.mounted) {
        return;
      }
      ConstantApp.showSnakeBarError(
          context, 'The User Is Not Exist Or Is InActive !!');
      Get.offAll(() => const LoginPage());
      return true;
    } else {
      return false;
    }
  }

  Future getPermission({required int userId}) async {
    DioClient dio = DioClient();
    var data = {'userId': userId.toString()};
    final response = await dio.postDio(path: '/permission', data1: data);
    if (response.statusCode == 200) {
      final per = response.data;
      permission.value = PermissionModel(
          cashDrawer: bool.tryParse(per['cashDrawer']) ?? false,
          addContact: bool.tryParse(per['addContact']) ?? false,
          closeBox: bool.tryParse(per['closeBox']) ?? false,
          choseOfferPrice: bool.tryParse(per['choseOfferPrice']) ?? false,
          choseWholePrice: bool.tryParse(per['choseWholePrice']) ?? false,
          choseMinPrice: bool.tryParse(per['choseMinPrice']) ?? false,
          choseCostPrice: bool.tryParse(per['choseCostPrice']) ?? false,
          viewDriver: bool.tryParse(per['viewDriver']) ?? false,
          discount: bool.tryParse(per['discount']) ?? false,
          showEmployeePos: bool.tryParse(per['showEmployeePos']) ?? false,
          removeItemOrder: bool.tryParse(per['removeItemOrder']) ?? false,
          addSales: bool.tryParse(per['addSales']) ?? false,
          deleteSales: bool.tryParse(per['deleteSales']) ?? false,
          editSales: bool.tryParse(per['editSales']) ?? false,
          returnSales: bool.tryParse(per['returnSales']) ?? false,
          viewSales: bool.tryParse(per['viewSales']) ?? false,
          printPage: bool.tryParse(per['printPage']) ?? false,
          tableChange: bool.tryParse(per['tableChange']) ?? false,
          voidPer: bool.tryParse(per['voidPer']) ?? false,
          userId: userId, editPrice:  bool.tryParse(per['editPrice']) ?? false,);
    } else {
      permission.value = PermissionModel(
          cashDrawer: false,
          addContact: false,
          closeBox: false,
          choseOfferPrice: false,
          choseWholePrice: false,
          choseMinPrice: false,
          choseCostPrice: false,
          viewDriver: false,
          discount: false,
          showEmployeePos: false,
          removeItemOrder: false,
          addSales: false,
          deleteSales: false,
          editSales: false,
          returnSales: false,
          viewSales: false,
          printPage: false,
          tableChange: false,
          voidPer: false,
          userId: userId, editPrice: false);
    }
  }

  bool isPermission(
    bool per,
    BuildContext context,
  ) {
    if (per == false) {
      ConstantApp.showSnakeBarError(context, 'No Permission !!'.tr);
     return false;
    } else {
      return true;
    }
  }
}
