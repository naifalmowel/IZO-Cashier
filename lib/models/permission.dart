class PermissionModel {
  int userId;
  bool cashDrawer;
  bool addContact;
  bool closeBox;
  bool choseOfferPrice;
  bool choseWholePrice;
  bool choseMinPrice;
  bool choseCostPrice;
  bool viewDriver;
  bool discount;
  bool showEmployeePos;
  bool removeItemOrder;
  bool addSales;
  bool deleteSales;
  bool editSales;
  bool returnSales;
  bool viewSales;
  bool printPage;
  bool tableChange;
  bool voidPer;
  bool editPrice;

  PermissionModel({
    required this.cashDrawer,
    required this.addContact,
    required this.closeBox,
    required this.choseOfferPrice,
    required this.choseWholePrice,
    required this.choseMinPrice,
    required this.choseCostPrice,
    required this.viewDriver,
    required this.discount,
    required this.showEmployeePos,
    required this.removeItemOrder,
    required this.addSales,
    required this.deleteSales,
    required this.editSales,
    required this.returnSales,
    required this.viewSales,
    required this.printPage,
    required this.tableChange,
    required this.voidPer,
    required this.userId,
    required this.editPrice,
  });
}
