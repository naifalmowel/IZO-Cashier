import 'dart:convert';
import 'dart:typed_data';
import 'package:cashier_app/models/app_type_model.dart';
import 'package:cashier_app/models/bill_model.dart';
import 'package:cashier_app/models/company_info_model.dart';
import 'package:cashier_app/models/tax_model.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/employee_model.dart';
import '../models/store_model.dart';
import '../models/tax_setting.dart';
import '../modules/login/login.dart';
import '../utils/constant.dart';
import '/models/hall_model.dart';
import '/models/table_model.dart';
import '/server/dio_services.dart';

class InfoController extends GetxController {
  RxList<HallModel> halls = RxList([]);
  RxList<StoreModel> stores = RxList([]);
  RxList<EmployeeModel> employees = RxList([]);
  RxList<TaxSettingModel> taxesSetting = RxList([]);
  RxList<TaxModel> taxes = RxList([]);
  RxList<BillModel> bills = RxList([]);
  CompanyInfo? companyInfo;
  RxBool isLoading = false.obs;
  RxBool isServerConnect = false.obs;
  RxBool isLoadingCheck = false.obs;
  RxBool isE = false.obs;
  RxList badgeTakeaway = RxList([]);
  RxList badgeDelivery = RxList([]);
  RxList badgeTables = RxList([]);
  RxBool isDelivery = RxBool(false);
  RxBool weight = RxBool(false);
  RxBool price = RxBool(false);
  RxBool both = RxBool(false);
  RxBool isActive = RxBool(false);
  RxInt balanceStart = RxInt(21);
  RxInt startProduct = RxInt(21);
  RxInt endProduct = RxInt(21);
  RxInt startWeight = RxInt(21);
  RxInt endWeight = RxInt(21);
  RxInt startPrice = RxInt(21);
  RxInt endPrice = RxInt(21);
  RxInt dotPrice = RxInt(0);
  RxInt dotWeight = RxInt(0);

  Future updateHomePage() async {
    isDelivery.value =
        Get.find<SharedPreferences>().getBool('delivery') ?? false;
    update();
  }

  Future<bool> getAllInformation() async {
    isLoading(true);
    if (ConstantApp.type == "guest") {
      halls.value = [
        HallModel(tables: [
          TableModel(
              number: "1",
              hall: "1",
              voidAmount: 100,
              cost: 100,
              waitCustomer: false,
              time: DateTime.now(),
              bookingTable: false,
              bookingDate: null,
              customerId: 1),
          TableModel(
              number: "2",
              hall: "1",
              voidAmount: 0,
              cost: 0,
              waitCustomer: false,
              time: DateTime.now(),
              bookingTable: false,
              bookingDate: null,
              customerId: 1),
        ], name: "Hall 1", id: 1, tableCount: 2),
        HallModel(tables: [
          TableModel(
              number: "1",
              hall: "0",
              voidAmount: 0,
              cost: 0,
              waitCustomer: false,
              time: DateTime.now(),
              bookingTable: false,
              bookingDate: null,
              customerId: 1),
        ], name: "Delivery", id: 0, tableCount: 2),
        HallModel(tables: [
          TableModel(
              number: "1",
              hall: "-1",
              voidAmount: 0,
              cost: 0,
              waitCustomer: false,
              time: DateTime.now(),
              bookingTable: false,
              bookingDate: null,
              customerId: 1),
        ], name: "Take Away", id: -1, tableCount: 2),
      ];
      isLoading(false);
      return true;
    } else {
      DioClient dio = DioClient();
      try {
        final response = await dio.getDio(path: '/info');
        if (response.statusCode == 200) {
          try {
            halls.clear();
            bills.clear();
            var data = jsonDecode(response.data);
            List list1 = jsonDecode(data['hall']);
            for (var i in list1) {
              List listTable = jsonDecode(i['tables']);
              List<TableModel> listT = [];
              for (var j in listTable) {
                listT.add(TableModel(
                    number: j['number'],
                    hall: j['hall'],
                    voidAmount: double.tryParse(j['amount']) ?? 0.0,
                    cost: double.tryParse(j['cost']) ?? 0.0,
                    waitCustomer: bool.tryParse(j['wait']) ?? false,
                    time: DateTime.tryParse(j['time']) ?? DateTime.now(),
                    bookingTable: bool.tryParse(j['booking']) ?? false,
                    bookingDate: DateTime.tryParse(j['booking-date']),
                    guestName: j['guest-name'],
                    guestMobile: j['guest-mobil'] ?? '',
                    guestNo: j['guestNo'] ?? '',
                    deliveryName: j['driver-name'],
                    formatNumber: j['format'],
                    customerId: int.tryParse(j['customerId']) ?? 0));
              }
              halls.add(HallModel(
                tables: listT,
                name: i["name"] == '' || i["name"] == null
                    ? i['id'].toString()
                    : i["name"],
                id: int.tryParse(i['id'].toString()) ?? 0,
                tableCount: int.tryParse(i["table-count"]) ?? 0,
              ));
            }
            List listBill = jsonDecode(data['bill']);
            for (var j in listBill) {
              bills.add(BillModel(
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
                customerId: null,
                storeId: int.tryParse(j['storeId']) ?? 0,
                invoice: '',
                numberOfBill: '',
                patternId: null,
                receiptDue: null,
                receiptStatus: '',
                typeInvoice: '',
              ));
            }
            badgeTakeaway.clear();
            badgeDelivery.clear();
            badgeTables.clear();
            for (var j in halls) {
              for (var i in j.tables) {
                if (i.hall == '-1' && (i.cost != 0 || i.bookingTable!)) {
                  badgeTakeaway.add(i);
                } else if (i.hall == '0' && (i.cost != 0 || i.bookingTable!)) {
                  badgeDelivery.add(i);
                } else if ((int.tryParse(i.hall) ?? 0) > 0 &&
                    (i.cost != 0 || i.bookingTable!)) {
                  badgeTables.add(i);
                }
              }
            }
            isLoading(false);
            update();
            return true;
          } catch (e) {
            debugPrint('Error ====>$e');
            isLoading(false);
            update();
            return false;
          }
        } else {
          debugPrint('Error');
          isLoading(false);
          update();
          return false;
        }
      } catch (e) {
        isLoading(false);
        return false;
      }
    }
  }

  Future<bool> checkQR() async {
    try {
      DioClient dio = DioClient();
      final response = await dio.getDio(path: '/check');
      if (response.statusCode == 200) {
        isLoadingCheck(true);
        if (response.data.toString() == 'success') {
          isLoadingCheck(false);
          return true;
        } else {
          isLoadingCheck(false);
          return false;
        }
      } else {
        isLoadingCheck(false);
        return false;
      }
    } catch (e) {
      isLoadingCheck(false);
      return false;
    }
  }

  Future<bool> checkMobile() async {
    isServerConnect(false);
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (GetPlatform.isAndroid) {
      var androidInfo = await deviceInfo.androidInfo;
      DioClient dio = DioClient();
      final response = await dio.postDio(
          path: '/check-mobile',
          data1: {"product": "${androidInfo.product}:Cashier"});
      if (response.statusCode == 200) {
        if (response.data['message'] == 'success') {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } else {
      var windowsInfo = await deviceInfo.windowsInfo;
      DioClient dio = DioClient();
      try {
        final response = await dio.postDio(
            path: '/check-mobile',
            data1: {"product": '${windowsInfo.deviceId}Cashier'});
        if (response.statusCode == 200) {
          isServerConnect(true);
          if (response.data['message'] == 'success') {
            return true;
          } else {
            return false;
          }
        } else {
          return false;
        }
      } catch (e) {
        return false;
      }
    }
  }

  Future<void> signUp() async {
    DioClient dio = DioClient();
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (GetPlatform.isAndroid) {
      var androidInfo = await deviceInfo.androidInfo;
      final data = {
        "name": androidInfo.brand,
        "device_id": '${androidInfo.product}:Cashier',
        "date": DateTime.now().toString()
      };
      final response = await dio.postDio(path: '/signup', data1: data);
      if (response.statusCode == 200) {
        Get.offAll(() => const LoginPage());
        Get.snackbar(
          'Success',
          'The Server Is Connected !!',
          isDismissible: false,
          backgroundColor: Colors.green,
          margin: EdgeInsets.only(
              left: Get.width / 3, right: Get.width / 3, top: 20),
          icon: const Icon(Icons.check),
        );
      } else {
        Get.back();
      }
    } else {
      var androidInfo = await deviceInfo.windowsInfo;
      final data = {
        "name": androidInfo.computerName,
        "device_id": '${androidInfo.deviceId}Cashier',
        "date": DateTime.now().toString()
      };
      final response = await dio.postDio(path: '/signup', data1: data);
      if (response.statusCode == 200) {
        Get.offAll(() => const LoginPage());
        Get.snackbar(
          'Success',
          'The Server Is Connected !!',
          isDismissible: false,
          backgroundColor: Colors.green,
          margin: EdgeInsets.only(
              left: Get.width / 3, right: Get.width / 3, top: 20),
          icon: const Icon(Icons.check),
        );
      } else {
        Get.back();
      }
    }
  }

  Future balanceSetting() async {
    DioClient dio = DioClient();
    try {
      final response = await dio.getDio(path: '/balance');

      if (response.statusCode == 200) {
        var data = response.data;
        if ((bool.tryParse(data['isActive']) ?? false)) {
          isActive.value = true;
          weight.value = bool.tryParse(data['weight']) ?? false;
          price.value = bool.tryParse(data['price']) ?? false;
          both.value = bool.tryParse(data['both']) ?? false;
          balanceStart.value = int.tryParse(data['balanceStart']) ?? 21;
          startProduct.value = int.tryParse(data['startProduct']) ?? 3;
          endProduct.value = int.tryParse(data['endProduct']) ?? 10;
          startWeight.value = int.tryParse(data['startWeight']) ?? 11;
          endWeight.value = int.tryParse(data['endWeight']) ?? 16;
          startPrice.value = int.tryParse(data['startPrice']) ?? 17;
          endPrice.value = int.tryParse(data['endPrice']) ?? 22;
          dotPrice.value = int.tryParse(data['dotPrice']) ?? 22;
          dotWeight.value = int.tryParse(data['dotWeight']) ?? 22;
          update();
        } else {
          isActive.value = false;
          update();
        }
      }
    } catch (e) {
      isActive.value = false;
      update();
      debugPrint("$e");
    }
  }

  Future getAllStore() async {
    DioClient dio = DioClient();
    stores.clear();
    try {
      final response = await dio.getDio(path: '/store');
      if (response.statusCode == 200) {
        for (var i in response.data['store']) {
          stores
              .add(StoreModel(name: i['name'], id: int.tryParse(i['id']) ?? 0));
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future getAllEmployee() async {
    DioClient dio = DioClient();
    employees.clear();
    try {
      final response = await dio.getDio(path: '/employee');
      if (response.statusCode == 200) {
        for (var i in response.data['employee']) {
          employees.add(EmployeeModel(
              id: int.tryParse(i['id']) ?? 0,
              englishName: i['englishName'],
              createdAt: DateTime.tryParse(i['createdAt']) ?? DateTime.now(),
              commission: double.tryParse(i['commission']) ?? 0.0,
              address: i['address'],
              arabicName: i['arabicName'],
              code: i['code'],
              isActive: bool.tryParse(i['isActive']) ?? false,
              mobilNum: i['mobilNum']));
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future getAllTaxesSetting() async {
    DioClient dio = DioClient();
    taxesSetting.clear();
    try {
      final response = await dio.getDio(path: '/tax-setting');
      if (response.statusCode == 200) {
        for (var i in response.data['tax']) {
          taxesSetting.add(TaxSettingModel(
            id: int.tryParse(i['id']) ?? 0,
            every: int.tryParse(i['every']) ?? 0,
            createAt: DateTime.tryParse(i['createAt']) ?? DateTime.now(),
            createBy: i['createBy'],
            taxId: int.tryParse(i['taxId']) ?? 0,
            taxNumber: i['taxNumber'],
            taxType: i['taxType'],
          ));
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future getAllTaxes() async {
    DioClient dio = DioClient();
    taxes.clear();
    try {
      final response = await dio.getDio(path: '/tax');
      if (response.statusCode == 200) {
        for (var i in response.data['tax']) {
          taxes.add(TaxModel(
            id: int.tryParse(i['id']) ?? 0,
            name: i['name'],
            createdAt: DateTime.tryParse(i['createdAt']) ?? DateTime.now(),
            taxValue: int.tryParse(i['taxValue']) ?? 0,
          ));
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future getCompanyInfo() async {
    DioClient dio = DioClient();
    final response = await dio.getDio(path: '/company-info');
    if (response.statusCode == 200) {
      companyInfo = CompanyInfo(
          id: int.tryParse(response.data['id'].toString()) ?? 0,
          ownerName: response.data['ownerName'],
          companyName: response.data['companyName'],
          address: response.data['address'],
          number: response.data['number'],
          additionalNumber: response.data['additionalNumber'],
          email: response.data['email'],
          webSite: response.data['webSite'],
          showWeb: bool.tryParse(response.data['showWeb'].toString()) ?? false,
          anotherAddress: response.data['anotherAddress'],
          image: response.data['image'],
          locationUrl: response.data['locationUrl'],
          showLocation:
              bool.tryParse(response.data['showLocation'].toString()) ?? false,
          facebookUrl: response.data['facebookUrl'],
          showFace:
              bool.tryParse(response.data['showFace'].toString()) ?? false,
          instagramUrl: response.data['instagramUrl'],
          showInstagram:
              bool.tryParse(response.data['showInstagram'].toString()) ?? false,
          twitterUrl: response.data['twitterUrl'],
          snapShatUrl: response.data['snapShatUrl'],
          youtubeUrl: response.data['youtubeUrl'],
          tiktokUrl: response.data['tiktokUrl'],
          showTiktok:
              bool.tryParse(response.data['showTiktok'].toString()) ?? false,
          showSnapShat:
              bool.tryParse(response.data['showSnapShat'].toString()) ?? false,
          showTwitter:
              bool.tryParse(response.data['showTwitter'].toString()) ?? false,
          showYoutube:
              bool.tryParse(response.data['showYoutube'].toString()) ?? false,
          companyImage: response.data['companyImage'] == null
              ? null
              : Uint8List.fromList(
                  List<int>.from((response.data['companyImage']) as List)));
    }
  }

  Future getAppType() async {
    DioClient dio = DioClient();
    final response = await dio.getDio(path: '/app-type');
    if (response.statusCode == 200) {
      ConstantApp.appType = AppTypeModel(
          id: int.tryParse(response.data['id'].toString()) ?? 0,
          backgroundColorDropDown: response.data['backgroundColorDropDown'],
          name: response.data['name'],
          primaryColor: response.data['primaryColor'],
          type: response.data['type'],
          backgroundImage: response.data['backgroundImage'],
          imageBar: response.data['imageBar'],
          titleBar: response.data['titleBar'],
          backImage: response.data['backImage'] == null
              ? response.data['backImage']
              : Uint8List.fromList(List<int>.from(response.data['backImage'])));
    }
  }
}
