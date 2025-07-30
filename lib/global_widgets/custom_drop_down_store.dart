// ignore_for_file: must_be_immutable

import 'package:cashier_app/models/store_model.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/scaled_dimensions.dart';
import '../utils/Theme/colors.dart';

class CustomDropDownButtonStore extends StatefulWidget {
  CustomDropDownButtonStore(
      {required this.title,
        required this.hint,
        required this.items,
        this.value,
        this.withOutValue,
        this.showIconReset = false,
        this.reset,
        required this.onChange,
        required this.width,
        required this.height,
        required this.textEditingController,
        Key? key})
      : super(key: key);

  final String title;
  final String hint;
  final List<StoreModel> items;
  int? value;
  final Function(int?) onChange;
  final double width;
  final double height;
  final bool? withOutValue;
  final bool showIconReset;
  TextEditingController textEditingController;
  VoidCallback?  reset ;


  @override
  State<CustomDropDownButtonStore> createState() => _CustomDropDownButtonStoreState();
}

class _CustomDropDownButtonStoreState extends State<CustomDropDownButtonStore> {
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
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: ScaledDimensions.getScaledHeight(px: 10)),
      width: widget.width,
      height: widget.height,

      child: DropdownButtonHideUnderline(
        child: DropdownButton2<int>(
          isExpanded: true,
          style: TextStyle(color: primaryColor.withOpacity(1)),
          hint: Center(
            child: Text(
              widget.hint,
              style:  TextStyle(
                  color: textColor
              ),
              overflow: TextOverflow.ellipsis,
            ),

          ),
          items: widget.items
              .map((item) {
            return DropdownMenuItem<int>(
              value: item.id,
              child: Center(
                child: Text(
                  item.name,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          })
              .toList(),
          value:  widget.value ,
          onChanged: (value) {
            setState(() {
              // print(value);
              widget.value = value;

              valuee = value;
            });
            widget.onChange(value);
          },
          buttonStyleData: ButtonStyleData(
            decoration: BoxDecoration(
                color:
                backgroundColorDropDown.withOpacity(1),
                borderRadius: const BorderRadius.all(
                    Radius.circular(30))),
            height: 50,
            width: double.infinity,
          ),
          dropdownStyleData: const DropdownStyleData(
            decoration: BoxDecoration(
              borderRadius:
              BorderRadius.all(Radius.circular(30)),
            ),
            maxHeight: 200,
            width: 200,
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
              return ((myItem.name.toString()
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
