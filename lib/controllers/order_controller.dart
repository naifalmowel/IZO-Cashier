import 'dart:convert';
import 'dart:typed_data';
import 'package:cashier_app/controllers/printer_controller.dart';
import 'package:cashier_app/models/table_model.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_cli/extensions/string.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/app_db.dart';
import '../database/app_db_controller.dart';
import '../models/bill_model.dart';
import '../models/category/category_model.dart';
import '../models/customer_model.dart';
import '../models/driver_model.dart';
import '../models/order/order_model.dart';
import '../models/product/product_model.dart';
import '../models/product/product_qty.dart';
import '../models/product/variable_product_model.dart';
import '../models/unit_model.dart';
import '../server/dio_services.dart';
import '../utils/constant.dart';
import 'info_controllers.dart';
import 'package:pdf/widgets.dart' as pw;

class OrderController extends GetxController {
  RxInt customerId = RxInt(0);
  RxInt orderWidth = RxInt(5);
  RxInt productWidth = RxInt(3);
  RxInt subWidth = RxInt(1);
  RxInt mainWidth = RxInt(1);
  RxInt productItem = RxInt(4);
  RxInt mainItem = RxInt(1);
  RxInt subItem = RxInt(1);
  RxBool showMain = RxBool(true);
  RxBool showSub = RxBool(true);
  RxBool obscure = false.obs;
  RxBool negative = false.obs;
  RxBool isDiscount = false.obs;
  RxBool loadingOrders = RxBool(false);
  RxList<ProductQty> proQty = RxList();
  RxList<OrderItem> orders = RxList();
  RxList<OrderModel> tempOrder = RxList();
  RxList<OrderModel> order = RxList();
  RxList<OrderModel> orderView = RxList();
  RxList<UnitModel> units = RxList();
  late RxInt selected1 = 100.obs;
  late RxInt checkOrderList = RxInt(0);
  late RxDouble totalPrice = 0.0.obs;
  late RxDouble priceWithOutVat = RxDouble(0.0);
  late RxDouble fTotal = RxDouble(0.0);
  late RxDouble vatAfterDis = RxDouble(0.0);
  late RxDouble vat = RxDouble(0.0);
  late RxDouble disAmount = RxDouble(0.0);
  late RxDouble discount = RxDouble(0.0);
  late OrderModel orderTemp;
  late RxDouble qty = 0.0.obs;
  TextEditingController? discountValue = TextEditingController();
  String type = "TakeAway";
  late RxBool keyboardVis = false.obs;
  late RxBool showUnit = false.obs;
  RxList<CustomerModel> customer = RxList();
  RxString customerName = RxString('');
  RxString salesType = RxString('sales');
  RxString voidReason = RxString('');
  RxString priceType = RxString('');
  RxString discountType = RxString('%');
  RxList<ProductModel> products = RxList();
  RxList<ProductVariableModel> allVariable = RxList([]);
  RxList<ProductVariableModel> productsVariable = RxList([]);
  RxList<SubCategoryModel> subCategories = RxList([]);
  RxList<MainCategoryModel> mainCategory = RxList([]);
  RxList<SubCategoryModel> subCategoriesPlayer = RxList([]);
  RxList<MainCategoryModel> mainCategoryPlayer = RxList([]);
  RxList<ProductModel> productDataPlayer = RxList([]);
  var productsLoading = false.obs;
  RxInt orderNumber = 0.obs;
  var requstingBill = false.obs;
  RxInt selectDriver = RxInt(0);
  List<DriverModel> drivers = RxList([]);
  late String guest = 'Global';
  RxList<String> listGuest = RxList([]);
  RxBool enableGuests = false.obs;
  RxBool allChange = false.obs;
  RxBool guestChange = false.obs;
  RxBool singleChange = false.obs;
  late RxBool byMistake = RxBool(false);
  late RxBool changeHisMind = RxBool(false);
  late RxBool cold = RxBool(false);
  late RxBool delay = RxBool(false);
  late RxBool notLike = RxBool(false);
  late RxBool cash = RxBool(true);
  late RxBool visa = RxBool(false);
  late RxBool cashVisa = RxBool(false);
  late RxDouble paid = 0.0.obs;
  late RxDouble balance = 0.0.obs;

  Map<String, IconData> icons = {
    "ban": FontAwesomeIcons.ban,
    "bowlFood": FontAwesomeIcons.bowlFood,
    "bowlRice": FontAwesomeIcons.bowlRice,
    "fastfood_outlined": Icons.fastfood_outlined,
    "burger": FontAwesomeIcons.burger,
    "hotdog": FontAwesomeIcons.hotdog,
    "pizzaSlice": FontAwesomeIcons.pizzaSlice,
    "breadSlice": FontAwesomeIcons.breadSlice,
    "cakeCandles": FontAwesomeIcons.cakeCandles,
    "cheese": FontAwesomeIcons.cheese,
    "candyCane": FontAwesomeIcons.candyCane,
    "cookie": FontAwesomeIcons.cookie,
    "iceCream": FontAwesomeIcons.iceCream,
    "fish": FontAwesomeIcons.fish,
    "shrimp": FontAwesomeIcons.shrimp,
    "appleWhole": FontAwesomeIcons.appleWhole,
    "wineBottle": FontAwesomeIcons.wineBottle,
    "wineGlass": FontAwesomeIcons.wineGlass,
    "mugHot": FontAwesomeIcons.mugHot,
    "emoji_food_beverage_rounded": Icons.emoji_food_beverage_rounded,
  };

  Map<String, IconData> iconsRetail = {
    "ban": FontAwesomeIcons.ban,
    "shopify": FontAwesomeIcons.shopify,
    "personDress": FontAwesomeIcons.personDress,
    "person": FontAwesomeIcons.person,
    "shirt": FontAwesomeIcons.shirt,
    "bagShopping": FontAwesomeIcons.bagShopping,
    "child": FontAwesomeIcons.child,
    "baby": FontAwesomeIcons.baby,
    "ring": FontAwesomeIcons.ring,
    "gifts": FontAwesomeIcons.gifts,
    "childDress": FontAwesomeIcons.childDress,
    "babyCarriage": FontAwesomeIcons.babyCarriage,
    "mitten": FontAwesomeIcons.mitten,
    "socks": FontAwesomeIcons.socks,
    "umbrella": FontAwesomeIcons.umbrella,
  };

  Map<String, IconData> iconsSalon = {
    "ban": FontAwesomeIcons.ban,
    "stethoscope": FontAwesomeIcons.stethoscope,
    "hospital": FontAwesomeIcons.hospital,
    "user-injured": FontAwesomeIcons.userInjured,
    "user-doctor": FontAwesomeIcons.userDoctor,
    "truck-medical": FontAwesomeIcons.truckMedical,
    "syringe": FontAwesomeIcons.syringe,
    "bandage": FontAwesomeIcons.bandage,
    "microscope": FontAwesomeIcons.microscope,
    "mask-face": FontAwesomeIcons.maskFace,
    "lungs-virus": FontAwesomeIcons.lungsVirus,
    "kit-medical": FontAwesomeIcons.kitMedical,
    "heart-pulse": FontAwesomeIcons.heartPulse,
    "suitcase-medical": FontAwesomeIcons.suitcaseMedical,
    "spray-can-sparkles": FontAwesomeIcons.sprayCanSparkles,
    "scissors": FontAwesomeIcons.scissors,
    "ruler-horizontal": FontAwesomeIcons.rulerHorizontal,
    "pump-soap": FontAwesomeIcons.pumpSoap,
    "cut": Icons.cut,
    "bedroom_child": Icons.bedroom_child,
    "bathroom": Icons.bathroom,
    "hot_tub": Icons.hot_tub,
    "description": Icons.description,
  };

  Future getProductQty() async {
    if (ConstantApp.type == "guest") {
      proQty.value = [
        ProductQty(proId: 1, variableId: 1, qty: 10, name: "name"),
        ProductQty(proId: 2, variableId: 2, qty: 10, name: "name"),
        ProductQty(proId: 3, variableId: 3, qty: 10, name: "name"),
      ];
    } else {
      DioClient dio = DioClient();
      proQty.clear();
      final response = await dio.getDio(path: '/product-qty');
      if (response.statusCode == 200) {
        var data = response.data;
        for (var i in data['product']) {
          proQty.add(ProductQty(
            proId: int.tryParse(i['proId']) ?? 0,
            variableId: int.tryParse(i['varId']) ?? 0,
            qty: double.tryParse(i['qty']) ?? 0.0,
            name: i['proName'],
          ));
        }
      }
    }
    update();
  }

  Future<void> getAllProducts() async {
    if (ConstantApp.type == "guest") {
      products.value = [
        ProductModel(
          id: 1,
          englishName: "product 1",
          arabicName: "",
          type: "single",
          barcode: "00001",
          price: "15",
          qty: 10,
          mainId: "1",
          subId: "1",
          colorProduct: "0xb3ec1c1c",
          image: Uint8List(0),
        ),
        ProductModel(
          id: 2,
          englishName: "product 2",
          arabicName: "",
          type: "single",
          barcode: "00001",
          price: "15",
          qty: 10,
          mainId: "1",
          subId: "1",
          colorProduct: "0xb3ec1c1c",
          image: Uint8List(0),
        ),
        ProductModel(
          id: 3,
          englishName: "product 3",
          arabicName: "",
          type: "single",
          barcode: "00001",
          price: "15",
          qty: 10,
          mainId: "1",
          subId: "1",
          colorProduct: "0xb3ec1c1c",
          image: Uint8List(0),
        ),
        ProductModel(
          id: 4,
          englishName: "product 4",
          arabicName: "",
          type: "single",
          barcode: "00001",
          price: "15",
          qty: 10,
          mainId: "1",
          subId: "1",
          colorProduct: "0xb3ec1c1c",
          image: Uint8List(0),
        ),
        ProductModel(
          id: 5,
          englishName: "product 5",
          arabicName: "",
          type: "single",
          barcode: "00001",
          price: "15",
          qty: 10,
          mainId: "2",
          subId: "2",
          colorProduct: "0xb3ec1c1c",
          image: Uint8List(0),
        ),
        ProductModel(
          id: 6,
          englishName: "product 6",
          arabicName: "",
          type: "single",
          barcode: "00001",
          price: "15",
          qty: 10,
          mainId: "2",
          subId: "2",
          colorProduct: "0xb3ec1c1c",
          image: Uint8List(0),
        ),
        ProductModel(
          id: 7,
          englishName: "product 7",
          arabicName: "",
          type: "single",
          barcode: "00001",
          price: "15",
          qty: 10,
          mainId: "2",
          subId: "2",
          colorProduct: "0xb3ec1c1c",
          image: Uint8List(0),
        ),
        ProductModel(
          id: 8,
          englishName: "product 8",
          arabicName: "",
          type: "single",
          barcode: "00001",
          price: "15",
          qty: 10,
          mainId: "2",
          subId: "2",
          colorProduct: "0xb3ec1c1c",
          image: Uint8List(0),
        ),
        ProductModel(
          id: 1,
          englishName: "product 9",
          arabicName: "",
          type: "single",
          barcode: "00001",
          price: "15",
          qty: 10,
          mainId: "1",
          subId: "1",
          colorProduct: "0xb3ec1c1c",
          image: Uint8List(0),
        ),
        ProductModel(
          id: 2,
          englishName: "product 10",
          arabicName: "",
          type: "single",
          barcode: "00001",
          price: "15",
          qty: 10,
          mainId: "1",
          subId: "1",
          colorProduct: "0xb3ec1c1c",
          image: Uint8List(0),
        ),
        ProductModel(
          id: 3,
          englishName: "product 11",
          arabicName: "",
          type: "single",
          barcode: "00001",
          price: "15",
          qty: 10,
          mainId: "1",
          subId: "1",
          colorProduct: "0xb3ec1c1c",
          image: Uint8List(0),
        ),
        ProductModel(
          id: 4,
          englishName: "product 12",
          arabicName: "",
          type: "single",
          barcode: "00001",
          price: "15",
          qty: 10,
          mainId: "1",
          subId: "1",
          colorProduct: "0xb3ec1c1c",
          image: Uint8List(0),
        ),
        ProductModel(
          id: 5,
          englishName: "product 13",
          arabicName: "",
          type: "single",
          barcode: "00001",
          price: "15",
          qty: 10,
          mainId: "2",
          subId: "2",
          colorProduct: "0xb3ec1c1c",
          image: Uint8List(0),
        ),
        ProductModel(
          id: 6,
          englishName: "product 14",
          arabicName: "",
          type: "single",
          barcode: "00001",
          price: "15",
          qty: 10,
          mainId: "2",
          subId: "2",
          colorProduct: "0xb3ec1c1c",
          image: Uint8List(0),
        ),
        ProductModel(
          id: 7,
          englishName: "product 15",
          arabicName: "",
          type: "single",
          barcode: "00001",
          price: "15",
          qty: 10,
          mainId: "2",
          subId: "2",
          colorProduct: "0xb3ec1c1c",
          image: Uint8List(0),
        ),
        ProductModel(
          id: 8,
          englishName: "product 16",
          arabicName: "",
          type: "single",
          barcode: "00001",
          price: "15",
          qty: 10,
          mainId: "2",
          subId: "2",
          colorProduct: "0xb3ec1c1c",
          image: Uint8List(0),
        ),
      ];
      mainCategory.value = [
        MainCategoryModel(
            id: 1,
            englishName: "main 1",
            image: Uint8List(0),
            color: "0xb3ec1c1c",
            icon: null),
        MainCategoryModel(
            id: 2,
            englishName: "main 2",
            image: Uint8List(0),
            color: "0xb3ec1c1c",
            icon: null),
      ];
      subCategories.value = [
        SubCategoryModel(
            id: 1,
            englishName: "sub 1",
            image: Uint8List(0),
            color: "0xb3ec1c1c",
            mainId: 1,
            icon: null),
        SubCategoryModel(
            id: 2,
            englishName: "sub 2",
            image: Uint8List(0),
            color: "0xb3ec1c1c",
            mainId: 2,
            icon: null),
      ];
      mainCategoryPlayer.value = mainCategory;
      subCategoriesPlayer.value = subCategories;
      productDataPlayer.value = products;
    } else {
      DioClient dio = DioClient();
      final response = await dio.getDio(path: '/product');
      if (response.statusCode == 200) {
        var data = response.data;
        List allProduct = data["product"];
        List allVar = data["variable"];
        List allMain = data['main_cat'];
        List allSub = data['sub_cat'];
        negative.value = bool.tryParse(data['negative_sale'])??false;
        products.clear();
        allVariable.clear();
        subCategories.clear();
        mainCategory.clear();
        for (var i in allProduct) {
          products.add(ProductModel(
            id: int.tryParse(i['id']) ?? 0,
            englishName: i['englishName'],
            arabicName: i['arabicName'],
            image: Uint8List.fromList(List<int>.from(i['image'] as List)),
            price: i['price'],
            price2: i['price2'],
            price3: i['price3'],
            description: i['description'],
            code: i['code'],
            subId: i['subId'],
            mainId: i['mainId'],
            type: i['type'],
            unit: int.tryParse(i['unit']) ?? 0,
            unit2: int.tryParse(i['unit2']) ?? 0,
            unit3: int.tryParse(i['unit3']) ?? 0,
            barcode: i['barcode'],
            barcode2: i['barcode2'],
            barcode3: i['barcode3'],
            variableId: int.tryParse(i['variableId']) ?? 0,
            vat: double.tryParse(i['vat']) ?? 0.0,
            qty: double.tryParse(i['qty']) ?? 0.0,
            vatId: int.tryParse(i['vatId']) ?? 0,
            recipeId: int.tryParse(i['recipeId']) ?? 0,
            forSale: bool.tryParse(i['forSale']) ?? false,
            colorProduct: i['colorProduct'],
            wholePrice: double.tryParse(i['wholePrice']) ?? 0.0,
            wholePrice2: double.tryParse(i['wholePrice2']) ?? 0.0,
            wholePrice3: double.tryParse(i['wholePrice3']) ?? 0.0,
            minPrice: double.tryParse(i['minPrice']) ?? 0.0,
            minPrice2: double.tryParse(i['minPrice2']) ?? 0.0,
            minPrice3: double.tryParse(i['minPrice3']) ?? 0.0,
            maxPrice: double.tryParse(i['maxPrice']) ?? 0.0,
            maxPrice2: double.tryParse(i['maxPrice2']) ?? 0.0,
            maxPrice3: double.tryParse(i['maxPrice3']) ?? 0.0,
            costPrice: double.tryParse(i['costPrice']) ?? 0.0,
            costPrice2: double.tryParse(i['costPrice2']) ?? 0.0,
            costPrice3: double.tryParse(i['costPrice3']) ?? 0.0,

          ));
        }
        for (var i in allVar) {
          allVariable.add(ProductVariableModel(
            id: int.tryParse(i['id']) ?? 0,
            proId: int.tryParse(i['proId']) ?? 0,
            image: Uint8List.fromList(List<int>.from(i['image'] as List)),
            price: double.tryParse(i['price']) ?? 0.0,
            code: i['code'],
            recipeId: int.tryParse(i['recipeId']) ?? 0,
            size: i['size'],
            color: i['color'],
            barcode: i['barcode'],
            name: i['name'],
            date: DateTime.tryParse(i['date']) ?? DateTime.now(),
          ));
        }
        for (var i in allMain) {
          mainCategory.add(MainCategoryModel(
              id: int.tryParse(i['id']) ?? 0,
              englishName: i['englishName'],
              color: i['color'],
              image: Uint8List.fromList(List<int>.from(i['image'] as List)),
              icon: i['icon']));
        }
        for (var i in allSub) {
          subCategories.add(SubCategoryModel(
            id: int.tryParse(i['id']) ?? 0,
            englishName: i['englishName'],
            color: i['color'],
            image: Uint8List.fromList(List<int>.from(i['image'] as List)),
            mainId: int.tryParse(i['mainId']) ?? 0,
            icon: i['icon'],
          ));
        }
        mainCategoryPlayer.value = mainCategory;
        subCategoriesPlayer.value = subCategories;
        productDataPlayer.value = products;
      }
    }
    Get.find<SharedPreferences>().remove('negative');
    Get.find<SharedPreferences>().setBool('negative', negative.value);
    update();
  }

  Future getVariable(int id) async {
    productsVariable.value = allVariable.where((p0) => p0.proId == id).toList();

    update();
  }

  Future<void> getAllOrders() async {
    if (ConstantApp.type == "guest") {
      order.value = [
        OrderModel(
            name: "1",
            quantity: 2,
            price: 30,
            itemId: 1,
            createdAt: DateTime.now(),
            totalPrice: 30,
            guest: "guest",
            table: "1",
            hall: "1",
            ident: "alaa",
            note: "note",
            unitId: 1,
            vatId: 0,
            catId: "1"),
        OrderModel(
            name: "2",
            quantity: 2,
            price: 30,
            itemId: 2,
            createdAt: DateTime.now(),
            totalPrice: 30,
            guest: "guest",
            table: "1",
            hall: "1",
            ident: "alaa",
            note: "note",
            unitId: 1,
            vatId: 0,
            catId: "1"),
        OrderModel(
            name: "3",
            quantity: 3,
            price: 45,
            itemId: 3,
            createdAt: DateTime.now(),
            totalPrice: 30,
            guest: "guest",
            table: "1",
            hall: "1",
            ident: "alaa",
            note: "note",
            unitId: 1,
            vatId: 0,
            catId: "1"),
      ];
      units.value = [
        UnitModel(
            id: 1,
            name: "pieces",
            arabicName: "pieces",
            qty: 1,
            source: 0,
            acceptsDecimal: false,
            createdAt: DateTime.now())
      ];
      orders.value = [
        OrderItem(id: 1, orderDate: DateTime.now(), orders: order),
      ];
      customer.value = [
        CustomerModel(
            id: 1,
            firstName: "علاء",
            lastName: "Alaa",
            businessName: "Alaa",
            code: "code",
            address: ["Dubai"],
            mobileList: ["25556556"],
            city: "Dubai",
            email: "alaa@gmail.com",
            type: "Customer",
            createAt: DateTime.now()),
        CustomerModel(
            id: 2,
            firstName: "naif",
            lastName: "naif",
            businessName: "naif",
            code: "code",
            address: ["Dubai"],
            mobileList: ["25556556"],
            city: "Dubai",
            email: "naif@gmail.com",
            type: "Customer",
            createAt: DateTime.now()),
      ];
      totalPrice.value = 155;
      qty.value = 7;
    } else {
      DioClient dio = DioClient();
      order.clear();
      orderView.clear();
      final response = await dio.getDio(path: '/order');
      if (response.statusCode == 200) {
        var data = response.data;
        List list = data['order'];
        List list1 = data['order-view'];
        for (var i in list) {
          order.add(OrderModel(
            id: int.tryParse(i['id']) ?? 0,
            name: i['name'],
            quantity: double.tryParse(i['quantity']) ?? 0.0,
            price: double.tryParse(i['price']) ?? 0.0,
            itemId: int.tryParse(i['itemId']) ?? 0,
            createdAt: DateTime.tryParse(i['createdAt']) ?? DateTime.now(),
            totalPrice: double.tryParse(i['totalPrice']) ?? 0.0,
            serial: int.tryParse(i['serial']) ?? 0,
            variableId: int.tryParse(i['variableId']) ?? 0,
            recipeId: int.tryParse(i['recipeId']) ?? 0,
            vatId: int.tryParse(i['vatId']) ?? 0,
            unitId: int.tryParse(i['unitId']) ?? 0,
            guest: i['guest'],
            table: i['table'],
            hall: i['hall'],
            ident: i['ident'],
            note: i['note'],
            billNum: i['billNum'],
            productType: i['productType'],
            catId: i['catId'],
            salesType: i['salesType'],
            employeeId: int.tryParse(i['employeeId'] ?? '0') ?? 0,
          ));
        }
        for (var i in list1) {
          orderView.add(OrderModel(
            id: int.tryParse(i['id']) ?? 0,
            name: i['name'],
            quantity: double.tryParse(i['quantity']) ?? 0.0,
            price: double.tryParse(i['price']) ?? 0.0,
            itemId: int.tryParse(i['itemId']) ?? 0,
            createdAt: DateTime.tryParse(i['createdAt']) ?? DateTime.now(),
            totalPrice: double.tryParse(i['totalPrice']) ?? 0.0,
            serial: int.tryParse(i['serial']) ?? 0,
            variableId: int.tryParse(i['variableId']) ?? 0,
            recipeId: int.tryParse(i['recipeId']) ?? 0,
            vatId: int.tryParse(i['vatId']) ?? 0,
            unitId: int.tryParse(i['unitId']) ?? 0,
            guest: i['guest'],
            table: i['table'],
            hall: i['hall'],
            ident: i['ident'],
            note: i['note'],
            billNum: i['billNum'],
            productType: i['productType'],
            catId: i['catId'],
            salesType: i['salesType'],
            employeeId: int.tryParse(i['employeeId'] ?? '0') ?? 0,
          ));
        }
      }
    }
  }

  Future getOrderForTable(String hall, String table) async {
    loadingOrders(true);
    var orderTable =
        order.where((e) => e.hall == hall && e.table == table).toList();
    if (orderTable.isEmpty) {
      loadingOrders(false);
      orders.clear();
      totalPrice.value = 0.0;
      qty.value = 0.0;
      salesType.value = 'sales';
      return;
    }
    List<int?> temp = [];
    for (var i in orderTable) {
      if (!temp.contains(i.serial)) {
        temp.add(i.serial);
      }
    }
    orders.clear();
    for (var i in temp) {
      var d = order.firstWhere((element) => element.serial == i);
      orders.add(OrderItem(
        id: i!,
        orderDate: d.createdAt,
        orders: orderTable.where((element) => element.serial == i).map((e) {
          return OrderModel(
              id: e.id,
              name: e.name,
              quantity: e.quantity,
              price: e.price,
              itemId: e.itemId,
              createdAt: e.createdAt,
              totalPrice: e.totalPrice,
              guest: e.guest,
              table: e.table,
              hall: e.hall,
              ident: e.ident,
              note: e.note,
              unitId: e.unitId,
              vatId: e.vatId,
              billNum: e.billNum,
              serial: e.serial,
              variableId: e.variableId,
              recipeId: e.recipeId,
              productType: e.productType,
              salesType: e.salesType,
              employeeId: e.employeeId,
              catId: e.catId);
        }).toList(),
      ));
    }
    update();
    totalPrice.value = 0.0;
    qty.value = 0.0;
    for (var i in orderTable) {
      priceWithOutVat.value = totalPrice.value += (i.quantity * i.price);
      qty.value += i.quantity;
    }
    salesType.value =
        (orderTable.isEmpty ? 'sales' : orderTable.last.salesType) ?? 'sales';
    loadingOrders(false);
    update();
    await getDetails();
  }

  void filterMainPlayer(String playerName) {
    List<MainCategoryModel> results = [];
    if (playerName.isEmpty) {
      results = mainCategory;
    } else {
      results = mainCategory
          .where((element) => element.englishName
              .toString()
              .toLowerCase()
              .contains(playerName.toLowerCase()))
          .toList();
    }
    mainCategoryPlayer.value = results;
    update();
  }

  Future<void> fillMain(int mainId) async {
    subCategoriesPlayer.value =
        subCategories.where((p0) => p0.mainId == mainId).toList();
    productDataPlayer.value = products
        .where((p0) => p0.type != 'raw' && p0.mainId == mainId.toString())
        .toList();
    update();
  }

  Future<void> fillProduct(int subId) async {
    productDataPlayer.value = products
        .where((p0) => p0.type != 'raw' && p0.subId == subId.toString())
        .toList();
    update();
  }

  void filterSubPlayer(String playerName) {
    List<SubCategoryModel> results = [];
    if (playerName.isEmpty) {
      results = subCategories;
    } else {
      results = subCategories
          .where((element) => element.englishName
              .toString()
              .toLowerCase()
              .contains(playerName.toLowerCase()))
          .toList();
    }
    subCategoriesPlayer.value = results;
    update();
  }

  void filterProductPlayer(String playerName) {
    List<ProductModel> results = [];
    if (playerName.isEmpty) {
      results = products.where((p0) => p0.type != 'raw').toList();
    } else {
      results = products
          .where((p0) => p0.type != 'raw')
          .toList()
          .where((element) =>
              element.englishName
                  .toString()
                  .toLowerCase()
                  .contains(playerName.toLowerCase()) ||
              element.arabicName
                  .toString()
                  .toLowerCase()
                  .contains(playerName.toLowerCase()))
          .toList();
    }
    productDataPlayer.value = results;
    update();
  }

  Future<void> getCustomerOrderNumber() async {
    DioClient dio = DioClient();
    try {
      final response = await dio.getDio(path: '/customer');
      if (response.statusCode == 200) {
        customer.clear();
        units.clear();
        var data = response.data;
        List customers = data['customer'];
        List unit = data['units'];
        orderNumber.value = int.tryParse(data['order_no']) ?? 0;
        for (var i in customers) {
          customer.add(
            CustomerModel(
              id: int.tryParse(i['id']) ?? 0,
              firstName: i['firstName'],
              lastName: i['lastName'],
              businessName: i['businessName'],
              code: i['code'],
              address: List<String>.from(i['address']),
              mobileList: List<String>.from(i['mobileList']),
              city: i['city'],
              email: i['email'],
              type: i['type'],
              createAt: DateTime.tryParse(i['type']) ?? DateTime.now(),
            ),
          );
        }
        for (var i in unit) {
          units.add(
            UnitModel(
              id: int.tryParse(i['id']) ?? 0,
              name: i['name'],
              arabicName: i['arabicName'],
              qty: i['qty'],
              source: int.tryParse(i['source']) ?? 0,
              acceptsDecimal: bool.tryParse(i['acceptsDecimal']) ?? false,
              createdAt: DateTime.tryParse(i['createdAt']) ?? DateTime.now(),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint("$e");
    }
    update();
  }

  Future<void> addProductFromBarcode(
    String barcode,
    BuildContext context,
    String hall,
    String table,
  ) async {
    await getProductQty();
    var controller = Get.find<InfoController>();
    await controller.balanceSetting();
    List<double> list = [];
    for (var i in tempOrder) {
      list.add(i.quantity);
    }
    ///todo before syria same izo pos
    var allProduct = products;
    var allVar = allVariable;
    String weightBarcode = '';
    String priceBarcode = '';
    if (controller.isActive.value) {
      if ((controller.isActive.value &&
          barcode.startsWith(controller.balanceStart.value.toString())&& barcode.length >= controller.endProduct.value)) {
        String productBarcode = barcode.substring(
            controller.startProduct.value - 1, controller.endProduct.value);
        int max = 0;
        if(controller.endPrice.value >= controller.endWeight.value){
          max =controller.endPrice.value;
        }else{
          max =controller.endWeight.value;
        }
        if (controller.both.value && barcode.length >= max) {
          weightBarcode = barcode.substring(
              controller.startWeight.value - 1, controller.endWeight.value).insert(controller.dotWeight.value , '.');
          priceBarcode = barcode.substring(
              controller.startPrice.value - 1, controller.endPrice.value).insert(controller.dotPrice.value , '.');
        } else if (controller.weight.value) {
          weightBarcode = barcode.substring(
              controller.startWeight.value - 1, controller.endWeight.value).insert(controller.dotWeight.value , '.');
        } else if (controller.price.value) {
          priceBarcode = barcode.substring(
              controller.startPrice.value - 1, controller.endPrice.value).insert(controller.dotPrice.value , '.');
        } else {
          weightBarcode = '';
          priceBarcode = '';
        }
        for (var i in allProduct) {
          if (i.barcode == productBarcode) {
            if (i.type != 'variable') {
              double qty = proQty
                  .where((element) =>
                      element.proId == i.id && element.variableId == 0)
                  .toList()
                  .last
                  .qty;
              for (var j in tempOrder) {
                if (j.itemId == i.id! && j.variableId == 0) {
                  qty -= j.quantity;
                }
              }
              if (negative.value ? true : qty > 0) {
                await addOrder(i, 0, double.tryParse(weightBarcode),
                    double.tryParse(priceBarcode), hall, table);
                break;
              }
            }
          }
        }
        for (var j in allVar) {
          if (j.barcode == productBarcode) {
            double qty = proQty
                .where((element) =>
                    element.proId == j.proId && element.variableId == j.id)
                .toList()
                .last
                .qty;
            for (var i in tempOrder) {
              if (i.itemId == j.proId! && i.variableId == j.id) {
                qty -= i.quantity;
              }
            }
            if ((negative.value ? true : qty > 0)) {
              var i = allProduct.firstWhere((element) => element.id == j.proId);
              await addOrder(i, j.id!, double.tryParse(weightBarcode),
                  double.tryParse(priceBarcode), hall, table);
              break;
            }
          }
        }
      } else {
        for (var i in allProduct) {
          if (i.barcode == barcode) {
            if (i.type != 'variable') {
              double qty = proQty
                  .where((element) =>
                      element.proId == i.id && element.variableId == 0)
                  .toList()
                  .last
                  .qty;
              for (var j in tempOrder) {
                if (j.itemId == i.id! && j.variableId == 0) {
                  qty -= j.quantity;
                }
              }
              if (negative.value ? true : qty > 0) {
                await addOrder(i, 0, double.tryParse(weightBarcode),
                    double.tryParse(priceBarcode), hall, table);
                break;
              }
            }
          }
        }
        for (var j in allVar) {
          if (j.barcode == barcode) {
            double qty = proQty
                .where((element) =>
                    element.proId == j.proId && element.variableId == j.id)
                .toList()
                .last
                .qty;
            for (var i in tempOrder) {
              if (i.itemId == j.proId! && i.variableId == j.id) {
                qty -= i.quantity;
              }
            }
            if ((negative.value ? true : qty > 0)) {
              var i = allProduct.firstWhere((element) => element.id == j.proId);
              await addOrder(i, j.id!, double.tryParse(weightBarcode),
                  double.tryParse(priceBarcode), hall, table);
              break;
            }
          }
        }
      }
    } else {
      for (var i in allProduct) {
        if (i.barcode == barcode) {
          if (i.type != 'variable') {
            double qty = proQty
                .where((element) =>
                    element.proId == i.id && element.variableId == 0)
                .toList()
                .last
                .qty;
            for (var j in tempOrder) {
              if (j.itemId == i.id! && j.variableId == 0) {
                qty -= j.quantity;
              }
            }
            if (negative.value ? true : qty > 0) {
              await addOrder(i, 0, double.tryParse(weightBarcode),
                  double.tryParse(priceBarcode), hall, table);
              break;
            }
          }
        }
      }
      for (var j in allVar) {
        if (j.barcode == barcode) {
          double qty = proQty
              .where((element) =>
                  element.proId == j.proId && element.variableId == j.id)
              .toList()
              .last
              .qty;
          for (var i in tempOrder) {
            if (i.itemId == j.proId! && i.variableId == j.id) {
              qty -= i.quantity;
            }
          }
          if ((negative.value ? true : qty > 0)) {
            var i = allProduct.firstWhere((element) => element.id == j.proId);
            await addOrder(i, j.id!, double.tryParse(weightBarcode),
                double.tryParse(priceBarcode), hall, table);
            break;
          }
        }
      }
    }
    if (list.equals(tempOrder.map((element) => element.quantity).toList())) {
      if (!context.mounted) return;
      ConstantApp.showSnakeBarError(context, 'Not Found !!');
      return;
    }
  }

  Future<void> addOrder(
    ProductModel product,
    int variableId,
    double? qtyBarcode,
    double? priceBarcode,
    String hall,
    String table,
  ) async {
    for (var i in customer) {
      if (customerId.value == i.id) {
        customerName.value = i.businessName;
      }
    }
    String varName = '';
    double price = 0.0;
    int recipeVarId = 0;
    for (var i in allVariable) {
      if (i.id == variableId) {
        varName = i.name!;
        price = i.price!;
        recipeVarId = i.recipeId!;
      }
    }
    final prefs = await SharedPreferences.getInstance();
    OrderModel? temp;
    if (tempOrder.isEmpty) {
      totalPrice.value = 0;
      qty.value = 0;
    }
    for (var x in tempOrder) {
      if (x.itemId == product.id &&
          x.guest == guest &&
          x.note == '' &&
          x.variableId == variableId) {
        temp = x;
        break;
      }
    }
    bool isCumulatively =
        Get.find<SharedPreferences>().getBool('Cumulatively') ?? false;
    var index = tempOrder.indexOf(temp);
    if (isCumulatively && index != -1) {
      add(index, 'i', qtyBarcode);
    } else {
      qty.value += qtyBarcode ?? 1;
      totalPrice.value += priceBarcode ??
          (variableId == 0 ? double.parse(product.price!) : price);
      tempOrder.add(OrderModel(
        name: variableId == 0
            ? product.englishName!
            : '${product.englishName!}/$varName',
        quantity: qtyBarcode ?? 1,
        price: priceBarcode != null && qtyBarcode != null
            ? priceBarcode / qtyBarcode
            : (variableId == 0 ? double.parse(product.price!) : price),
        itemId: product.id!,
        createdAt: DateTime.now(),
        totalPrice: priceBarcode ??
            (variableId == 0 ? double.parse(product.price!) : price),
        serial: orderNumber.value,
        guest: guest,
        table: table,
        hall: hall,
        ident: prefs.getString('name')!,
        note: '',
        variableId: variableId,
        productType: product.type,
        recipeId: variableId == 0 ? product.recipeId : recipeVarId,
        vatId: product.vatId,
        unitId: product.unit,
        catId: product.subId,
        wholePrice: product.wholePrice,
        wholePrice2: product.wholePrice2,
        wholePrice3: product.wholePrice3,
        minPrice: product.minPrice,
        minPrice2: product.minPrice2,
        minPrice3: product.minPrice3,
        maxPrice: product.maxPrice,
        maxPrice2: product.maxPrice2,
        maxPrice3: product.maxPrice3,
        costPrice: product.costPrice,
        costPrice2: product.costPrice2,
        costPrice3: product.costPrice3,
        firstPrice: priceBarcode != null && qtyBarcode != null
            ? priceBarcode / qtyBarcode
            : (variableId == 0 ? double.parse(product.price!) : price),
        commission: 0,
      ));
    }
    update();
  }

  void add(
    int index,
    String quantity,
    double? qtyBar,
  ) {
    if (quantity == 'i') {
      tempOrder[index].quantity += (qtyBar ?? 1);
      tempOrder[index].totalPrice =
          tempOrder[index].price * tempOrder[index].quantity;
      totalPrice.value +=
          tempOrder[index].totalPrice / tempOrder[index].quantity;
      qty.value += tempOrder[index].quantity;
    } else {
      tempOrder[index].quantity = double.parse(quantity);
      tempOrder[index].totalPrice =
          tempOrder[index].price * tempOrder[index].quantity;
      totalPrice.value = 0;
      qty.value = 0;
      for (var i in tempOrder) {
        totalPrice.value += (i.price * i.quantity);
        qty.value += i.quantity;
      }
    }
    update();
  }

  Future sendOrder() async {
    loadingOrders(true);
    DioClient dio = DioClient();
    List<Map<String, dynamic>> list = [];
    for (var i in tempOrder) {
      list.add({
        "name": i.name,
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
        "guest": i.guest,
        "table": i.table,
        "hall": i.hall,
        "ident": i.ident,
        "note": i.note,
        "billNum": i.billNum.toString(),
        "productType": i.productType,
        "catId": i.catId,
        "employeeId": i.employeeId.toString(),
        "commission": i.commission.toString()
      });
    }

    Map<String, dynamic> data1 = {
      "temp": jsonEncode(list),
      "customer_id": customerId.value.toString(),
      "total": totalPrice.value.toString(),
      "salesType": salesType.value.toString(),
    };
    final response = await dio.postDio(path: '/send-order', data1: data1);
    if (response.statusCode == 200) {
      await getOrderForTable(tempOrder.last.hall, tempOrder.last.table);
      tempOrder.clear();
    }

    await getDetails();
    loadingOrders(false);
    update();
  }

  Future voidOrder(
      {required OrderModel order,
      required String reason,
      required double qty1}) async {
    loadingOrders(true);
    DioClient dio = DioClient();
    Map<String, dynamic> data1 = {
      "id": order.id.toString(),
      "name": order.name,
      "quantity": order.quantity.toString(),
      "price": order.price.toString(),
      "itemId": order.itemId.toString(),
      "createdAt": order.createdAt.toString(),
      "totalPrice": order.totalPrice.toString(),
      "serial": order.serial.toString(),
      "variableId": order.variableId.toString(),
      "recipeId": order.recipeId.toString(),
      "vatId": order.vatId.toString(),
      "unitId": order.unitId.toString(),
      "guest": order.guest,
      "table": order.table,
      "hall": order.hall,
      "ident": order.ident,
      "note": order.note,
      "billNum": order.billNum.toString(),
      "productType": order.productType,
      "catId": order.catId,
      "reason": reason,
      "qty": qty1.toString(),
      "cashier": Get.find<SharedPreferences>().getString('name') ?? ''
    };
    final response = await dio.postDio(path: '/void', data1: data1);
    if (response.statusCode == 200) {}
    loadingOrders(false);
    update();
  }

  Future<String> billRequest({
    required String address,
    required String customerNo,
    required String hall,
    required String table,
    required double total,
    required int driver,
  }) async {
    String type1 = '';
    if (hall == '-1') {
      type1 = 'TakeAway';
    } else if (hall == '0') {
      type1 = 'Delivery';
    } else if (hall == '-2') {
      type1 = 'SALES';
    }
    loadingOrders(true);
    DioClient dio = DioClient();
    Map<String, dynamic> data1 = {
      "addressCustomer": address,
      "customerNumber": customerNo,
      "hall": hall,
      "table": table,
      "salesType": salesType.value,
      "customer": customerId.value.toString(),
      "total": total.toString(),
      "driver": driver.toString(),
    };
    try {
      final response = await dio.postDio(path: '/bill-request', data1: data1);
      if (response.statusCode == 200) {
        loadingOrders(false);
        requstingBill(true);
        TableModel? tables;
        for (var i in Get.find<InfoController>().halls) {
          for (var j in i.tables) {
            if (j.hall == hall && j.number == table) {
              tables = j;
            }
          }
        }
        await getAllOrders();
        await Get.find<InfoController>().getAllInformation();
        List<OrderModel> order1 = order
            .where((element) => element.hall == hall && element.table == table)
            .toList();
        BillModel bill = BillModel(
            id: 0,
            formatNumber: tables!.formatNumber,
            customerId: customerId.value,
            payType: '-',
            total: totalPrice.value,
            discountAmount: 0,
            disType: '',
            disValue: '',
            cashier: Get.find<SharedPreferences>().getString('name')!,
            vat: vat.value,
            finalTotal: fTotal.value,
            createdAt: DateTime.now(),
            table: table,
            hall: int.parse(hall) > 0 ? hall : type1,
            dateSales: DateTime.now(),
            cashAmount: null,
            visaAmount: null,
            customerName: '',
            salesType: '',
            balance: '',
            noteOrder: '',
            paid: '',
            tips: null,
            storeId: 0,
            invoice: '',
            numberOfBill: '',
            patternId: null,
            receiptDue: null,
            receiptStatus: '',
            typeInvoice: '');
        var doc = await printBill(
            orders: order1,
            bill: bill,
            printerName: '',
            customerAddress: address,
            driverName: tables.deliveryName,
            customerNum: customerNo);
        var printer = await Get.find<AppDataBaseController>()
            .appDataBase
            .getPrinterSetting(1);
        var allPrinters =
            await Get.find<AppDataBaseController>().appDataBase.getAllPrinter();
        if (printer!.billPrinter != 0) {
          String name = allPrinters
              .firstWhere((element) => element.id == printer.billPrinter)
              .printerName!;
          await Printing.directPrintPdf(
            usePrinterSettings: true,
            dynamicLayout: false,
            printer: Printer(
              url: name,
              name: name,
            ),
            onLayout: (format) async => doc.save(),
          );
          update();
          return 'Success';
        } else {
          loadingOrders(false);
          update();
          return 'printer error';
        }
      } else {
        loadingOrders(false);
        update();
        return 'Error';
      }
    } catch (e) {
      loadingOrders(false);
      update();
      return 'Error';
    }
  }

  Future<String> addCustomer({
    required String firstName,
    required String busName,
    required String address,
    required String mobile,
  }) async {
    DioClient dio = DioClient();
    final data1 = {
      "firstName": firstName,
      "busName": busName,
      "address": address,
      "mobile": mobile,
    };
    try {
      final response = await dio.postDio(path: '/add-customer', data1: data1);
      if (response.statusCode == 200) {
        return 'Success';
      } else {
        return 'Error';
      }
    } catch (e) {
      return 'Error';
    }
  }

  Future<void> updateOrderSetting(PosSettingData acc) async {
    Get.find<AppDataBaseController>().appDataBase.updatePosSetting(acc);
    getOrderSetting();
  }

  Future<void> getOrderSetting() async {
    PosSettingData pos =
        await Get.find<AppDataBaseController>().appDataBase.getPosSetting();
    orderWidth.value = pos.orderW!;
    productWidth.value = pos.productW!;
    subWidth.value = pos.subW!;
    mainWidth.value = pos.mainW!;
    productItem.value = pos.productItem!;
    mainItem.value = pos.mainItem!;
    subItem.value = pos.subItem!;
    showMain.value = pos.showMain!;
    showSub.value = pos.showSub!;
    update();
  }

  Future<double> checkQty({required int id, required int variableId}) async {
    DioClient dio = DioClient();
    try {
      var data1 = {
        "id": id.toString(),
        "variable_id": variableId.toString(),
      };
      final response = await dio.postDio(path: '/check-qty', data1: data1);
      if (response.statusCode == 200) {
        var data = response.data;

        negative.value = bool.tryParse(data['negative_sale']) ?? false;
        update();
        return double.tryParse(data['qty']) ?? 0;
      }
    } catch (e) {
      debugPrint("$e");
      return 0.0;
    }
    return 0.0;
  }

  Future<String> addNewAddressMobile(
      {required int id,
      required String address,
      required String mobile}) async {
    DioClient dio = DioClient();
    try {
      var data1 = {
        "id": id.toString(),
        "address": address,
        "mobile": mobile,
      };
      final response = await dio.postDio(path: '/address-mobile', data1: data1);
      if (response.statusCode == 200) {
        return 'Success';
      } else {
        return 'Error';
      }
    } catch (e) {
      return 'Error';
    }
  }

  Future<String> updatePrice({
    required int id,
    required double price,
    required double total,
    required String hall,
    required String table,
  }) async {
    var data = {
      "id": id.toString(),
      "price": price.toString(),
      "total": total.toString(),
      "hall": hall,
      "table": table,
    };
    DioClient dio = DioClient();
    try {
      final response = await dio.postDio(path: '/update-price', data1: data);
      if (response.statusCode == 200) {
        if (response.data['message'] == 'Success') {
          return 'Success';
        } else {
          return 'Error';
        }
      } else {
        return 'Error';
      }
    } catch (e) {
      return 'Error';
    }
  }

  Future<void> saveDiscount() async {
    isDiscount(true);
    if (ConstantApp.appType.name != 'REST') {
      await getDetailsForAddOrder();
    }
    if (discountValue!.value.text.isEmpty) {
      disAmount.value = 0;
      vatAfterDis.value = vat.value;
      if (ConstantApp.appType.name != 'REST') {
        getDetailsForAddOrder();
      } else {
        getDetails();
      }
      return;
    }
    if (ConstantApp.appType.name != 'REST') {
      if (totalPrice.value == 0) {
        disAmount.value = 0;
        vatAfterDis.value = vat.value;
        if (ConstantApp.appType.name != 'REST') {
          getDetailsForAddOrder();
        } else {
          getDetails();
        }
        return;
      }
    }
    var taxId = Get.find<InfoController>().taxesSetting.isEmpty
        ? 0
        : Get.find<InfoController>().taxesSetting.last.taxId!;
    var tax = taxId == 0
        ? 0.0
        : Get.find<InfoController>()
            .taxes
            .firstWhere((element) => element.id == taxId)
            .taxValue!;
    if (discountType.value == '%') {
      discount.value = double.parse(discountValue!.value.text) * 0.01;
      disAmount.value = discount.value * (priceWithOutVat.value);
    } else if (discountType.value == 'Fixed before Vat' ||
        discountType.value == 'Value') {
      discount.value = double.parse(discountValue!.value.text);
      disAmount.value = discount.value;
    } else {
      discount.value = double.parse(discountValue!.value.text);
      disAmount.value = discount.value - discount.value * tax / (100 + tax);
    }
    vatAfterDis.value = ((priceWithOutVat.value) - disAmount.value) * tax / 100;
    if (ConstantApp.appType.name != 'REST') {
      getDetailsForAddOrder();
    } else {
      getDetails();
    }
    update();
    isDiscount(true);
  }

  Future getDetailsForAddOrder() async {
    totalPrice.value = 0;
    priceWithOutVat.value = 0;
    vat.value = 0;
    qty.value = 0;
    for (var j in tempOrder) {
      totalPrice.value += (j.quantity * j.price);
      qty.value += j.quantity;
      var tax = j.vatId == 0
          ? 0
          : Get.find<InfoController>()
                  .taxes
                  .firstWhere((element) => element.id == j.vatId)
                  .taxValue ??
              0;
      var taxType = Get.find<InfoController>().taxesSetting.isEmpty
          ? ''
          : Get.find<InfoController>().taxesSetting.last.taxType;
      if (taxType == 'inc') {
        priceWithOutVat.value += (j.quantity * j.price * 100 / (100 + tax));
      } else {
        priceWithOutVat.value += (j.quantity * j.price);
      }
    }
    if (disAmount.value == 0) {
      vatAfterDis.value =
          vat.value = (totalPrice.value - priceWithOutVat.value);
      fTotal.value = totalPrice.value;
    } else {
      vat.value = vatAfterDis.value;
      fTotal.value = vat.value + (priceWithOutVat.value - disAmount.value);
    }
    update();
  }

  Future<void> getDetails() async {
    totalPrice.value = 0;
    priceWithOutVat.value = 0;
    vat.value = 0;
    fTotal.value = 0;
    qty.value = 0.0;
    await Get.find<InfoController>().getAllTaxesSetting();
    if (orders.isEmpty) {
      totalPrice.value = 0;
      priceWithOutVat.value = 0;
      vat.value = 0;
      fTotal.value = 0.0;
    } else {
      for (var i in orders) {
        for (var j in i.orders) {
          totalPrice.value += (j.quantity * j.price);
          qty.value += j.quantity;
          var tax = (j.vatId == 0)
              ? 0
              : Get.find<InfoController>()
                      .taxes
                      .firstWhere((element) => element.id == j.vatId)
                      .taxValue ??
                  0.0;
          priceWithOutVat.value += (j.quantity * j.price * 100 / (100 + tax));
        }
      }
      if (disAmount.value == 0) {
        vat.value = (totalPrice.value - priceWithOutVat.value);
        fTotal.value = totalPrice.value;
      } else {
        vat.value = vatAfterDis.value;
        fTotal.value =
            vatAfterDis.value + (priceWithOutVat.value - disAmount.value);
      }
    }
    update();
  }

  Future<void> saveBill({
    required String paid,
    required String balance,
    required double tips,
    required double cashAmount,
    required double visaAmount,
    required String note,
    required DateTime date,
    required String? tableS,
    required String? hallS,
    required double? fTotalS,
    required double? totalPriceS,
    required double? priceWithOutVatS,
    required double? disAmountS,
    required double? vatS,
    required double? vatAfterDisS,
    required String? discountTypeS,
    required String? discountValueS,
    required String? cashier,
    required String? salesTypeS,
    required int? customerS,
    required int? storeIdS,
    required String? salesType,
    required List<OrderItem> listOrdersS,
  }) async {
    DioClient dio = DioClient();
    var data = {
      "paid": paid,
      "balance": balance,
      "tips": tips.toString(),
      "payT": '',
      "cashAmount": cashAmount.toString(),
      "visaAmount": visaAmount.toString(),
      "note": note,
      "date": date.toString(),
      "tableS": tableS,
      "hallS": hallS,
      "fTotalS": fTotalS.toString(),
      "totalPriceS": totalPriceS.toString(),
      "priceWithOutVatS": priceWithOutVatS.toString(),
      "disAmountS": disAmountS.toString(),
      "vatS": vatS.toString(),
      "vatAfterDisS": vatAfterDisS.toString(),
      "discountTypeS": discountTypeS.toString(),
      "discountValueS": discountValueS.toString(),
      "cashier": cashier,
      "customerS": customerS.toString(),
      "storeIdS": storeIdS.toString(),
      "salesType": salesType.toString(),
    };
    final response = await dio.postDio(path: '/save-bill', data1: data);
    if (response.statusCode == 200) {

    }
  }

  Future<pw.Document> printBill({
    required List<OrderModel> orders,
    required BillModel bill,
    String? customerNum,
    String? customerAddress,
    String? driverName,
    required String printerName,
  }) async {
    final ttf = await PdfGoogleFonts.iBMPlexSansArabicBold();
    final doc = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    var qty = 0.0;
    for (var i in orders) {
      qty += i.quantity;
    }
    Map<int, double> map = {};
    var customer1 =
        customer.firstWhereOrNull((element) => element.id == bill.customerId);
    String customerName = customer1 == null ? '' : customer1.businessName;
    String customerPhone = customerNum ?? '';
    String customerAdd = customerAddress ?? '';
    String hall = '';
    if (bill.hall == 'Delivery') {
      hall = 'Delivery';
    } else if (bill.hall == 'TakeAway') {
      hall = 'TakeAway';
    } else if (bill.hall == 'SALES') {
      hall = 'SALES';
    } else {
      hall = 'Dine-In';
    }
    var unit = Get.find<OrderController>().units;
    var product = Get.find<OrderController>().products;
    for (var i in orders) {
      if (map.containsKey(i.vatId)) {
        map[i.vatId!] = (map[i.vatId!]! + (i.price * i.quantity));
      } else {
        map[i.vatId!] = (i.price * i.quantity);
      }
    }
    var printer = await Get.find<AppDataBaseController>()
        .appDataBase
        .getPrinterSetting(1);
    await Get.find<InfoController>().getCompanyInfo();
    await Get.find<InfoController>().getAllTaxesSetting();
    await Get.find<InfoController>().getAllTaxes();
    var vat1 = Get.find<InfoController>().taxes;
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
                pw.Text(
                  tax.isEmpty
                      ? '   Invoice \n   فاتوره  '
                      : '  Tax Invoice \n  فاتوره ضريبية  ',
                  textAlign: pw.TextAlign.center,
                  textDirection: pw.TextDirection.rtl,
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.normal,
                      fontSize: 12,
                      font: ttf),
                ),
                pw.SizedBox(
                  height: 10,
                ),
                pw.Row(children: [
                  pw.Text('Sales Invoice:',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.normal,
                          fontSize: 10,
                          font: ttf)),
                  pw.Expanded(child: pw.SizedBox()),
                  pw.Text(bill.formatNumber ?? '',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.normal,
                          fontSize: 10,
                          font: ttf))
                ]),
                pw.Row(children: [
                  pw.Text('Cashier :',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.normal,
                          fontSize: 10,
                          font: ttf)),
                  pw.Expanded(child: pw.SizedBox()),
                  pw.Text(Get.find<SharedPreferences>().getString('name')!,
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.normal,
                          fontSize: 10,
                          font: ttf))
                ]),
                driverName != null && driverName != ""
                    ? pw.Row(children: [
                        pw.Text(
                          'Driver Name :',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal,
                              fontSize: 10,
                              font: ttf),
                        ),
                        pw.Expanded(child: pw.SizedBox()),
                        pw.Text(driverName,
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.normal,
                                fontSize: 10,
                                font: ttf))
                      ])
                    : pw.SizedBox(),
                pw.Row(children: [
                  pw.Text('Payment Type:',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.normal,
                          fontSize: 10,
                          font: ttf)),
                  pw.Expanded(child: pw.SizedBox()),
                  pw.Text(bill.payType ?? '',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.normal,
                          fontSize: 10,
                          font: ttf))
                ]),
                pw.Row(children: [
                  pw.Text('Type :',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.normal,
                          fontSize: 10,
                          font: ttf)),
                  pw.Expanded(child: pw.SizedBox()),
                  pw.Text(
                      ConstantApp.appType.name == "REST"
                          ? hall
                          : hall == "TakeAway"
                              ? "Sales"
                              : hall,
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.normal,
                          fontSize: 10,
                          font: ttf))
                ]),
                pw.Row(children: [
                  pw.Text('Date :',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.normal,
                          fontSize: 10,
                          font: ttf)),
                  pw.Expanded(child: pw.SizedBox()),
                  pw.Text(
                      DateFormat('dd-MM-yyyy hh:mm aaa')
                          .format(bill.createdAt!),
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.normal,
                          fontSize: 10,
                          font: ttf))
                ]),
                pw.Text(
                  'Customer Details',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.normal,
                      fontSize: 11,
                      font: ttf),
                ),
                pw.Row(children: [
                  pw.Text('Customer Name :',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.normal,
                          fontSize: 10,
                          font: ttf)),
                  pw.Expanded(child: pw.SizedBox()),
                  pw.Text(customerName,
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.normal,
                          fontSize: 10,
                          font: ttf))
                ]),
                pw.Row(children: [
                  pw.Text('Customer Phone :',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.normal,
                          fontSize: 10,
                          font: ttf)),
                  pw.Expanded(child: pw.SizedBox()),
                  pw.Text(customerPhone,
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.normal,
                          fontSize: 10,
                          font: ttf))
                ]),
                pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Customer Address :',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal,
                              fontSize: 10,
                              font: ttf)),
                      pw.SizedBox(width: 30),
                      pw.Expanded(
                          child: pw.Text(customerAdd,
                              maxLines: 5,
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.normal,
                                  fontSize: 9,
                                  font: ttf)))
                    ]),
                pw.Text(
                  '................................................. ',
                  textDirection: pw.TextDirection.rtl,
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.normal, fontSize: 10),
                ),
                pw.SizedBox(
                  height: 10,
                ),
                pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Expanded(
                          flex: 1,
                          child: pw.Text('No',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 8,
                                  font: ttf))),
                      pw.Expanded(
                          flex: 4,
                          child: pw.Center(
                              child: pw.Text('Item',
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 9,
                                      font: ttf)))),
                      pw.Expanded(
                          flex: 2,
                          child: pw.Text('QTY',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 9,
                                  font: ttf))),
                      !printer!.showUnit
                          ? pw.SizedBox()
                          : pw.Expanded(
                              flex: 2,
                              child: pw.Text('Unit',
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 9,
                                      font: ttf)),
                            ),
                      pw.Expanded(
                        flex: 2,
                        child: pw.Text('Price',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 9,
                                font: ttf)),
                      ),
                      pw.Expanded(
                          flex: 2,
                          child: pw.Text('Total',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 9,
                                  font: ttf))),
                      tax.isEmpty
                          ? pw.SizedBox()
                          : !printer.showVat
                              ? pw.SizedBox()
                              : pw.Expanded(
                                  flex: 2,
                                  child: pw.Text('Vat%',
                                      style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.bold,
                                          fontSize: 9,
                                          font: ttf))),
                    ]),
                pw.Text(
                  '------------------------------------------------',
                  textDirection: pw.TextDirection.rtl,
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.normal, fontSize: 10),
                ),
                pw.Column(children: [
                  pw.ListView.builder(
                      itemBuilder: (context, index) {
                        var pro = product.firstWhere(
                            (element) => element.id == orders[index].itemId);
                        return pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Row(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Expanded(
                                      flex: 1,
                                      child: pw.Text('${index + 1}',
                                          style: pw.TextStyle(
                                              fontWeight: pw.FontWeight.normal,
                                              fontSize: printer.fontSize,
                                              font: ttf))),
                                  pw.Expanded(
                                      flex: 4,
                                      child: pw.Column(children: [
                                        pw.Text(pro.englishName!,
                                            style: pw.TextStyle(
                                                fontWeight:
                                                    pw.FontWeight.normal,
                                                fontSize:
                                                    (printer.fontSize ?? 10),
                                                font: ttf)),
                                        pw.Text(pro.arabicName ?? '',
                                            textDirection: pw.TextDirection.rtl,
                                            style: pw.TextStyle(
                                                fontWeight:
                                                    pw.FontWeight.normal,
                                                fontSize:
                                                    (printer.fontSize ?? 10),
                                                font: ttf))
                                      ])),
                                  pw.Expanded(
                                      flex: 2,
                                      child: pw.Center(
                                          child: pw.Text(
                                              '${orders[index].quantity.toStringAsFixed(2).endsWith('.00') ? orders[index].quantity.toStringAsFixed(2).replaceAll('.00', '') : orders[index].quantity}',
                                              style: pw.TextStyle(
                                                  fontWeight:
                                                      pw.FontWeight.normal,
                                                  fontSize: printer.fontSize,
                                                  font: ttf)))),
                                  !printer.showUnit
                                      ? pw.SizedBox()
                                      : pw.Expanded(
                                          flex: 2,
                                          child: pw.Column(children: [
                                            pw.Text(
                                                unit
                                                    .firstWhere((element) =>
                                                        element.id ==
                                                        orders[index].unitId)
                                                    .name,
                                                style: pw.TextStyle(
                                                    fontWeight:
                                                        pw.FontWeight.normal,
                                                    fontSize: printer.fontSize,
                                                    font: ttf)),
                                            pw.Text(
                                                unit
                                                    .firstWhere((element) =>
                                                        element.id ==
                                                        orders[index].unitId)
                                                    .arabicName,
                                                textDirection:
                                                    pw.TextDirection.rtl,
                                                style: pw.TextStyle(
                                                    fontWeight:
                                                        pw.FontWeight.normal,
                                                    fontSize: printer.fontSize,
                                                    font: ttf))
                                          ]),
                                        ),
                                  pw.Expanded(
                                      flex: 2,
                                      child: pw.Text('${orders[index].price}',
                                          style: pw.TextStyle(
                                              fontWeight: pw.FontWeight.normal,
                                              fontSize: printer.fontSize,
                                              font: ttf))),
                                  pw.Expanded(
                                      flex: 2,
                                      child: pw.Text(
                                          '${(orders[index].price * orders[index].quantity)}',
                                          style: pw.TextStyle(
                                              fontWeight: pw.FontWeight.normal,
                                              fontSize: printer.fontSize,
                                              font: ttf))),
                                  tax.isEmpty
                                      ? pw.SizedBox()
                                      : !printer.showVat
                                          ? pw.SizedBox()
                                          : pw.Expanded(
                                              flex: 2,
                                              child: pw.Text(
                                                  orders[index].vatId == 0 ||
                                                          orders[index].vatId ==
                                                              null
                                                      ? '_'
                                                      : '${vat1.firstWhere((element) => element.id == orders[index].vatId).taxValue}%',
                                                  style: pw.TextStyle(
                                                      fontWeight:
                                                          pw.FontWeight.normal,
                                                      fontSize:
                                                          printer.fontSize,
                                                      font: ttf))),
                                ]),
                            Get.find<PrinterController>()
                                    .printerSetting
                                    .value
                                    .showProductDescription
                                ? pw.Text(
                                    Get.find<OrderController>()
                                            .products
                                            .firstWhereOrNull((element) =>
                                                element.id ==
                                                orders[index].itemId)
                                            ?.description ??
                                        "",
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.normal,
                                        fontSize: printer.fontSize,
                                        font: ttf))
                                : pw.SizedBox()
                          ],
                        );
                      },
                      itemCount: orders.length),
                ]),
                pw.SizedBox(
                  height: 10,
                ),
                pw.Center(
                  child: pw.Text(
                    '................................................. ',
                    textDirection: pw.TextDirection.rtl,
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.normal, fontSize: 10),
                  ),
                ),
                pw.Text(
                  'All QTY : ${qty.toStringAsFixed(2).endsWith('.00') ? qty.toStringAsFixed(2).replaceAll('.00', '') : qty.toStringAsFixed(2)}',
                  textAlign: pw.TextAlign.left,
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.normal, fontSize: 8, font: ttf),
                ),
                pw.SizedBox(
                  height: 10,
                ),
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                        child: pw.Column(children: [
                      pw.Text(
                        tax.isEmpty ? 'Subtotal :' : 'Taxable Amount :',
                        textAlign: pw.TextAlign.left,
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.normal,
                            fontSize: 9,
                            font: ttf),
                      ),
                      pw.Text(
                        tax.isEmpty
                            ? 'المجموع الفرعي'
                            : 'المبلغ الخاضع للضريبة',
                        textAlign: pw.TextAlign.left,
                        textDirection: pw.TextDirection.rtl,
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.normal,
                            fontSize: 9,
                            font: ttf),
                      ),
                    ])),
                    pw.Expanded(
                      child: pw.Text(
                        '${bill.total!.toStringAsFixed(2)}  ${'AED'.tr}',
                        textAlign: pw.TextAlign.right,
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.normal,
                            fontSize: 9,
                            font: ttf),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(
                  height: 5,
                ),
                bill.discountAmount != 0
                    ? pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Expanded(
                              child: pw.Column(children: [
                            pw.Text(
                              'Discount (${bill.disValue}):',
                              textAlign: pw.TextAlign.left,
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.normal,
                                  fontSize: 9,
                                  font: ttf),
                            ),
                          ])),
                          pw.Expanded(
                            child: pw.Text(
                              '${(bill.discountAmount ?? 0.0).toStringAsFixed(2)}  ${'AED'.tr}',
                              textAlign: pw.TextAlign.right,
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.normal,
                                  fontSize: 9,
                                  font: ttf),
                            ),
                          ),
                        ],
                      )
                    : pw.SizedBox(),
                pw.SizedBox(
                  height: 5,
                ),
                tax.isNotEmpty
                    ? pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Expanded(
                              child: pw.Column(children: [
                            pw.Text(
                              'VAT Amount:',
                              textAlign: pw.TextAlign.left,
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.normal,
                                  fontSize: 9,
                                  font: ttf),
                            ),
                            pw.Text(
                              'قيمة الضريبة',
                              textAlign: pw.TextAlign.left,
                              textDirection: pw.TextDirection.rtl,
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.normal,
                                  fontSize: 9,
                                  font: ttf),
                            ),
                          ])),
                          pw.Expanded(
                            child: pw.Text(
                              '${(bill.vat ?? 0.0).toStringAsFixed(2)}  ${'AED'.tr}',
                              textAlign: pw.TextAlign.right,
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.normal,
                                  fontSize: 9,
                                  font: ttf),
                            ),
                          ),
                        ],
                      )
                    : pw.SizedBox(),
                pw.SizedBox(
                  height: 5,
                ),
                pw.Container(
                  decoration: pw.BoxDecoration(border: pw.Border.all()),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Expanded(
                          child: pw.Column(children: [
                        pw.Text(
                          'Bill Amount :',
                          textAlign: pw.TextAlign.left,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 10,
                              font: ttf),
                        ),
                        pw.Text(
                          'قيمة الفاتورة',
                          textAlign: pw.TextAlign.left,
                          textDirection: pw.TextDirection.rtl,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 10,
                              font: ttf),
                        ),
                      ])),
                      pw.Expanded(
                        child: pw.Text(
                          '${(bill.finalTotal ?? 0.0).toStringAsFixed(2)}  ${'AED'.tr}',
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 10,
                              font: ttf),
                        ),
                      ),
                    ],
                  ),
                ),
                pw.Text(
                  '................................................. ',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.normal, fontSize: 10),
                ),
                bill.id == 0
                    ? pw.SizedBox()
                    : pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Expanded(
                              child: pw.Column(children: [
                            pw.Text(
                              'Paid :',
                              textAlign: pw.TextAlign.left,
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.normal,
                                  fontSize: 10,
                                  font: ttf),
                            ),
                            pw.Text(
                              'المدفوعات ',
                              textAlign: pw.TextAlign.left,
                              textDirection: pw.TextDirection.rtl,
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.normal,
                                  fontSize: 10,
                                  font: ttf),
                            ),
                          ])),
                          pw.Expanded(
                            child: pw.Text(
                              '${bill.paid}  ${'AED'.tr}',
                              textAlign: pw.TextAlign.right,
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.normal,
                                  fontSize: 10,
                                  font: ttf),
                            ),
                          ),
                        ],
                      ),
                bill.id == 0
                    ? pw.SizedBox()
                    : (bill.tips == 0.0 || bill.tips == 0)
                        ? pw.SizedBox()
                        : pw.Row(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Expanded(
                                  child: pw.Column(children: [
                                pw.Text(
                                  'Tips :',
                                  textAlign: pw.TextAlign.left,
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.normal,
                                      fontSize: 10,
                                      font: ttf),
                                ),
                                pw.Text(
                                  'أكراميه',
                                  textAlign: pw.TextAlign.left,
                                  textDirection: pw.TextDirection.rtl,
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.normal,
                                      fontSize: 10,
                                      font: ttf),
                                ),
                              ])),
                              pw.Expanded(
                                child: pw.Text(
                                  '${bill.tips}  ${'AED'.tr}',
                                  textAlign: pw.TextAlign.right,
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.normal,
                                      fontSize: 10,
                                      font: ttf),
                                ),
                              ),
                            ],
                          ),
                bill.id == 0
                    ? pw.SizedBox()
                    : pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Expanded(
                              child: pw.Column(children: [
                            pw.Text(
                              bill.payType == "Credit"
                                  ? 'Balance :'
                                  : 'Return :',
                              textAlign: pw.TextAlign.left,
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.normal,
                                  fontSize: 10,
                                  font: ttf),
                            ),
                            pw.Text(
                              'الباقي',
                              textAlign: pw.TextAlign.left,
                              textDirection: pw.TextDirection.rtl,
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.normal,
                                  fontSize: 10,
                                  font: ttf),
                            ),
                          ])),
                          pw.Expanded(
                            child: pw.Text(
                              '${bill.balance}  ${'AED'.tr}',
                              textAlign: pw.TextAlign.right,
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.normal,
                                  fontSize: 10,
                                  font: ttf),
                            ),
                          ),
                        ],
                      ),
                bill.id == 0
                    ? pw.SizedBox()
                    : pw.Text(
                        '................................................. ',
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.normal, fontSize: 10),
                      ),
                tax.isEmpty
                    ? pw.SizedBox()
                    : pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                            pw.Expanded(
                                flex: 2,
                                child: pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.center,
                                    children: [
                                      pw.Text(
                                        'Tax :',
                                        style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.normal,
                                            fontSize: 10,
                                            font: ttf),
                                      ),
                                      pw.Text(
                                        'الضريبة',
                                        textDirection: pw.TextDirection.rtl,
                                        style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.normal,
                                            fontSize: 10,
                                            font: ttf),
                                      ),
                                    ])),
                            pw.Expanded(
                                flex: 2,
                                child: pw.Column(children: [
                                  pw.Text(
                                    'Amount :',
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.normal,
                                        fontSize: 10,
                                        font: ttf),
                                  ),
                                  pw.Text(
                                    'المبلغ',
                                    textDirection: pw.TextDirection.rtl,
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.normal,
                                        fontSize: 10,
                                        font: ttf),
                                  ),
                                ])),
                            pw.Expanded(
                                flex: 2,
                                child: pw.Column(children: [
                                  pw.Text(
                                    'Tax Amount :',
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.normal,
                                        fontSize: 10,
                                        font: ttf),
                                  ),
                                  pw.Text(
                                    'قيمة الضريبة',
                                    textDirection: pw.TextDirection.rtl,
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.normal,
                                        fontSize: 10,
                                        font: ttf),
                                  ),
                                ])),
                          ]),
                tax.isEmpty
                    ? pw.SizedBox()
                    : pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                            pw.ListView.builder(
                                itemBuilder: (context, index) {
                                  var key = map.keys.elementAt(index);
                                  return pw.Row(
                                      crossAxisAlignment:
                                          pw.CrossAxisAlignment.start,
                                      children: [
                                        pw.Expanded(
                                            flex: 2,
                                            child: pw.Column(children: [
                                              pw.Text(
                                                  '${vat1.firstWhere((element) => element.id == key).taxValue}%',
                                                  style: pw.TextStyle(
                                                      fontWeight:
                                                          pw.FontWeight.normal,
                                                      fontSize: 7,
                                                      font: ttf))
                                            ])),
                                        pw.Expanded(
                                            flex: 2,
                                            child: pw.Column(children: [
                                              pw.Text(
                                                  (map[key]! -
                                                          (map[key]! *
                                                              vat1
                                                                  .firstWhere(
                                                                      (element) =>
                                                                          element
                                                                              .id ==
                                                                          key)
                                                                  .taxValue! /
                                                              (100 +
                                                                  vat1
                                                                      .firstWhere((element) =>
                                                                          element
                                                                              .id ==
                                                                          key)
                                                                      .taxValue!)))
                                                      .toStringAsFixed(2),
                                                  style:
                                                      pw.TextStyle(
                                                          fontWeight: pw
                                                              .FontWeight
                                                              .normal,
                                                          fontSize: 7,
                                                          font: ttf))
                                            ])),
                                        pw.Expanded(
                                            flex: 2,
                                            child: pw.Column(children: [
                                              pw.Text(
                                                  (map[key]! *
                                                          vat1
                                                              .firstWhere(
                                                                  (element) =>
                                                                      element
                                                                          .id ==
                                                                      key)
                                                              .taxValue! /
                                                          (100 +
                                                              vat1
                                                                  .firstWhere(
                                                                      (element) =>
                                                                          element
                                                                              .id ==
                                                                          key)
                                                                  .taxValue!))
                                                      .toStringAsFixed(3),
                                                  style: pw.TextStyle(
                                                      fontWeight:
                                                          pw.FontWeight.normal,
                                                      fontSize: 7,
                                                      font: ttf))
                                            ])),
                                      ]);
                                },
                                itemCount: map.length),
                          ]),
                pw.SizedBox(
                  height: 3,
                ),
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
                pw.SizedBox(height: 10),
                pw.Divider(
                    thickness: 2,
                    borderStyle: const pw.BorderStyle(pattern: [1, 3])),
                pw.Text(
                  '................................................. ',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.normal, fontSize: 10),
                ),
                pw.SizedBox(
                  height: 10,
                ),
                printer.tailPrint != ''
                    ? pw.Text(
                        printer.tailPrint ?? '',
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.normal,
                            fontSize: 10,
                            font: ttf),
                      )
                    : pw.SizedBox(),
                pw.SizedBox(
                  height: 5,
                ),
                pw.Text(
                  ' اهلا و سهلا ',
                  textDirection: pw.TextDirection.rtl,
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.normal,
                      fontSize: 10,
                      font: ttf),
                ),
                pw.SizedBox(
                  height: 10,
                ),
              ],
            ),
          );
        }));

    return doc;
  }

  Future<pw.Document> printStoriesReport1() async {
    final doc = pw.Document();

    doc.addPage(pw.Page(
        pageFormat: PdfPageFormat.roll80,
        build: (pw.Context context) {
          return pw.Center(
              child: pw.Container(
                  margin: const pw.EdgeInsets.only(right: 10),
                  width: 200,
                  child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Center(
                          child: pw.Text('OPEN CASH DRAWER',
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                  fontSize: 15,
                                  fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.SizedBox(height: 10),
                        pw.Text(DateFormat('dd-MM-yyyy hh:mm')
                            .format(DateTime.now())),
                      ])));
        }));
    return doc;
  }
}
