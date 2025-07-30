import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cashier_app/modules/tables/dien_in/widget/hall_widget.dart';
import '../../../controllers/info_controllers.dart';
import '../../../utils/Theme/colors.dart';
import '../../../utils/constant.dart';
import '../../../utils/scaled_dimensions.dart';
import '../../home_view/header_widget.dart';

class TablesView extends StatefulWidget {
  const TablesView({super.key});

  @override
  State<TablesView> createState() => _TablesViewState();
}

class _TablesViewState extends State<TablesView> {
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
          child:    infoController.halls
              .where((p0) => p0.id > 0)
              .toList()
              .isEmpty
              ? Center(
            child: Center(
              child: Text(
                'THERE ARE NO TABLES ..!!',
                style: ConstantApp.getTextStyle(
                    context: context,
                    size: 15,
                    fontWeight: FontWeight.bold),
              ),
            ),
          )
              : Obx(
            () => RefreshIndicator(
              onRefresh: () async {
                await Get.find<InfoController>().getAllInformation();
              },
              child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                      horizontal: ScaledDimensions.getScaledWidth(px: 10),
                      vertical: ScaledDimensions.getScaledHeight(px: 15)),
                  child: Column(
                    children: [
                      const HeaderWidget(),
                   Column(
                              children: infoController.halls
                                  .where((p0) => p0.id > 0)
                                  .toList()
                                  .map((element) => HallWidget(
                                      number: element.name,
                                      tables: element.tables))
                                  .toList(),
                            ),
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
