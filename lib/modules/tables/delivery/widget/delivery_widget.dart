import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cashier_app/controllers/order_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../controllers/info_controllers.dart';
import '../../../../controllers/tables_controller.dart';
import '../../../../controllers/user_controller.dart';
import '../../../../models/table_model.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/scaled_dimensions.dart';
import '../../../order_view/order_view_a.dart';
import '../../../order_view/order_view_w.dart';
import 'delivery_table_widget.dart';

class DeliveryWidget extends StatefulWidget {
  const DeliveryWidget({required this.number, required this.tables, Key? key})
      : super(key: key);
  final List<TableModel> tables;
  final int number;

  @override
  State<DeliveryWidget> createState() => _DeliveryWidgetState();
}

class _DeliveryWidgetState extends State<DeliveryWidget> {
  bool payT = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: ScaledDimensions.getScaledHeight(px: 10),
        ),
        GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: GetPlatform.isDesktop || Get.width > 750
                  ? Get.width < 1000
                      ? 3
                      : 5
                  : 2,
              childAspectRatio: 1.8),
          itemCount: widget.tables.length,
          itemBuilder: (BuildContext context, int index) {
            return DeliveryTableWidget(
              number: widget.tables[index].number,
              amount: widget.tables[index].voidAmount != null
                  ? (widget.tables[index].cost -
                          widget.tables[index].voidAmount!)
                      .toString()
                  : widget.tables[index].cost.toString(),
              isOn: widget.tables[index].cost != 0 ? true : false,
              onTap: () async {

                if(ConstantApp.type == "guest"){

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
                else{
                  bool isActive = await   Get.find<UserController>().checkUser(context: context);
                  if(isActive){
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
                  if (message == 'ERROR') {
                    if (!context.mounted) return;
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
              isBill: widget.tables[index].waitCustomer != null &&
                      widget.tables[index].waitCustomer == true
                  ? true
                  : false,
              orders: const [],
              onUpdatedPress: (val) {},
              onBillRequest: () {},
              time: widget.tables[index].time,
              formatNumber: widget.tables[index].formatNumber ?? '',
            );
          },
        ),
      ],
    );
  }
}
