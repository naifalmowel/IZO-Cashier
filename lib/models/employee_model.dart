class EmployeeModel{
  EmployeeModel({
    required this.id,
    required this.englishName,
    required this.createdAt,
    required this.commission,
    required this.address,
    required this.arabicName,
    required this.code,
    required this.isActive,
    required this.mobilNum,
});
 int  id;
 String englishName;
 String arabicName;
 String code;
 String mobilNum;
 String address;
 double  commission;
 bool isActive;
 DateTime createdAt;
}