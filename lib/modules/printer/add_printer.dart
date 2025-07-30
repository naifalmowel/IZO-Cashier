import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';
import 'package:get/get.dart';
import 'package:drift/drift.dart' as drift;
import '../../../database/app_db.dart';
import '../../../database/app_db_controller.dart';
import '../../../utils/Theme/colors.dart';
import '../../../utils/scaled_dimensions.dart';
import '../../controllers/printer_controller.dart';
import '../../global_widgets/custom_app_button.dart';
import '../../models/printer.dart';
import '../../utils/constant.dart';

class AddPrinter extends StatefulWidget {
  const AddPrinter({Key? key}) : super(key: key);

  @override
  State<AddPrinter> createState() => AddPrinterState();
}

class AddPrinterState extends State<AddPrinter> {
  var controller = Get.find<PrinterController>();
  var defaultPrinterType = PrinterType.bluetooth;
  var _isBle = false;
  var _reconnect = false;
  var _isConnected = false;
  var printerManager = PrinterManager.instance;
  var devices = <PrinterModel>[];
  StreamSubscription<PrinterDevice>? _subscription;
  StreamSubscription<BTStatus>? _subscriptionBtStatus;
  StreamSubscription<USBStatus>? _subscriptionUsbStatus;
  BTStatus _currentStatus = BTStatus.none;

  USBStatus currentUsbStatus = USBStatus.none;
  List<int>? pendingTask;
  String _ipAddress = '';
  String _port = '9100';
  final _ipController = TextEditingController();
  final _portController = TextEditingController();
  PrinterModel? selectedPrinter;

  @override
  void initState() {
    if (Platform.isWindows) defaultPrinterType = PrinterType.usb;
    super.initState();
    _portController.text = _port;
    scan();

    // subscription to listen change status of bluetooth connection
    _subscriptionBtStatus =
        PrinterManager.instance.stateBluetooth.listen((status) {
          log(' ----------------- status bt $status ------------------ ');
          _currentStatus = status;
          if (status == BTStatus.connected) {
            setState(() {
              _isConnected = true;
            });
          }
          if (status == BTStatus.none) {
            setState(() {
              _isConnected = false;
            });
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
    //  PrinterManager.instance.stateUSB is only supports on Android
    _subscriptionUsbStatus = PrinterManager.instance.stateUSB.listen((status) {
      log(' ----------------- status usb $status ------------------ ');
      currentUsbStatus = status;
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

  @override
  void dispose() {
    _subscription?.cancel();
    _subscriptionBtStatus?.cancel();
    _subscriptionUsbStatus?.cancel();
    _portController.dispose();
    _ipController.dispose();
    super.dispose();
  }

  // method to scan devices according PrinterType
  void scan() {
    devices.clear();
    printerManager
        .discovery(type: defaultPrinterType, isBle: _isBle)
        .listen((device) {
      devices.add(PrinterModel(
        deviceName: device.name,
        address: device.address,
        isBle: _isBle,
        vendorId: device.vendorId,
        productId: device.productId,
        typePrinter: defaultPrinterType,
      ));
      setState(() {});
    });
    controller.devices = devices;
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
    setState(() {});
  }

  Future _printReceiveTest() async {
    List<int> bytes = [];

    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    generator.setGlobalCodeTable('CP1256');

    bytes += generator.text('Test Print',
        styles: const PosStyles(
          align: PosAlign.center,
        ));

    bytes += generator.row([
      PosColumn(
        text: 'col3',
        width: 3,
        styles: const PosStyles(align: PosAlign.center, underline: true),
      ),
      PosColumn(
        text: 'col6',
        width: 6,
        styles: const PosStyles(align: PosAlign.center, underline: true),
      ),
      PosColumn(
        text: 'col3',
        width: 3,
        styles: const PosStyles(align: PosAlign.center, underline: true),
      ),
    ]);
    bytes += generator.text('Product 2');

    _printEscPos(bytes, generator);
  }

  /// print ticket
  void _printEscPos(List<int> bytes, Generator generator) async {
    if (selectedPrinter == null) return;
    var bluetoothPrinter = selectedPrinter!;
    switch (bluetoothPrinter.typePrinter) {
      case PrinterType.usb:
        bytes += generator.feed(1);
        bytes += generator.cut();
        await printerManager.connect(
            type: bluetoothPrinter.typePrinter,
            model: UsbPrinterInput(
                name: bluetoothPrinter.deviceName,
                productId: bluetoothPrinter.productId,
                vendorId: bluetoothPrinter.vendorId));
        pendingTask = null;
        break;
      case PrinterType.bluetooth:
        bytes += generator.cut();
        await printerManager.connect(
            type: bluetoothPrinter.typePrinter,
            model: BluetoothPrinterInput(
                name: bluetoothPrinter.deviceName,
                address: bluetoothPrinter.address!,
                isBle: bluetoothPrinter.isBle ?? false,
                autoConnect: _reconnect));
        pendingTask = null;
        if (Platform.isAndroid) pendingTask = bytes;
        break;
      case PrinterType.network:
        bytes += generator.feed(15);
        bytes += generator.cut();
        await printerManager.connect(
            type: bluetoothPrinter.typePrinter,
            model: TcpPrinterInput(ipAddress: bluetoothPrinter.address!));
        break;
      default:
    }
    if (bluetoothPrinter.typePrinter == PrinterType.bluetooth &&
        Platform.isAndroid) {
      if (_currentStatus == BTStatus.connected) {
        printerManager.send(type: bluetoothPrinter.typePrinter, bytes: bytes);
        pendingTask = null;
      }
    } else {
      printerManager.send(type: bluetoothPrinter.typePrinter, bytes: bytes);
    }
  }

  _connectDevice() async {
    _isConnected = false;
    if (selectedPrinter == null) return;
    switch (selectedPrinter!.typePrinter) {
      case PrinterType.usb:
        await printerManager.connect(
            type: selectedPrinter!.typePrinter,
            model: UsbPrinterInput(
                name: selectedPrinter!.deviceName,
                productId: selectedPrinter!.productId,
                vendorId: selectedPrinter!.vendorId));
        _isConnected = true;
        break;
      case PrinterType.bluetooth:
        await printerManager.connect(
            type: selectedPrinter!.typePrinter,
            model: BluetoothPrinterInput(
                name: selectedPrinter!.deviceName,
                address: selectedPrinter!.address!,
                isBle: selectedPrinter!.isBle ?? false,
                autoConnect: _reconnect));
        break;
      case PrinterType.network:
        await printerManager.connect(
            type: selectedPrinter!.typePrinter,
            model: TcpPrinterInput(ipAddress: selectedPrinter!.address!));
        _isConnected = true;
        break;
      default:
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Printer'.tr),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Container(
                  height: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        Text(
                          'Printers In Your Device'.tr,
                          style: ConstantApp.getTextStyle(
                              context: context, size: 20),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed:
                                  selectedPrinter == null || _isConnected
                                      ? null
                                      : () {
                                    _connectDevice();
                                  },
                                  child: Text("Connect".tr,
                                      textAlign: TextAlign.center),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed:
                                  selectedPrinter == null || !_isConnected
                                      ? null
                                      : () {
                                    if (selectedPrinter != null) {
                                      printerManager.disconnect(
                                          type: selectedPrinter!
                                              .typePrinter);
                                    }
                                    setState(() {
                                      _isConnected = false;
                                    });
                                  },
                                  child: Text("Disconnect".tr,
                                      textAlign: TextAlign.center),
                                ),
                              ),
                            ],
                          ),
                        ),
                        DropdownButtonFormField<PrinterType>(
                          value: defaultPrinterType,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.print,
                              size: 24,
                            ),
                            labelText: "Type Printer Device".tr,
                            labelStyle: const TextStyle(fontSize: 18.0),
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                          ),
                          items: <DropdownMenuItem<PrinterType>>[
                            if (Platform.isAndroid || Platform.isIOS)
                              DropdownMenuItem(
                                value: PrinterType.bluetooth,
                                child: Text("bluetooth".tr),
                              ),
                            if (Platform.isAndroid || Platform.isWindows)
                              DropdownMenuItem(
                                value: PrinterType.usb,
                                child: Text("usb".tr),
                              ),
                            DropdownMenuItem(
                              value: PrinterType.network,
                              child: Text("Wifi".tr),
                            ),
                          ],
                          onChanged: (PrinterType? value) {
                            setState(() {
                              if (value != null) {
                                setState(() {
                                  defaultPrinterType = value;
                                  selectedPrinter = null;
                                  _isBle = false;
                                  _isConnected = false;
                                  scan();
                                });
                              }
                            });
                          },
                        ),
                        Visibility(
                          visible:
                          defaultPrinterType == PrinterType.bluetooth &&
                              Platform.isAndroid,
                          child: SwitchListTile.adaptive(
                            contentPadding:
                            const EdgeInsets.only(bottom: 20.0, left: 20),
                            title: Text(
                              "This device supports ble (low energy)".tr,
                              textAlign: TextAlign.start,
                              style: const TextStyle(fontSize: 19.0),
                            ),
                            value: _isBle,
                            onChanged: (bool? value) {
                              setState(() {
                                _isBle = value ?? false;
                                _isConnected = false;
                                selectedPrinter = null;
                                scan();
                              });
                            },
                          ),
                        ),
                        Visibility(
                          visible:
                          defaultPrinterType == PrinterType.bluetooth &&
                              Platform.isAndroid,
                          child: SwitchListTile.adaptive(
                            contentPadding:
                            const EdgeInsets.only(bottom: 20.0, left: 20),
                            title: Text(
                              "reconnect".tr,
                              textAlign: TextAlign.start,
                              style: const TextStyle(fontSize: 19.0),
                            ),
                            value: _reconnect,
                            onChanged: (bool? value) {
                              setState(() {
                                _reconnect = value ?? false;
                              });
                            },
                          ),
                        ),
                        Column(
                            children: devices
                                .map(
                                  (device) => ListTile(
                                title: Text('${device.deviceName}'),
                                style: ListTileStyle.drawer,
                                horizontalTitleGap: 20,
                                onTap: () {
                                  // do something
                                  selectDevice(device);
                                },
                                subtitle: IconButton(
                                    onPressed: () async {
                                      for (var i in controller.printers) {
                                        if (i.printerName ==
                                            device.deviceName) {
                                          ConstantApp.showSnakeBarError(
                                              context,
                                              'Added This Printer !! '.tr);
                                          return;
                                        }
                                      }
                                      await Get.find<
                                          AppDataBaseController>()
                                          .appDataBase
                                          .insertPrinter(
                                          PrinterEntityCompanion(
                                              createdAt:
                                              drift
                                                  .Value(DateTime
                                                  .now()),
                                              printerName:
                                              drift.Value(
                                                  device
                                                      .deviceName),
                                              printerType: drift.Value(
                                                  device.typePrinter
                                                      .name)));
                                      await controller.viewPrinter();
                                      setState(() {});
                                    },
                                    icon: Icon(
                                      Icons.add,
                                      color: primaryColor,
                                    ),
                                    tooltip: 'Add Printer'.tr),
                                leading: selectedPrinter != null &&
                                    ((device.typePrinter ==
                                        PrinterType.usb &&
                                        Platform.isWindows
                                        ? device.deviceName ==
                                        selectedPrinter!
                                            .deviceName
                                        : device.vendorId != null &&
                                        selectedPrinter!
                                            .vendorId ==
                                            device.vendorId) ||
                                        (device.address != null &&
                                            selectedPrinter!.address ==
                                                device.address))
                                    ? const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                )
                                    : null,
                                trailing: OutlinedButton(
                                  onPressed: selectedPrinter == null ||
                                      device.deviceName !=
                                          selectedPrinter?.deviceName
                                      ? null
                                      : () async {
                                    _printReceiveTest();
                                  },
                                  child: Text("Print test ticket".tr,
                                      textAlign: TextAlign.center),
                                ),
                              ),
                            )
                                .toList()),
                        Visibility(
                          visible: defaultPrinterType == PrinterType.network &&
                              Platform.isWindows,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: TextFormField(
                              controller: _ipController,
                              keyboardType:
                              const TextInputType.numberWithOptions(
                                  signed: true),
                              decoration: InputDecoration(
                                label: Text("Ip Address".tr),
                                prefixIcon: const Icon(Icons.wifi, size: 24),
                              ),
                              onChanged: setIpAddress,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: defaultPrinterType == PrinterType.network &&
                              Platform.isWindows,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: TextFormField(
                              controller: _portController,
                              keyboardType:
                              const TextInputType.numberWithOptions(
                                  signed: true),
                              decoration: InputDecoration(
                                label: Text("Port".tr),
                                prefixIcon: const Icon(Icons.numbers_outlined,
                                    size: 24),
                              ),
                              onChanged: setPort,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: defaultPrinterType == PrinterType.network &&
                              Platform.isWindows,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: OutlinedButton(
                              onPressed: () async {
                                if (_ipController.text.isNotEmpty) {
                                  setIpAddress(_ipController.text);
                                }
                                _printReceiveTest();
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 50),
                                child: Text("Print test ticket".tr,
                                    textAlign: TextAlign.center),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  color: Colors.black38,
                  width: 3,
                  height: double.infinity,
                ),
              ),
              Expanded(
                  flex: 8,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomAppButton(
                              height: ScaledDimensions.getScaledHeight(px: 60),
                              width: ScaledDimensions.getScaledWidth(px: 70),
                              onPressed: () async {
                                if (controller.printers.isNotEmpty) {
                                  ConstantApp.showSnakeBarError(
                                      context,
                                      'Can\'t Add , Must Delete All Firstly !! =>'
                                          .tr);
                                  return;
                                }
                                await controller.addPrinter();
                                await controller.viewPrinter();
                                setState(() {});
                              },
                              title: 'Add Printers to DB'.tr,
                              backgroundColor: primaryColor,
                              textColor: Colors.white,
                              withPadding: true,
                            ),
                            CustomAppButton(
                              height: ScaledDimensions.getScaledHeight(px: 60),
                              width: ScaledDimensions.getScaledWidth(px: 70),
                              onPressed: () async {
                                if (controller.printers.isNotEmpty) {
                                  await controller.deletePrinter();
                                  await controller.viewPrinter();
                                }

                                setState(() {});
                              },
                              title: 'Delete All Printers'.tr,
                              backgroundColor: primaryColor,
                              textColor: Colors.white,
                              withPadding: true
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: GetBuilder<PrinterController>(
                          builder: (controller) => controller.printers.isEmpty
                              ? Center(
                            child: Text(
                              'No Printers'.tr,
                              style: ConstantApp.getTextStyle(
                                  context: context,
                                  size: 20,
                                  fontWeight: FontWeight.w600),
                            ),
                          )
                              : SingleChildScrollView(
                            child: Column(
                              children: [
                                Card(
                                  color: secondaryColor,
                                  child: Padding(
                                    padding:
                                    const EdgeInsets.only(left: 20),
                                    child: Row(children: [
                                      Flexible(
                                          flex: 1,
                                          fit: FlexFit.tight,
                                          child: Text(
                                            'Id'.tr,
                                            style:
                                            ConstantApp.getTextStyle(
                                                context: context,
                                                size: 13,
                                                color: Colors.white,
                                                fontWeight:
                                                FontWeight.w600),
                                          )),
                                      Flexible(
                                          flex: 1,
                                          fit: FlexFit.tight,
                                          child: Text(
                                            'Printer Name'.tr,
                                            style:
                                            ConstantApp.getTextStyle(
                                                context: context,
                                                size: 13,
                                                color: Colors.white,
                                                fontWeight:
                                                FontWeight.w600),
                                          )),
                                      Flexible(
                                          flex: 1,
                                          fit: FlexFit.tight,
                                          child: Text(''.tr)),
                                    ]),
                                  ),
                                ),
                                const Divider(
                                    thickness: 3, color: Colors.black38),
                                SizedBox(
                                  width: double.infinity,
                                  height: 400,
                                  child: ListView.builder(
                                      itemCount:
                                      controller.printers.length,
                                      itemBuilder: (context, index) {
                                        return Card(
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.only(
                                                left: 20),
                                            child: Row(children: [
                                              Flexible(
                                                  flex: 1,
                                                  fit: FlexFit.tight,
                                                  child: Text(
                                                    (controller
                                                        .printers[
                                                    index]
                                                        .id)
                                                        .toString(),
                                                    style: ConstantApp
                                                        .getTextStyle(
                                                        context:
                                                        context,
                                                        size: 8,
                                                        color:
                                                        secondaryColor,
                                                        fontWeight:
                                                        FontWeight
                                                            .w600),
                                                  )),
                                              Flexible(
                                                  flex: 1,
                                                  fit: FlexFit.tight,
                                                  child: Text(

                                                    controller
                                                        .printers[index]
                                                        .printerName
                                                        .toString(),
                                                    style: ConstantApp
                                                        .getTextStyle(
                                                        context:
                                                        context,
                                                        size: 8,
                                                        color:
                                                        secondaryColor,
                                                        fontWeight:
                                                        FontWeight
                                                            .w600),
                                                  )),
                                              Flexible(
                                                  flex: 1,
                                                  fit: FlexFit.tight,
                                                  child: IconButton(
                                                    icon: const Icon(
                                                        Icons.delete,
                                                        color:
                                                        Colors.red),
                                                    onPressed: () async {
                                                      await Get.find<
                                                          AppDataBaseController>()
                                                          .appDataBase
                                                          .deletePrinter(
                                                          controller
                                                              .printers[
                                                          index]
                                                              .id);
                                                      await controller
                                                          .getPrintSettingData(
                                                          1);
                                                      int rP = controller
                                                          .printerSetting
                                                          .value
                                                          .reportPrinter ??
                                                          0;
                                                      int bP = controller
                                                          .printerSetting
                                                          .value
                                                          .billPrinter ??
                                                          0;
                                                      if (controller
                                                          .printerSetting
                                                          .value
                                                          .reportPrinter ==
                                                          controller
                                                              .printers[
                                                          index]
                                                              .id) {
                                                        rP = 0;
                                                      }
                                                      if (controller
                                                          .printerSetting
                                                          .value
                                                          .billPrinter ==
                                                          controller
                                                              .printers[
                                                          index]
                                                              .id) {
                                                        bP = 0;
                                                      }
                                                      await Get.find<
                                                          AppDataBaseController>()
                                                          .appDataBase
                                                          .editReportBillPrinter(
                                                          id: 1,
                                                          reportId:
                                                          rP,
                                                          billPrinter:
                                                          bP);
                                                      await controller
                                                          .viewPrinter();
                                                    },
                                                  )),
                                            ]),
                                          ),
                                        );
                                      }),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
