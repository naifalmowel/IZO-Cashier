import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cashier_app/controllers/info_controllers.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../utils/constant.dart';

import '../../controllers/printer_controller.dart';
import '../../controllers/user_controller.dart';
import '../../global_widgets/custom_drop_down_store.dart';
import '../../utils/Theme/colors.dart';
import '../../utils/scaled_dimensions.dart';
import '../printer/printer_view.dart';

class AppSetting extends StatefulWidget {
  const AppSetting({super.key});

  @override
  AppSettingState createState() => AppSettingState();
}

class AppSettingState extends State<AppSetting> {
bool isCumulatively = false;
int storeId = 1;
TextEditingController storeTextEditingController = TextEditingController();
  @override
  void initState() {
    ConstantApp.enableColor = Get.find<SharedPreferences>().getBool('enableColor') ?? false;
    ConstantApp.isDelivery = Get.find<SharedPreferences>().getBool('delivery') ?? false;
    isCumulatively = Get.find<SharedPreferences>().getBool('Cumulatively') ?? false;
    ConstantApp.storeId = storeId = Get.find<SharedPreferences>().getInt('store') ?? 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Setting',
        style: ConstantApp.getTextStyle(context: context, color: Colors.white),
      )),
      body: Container(
        width: ConstantApp.  getWidth(context),
        height: ConstantApp.getHeight(context),
        decoration: BoxDecoration(
          gradient: backgroundGradient,
        ),
        child: SettingsList(
          lightTheme: const SettingsThemeData(
              settingsListBackground: Colors.transparent),
          sections: [
            SettingsSection(
              title: Text('App Setting'.tr,
                  style: ConstantApp.getTextStyle(context: context)),
              tiles: [
                if(ConstantApp.appType.name == "REST" ||
                    ConstantApp.appType.name == "MARKET"  )
                SettingsTile.switchTile(
                  title: Text('Allow To Add Delivery Orders'.tr),
                  leading: const Icon(Icons.delivery_dining),
                  activeSwitchColor: primaryColor,
                  onToggle: (value) {
                    setState(() {
                      ConstantApp.isDelivery = value;
                      Get.find<SharedPreferences>().remove('delivery');
                      Get.find<SharedPreferences>().setBool('delivery', value);
                      Get.find<InfoController>().updateHomePage();
                    });
                  },
                  initialValue: ConstantApp.isDelivery,
                ),
                SettingsTile.switchTile(
                  title: Text('Add Items Cumulatively To Invoice'.tr),
                  leading: const Icon(Icons.point_of_sale),
                  activeSwitchColor: primaryColor,
                  onToggle: (value) {
                    setState(() {
                      isCumulatively = value;
                      Get.find<SharedPreferences>().remove('Cumulatively');
                      Get.find<SharedPreferences>()
                          .setBool('Cumulatively', value);
                    });
                  },
                  initialValue: isCumulatively,
                ),
                SettingsTile.navigation(
                  title: Text('Printer Setting'.tr),
                  leading: const Icon(Icons.print),
                   onPressed: (_)async{
                     var cont =Get.find<UserController>();
                     bool result = cont.isPermission(cont.permission.value.printPage, context);
                     if(!result){
                       return;
                     }
                     await Get.find<PrinterController>().viewPrinter();
                     await Get.find<PrinterController>().getPrintSettingData(1);
                    Get.to(()=>const PrinterPage());
                   },
                ),
              ],
            ),
            SettingsSection(
              title: Text('Theme'.tr,
                  style: ConstantApp.getTextStyle(context: context)),
              tiles: [
                SettingsTile.switchTile(
                  title: Text('Enable color item'.tr),
                  leading: const Icon(Icons.color_lens_outlined),
                  activeSwitchColor: primaryColor,
                  onToggle: (value) {
                    setState(() {
                      ConstantApp.enableColor = value;
                      Get.find<SharedPreferences>().remove('enableColor');
                      Get.find<SharedPreferences>().setBool('enableColor', value);
                      Get.find<InfoController>().updateHomePage();
                    });
                  },
                  initialValue: ConstantApp.enableColor,
                ),
              ],
            ),
            SettingsSection(
              title: Text('Stores'.tr,
                  style: ConstantApp.getTextStyle(context: context)),
              tiles: [
                SettingsTile(
                  title: Text('Select Store For This App'.tr),
                  leading: const Icon(Icons.store),
                  trailing:CustomDropDownButtonStore(
                    title: '',
                    hint: 'Store'.tr,
                    value:
                    storeId == 0 ? null : storeId,
                    items: Get
                        .find<InfoController>()
                        .stores,
                    onChange: (val) {
                      storeId = val ?? 1;
                      ConstantApp.storeId = storeId;
                      Get.find<SharedPreferences>().remove('store');
                      Get.find<SharedPreferences>().setInt('store', storeId);
                    },
                    width: Get.width / 9,
                    height: ScaledDimensions
                        .getScaledHeight(px: 40),
                    textEditingController:
                    storeTextEditingController,
                    showIconReset: false,
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 20,
          child: Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Text('Version : ${Get.find<SharedPreferences>().get('version')??'1.1.1'}' , style: ConstantApp.getTextStyle(context: context , size: 8 , fontWeight: FontWeight.bold),),
          )),
    );
  }
}
