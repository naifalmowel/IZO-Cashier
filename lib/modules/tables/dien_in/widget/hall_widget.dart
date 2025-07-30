import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cashier_app/controllers/info_controllers.dart';
import 'package:cashier_app/modules/tables/dien_in/widget/table_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../controllers/tables_controller.dart';
import '../../../../controllers/user_controller.dart';
import '../../../../models/table_model.dart';
import '../../../../utils/Theme/colors.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/scaled_dimensions.dart';
import '../../../../controllers/order_controller.dart';
import '../../../order_view/order_view_a.dart';
import '../../../order_view/order_view_w.dart';

class HallWidget extends StatefulWidget {
  const HallWidget({required this.number, required this.tables, Key? key})
      : super(key: key);
  final List<TableModel> tables;
  final String number;

  @override
  State<HallWidget> createState() => _HallWidgetState();
}

class _HallWidgetState extends State<HallWidget> {
  TextEditingController mobilController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime selectDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7), color: primaryColor),
          child: Center(
              child: Text(
            'HALL - ${widget.number}',
            style: ConstantApp.getTextStyle(
                    context: context,
                    size: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)
                .copyWith(
              letterSpacing: 3,
            ),
          )),
        ),
        SizedBox(
          height: ScaledDimensions.getScaledHeight(px: 10),
        ),
        GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: GetPlatform.isDesktop || Get.width > 750
                  ? Get.width < 1000
                      ? 3
                      : 5
                  : 2,
              childAspectRatio: 1.8),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.tables.length,
          itemBuilder: (BuildContext context, int index) {
            return TableWidget(
              onTap: () async {
                if (ConstantApp.type == "guest") {
                  Get.find<OrderController>().getAllProducts();
                  Get.find<OrderController>().getAllOrders();
                  Get.to(() =>GetPlatform.isWindows ?  OrderViewW(
                    hall: widget.tables[index].hall.toString(),
                    table: widget.tables[index].number.toString(),
                    customerId: widget.tables[index].customerId ?? 0,
                    billRequest: widget.tables[index].waitCustomer ?? false,
                  ):OrderViewA(
                    hall: widget.tables[index].hall.toString(),
                    table: widget.tables[index].number.toString(),
                    customerId: widget.tables[index].customerId ?? 0,
                    billRequest: widget.tables[index].waitCustomer ?? false,
                  ));
                }
                else {
                  bool isActive = await   Get.find<UserController>().checkUser(context: context);
                  if(isActive){
                    return;
                  }
                  await Get.find<UserController>().getUsers();
                  if(!Get.find<InfoController>().isServerConnect.value){
                    if(!context.mounted)return;
                    ConstantApp.showSnakeBarError(context, 'Server Connection !!');
                    return;
                  }
                  Get.find<OrderController>().order.clear();
                  await Get.find<OrderController>().getAllProducts();
                  await Get.find<OrderController>().getAllOrders();
                  await Get.find<OrderController>().getOrderForTable(
                    widget.tables[index].hall.toString(),
                    widget.tables[index].number.toString(),
                  );
                  final cashier =
                      Get.find<SharedPreferences>().getString('name') ?? '';

                  final message =
                      await Get.find<TableController>().entryToTable(data: {
                    "number": widget.tables[index].number.toString(),
                    "hall": widget.tables[index].hall.toString(),
                    "cashier": cashier,
                  });
                  if (!context.mounted)return;
                  if (message == 'ERROR') {
                    ConstantApp.showSnakeBarError(context, 'The Table is Busy');
                    return;
                  }
                  Get.to(() =>GetPlatform.isWindows ?  OrderViewW(
                    hall: widget.tables[index].hall.toString(),
                    table: widget.tables[index].number.toString(),
                    customerId: widget.tables[index].customerId ?? 0,
                    billRequest: widget.tables[index].waitCustomer ?? false,
                  ):OrderViewA(
                    hall: widget.tables[index].hall.toString(),
                    table: widget.tables[index].number.toString(),
                    customerId: widget.tables[index].customerId ?? 0,
                    billRequest: widget.tables[index].waitCustomer ?? false,
                  ));
                }
              },
              number: widget.tables[index].number,
              amount: widget.tables[index].voidAmount != null
                  ? (widget.tables[index].cost -
                          widget.tables[index].voidAmount!)
                      .toString()
                  : widget.tables[index].cost.toString(),
              isOn: widget.tables[index].cost != 0 ? true : false,
              isBill: widget.tables[index].waitCustomer != null &&
                      widget.tables[index].waitCustomer == true
                  ? true
                  : false,
              time: widget.tables[index].time,
              orders: const [],
              onUpdatedPress: (value) async {
                // Get.find<OrderController>().changeOrder(tables[index], value);
                // Get.toNamed('/order', arguments: tables[index].number);
              },
              onBillRequest: () async {},
              onLongPress: () {
                numberController.clear();
                nameController.clear();
                dateController.clear();
                mobilController.clear();
                widget.tables[index].bookingTable == true
                    ? const SizedBox()
                    : showDialog(
                        context: context,
                        builder: (context) {
                          return alert(index, false);
                        });
              },
              bookingTable: widget.tables[index].bookingTable ?? false,
              bookingDate: widget.tables[index].bookingDate,
              deleteBooking: () {
                Get.dialog(AlertDialog(
                  title: Text("Cancellation Of Reservation".tr),
                  content: Text("Are you sure to cancel your reservation?".tr),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text(
                          "No".tr,
                          style: ConstantApp.getTextStyle(
                              context: context, color: errorColor),
                        )),
                    TextButton(
                        onPressed: () async {},
                        child: Text(
                          "Yes".tr,
                          style: ConstantApp.getTextStyle(
                              context: context, color: textColor),
                        )),
                  ],
                ));
                setState(() {});
              },
              editBooking: () {
                nameController.text = widget.tables[index].guestName ?? '';
                numberController.text = widget.tables[index].guestNo ?? '';
                mobilController.text = widget.tables[index].guestMobile ?? '';
                dateController.text =
                    widget.tables[index].bookingDate.toString();
                showDialog(
                    context: context,
                    builder: (context) {
                      return alert(index, true);
                    });
              },
              guestsNumber: widget.tables[index].guestNo ?? '',
              guestName: widget.tables[index].guestName ?? '',
              guestMobil: widget.tables[index].guestMobile ?? '',
              lockIconPressed: () {},
              formatNumber: widget.tables[index].formatNumber ?? '',
            );
          },
        )
      ],
    );
  }

  dateTimePickerWidget(BuildContext context, int index1) {
    return DatePicker.showDatePicker(context,
        dateFormat: 'dd HH:mm',
        pickerMode: DateTimePickerMode.datetime,
        initialDateTime: DateTime.now(),
        minDateTime: DateTime(2000),
        maxDateTime: DateTime(3000),
        onConfirm: (dateTime, List<int> index) async {
      DateTime selectDate = dateTime;
      dateController.text = DateFormat('yyyy-MM-dd hh:mm a').format(selectDate);
    });
  }

  Widget alert(int index, bool isLock) {
    return AlertDialog(
        icon: const Center(
          child: Text(
            'Booking Tables',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        title: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Name'.tr,
                ),
                controller: nameController,
                onChanged: (val) {
                  setState(() {});
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter Name'.tr;
                  }
                  return null;
                },
              ),
              TextFormField(
                autofocus: true,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: 'Mobile Number'.tr,
                ),
                controller: mobilController,
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  setState(() {});
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter Mobile'.tr;
                  }
                  return null;
                },
              ),
              TextFormField(
                autofocus: true,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Guests Number'.tr,
                ),
                controller: numberController,
                onChanged: (val) {
                  setState(() {});
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter Guests Number'.tr;
                  }
                  return null;
                },
              ),
              TextFormField(
                autofocus: true,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Booking Date'.tr,
                ),
                controller: dateController,
                onTap: () {
                  _selectDateTime(context);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Select Date Please !'.tr;
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          isLock
              ? TextButton(
                  onPressed: () {
                    Get.back();
                    Get.dialog(AlertDialog(
                      title: Text("Cancellation Of Reservation".tr),
                      content:
                          Text("Are you sure to cancel your reservation?".tr),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: Text(
                              "No".tr,
                              style: ConstantApp.getTextStyle(
                                  context: context, color: errorColor),
                            )),
                        TextButton(
                            onPressed: () async {
                              await Get.find<TableController>().deleteBooking(
                                hall: widget.tables[index].hall,
                                table: widget.tables[index].number,
                              );
                              Get.back();
                              await Get.find<InfoController>()
                                  .getAllInformation();
                            },
                            child: Text(
                              "Yes".tr,
                              style: ConstantApp.getTextStyle(
                                  context: context, color: textColor),
                            )),
                      ],
                    ));
                    setState(() {});
                  },
                  child: Text(
                    'Delete',
                    style: ConstantApp.getTextStyle(
                        context: context, size: 10, color: errorColor),
                  ))
              : const SizedBox(),
          TextButton(
              onPressed: () async {
              if(_formKey.currentState!.validate()){
                await Get.find<TableController>().bookingTable(
                  hall: widget.tables[index].hall,
                  table: widget.tables[index].number,
                  date: dateController.text,
                  guestName: nameController.text,
                  guestNo: numberController.text,
                  guestMobile: mobilController.text,
                );
                Get.back();
                if (!mounted) return;
                ConstantApp.showSnakeBarSuccess(context, 'Booking Success !!');
                dateController.clear();
                nameController.clear();
                numberController.clear();
                mobilController.clear();
                await Get.find<InfoController>().getAllInformation();
              }
              },
              child: Text(
                'OK'.tr,
                style: ConstantApp.getTextStyle(context: context),
              )),
        ]);
  }

  Widget showInfoBooking(String name, String number, String date) {
    return AlertDialog(
      icon: Column(
        children: [
          Center(
            child: Text(
              'Booking Tables',
              style: ConstantApp.getTextStyle(
                  context: context, size: 15, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider()
        ],
      ),
      title: SizedBox(
        width: ConstantApp.getWidth(context) / 3,
        height: ConstantApp.getHeight(context) / 6,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Expanded(
              child: Column(children: [
                Flexible(
                    flex: 1, fit: FlexFit.tight, child: Text('Guest Name :')),
                Flexible(
                    flex: 1, fit: FlexFit.tight, child: Text('Guest Mobil :')),
                Flexible(
                    flex: 1, fit: FlexFit.tight, child: Text('Booking Date :')),
              ]),
            ),
            Expanded(
              child: Column(children: [
                Flexible(flex: 1, fit: FlexFit.tight, child: Text(name)),
                Flexible(flex: 1, fit: FlexFit.tight, child: Text(number)),
                Flexible(flex: 1, fit: FlexFit.tight, child: Text(date)),
              ]),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: Text('Close',
              style: ConstantApp.getTextStyle(
                  context: context,
                  color: errorColor,
                  size: 11,
                  fontWeight: FontWeight.bold)),
        )
      ],
    );
  }
  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectDate,
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      if (!context.mounted) return;
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectDate),
      );
      if (pickedTime != null) {
        setState(() {
          selectDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          selectDate = selectDate;
          dateController.text =
              DateFormat('yyyy-MM-dd hh:mm a').format(selectDate);
        });
      }
    }
  }
}

