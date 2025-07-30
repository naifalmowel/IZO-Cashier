import 'package:drift/drift.dart';

class PrinterEntity extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get printerType => text().nullable()();
  TextColumn get printerName => text().nullable()();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
}