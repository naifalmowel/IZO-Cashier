import 'dart:async';
import 'dart:io';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';
import 'package:get/get.dart';
import '../../../database/app_db_controller.dart';
import 'package:drift/drift.dart' as drift;

import '../database/app_db.dart';
import '../models/printer.dart';

class PrinterController extends GetxController {
  var defaultPrinterType = PrinterType.bluetooth;
  var isBle = false;
  List<PrinterEntityData> printers = [];
  var reconnect = false;
  var isConnected = false;
  var printerManager = PrinterManager.instance;
  var devices = <PrinterModel>[];
  StreamSubscription<PrinterDevice>? subscription;
  StreamSubscription<BTStatus>? subscriptionBtStatus;
  StreamSubscription<USBStatus>? subscriptionUsbStatus;
  BTStatus _currentStatus = BTStatus.none;
  List<int>? pendingTask;
  String _ipAddress = '';
  String _port = '9100';
  final ipController = TextEditingController();
  final portController = TextEditingController();
  PrinterModel? selectedPrinter;
  RxDouble fountSize = RxDouble(10);

  void initState() {
    if (Platform.isWindows) defaultPrinterType = PrinterType.usb;
    portController.text = _port;

    subscriptionBtStatus =
        PrinterManager.instance.stateBluetooth.listen((status) {
          _currentStatus = status;
          if (status == BTStatus.connected) {
            isConnected = true;
            update();
          }
          if (status == BTStatus.none) {
            isConnected = false;
            update();
          }
          if (status == BTStatus.connected && pendingTask != null) {
            if (Platform.isAndroid) {
              Future.delayed(const Duration(milliseconds: 1000), () {
                PrinterManager.instance
                    .send(type: PrinterType.bluetooth, bytes: pendingTask!);
                pendingTask = null;
              });
            } else if (Platform.isIOS) {
              PrinterManager.instance
                  .send(type: PrinterType.bluetooth, bytes: pendingTask!);
              pendingTask = null;
            }
          }
        });
    subscriptionUsbStatus = PrinterManager.instance.stateUSB.listen((status) {
      if (Platform.isAndroid) {
        if (status == USBStatus.connected && pendingTask != null) {
          Future.delayed(const Duration(milliseconds: 1000), () {
            PrinterManager.instance
                .send(type: PrinterType.usb, bytes: pendingTask!);
            pendingTask = null;
          });
        }
      }
    });
  }

  void print1(List<int> bytes, Generator generator, String name) async {
    bytes += generator.feed(2);
    bytes += generator.cut();
    printerManager.connect(
        type: PrinterType.usb,
        model: UsbPrinterInput(name: name, productId: null, vendorId: null));
    printerManager.send(type: PrinterType.usb, bytes: bytes);
  }

  void scan() {
    devices.clear();
    printerManager
        .discovery(type: defaultPrinterType, isBle: isBle)
        .listen((device) {
      devices.add(PrinterModel(
        deviceName: device.name,
        address: device.address,
        isBle: isBle,
        vendorId: device.vendorId,
        productId: device.productId,
        typePrinter: defaultPrinterType,
      ));
    });
    update();
  }

  void setPort(String value) {
    if (value.isEmpty) value = '9100';
    _port = value;
    var device = PrinterModel(
      deviceName: value,
      address: _ipAddress,
      port: _port,
      typePrinter: PrinterType.network,
      state: false,
    );
    selectDevice(device);
  }

  void setIpAddress(String value) {
    _ipAddress = value;
    var device = PrinterModel(
      deviceName: value,
      address: _ipAddress,
      port: _port,
      typePrinter: PrinterType.network,
      state: false,
    );
    selectDevice(device);
  }

  void selectDevice(PrinterModel device) async {
    if (selectedPrinter != null) {
      if ((device.address != selectedPrinter!.address) ||
          (device.typePrinter == PrinterType.usb &&
              selectedPrinter!.vendorId != device.vendorId)) {
        await PrinterManager.instance
            .disconnect(type: selectedPrinter!.typePrinter);
      }
    }
    selectedPrinter = device;
    update();
  }

  void printEscPos(List<int> bytes, Generator generator) async {
    if (selectedPrinter == null) return;
    var printerModel = selectedPrinter!;

    switch (printerModel.typePrinter) {
      case PrinterType.usb:
        bytes += generator.feed(2);
        bytes += generator.cut();
        await printerManager.connect(
            type: printerModel.typePrinter,
            model: UsbPrinterInput(
                name: printerModel.deviceName,
                productId: printerModel.productId,
                vendorId: printerModel.vendorId));
        pendingTask = null;
        break;
      case PrinterType.bluetooth:
        bytes += generator.cut();
        await printerManager.connect(
            type: printerModel.typePrinter,
            model: BluetoothPrinterInput(
                name: printerModel.deviceName,
                address: printerModel.address!,
                isBle: printerModel.isBle ?? false,
                autoConnect: reconnect));
        pendingTask = null;
        if (Platform.isAndroid) pendingTask = bytes;
        break;
      case PrinterType.network:
        bytes += generator.feed(2);
        bytes += generator.cut();
        await printerManager.connect(
            type: printerModel.typePrinter,
            model: TcpPrinterInput(ipAddress: printerModel.address!));
        break;
      default:
    }
    if (printerModel.typePrinter == PrinterType.bluetooth &&
        Platform.isAndroid) {
      if (_currentStatus == BTStatus.connected) {
        printerManager.send(type: printerModel.typePrinter, bytes: bytes);
        pendingTask = null;
      }
    } else {
      printerManager.send(type: printerModel.typePrinter, bytes: bytes);
    }
  }

  connectDevice() async {
    isConnected = false;
    if (selectedPrinter == null) return;
    switch (selectedPrinter!.typePrinter) {
      case PrinterType.usb:
        await printerManager.connect(
            type: selectedPrinter!.typePrinter,
            model: UsbPrinterInput(
                name: selectedPrinter!.deviceName,
                productId: selectedPrinter!.productId,
                vendorId: selectedPrinter!.vendorId));
        isConnected = true;
        break;
      case PrinterType.bluetooth:
        await printerManager.connect(
            type: selectedPrinter!.typePrinter,
            model: BluetoothPrinterInput(
                name: selectedPrinter!.deviceName,
                address: selectedPrinter!.address!,
                isBle: selectedPrinter!.isBle ?? false,
                autoConnect: reconnect));
        break;
      case PrinterType.network:
        await printerManager.connect(
            type: selectedPrinter!.typePrinter,
            model: TcpPrinterInput(ipAddress: selectedPrinter!.address!));
        isConnected = true;
        break;
      default:
    }

    update();
  }

  Future<void> addPrinter() async {
    int counter = 1;
    for (var i in devices) {
      await Get
          .find<AppDataBaseController>()
          .appDataBase
          .insertPrinter(
          PrinterEntityCompanion(
              id: drift.Value(counter),
              createdAt: drift.Value(DateTime.now()),
              printerName: drift.Value(i.deviceName),
              printerType: drift.Value(i.typePrinter.name)));
      counter++;
    }
  }

  viewPrinter() async {
    printers =
    await Get
        .find<AppDataBaseController>()
        .appDataBase
        .getAllPrinter();
    update();
  }

  deletePrinter() async {
    for (var i in printers) {
      await Get
          .find<AppDataBaseController>()
          .appDataBase
          .deletePrinter(i.id);
      await Get
          .find<AppDataBaseController>()
          .appDataBase
          .editReportBillPrinter(id:1, billPrinter:0, reportId:0,);
    }
    update();
  }

  Rx<PrinterSettingEntityData> printerSetting = const PrinterSettingEntityData(
    id: 0,
    billPrinter: 1,
    isFullOrder: false,
    reportPrinter: 1,
    showUnit: false,
    showVat: false,
    headerPrint: 'Restaurant',
    fontSize: 8,
    tailPrint: "Thank you for visit",
    showProductDescription: false,
  ).obs;

  Future<void> getPrintSettingData(int id) async {
    printerSetting.value = (await Get
        .find<AppDataBaseController>()
        .appDataBase
        .getPrinterSetting(id))!;
  }
  Future<void> updatePrintSetting(PrinterSettingEntityData information) async {
    await Get
        .find<AppDataBaseController>()
        .appDataBase
        .updatePrinterSetting(information);
    await getPrintSettingData(1);
  }

}
