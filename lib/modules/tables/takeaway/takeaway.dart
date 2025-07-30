import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cashier_app/controllers/info_controllers.dart';
import 'package:cashier_app/controllers/tables_controller.dart';
import 'package:cashier_app/modules/tables/takeaway/widget/takeaway_widget.dart';
import '../../../controllers/user_controller.dart';
import '../../../utils/Theme/colors.dart';
import '../../../utils/constant.dart';
import '../../../utils/scaled_dimensions.dart';
import '../../home_view/header_widget.dart';

class TakeawayView extends StatefulWidget {
  const TakeawayView({super.key});

  @override
  State<TakeawayView> createState() => _TakeawayViewState();
}

class _TakeawayViewState extends State<TakeawayView> {
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
                        ConstantApp.appType.name != "REST"
                            ? "SALES".tr
                            : 'TAKEAWAY'.tr,
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
                      .where((p0) => p0.id == -1)
                      .toList()
                      .map((element) => TakeawayWidget(
                          number: element.id, tables: element.tables))
                      .toList(),
                ),
              ])),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "btn1",
            onPressed: () async {
              bool isActive = await   Get.find<UserController>().checkUser(context: context);
              if(isActive){
                return;
              }
              String message = await Get.find<TableController>().incTakeaway();
              if (message == 'ERROR') {
                if(!context.mounted)return;
                ConstantApp.showSnakeBarError(
                    context, 'SORRY , NO SERVER CONNECTION !!');
              }
            },
            backgroundColor: primaryColor.withOpacity(0.7),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
              String message = await Get.find<TableController>().decTakeaway();
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
