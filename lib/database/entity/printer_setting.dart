import 'package:drift/drift.dart';

class PrinterSettingEntity extends Table{
  IntColumn get id =>integer().autoIncrement()();
  IntColumn get billPrinter => integer().nullable()();
  IntColumn get reportPrinter => integer().nullable()();
  RealColumn get fontSize => real().nullable()();
  BoolColumn get isFullOrder => boolean().withDefault(const Constant(false))();
  BoolColumn get showUnit => boolean().withDefault(const Constant(false))();
  BoolColumn get showVat => boolean().withDefault(const Constant(false))();
  BoolColumn get showProductDescription => boolean().withDefault(const Constant(false))();
  TextColumn get tailPrint => text().nullable()();
  TextColumn get headerPrint => text().nullable()();
}