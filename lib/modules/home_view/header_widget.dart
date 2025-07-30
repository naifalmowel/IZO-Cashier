import 'package:cashier_app/controllers/info_controllers.dart';
import 'package:cashier_app/controllers/user_controller.dart';
import 'package:cashier_app/modules/login/control_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/IZO_information_page.dart';
import '../../utils/Theme/colors.dart';
import '../login/login.dart';
import '../setting/setting_page.dart';

class HeaderWidget extends StatefulWidget {
  const HeaderWidget({super.key});

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return   Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
       IconButton(
              onPressed: () async{
                Get.off(()=> const ControlScreen(
                ));
              },
              tooltip: 'close',
              iconSize: 30,
              icon: Icon(
                Icons.arrow_back_outlined,
                color: secondaryColor,
              )),
        InkWell(
            onTap: () {
              Get.to(() => const IZOPage());
            },
            child: Image.asset(
              'assets/images/IZO.png',
              width: 50,
              height: 50,
            )),
        Row(
          children: [
            IconButton(
                onPressed: () async{
                  await Get.find<InfoController>().getAllStore();
                  Get.to(()=>const AppSetting());
                },
                tooltip: 'Setting',
                iconSize: 30,
                icon: Icon(
                  Icons.settings,
                  color: secondaryColor,
                )),
            IconButton(
                onPressed: () {
                  showAnimatedDialog(
                      context: context,
                      builder: (context) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: SingleChildScrollView(
                            child: AlertDialog(
                              alignment: Alignment.topCenter,
                              backgroundColor: Colors.white.withOpacity(0.9),
                              actionsPadding: const EdgeInsets.all(20),
                              shape: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(30))),
                              title: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Lottie.asset('lottie/question.json',
                                          height: 200, width: 200),
                                      const Text('Are You Sure To Logout ?',
                                          textAlign: TextAlign.center),
                                    ],
                                  )),
                              content: const Text(
                                  'You Will Not Be Able To Return To This Page',
                                  textAlign: TextAlign.center),
                              actions: [
                                ElevatedButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateColor.resolveWith(
                                                (states) => Colors.redAccent)),
                                    child: const Padding(
                                      padding: EdgeInsets.only(left: 20, right: 20),
                                      child: Text('No',style: TextStyle(color: Colors.white , fontWeight: FontWeight.w600),),
                                    )),
                                ElevatedButton(
                                    onPressed: () async{
                                      await Get.find<UserController>().getUsers();
                                      Get.find<SharedPreferences>().remove('name');
                                      Get.find<SharedPreferences>()
                                          .remove('userId');
                                      Get.find<SharedPreferences>()
                                          .remove('type');
                                      Get.back();
                                      Get.offAll(()=> const LoginPage());
                                    },
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateColor.resolveWith(
                                                (states) => primaryColor.withOpacity(0.8))),
                                    child: const Padding(
                                      padding: EdgeInsets.only(left: 20 , right: 20),
                                      child: Text('Yes' ,style: TextStyle(color: Colors.white , fontWeight: FontWeight.w600),),
                                    )),

                              ],
                            ),
                          ),
                        );
                      },
                      barrierDismissible: true,
                      animationType: DialogTransitionType.slideFromTop,
                      curve: Curves.fastOutSlowIn,
                      duration: const Duration(milliseconds: 400));
                },
                tooltip: 'Logout',
                iconSize: 30,
                icon: Icon(Icons.logout, color: secondaryColor)),
          ],
        ),
      ],
    );
  }
}
