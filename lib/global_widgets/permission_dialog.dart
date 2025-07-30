import 'package:cashier_app/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/Theme/colors.dart';
import '../../../utils/constant.dart';
import '../utils/scaled_dimensions.dart';
import 'drop_down_button_users.dart';

class CustomPermissionDialog extends StatefulWidget {
   const CustomPermissionDialog({required this.fun, super.key});

 final VoidCallback fun;

  @override
  State<CustomPermissionDialog> createState() => _CustomPermissionDialogState();
}

class _CustomPermissionDialogState extends State<CustomPermissionDialog> {
  final cont = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Center(
      child: SizedBox(
        width: ConstantApp.getWidth(context) / 3,
        height: ConstantApp.getWidth(context) / 5,
        child: AlertDialog(
          title: SingleChildScrollView(
              child: Column(
            children: [
              CustomDropDownButtonUsers(
                value: cont.usersId.value == 0 ? null : cont.usersId.value,
                title: '',
                hint: 'Users'.tr,
                items: Get.find<UserController>()
                    .users
                    .where((p0) => p0.isActive == true)
                    .toList(),
                onChange: (value) {
                  cont.usersId.value = value!;
                },
                width: ConstantApp.getWidth(context) / 3.5,
                height: 50,
                textEditingController: cont.textEditingController,
              ),
              Obx(
                () => Container(
                  color: Colors.white.withOpacity(0.7),
                  height: ScaledDimensions.getScaledHeight(px: 60),
                  width: ConstantApp.getWidth(context) / 3.5,
                  child: TextFormField(
                    onFieldSubmitted: (value) async {
                      if (cont.usersId.value == 0) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Pleas chose user'.tr),
                          backgroundColor: Colors.red,
                        ));
                        return ;
                      }
                      String passwordU = '';
                      var x = await Get.find<UserController>().getUsers();
                      if (x.isNotEmpty) {
                        for (var i in x) {
                          if (i.id == cont.usersId.value) {
                            passwordU = i.password;
                          }
                        }
                        if (passwordU == cont.password.text) {
                          Get.back();
                          widget.fun;
                        } else {
                          if (!context.mounted) {
                            return;
                          }
                          ConstantApp.showSnakeBarError(
                            context,
                            'Invalid username or password.. !!'.tr,
                          );
                        }
                      }
                    },
                    controller: cont.password,
                    obscureText: cont.obscure.value,
                    autofocus: true,
                    cursorColor: const Color(0xffee680e),
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: 'PIN'.tr,
                        focusColor: const Color(0xffee680e),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffee680e))),
                        suffixIcon: cont.obscure.value
                            ? IconButton(
                                onPressed: () {
                                  cont.obscure.value = !cont.obscure.value;
                                  setState(() {});
                                },
                                icon: const Icon(Icons.visibility,
                                    color: Colors.black),
                                tooltip: 'Show Password'.tr,
                              )
                            : IconButton(
                                onPressed: () {
                                  cont.obscure.value = !cont.obscure.value;
                                  setState(() {});
                                },
                                icon: const Icon(Icons.visibility_off,
                                    color: Colors.black),
                                tooltip: 'Hide Password'.tr,
                              )),
                  ),
                ),
              ),
            ],
          )),
          actions: [
            MaterialButton(
              color: Colors.red,
              onPressed: () {
                Get.back();
                return;
              },
              child: const Text(
                'Cancel',
                style: TextStyle(fontSize: 18),
              ),
            ),
            MaterialButton(
              color: primaryColor,
              onPressed: () async {
                if (cont.usersId.value == 0) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Pleas chose user'.tr),
                    backgroundColor: Colors.red,
                  ));
                  return;
                }
                String passwordU = '';
                var x = await Get.find<UserController>().getUsers();
                if (x.isNotEmpty) {
                  for (var i in x) {
                    if (i.id == cont.usersId.value) {
                      passwordU = i.password;
                    }
                  }
                  if (passwordU == cont.password.text) {
                    Get.back();
                    widget.fun;
                  } else {
                    if (!context.mounted) {
                      return;
                    }
                    ConstantApp.showSnakeBarError(
                      context,
                      'Invalid username or password.. !!'.tr,
                    );
                    return;
                  }
                }
              },
              child: const Text(
                'Accept',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
