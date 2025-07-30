import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cashier_app/modules/tables/delivery/widget/delivery_widget.dart';
import '../../../controllers/info_controllers.dart';
import '../../../controllers/tables_controller.dart';
import '../../../controllers/user_controller.dart';
import '../../../utils/Theme/colors.dart';
import '../../../utils/constant.dart';
import '../../../utils/scaled_dimensions.dart';
import '../../home_view/header_widget.dart';

class DeliveryView extends StatefulWidget {
  const DeliveryView({super.key});

  @override
  State<DeliveryView> createState() => _DeliveryViewState();
}

class _DeliveryViewState extends State<DeliveryView> {
  final infoController = Get.find<InfoController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        width: ConstantApp.getWidth(context),
        height: ConstantApp.getHeight(context),
        decoration: BoxDecoration(
          gradient: backgroundGradient,
        ),
        child: Obx(
          () => SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                  horizontal: ScaledDimensions.getScaledWidth(px: 10),
                  vertical: ScaledDimensions.getScaledHeight(px: 15)),
              child: Column(children: [
                const HeaderWidget(),
                Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: primaryColor),
                  child: Center(
                    child: Text(
                      'DELIVERY',
                      style: ConstantApp.getTextStyle(
                          context: context,
                          size: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold).copyWith(letterSpacing: 3,),
                    ),
                  ),
                ),
                Column(
                  children: infoController.halls
                      .where((p0) => p0.id == 0)
                      .toList()
                      .map((element) => DeliveryWidget(
                          number: element.id, tables: element.tables))
                      .toList(),
                )
              ])),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "btn1",
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            onPressed: () async {
              bool isActive = await   Get.find<UserController>().checkUser(context: context);
              if(isActive){
                return;
              }
              String message = await Get.find<TableController>().incDelivery();
              if (message == 'ERROR') {
                if(!context.mounted)return;
                ConstantApp.showSnakeBarError(
                    context, 'SORRY , NO SERVER CONNECTION !!');
              }
            },
            backgroundColor: primaryColor.withOpacity(0.7),
            child: const Icon(Icons.add),
          ),
          const SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            heroTag: "btn2",
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            onPressed: () async {
              bool isActive = await   Get.find<UserController>().checkUser(context: context);
              if(isActive){
                return;
              }
              String message = await Get.find<TableController>().decDelivery();
              if (message == 'ERROR') {
                if(!context.mounted)return;
                ConstantApp.showSnakeBarError(
                    context, 'SORRY , CAN NOT DELETE !!');
              }
            },
            backgroundColor: errorColor.withOpacity(0.7),
            child: const Icon(Icons.remove),
          )
        ],
      ),
    ));
  }
}
