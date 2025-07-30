import 'dart:convert';

import 'package:cashier_app/controllers/info_controllers.dart';
import 'package:cashier_app/controllers/order_controller.dart';
import 'package:cashier_app/models/bill_model.dart';
import 'package:cashier_app/server/dio_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/order/order_model.dart';
import '../models/product/product_model.dart';
import '../models/product/variable_product_model.dart';

class SalesBillController extends GetxController {
  RxList<BillModel> bill = RxList();
  RxList<OrderModel> order = RxList();
  List<OrderModel> oldOrderId = [];
  TextEditingController firstDateController = TextEditingController();
  TextEditingController lastDateController = TextEditingController();
  TextEditingController onceDateController = TextEditingController();
  DateTime? pickedDate1;
  DateTime? pickedDate2;
  DateTime? pickedDate3;
  List<BillModel> bills = [];
  List<BillModel> userBills = [];
  RxList<BillModel> foundPlayers = RxList();
  RxDouble totalOrders = RxDouble(0.0);
  RxDouble totalExcVatOrders = RxDouble(0.0);
  RxDouble vatOrders = RxDouble(0.0);
  RxDouble subTotal = RxDouble(0.0);
  RxDouble total = RxDouble(0.0);
  RxDouble totalTips = RxDouble(0.0);
  RxDouble totalExcVat = RxDouble(0.0);
  RxDouble totalDisAmo = RxDouble(0.0);
  RxDouble totalVat = RxDouble(0.0);
  RxDouble totalPaid = RxDouble(0.0);
  RxDouble totalBalance = RxDouble(0.0);
  RxDouble totalReturn = RxDouble(0.0);
  RxDouble totalCash = RxDouble(0.0);
  RxDouble totalVisa = RxDouble(0.0);
  RxDouble vat = RxDouble(0.0);
  RxDouble discount = RxDouble(0.0);
  RxDouble finalTotal = RxDouble(0.0);
  RxDouble disAmount = RxDouble(0.0);
  RxDouble totalOperation = RxDouble(0.0);
  RxDouble totalQty = RxDouble(0.0);
  RxString disType = RxString('');
  RxBool tableS = false.obs;
  RxBool formatS = false.obs;
  RxBool costumerS = false.obs;
  RxBool payTypeS = false.obs;
  RxBool cashierS = false.obs;
  RxBool totalS = false.obs;
  RxBool excVatS = false.obs;
  RxBool disS = false.obs;
  RxBool disAmoS = false.obs;
  RxBool vatS = false.obs;
  RxBool finalS = false.obs;
  RxBool dateS = false.obs;
  RxBool hallS = false.obs;
  RxBool isLoading = true.obs;
  RxString discountType = RxString('%');
  TextEditingController discountValue = TextEditingController();
  FocusNode discountValueFocusNode = FocusNode();
  var isSearch = false.obs;
  var isFilter = false.obs;
  late RxBool cash = RxBool(true);
  late RxBool visa = RxBool(false);
  late RxBool cashVisa = RxBool(false);
  late RxDouble paid = 0.0.obs;
  late RxDouble balance = 0.0.obs;
  late RxInt mainId = RxInt(0);
  late RxInt subId = RxInt(0);

  void filterPlayer(String playerName) async {
    List<BillModel> results = [];
    if (playerName.isEmpty) {
      results = bills;
    } else {
      results = bills.where((element) {
        return element.table
                .toString()
                .toLowerCase()
                .contains(playerName.toLowerCase()) ||
            element.formatNumber
                .toString()
                .toLowerCase()
                .contains(playerName.toLowerCase()) ||
            element.customerName
                .toString()
                .toLowerCase()
                .contains(playerName.toLowerCase()) ||
            element.payType
                .toString()
                .toLowerCase()
                .contains(playerName.toLowerCase()) ||
            element.cashier
                .toString()
                .toLowerCase()
                .contains(playerName.toLowerCase()) ||
            element.total
                .toString()
                .toLowerCase()
                .contains(playerName.toLowerCase()) ||
            element.discountAmount
                .toString()
                .toLowerCase()
                .contains(playerName.toLowerCase()) ||
            element.vat
                .toString()
                .toLowerCase()
                .contains(playerName.toLowerCase()) ||
            element.createdAt
                .toString()
                .toLowerCase()
                .contains(playerName.toLowerCase()) ||
            element.hall
                .toString()
                .toLowerCase()
                .contains(playerName.toLowerCase()) ||
            element.finalTotal
                .toString()
                .toLowerCase()
                .contains(playerName.toLowerCase()) ||
            element.paid
                .toString()
                .toLowerCase()
                .contains(playerName.toLowerCase());
      }).toList();
    }
    foundPlayers.value = results;
    await getDetails();
    update();
  }

  Future<void> getAllBills() async {
    List<BillModel> allBill = [];
    DioClient dio = DioClient();
    final response = await dio.getDio(path: '/bills');
    if (response.statusCode == 200) {
      var data = jsonDecode(response.data);
      List listBill = data['bill'];
      for (var j in listBill) {
        allBill.add(BillModel(
          id: int.tryParse(j['id']) ?? 0,
          formatNumber: j['bill-number'],
          finalTotal: double.tryParse(j['final-total']) ?? 0.0,
          cashAmount: double.tryParse(j['cash-amount']) ?? 0.0,
          visaAmount: double.tryParse(j['visa-amount']) ?? 0.0,
          hall: j['hall'],
          table: j['table'],
          customerName: j['customer-name'],
          cashier: j['cashier-name'],
          dateSales: DateTime.tryParse(j['date']) ?? DateTime.now(),
          salesType: j['type'],
          total: double.tryParse(j['subtotal']) ?? 0.0,
          discountAmount: double.tryParse(j['discountAmount']) ?? 0.0,
          disType: j['disType'],
          disValue: j['disValue'],
          vat: double.tryParse(j['vat']) ?? 0.0,
          createdAt: DateTime.tryParse(j['createdAt']) ?? DateTime.now(),
          balance: j['balance'],
          noteOrder: j['noteOrder'] ?? '',
          paid: j['paid'],
          payType: j['payType'],
          tips: double.tryParse(j['tips']) ?? 0.0,
          customerId: int.tryParse(j['customerId']) ?? 0,
          storeId: int.tryParse(j['storeId']) ?? 0,
          invoice: j['invoice'],
          numberOfBill:j['numberOfBill'],
          patternId: int.tryParse(j['patternId'].toString()) ?? 0,
          receiptDue: double.tryParse(j['receiptDue'].toString()) ?? 0,
          receiptStatus: j['receiptStatus'],
          typeInvoice: j['typeInvoice'],
        ));
      }
    }
    bills = allBill
        .where((element) =>
            element.cashier ==
                (Get.find<SharedPreferences>().getString('name') ?? '') &&
            element.createdAt!.day == DateTime.now().day &&
            element.createdAt!.month == DateTime.now().month &&
            element.createdAt!.year == DateTime.now().year)
        .toList();
    foundPlayers.value = bills;
    await getDetails();

    update();
  }

  Future getDetails() async {
    totalExcVat.value = 0.0;
    totalDisAmo.value = 0.0;
    totalVat.value = 0.0;
    total.value = 0.0;
    totalPaid.value = 0.0;
    totalBalance.value = 0.0;
    totalReturn.value = 0.0;
    totalTips.value = 0.0;
    totalCash.value = 0.0;
    totalVisa.value = 0.0;

    for (var i in foundPlayers) {
      if (i.salesType == 'sales') {
        totalExcVat.value += i.total ?? 0;
        totalDisAmo.value += i.discountAmount ?? 0;
        totalVat.value += i.vat ?? 0;
        total.value += i.finalTotal ?? 0;
        totalPaid.value += double.tryParse(i.paid!) ?? 0.0;
        totalBalance.value +=
            i.payType == "Credit" ? double.tryParse(i.balance!) ?? 0.0 : 0.0;
        totalReturn.value +=
            i.payType != "Credit" ? double.tryParse(i.balance!) ?? 0.0 : 0.0;
        totalTips.value += (i.tips ?? 0.0);
        totalCash.value += i.cashAmount!;
        totalVisa.value += i.visaAmount!;
      } else {
        totalExcVat.value -= i.total ?? 0;
        totalDisAmo.value -= i.discountAmount ?? 0;
        totalVat.value -= i.vat ?? 0;
        total.value -= i.finalTotal ?? 0;
        totalPaid.value -= double.tryParse(i.paid!) ?? 0.0;
        totalBalance.value -=
            i.payType == "Credit" ? double.tryParse(i.balance!) ?? 0.0 : 0.0;
        totalReturn.value -=
            i.payType != "Credit" ? double.tryParse(i.balance!) ?? 0.0 : 0.0;
        totalTips.value -= (i.tips ?? 0.0);
        totalCash.value -= i.cashAmount!;
        totalVisa.value -= i.visaAmount!;
      }
    }
    update();
  }

  Future deleteBill(
      {required int billId,
      required int cashierId,
      required String format,
      required String cashierName}) async {
    DioClient dio = DioClient();
    try {
      final response = await dio.postDio(path: '/delete-bill', data1: {
        "id": billId.toString(),
        "cashierId": cashierId.toString(),
        "formatNumber": format,
        "cashier": cashierName,
      });
      if (response.statusCode == 200) {
        await getAllBills();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future getDetail() async {
    totalOrders.value = 0;
    vatOrders.value = 0;
    totalExcVatOrders.value = 0;
    finalTotal.value = 0;
    disAmount.value = 0;
    vat.value = 0;
    List<double> list = [];
    await Get.find<InfoController>().getAllTaxesSetting();
    await Get.find<InfoController>().getAllTaxes();
    for (var i in order) {
      list.add(i.price * i.quantity);
      var tax = i.vatId == 0
          ? 0
          : Get.find<InfoController>()
                  .taxes
                  .firstWhere((element) => element.id == i.vatId)
                  .taxValue ??
              0;
      var taxType = Get.find<InfoController>().taxesSetting.isEmpty
          ? ''
          : Get.find<InfoController>().taxesSetting.last.taxType;
      if (taxType == 'inc') {
        totalExcVatOrders.value += (i.price * i.quantity * 100 / (100 + tax));
      } else {
        totalExcVatOrders.value += (i.price * i.quantity);
      }
    }
    if (order.isEmpty) {
      totalOrders.value = 0;
      vatOrders.value = 0;
      totalExcVatOrders.value = 0;
      finalTotal.value = 0;
      disAmount.value = 0;
      vat.value = 0;
    } else {
      totalOrders.value = list.reduce((a, b) => a + b);
      if (discountValue.text.isEmpty) {
        subTotal.value = totalExcVatOrders.value;
        vat.value = totalOrders.value - subTotal.value;
      } else {
        var taxId = Get.find<InfoController>().taxesSetting.isEmpty
            ? 0
            : Get.find<InfoController>().taxesSetting.last.taxId;
        var tax = taxId == 0
            ? 0
            : Get.find<InfoController>()
                    .taxes
                    .firstWhere((element) => element.id == taxId)
                    .taxValue ??
                0;
        if (discountType.value == '%') {
          disAmount.value =
              totalExcVatOrders * double.parse(discountValue.text) / 100;
        } else if (discountType.value == 'Fixed before Vat' ||
            discountType.value == 'Value') {
          disAmount.value = double.parse(discountValue.text);
        } else if (discountType.value == 'Fixed After Vat') {
          disAmount.value =
              double.parse(discountValue.text) * 100 / (100 + tax);
        }
        subTotal.value = (totalExcVatOrders.value) - disAmount.value;
        vat.value = subTotal * tax / 100;
      }
      finalTotal.value = vat.value + subTotal.value;
    }
  }
  Future getOrderWithBill(String formatNumber) async {
    order.clear();
    oldOrderId.clear();
    await Get.find<OrderController>().getAllOrders();
    var allOrders = Get.find<OrderController>()
        .orderView
        .where((element) => element.billNum
        .toString()
        .toLowerCase()
        .contains(formatNumber.toLowerCase()))
        .toList();
    List<int> list = [];
    for(var i in allOrders){
      if(i.quantity.isNegative){
        for(var j in allOrders.where((element) {
          return element.itemId == i.itemId && element.id != i.id;
        })){
          if((i.quantity * -1) < j.quantity){
            list.add(j.id!);
            order.add(OrderModel(
              id: j.id,
              billNum: j.billNum,
              name: j.name,
              quantity: j.quantity + i.quantity,
              price: j.price,
              catId: j.catId,
              itemId: j.itemId,
              createdAt: j.createdAt,
              totalPrice: j.totalPrice,
              serial: j.serial,
              guest: j.guest,
              table: j.table,
              hall: j.hall,
              ident: j.ident,
              note: j.note,
              variableId: j.variableId,
              recipeId: j.recipeId,
              productType: j.productType,
              vatId: j.vatId,
              unitId: j.unitId,
              employeeId: j.employeeId,
              salesType: i.salesType
            ));break;
          }else if((i.quantity * -1) == j.quantity){
            list.add(j.id!);break;
          }
        }
        list.add(i.id!);
      }
    }
    for (var i in allOrders.where((element) => !list.contains(element.id))) {
      
      order.add(OrderModel(
        id: i.id,
        billNum: i.billNum,
        name: i.name,
        quantity: i.quantity,
        price: i.price,
        catId: i.catId,
        itemId: i.itemId,
        createdAt: i.createdAt,
        totalPrice: i.totalPrice,
        serial: i.serial,
        guest: i.guest,
        table: i.table,
        hall: i.hall,
        ident: i.ident,
        note: i.note,
        variableId: i.variableId,
        recipeId: i.recipeId,
        productType: i.productType,
        vatId: i.vatId,
        unitId: i.unitId,
        employeeId: i.employeeId,
        salesType: i.salesType,
      ));
    }
    oldOrderId.clear();
    for (var i in order) {
      oldOrderId.add(i);
    }
    totalOrders.value = 0;
    vatOrders.value = 0;
    totalExcVatOrders.value = 0;
    discount.value = 0;
    disType.value = '';
    subTotal.value = 0;
    vat.value = 0;
    finalTotal.value = 0;
    disAmount.value = 0;
    order.isEmpty ? null : await getDetail();
  }
  Future<void> addOrder(ProductModel product, BillModel bill,
      ProductVariableModel? variable, int variableId) async {
    final prefs = await SharedPreferences.getInstance();
    OrderModel? temp;
    if (order.isEmpty) {
      totalOrders.value = 0;
    }
    for (var x in order) {
      if (x.itemId == product.id && x.variableId == variableId) {
        temp = x;
        break;
      }
    }
    if (temp != null) {
      var index = order.indexOf(temp);
      order[index].quantity += 1;
    } else {
      order.add(OrderModel(
        name: variableId == 0
            ? product.englishName!
            : '${product.englishName!}/${variable!.name}',
        quantity: 1,
        price:
            variableId == 0 ? double.parse(product.price!) : variable!.price!,
        catId: product.subId,
        itemId: product.id!,
        createdAt: DateTime.now(),
        totalPrice:
            variableId == 0 ? double.parse(product.price!) : variable!.price!,
        guest: '',
        billNum: bill.formatNumber,
        table: bill.table ?? '',
        hall: bill.hall ?? '',
        ident: prefs.getString('name')!,
        note: '',
        serial: 0,
        sectionId: 0,
        variableId: variableId,
        productType: product.type,
        recipeId: variableId == 0 ? product.recipeId : variable!.recipeId,
        vatId: product.vatId,
        unitId: product.unit,
        employeeId: 0,
      ));
    }
   await getDetail();
    update();
  }

  Future editBill(BillModel bill) async {
    DioClient dio = DioClient();
List listOrder = [];
List listOldOrder = [];
for(var i in order){
  listOrder.add({
    "id": i.id.toString(),
    "name": i.name.toString(),
    "quantity": i.quantity.toString(),
    "price": i.price.toString(),
    "itemId": i.itemId.toString(),
    "createdAt": i.createdAt.toString(),
    "totalPrice": i.totalPrice.toString(),
    "serial": i.serial.toString(),
    "variableId": i.variableId.toString(),
    "recipeId": i.recipeId.toString(),
    "vatId": i.vatId.toString(),
    "unitId": i.unitId.toString(),
    "guest": i.guest.toString(),
    "table": i.table.toString(),
    "hall": i.hall.toString(),
    "ident": i.ident.toString(),
    "note": i.note.toString(),
    "billNum": i.billNum.toString(),
    "productType": i.productType.toString(),
    "catId": i.catId.toString(),
    "salesType": i.salesType.toString(),
    "employeeId": i.employeeId.toString(),
  });
}
for(var i in oldOrderId){
  listOldOrder.add({
    "id": i.id.toString(),
    "name": i.name.toString(),
    "quantity": i.quantity.toString(),
    "price": i.price.toString(),
    "itemId": i.itemId.toString(),
    "createdAt": i.createdAt.toString(),
    "totalPrice": i.totalPrice.toString(),
    "serial": i.serial.toString(),
    "variableId": i.variableId.toString(),
    "recipeId": i.recipeId.toString(),
    "vatId": i.vatId.toString(),
    "unitId": i.unitId.toString(),
    "guest": i.guest.toString(),
    "table": i.table.toString(),
    "hall": i.hall.toString(),
    "ident": i.ident.toString(),
    "note": i.note.toString(),
    "billNum": i.billNum.toString(),
    "productType": i.productType.toString(),
    "catId": i.catId.toString(),
    "salesType": i.salesType.toString(),
    "employeeId": i.employeeId.toString(),
  });
}
    var data = {
      "id": bill.id.toString(),
      "invoice": bill.invoice.toString(),
      "formatNumber": bill.formatNumber.toString(),
      "typeInvoice": bill.typeInvoice.toString(),
      "numberOfBill": bill.numberOfBill.toString(),
      "customerId": bill.customerId.toString(),
      "patternId": bill.patternId.toString(),
      "storeId": bill.storeId.toString(),
      "payType": bill.payType.toString(),
      "total": bill.total.toString(),
      "discountAmount": bill.discountAmount.toString(),
      "disType": bill.disType.toString(),
      "disValue": bill.disValue.toString(),
      "cashier": bill.cashier.toString(),
      "receiptStatus": bill.receiptStatus.toString(),
      "vat": bill.vat.toString(),
      "receiptDue": bill.receiptDue.toString(),
      "finalTotal": bill.finalTotal.toString(),
      "createdAt": bill.createdAt.toString(),
      "dateSales": bill.dateSales.toString(),
      "table": bill.table.toString(),
      "hall": bill.hall.toString(),
      "balance": bill.balance.toString(),
      "cashAmount": bill.cashAmount.toString(),
      "costCenterId": '0',
      "paid": bill.paid.toString(),
      "noteOrder": bill.noteOrder.toString(),
      "salesType": bill.salesType.toString(),
      "tips": bill.tips.toString(),
      "visaAmount": bill.visaAmount.toString(),
      "order" : listOrder,
      "oldOrder" : listOldOrder,
    };
final response = await dio.postDio(path: '/edit-bill', data1: data);
if(response.statusCode == 200 ){
print(response.data);
}

  }
}
