import 'dart:io';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:cashier_app/database/entity/pos_setting.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:drift/native.dart';

import 'entity/close_box_setting.dart';
import 'entity/printer_entity.dart';
import 'entity/printer_setting.dart';

part 'app_db.g.dart';

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'cashier2.db'));
    return NativeDatabase(file);
  });
}

@DriftDatabase(tables: [
  PosSetting,
  PrinterEntity,
  PrinterSettingEntity,
  CloseBoxSetting,
])
class AppDataBase extends _$AppDataBase {
  AppDataBase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        await insertDb();
      },
      onUpgrade: (Migrator m, int from, int to) async {
          tryCatch(into(closeBoxSetting).insertReturning(CloseBoxSettingCompanion(
            id: const Value(1),
            show1000: const Value(true),
            show500: const Value(true),
            show200: const Value(true),
            show100: const Value(true),
            show50: const Value(true),
            show20: const Value(true),
            show10: const Value(true),
            show5: const Value(true),
            show2: const Value(false),
            show1: const Value(true),
            show050: const Value(true),
            show025: const Value(true),
            show010: const Value(false),
            show005: const Value(false),
            show001: const Value(false),
            createAt: Value(DateTime.now()),
          )));
      },
      beforeOpen: (details) async {},
    );
  }

  void tryCatch(Future<void> fun) async {
    try {
      await fun;
    } catch (e) {
      debugPrint('ERROR MIGRATION');
    }
  }

  Future<void> insertDb() async {
    await into(posSetting).insertReturning(const PosSettingCompanion(
      id: Value(1),
      productItem: Value(4),
      mainItem: Value(1),
      subItem: Value(1),
      orderW: Value(5),
      productW: Value(3),
      mainW: Value(1),
      subW: Value(1),
      showMain: Value(true),
      showSub: Value(true),
    ));
    await into(printerSettingEntity).insert(const PrinterSettingEntityData(
        id: 1,
        billPrinter: 0,
        reportPrinter: 0,
        showUnit: false,
        showVat: false,
        fontSize: 8.0,
        headerPrint: 'Restaurant',
        tailPrint: "Thank you for visit",
        isFullOrder: false,
        showProductDescription: false));
    await into(closeBoxSetting).insert(CloseBoxSettingCompanion(
      id: const Value(1),
      show1000: const Value(true),
      show500: const Value(true),
      show200: const Value(true),
      show100: const Value(true),
      show50: const Value(true),
      show20: const Value(true),
      show10: const Value(true),
      show5: const Value(true),
      show2: const Value(false),
      show1: const Value(true),
      show050: const Value(true),
      show025: const Value(true),
      show010: const Value(false),
      show005: const Value(false),
      show001: const Value(false),
      createAt: Value(DateTime.now()),
    ));
  }

  Future insertPosSetting(PosSettingCompanion mov) =>
      into(posSetting).insert(mov);

  Future updatePosSetting(PosSettingData acc) =>
      update(posSetting).replace(acc);

  // Future deletePosSetting(int idMove) async {
  //   await (delete(posSetting)..where((tbl) => tbl.id.equals(idMove))).go();
  // }

  Future<PosSettingData> getPosSetting() async {
    final query = select(posSetting)..where((company) => company.id.equals(1));
    return await query.getSingle();
  }
  Future insertPrinter(PrinterEntityCompanion printer) =>
      into(printerEntity).insert(printer);
  Future<List<PrinterEntityData>> getAllPrinter() =>
      select(printerEntity).get();
  Future<int> deletePrinter(int id) =>
      (delete(printerEntity)..where((tbl) => tbl.id.equals(id))).go();
  Future editReportBillPrinter({
    required int id,
    required int reportId,
    required int billPrinter,
  }) async {
    return (update(printerSettingEntity)..where((tbl) => tbl.id.equals(id)))
      ..write(PrinterSettingEntityCompanion(
        reportPrinter: Value(reportId),
        billPrinter: Value(billPrinter),
      ));
  }
  Future<PrinterSettingEntityData?> getPrinterSetting(int id) async {
    final query = select(printerSettingEntity)
      ..where((printer) => printer.id.equals(id));
    return query.getSingleOrNull();
  }
  Future updatePrinterSetting(PrinterSettingEntityData acc) =>
      update(printerSettingEntity).replace(acc);

  Future updateCloseBoxSetting(CloseBoxSettingData acc) =>
      update(closeBoxSetting).replace(acc);
  Future<CloseBoxSettingData?> getCloseBoxSetting() {
    final query = select(closeBoxSetting)
      ..where((company) => company.id.equals(1));
    return query.getSingleOrNull();
  }

}
