import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../../utils/constant.dart';

void showDialogNote({
  String? note,
  required BuildContext context,
  required TextEditingController noteOrderController,
  required VoidCallback addUpdateNote,
  required GlobalKey<FormState> formKey,
}) {
  showAnimatedDialog(
    context: context,
    builder: (context) {
      if (note != null) {
        noteOrderController.text = note;
      }
      return SimpleDialog(
        backgroundColor: Colors.white,
        alignment: Alignment.center,
        titleTextStyle: ConstantApp.getTextStyle(context: context, size: 15),
        children: [
          Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SizedBox(
                    child: TextFormField(
                      controller: noteOrderController,
                      decoration: InputDecoration(
                        labelText: "Note Order".tr,
                        icon: const Icon(FontAwesomeIcons.noteSticky),
                      ),
                      validator: (value) {
                        if (value == null || value == "") {
                          return "Add Note".tr;
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                TextButton(
                    onPressed: addUpdateNote,
                    child: note == null
                        ? Text("Add Note".tr)
                        : Text("Update Note".tr)),
              ],
            ),
          ),
        ],
      );
    },
    barrierDismissible: true,
    animationType: DialogTransitionType.sizeFade,
    curve: Curves.fastOutSlowIn,
    duration: const Duration(milliseconds: 400),
  );
}


