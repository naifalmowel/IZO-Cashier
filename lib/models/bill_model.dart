class BillModel {
  BillModel({
    required this.id,
    required this.formatNumber,
    required this.finalTotal,
    required this.cashAmount,
    required this.visaAmount,
    required this.hall,
    required this.table,
    required this.customerName,
    required this.cashier,
    required this.dateSales,
    required this.salesType,
    required this.total,
    required this.discountAmount,
    required this.disType,
    required this.disValue,
    required this.vat,
    required this.createdAt,
    required this.balance,
    required this.noteOrder,
    required this.paid,
    required this.payType,
    required this.tips,
    required this.customerId,
    required this.storeId,
    required this.invoice,
    required this.numberOfBill,
    required this.patternId,
    required this.receiptDue,
    required this.receiptStatus,
    required this.typeInvoice,
  });

   int? id;
   int? customerId;
   int? patternId;
   String? formatNumber;
   String? invoice;
   String? typeInvoice;
   String? numberOfBill;
   String? receiptStatus;
 double? receiptDue;
 double? finalTotal;
  double? cashAmount;
  double? visaAmount;
  String?  hall;
  String? table;
  String? customerName;
  String? cashier;
  DateTime? dateSales;
  String? salesType;
  double? total;
  double? discountAmount;
  double? tips;
  String?  disType;
  String? disValue;
  double? vat;
  DateTime? createdAt;
  String? balance;
  String? noteOrder;
  String? paid;
  String? payType;


  int? storeId;
}
