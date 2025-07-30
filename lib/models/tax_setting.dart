class TaxSettingModel{
  TaxSettingModel({
    required this.id,
    required this.every,
    required this.createAt,
    required this.createBy,
    required this.taxId,
    required this.taxNumber,
    required this.taxType,
});
 int? id;
 int? taxId;
 int? every;
 String? taxNumber;
 String? taxType;
 String? createBy;
 DateTime? createAt;
}