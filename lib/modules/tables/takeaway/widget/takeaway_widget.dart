import 'package:cashier_app/controllers/info_controllers.dart';
import 'package:cashier_app/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cashier_app/controllers/tables_controller.dart';
import '../../../../controllers/order_controller.dart';
import '../../../order_view/order_view_a.dart';
import '../../../order_view/order_view_w.dart';
import 'package:cashier_app/modules/tables/takeaway/widget/takeaway_table_widget.dart';
import 'package:cashier_app/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../models/table_model.dart';
import '../../../../utils/scaled_dimensions.dart';

class TakeawayWidget extends StatelessWidget {
  const TakeawayWidget({required this.number, required this.tables, Key? key})
      : super(key: key);
  final List<TableModel> tables;
  final int number;

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
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: GetPlatform.isDesktop || Get.width > 750
                  ? Get.width < 1000
                  ? 3
                  : 5
                  : 2,
              childAspectRatio: 1.8),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: tables.length,
          itemBuilder: (BuildContext context, int index) {
            return TakeawayTableWidget(
              onTap: () async {

              if(ConstantApp.type == "guest"){
                Get.find<OrderController>().getAllProducts();
                Get.find<OrderController>().getAllOrders();
              }
              else{
                bool isActive = await   Get.find<UserController>().checkUser(context: context);
                if(isActive){
                  return;
                }
                await Get.find<OrderController>().getAllProducts();
                await Get.find<UserController>().getUsers();
                if(!Get.find<InfoController>().isServerConnect.value){
                  if(!context.mounted)return;
                  ConstantApp.showSnakeBarError(context, 'Server Connection !!');
                  return;
                }
                Get.find<OrderController>().order.clear();
                await Get.find<OrderController>()
                    .getAllOrders();
                Get.find<OrderController>().orders.clear();
                await Get.find<OrderController>().getOrderForTable(
                  tables[index].hall.toString(),
                  tables[index].number.toString(),
                );
                await Get.find<OrderController>().getDetails();
                final cashier =
                    Get.find<SharedPreferences>().getString('name') ?? '';

                final message =
                await Get.find<TableController>().entryToTable(data: {
                  "number": tables[index].number.toString(),
                  "hall": tables[index].hall.toString(),
                  "cashier": cashier,
                });
                if (!context.mounted) return;
                if (message == 'ERROR') {
                  ConstantApp.showSnakeBarError(context, 'The Table is Busy');
                  return;
                }
              }
              Get.to(() =>GetPlatform.isWindows ?  OrderViewW(
                hall: tables[index].hall.toString(),
                table: tables[index].number.toString(),
                customerId: tables[index].customerId ?? 0,
                billRequest: tables[index].waitCustomer ?? false,
              ):OrderViewA(
                hall: tables[index].hall.toString(),
                table: tables[index].number.toString(),
                customerId: tables[index].customerId ?? 0,
                billRequest: tables[index].waitCustomer ?? false,
              ));
              },
              number: tables[index].number,
              amount: tables[index].voidAmount != null
                  ? (tables[index].cost - tables[index].voidAmount!).toString()
                  : tables[index].cost.toString(),
              isOn: tables[index].cost != 0 ? true : false,
              isBill: tables[index].waitCustomer != null &&
                      tables[index].waitCustomer == true
                  ? true
                  : false,
              time: tables[index].time,
              orders: const [],
              onUpdatedPress: (value) async {},
              onBillRequest: () async {},
              formatNumber: tables[index].formatNumber ?? '',
            );
          },
        )
      ],
    );
  }
}
