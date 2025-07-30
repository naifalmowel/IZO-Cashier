
import 'package:drift/drift.dart';

class CloseBoxSetting extends Table{
  IntColumn get id => integer().autoIncrement()();
  BoolColumn get show1000 => boolean().withDefault(const Constant(false))();
  BoolColumn get show500 => boolean().withDefault(const Constant(false))();
  BoolColumn get show200 => boolean().withDefault(const Constant(false))();
  BoolColumn get show100 => boolean().withDefault(const Constant(false))();
  BoolColumn get show50 => boolean().withDefault(const Constant(false))();
  BoolColumn get show20 => boolean().withDefault(const Constant(false))();
  BoolColumn get show10 => boolean().withDefault(const Constant(false))();
  BoolColumn get show5 => boolean().withDefault(const Constant(false))();
  BoolColumn get show2 => boolean().withDefault(const Constant(false))();
  BoolColumn get show1 => boolean().withDefault(const Constant(false))();
  BoolColumn get show050 => boolean().withDefault(const Constant(false))();
  BoolColumn get show025 => boolean().withDefault(const Constant(false))();
  BoolColumn get show010 => boolean().withDefault(const Constant(false))();
  BoolColumn get show005 => boolean().withDefault(const Constant(false))();
  BoolColumn get show001 => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createAt => dateTime()();
}