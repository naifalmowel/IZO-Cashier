// ignore_for_file: must_be_immutable

import 'package:cashier_app/models/employee_model.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../utils/Theme/colors.dart';
import '../utils/constant.dart';

class CustomDropDownButtonEmployee extends StatefulWidget {
  CustomDropDownButtonEmployee(
      {required this.title,
        required this.hint,
        required this.items,
        this.value,
        this.withOutValue,
        this. reset,
        this. showIconReset = true,
        required this.onChange,
        required this.width,
        required this.height,
        required this.textEditingController,
        Key? key})
      : super(key: key);

  final String title;
  final String hint;
  final List<EmployeeModel> items;
  int? value;
  final Function(int?) onChange;
  final double width;
  final double height;
  final bool? withOutValue;
  final bool showIconReset;
  final VoidCallback? reset ;
  TextEditingController textEditingController ;

  @override
  State<CustomDropDownButtonEmployee> createState() => _CustomDropDownButtonEmployeeState();
}

class _CustomDropDownButtonEmployeeState extends State<CustomDropDownButtonEmployee> {
  int? valuee;
  var init = true;

  @override
  void initState() {
    if (init) {
      valuee = null;
      init = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<int>(
          style:ConstantApp.getWidth(context)>900? ConstantApp.getTextStyle(context: context): ConstantApp.getTextStyle(context: context,size: 7),
          hint: Center(
            child: Text(
              widget.hint,
              style:  ConstantApp.getTextStyle(context: context,color: textColor,size:8),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          items: widget.items
              .map((item) => DropdownMenuItem<int>(
            value: item.id,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Center(
                child: Text(
                  item.englishName,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ))
              .toList(),
          value:  widget.value ,
          onChanged: (value) {
            setState(() {
              widget.value = value;
              valuee = value;
            });
            widget.onChange(value);
          },
          buttonStyleData: ButtonStyleData(
            decoration: BoxDecoration(
                color: backgroundColorDropDown.withOpacity(1),
                borderRadius: const BorderRadius.all(
                    Radius.circular(30))),
            width: widget.width,
            height: widget.height,
          ),
          iconStyleData: IconStyleData(
              iconSize: ConstantApp.getTextSize(context)*10
          ),
          dropdownStyleData:  DropdownStyleData(
            width: ConstantApp.getWidth(context)/9,
            decoration: const BoxDecoration(
              borderRadius:
              BorderRadius.all(Radius.circular(30)),
            ),
            maxHeight: 200,
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
          ),
          dropdownSearchData: DropdownSearchData(
            searchController: widget.textEditingController,
            searchInnerWidgetHeight: 50,
            searchInnerWidget: Container(
              height: 50,
              padding: const EdgeInsets.only(
                top: 8,
                bottom: 4,
                right: 8,
                left: 8,
              ),
              child: TextFormField(
                expands: true,
                maxLines: null,
                autofocus: true,
                controller: widget.textEditingController,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  hintText: 'Search...'.tr,
                  hintStyle: const TextStyle(fontSize: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            searchMatchFn: (item, searchValue) {
              final myItem = widget.items.firstWhere((element) => element.id == item.value);
              return ((myItem.englishName.toString()
                  .toLowerCase()
                  .toString()
                  .contains(
                  searchValue.toLowerCase().toString())) || (item.value.toString()
                  .toLowerCase()
                  .toString()
                  .contains(
                  searchValue.toLowerCase().toString())));
            },
          ),
          isExpanded: true,
          onMenuStateChange: (isOpen) {
            if (!isOpen) {
              widget.textEditingController.clear();
            }
          },
        ),
      ),
    );
  }
}
