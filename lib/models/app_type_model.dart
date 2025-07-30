
import 'dart:typed_data';

class AppTypeModel {
  int id;
  String name;
  String type;
  String titleBar;
  String imageBar;
  String? backgroundImage;
  String primaryColor;
 Uint8List? backImage;
 String? backgroundColorDropDown;

  AppTypeModel({
    required this.id,
    required this.name,
    required this.type,
    required this.titleBar,
    required this.imageBar,
    required this.backgroundImage,
    required this.primaryColor,
    required this.backgroundColorDropDown,
    required this.backImage,
  });
}
