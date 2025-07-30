import 'dart:typed_data';

class MainCategoryModel {
  MainCategoryModel(
      {required this.id,
      required this.englishName,
      required this.image,
      required this.color,
      required this.icon});

  int id;
  String? englishName;
  Uint8List? image;
  String? color;
  String? icon;
}

class SubCategoryModel {
  SubCategoryModel(
      {required this.id,
      required this.englishName,
      required this.image,
      this.color,
      required this.icon,
      this.mainId});

  int id;
  String? englishName;
  Uint8List? image;
  int? mainId;
  String? color;
  String? icon;
}
