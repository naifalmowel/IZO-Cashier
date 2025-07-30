// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_db.dart';

// ignore_for_file: type=lint
class $PosSettingTable extends PosSetting
    with TableInfo<$PosSettingTable, PosSettingData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PosSettingTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _orderWMeta = const VerificationMeta('orderW');
  @override
  late final GeneratedColumn<int> orderW = GeneratedColumn<int>(
      'order_w', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _productWMeta =
      const VerificationMeta('productW');
  @override
  late final GeneratedColumn<int> productW = GeneratedColumn<int>(
      'product_w', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _subWMeta = const VerificationMeta('subW');
  @override
  late final GeneratedColumn<int> subW = GeneratedColumn<int>(
      'sub_w', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _mainWMeta = const VerificationMeta('mainW');
  @override
  late final GeneratedColumn<int> mainW = GeneratedColumn<int>(
      'main_w', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _productItemMeta =
      const VerificationMeta('productItem');
  @override
  late final GeneratedColumn<int> productItem = GeneratedColumn<int>(
      'product_item', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _mainItemMeta =
      const VerificationMeta('mainItem');
  @override
  late final GeneratedColumn<int> mainItem = GeneratedColumn<int>(
      'main_item', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _subItemMeta =
      const VerificationMeta('subItem');
  @override
  late final GeneratedColumn<int> subItem = GeneratedColumn<int>(
      'sub_item', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _showMainMeta =
      const VerificationMeta('showMain');
  @override
  late final GeneratedColumn<bool> showMain = GeneratedColumn<bool>(
      'show_main', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("show_main" IN (0, 1))'));
  static const VerificationMeta _showSubMeta =
      const VerificationMeta('showSub');
  @override
  late final GeneratedColumn<bool> showSub = GeneratedColumn<bool>(
      'show_sub', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("show_sub" IN (0, 1))'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        orderW,
        productW,
        subW,
        mainW,
        productItem,
        mainItem,
        subItem,
        showMain,
        showSub
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pos_setting';
  @override
  VerificationContext validateIntegrity(Insertable<PosSettingData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('order_w')) {
      context.handle(_orderWMeta,
          orderW.isAcceptableOrUnknown(data['order_w']!, _orderWMeta));
    }
    if (data.containsKey('product_w')) {
      context.handle(_productWMeta,
          productW.isAcceptableOrUnknown(data['product_w']!, _productWMeta));
    }
    if (data.containsKey('sub_w')) {
      context.handle(
          _subWMeta, subW.isAcceptableOrUnknown(data['sub_w']!, _subWMeta));
    }
    if (data.containsKey('main_w')) {
      context.handle(
          _mainWMeta, mainW.isAcceptableOrUnknown(data['main_w']!, _mainWMeta));
    }
    if (data.containsKey('product_item')) {
      context.handle(
          _productItemMeta,
          productItem.isAcceptableOrUnknown(
              data['product_item']!, _productItemMeta));
    }
    if (data.containsKey('main_item')) {
      context.handle(_mainItemMeta,
          mainItem.isAcceptableOrUnknown(data['main_item']!, _mainItemMeta));
    }
    if (data.containsKey('sub_item')) {
      context.handle(_subItemMeta,
          subItem.isAcceptableOrUnknown(data['sub_item']!, _subItemMeta));
    }
    if (data.containsKey('show_main')) {
      context.handle(_showMainMeta,
          showMain.isAcceptableOrUnknown(data['show_main']!, _showMainMeta));
    }
    if (data.containsKey('show_sub')) {
      context.handle(_showSubMeta,
          showSub.isAcceptableOrUnknown(data['show_sub']!, _showSubMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PosSettingData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PosSettingData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      orderW: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order_w']),
      productW: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}product_w']),
      subW: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sub_w']),
      mainW: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}main_w']),
      productItem: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}product_item']),
      mainItem: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}main_item']),
      subItem: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sub_item']),
      showMain: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}show_main']),
      showSub: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}show_sub']),
    );
  }

  @override
  $PosSettingTable createAlias(String alias) {
    return $PosSettingTable(attachedDatabase, alias);
  }
}

class PosSettingData extends DataClass implements Insertable<PosSettingData> {
  final int id;
  final int? orderW;
  final int? productW;
  final int? subW;
  final int? mainW;
  final int? productItem;
  final int? mainItem;
  final int? subItem;
  final bool? showMain;
  final bool? showSub;
  const PosSettingData(
      {required this.id,
      this.orderW,
      this.productW,
      this.subW,
      this.mainW,
      this.productItem,
      this.mainItem,
      this.subItem,
      this.showMain,
      this.showSub});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || orderW != null) {
      map['order_w'] = Variable<int>(orderW);
    }
    if (!nullToAbsent || productW != null) {
      map['product_w'] = Variable<int>(productW);
    }
    if (!nullToAbsent || subW != null) {
      map['sub_w'] = Variable<int>(subW);
    }
    if (!nullToAbsent || mainW != null) {
      map['main_w'] = Variable<int>(mainW);
    }
    if (!nullToAbsent || productItem != null) {
      map['product_item'] = Variable<int>(productItem);
    }
    if (!nullToAbsent || mainItem != null) {
      map['main_item'] = Variable<int>(mainItem);
    }
    if (!nullToAbsent || subItem != null) {
      map['sub_item'] = Variable<int>(subItem);
    }
    if (!nullToAbsent || showMain != null) {
      map['show_main'] = Variable<bool>(showMain);
    }
    if (!nullToAbsent || showSub != null) {
      map['show_sub'] = Variable<bool>(showSub);
    }
    return map;
  }

  PosSettingCompanion toCompanion(bool nullToAbsent) {
    return PosSettingCompanion(
      id: Value(id),
      orderW:
          orderW == null && nullToAbsent ? const Value.absent() : Value(orderW),
      productW: productW == null && nullToAbsent
          ? const Value.absent()
          : Value(productW),
      subW: subW == null && nullToAbsent ? const Value.absent() : Value(subW),
      mainW:
          mainW == null && nullToAbsent ? const Value.absent() : Value(mainW),
      productItem: productItem == null && nullToAbsent
          ? const Value.absent()
          : Value(productItem),
      mainItem: mainItem == null && nullToAbsent
          ? const Value.absent()
          : Value(mainItem),
      subItem: subItem == null && nullToAbsent
          ? const Value.absent()
          : Value(subItem),
      showMain: showMain == null && nullToAbsent
          ? const Value.absent()
          : Value(showMain),
      showSub: showSub == null && nullToAbsent
          ? const Value.absent()
          : Value(showSub),
    );
  }

  factory PosSettingData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PosSettingData(
      id: serializer.fromJson<int>(json['id']),
      orderW: serializer.fromJson<int?>(json['orderW']),
      productW: serializer.fromJson<int?>(json['productW']),
      subW: serializer.fromJson<int?>(json['subW']),
      mainW: serializer.fromJson<int?>(json['mainW']),
      productItem: serializer.fromJson<int?>(json['productItem']),
      mainItem: serializer.fromJson<int?>(json['mainItem']),
      subItem: serializer.fromJson<int?>(json['subItem']),
      showMain: serializer.fromJson<bool?>(json['showMain']),
      showSub: serializer.fromJson<bool?>(json['showSub']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'orderW': serializer.toJson<int?>(orderW),
      'productW': serializer.toJson<int?>(productW),
      'subW': serializer.toJson<int?>(subW),
      'mainW': serializer.toJson<int?>(mainW),
      'productItem': serializer.toJson<int?>(productItem),
      'mainItem': serializer.toJson<int?>(mainItem),
      'subItem': serializer.toJson<int?>(subItem),
      'showMain': serializer.toJson<bool?>(showMain),
      'showSub': serializer.toJson<bool?>(showSub),
    };
  }

  PosSettingData copyWith(
          {int? id,
          Value<int?> orderW = const Value.absent(),
          Value<int?> productW = const Value.absent(),
          Value<int?> subW = const Value.absent(),
          Value<int?> mainW = const Value.absent(),
          Value<int?> productItem = const Value.absent(),
          Value<int?> mainItem = const Value.absent(),
          Value<int?> subItem = const Value.absent(),
          Value<bool?> showMain = const Value.absent(),
          Value<bool?> showSub = const Value.absent()}) =>
      PosSettingData(
        id: id ?? this.id,
        orderW: orderW.present ? orderW.value : this.orderW,
        productW: productW.present ? productW.value : this.productW,
        subW: subW.present ? subW.value : this.subW,
        mainW: mainW.present ? mainW.value : this.mainW,
        productItem: productItem.present ? productItem.value : this.productItem,
        mainItem: mainItem.present ? mainItem.value : this.mainItem,
        subItem: subItem.present ? subItem.value : this.subItem,
        showMain: showMain.present ? showMain.value : this.showMain,
        showSub: showSub.present ? showSub.value : this.showSub,
      );
  @override
  String toString() {
    return (StringBuffer('PosSettingData(')
          ..write('id: $id, ')
          ..write('orderW: $orderW, ')
          ..write('productW: $productW, ')
          ..write('subW: $subW, ')
          ..write('mainW: $mainW, ')
          ..write('productItem: $productItem, ')
          ..write('mainItem: $mainItem, ')
          ..write('subItem: $subItem, ')
          ..write('showMain: $showMain, ')
          ..write('showSub: $showSub')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, orderW, productW, subW, mainW,
      productItem, mainItem, subItem, showMain, showSub);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PosSettingData &&
          other.id == this.id &&
          other.orderW == this.orderW &&
          other.productW == this.productW &&
          other.subW == this.subW &&
          other.mainW == this.mainW &&
          other.productItem == this.productItem &&
          other.mainItem == this.mainItem &&
          other.subItem == this.subItem &&
          other.showMain == this.showMain &&
          other.showSub == this.showSub);
}

class PosSettingCompanion extends UpdateCompanion<PosSettingData> {
  final Value<int> id;
  final Value<int?> orderW;
  final Value<int?> productW;
  final Value<int?> subW;
  final Value<int?> mainW;
  final Value<int?> productItem;
  final Value<int?> mainItem;
  final Value<int?> subItem;
  final Value<bool?> showMain;
  final Value<bool?> showSub;
  const PosSettingCompanion({
    this.id = const Value.absent(),
    this.orderW = const Value.absent(),
    this.productW = const Value.absent(),
    this.subW = const Value.absent(),
    this.mainW = const Value.absent(),
    this.productItem = const Value.absent(),
    this.mainItem = const Value.absent(),
    this.subItem = const Value.absent(),
    this.showMain = const Value.absent(),
    this.showSub = const Value.absent(),
  });
  PosSettingCompanion.insert({
    this.id = const Value.absent(),
    this.orderW = const Value.absent(),
    this.productW = const Value.absent(),
    this.subW = const Value.absent(),
    this.mainW = const Value.absent(),
    this.productItem = const Value.absent(),
    this.mainItem = const Value.absent(),
    this.subItem = const Value.absent(),
    this.showMain = const Value.absent(),
    this.showSub = const Value.absent(),
  });
  static Insertable<PosSettingData> custom({
    Expression<int>? id,
    Expression<int>? orderW,
    Expression<int>? productW,
    Expression<int>? subW,
    Expression<int>? mainW,
    Expression<int>? productItem,
    Expression<int>? mainItem,
    Expression<int>? subItem,
    Expression<bool>? showMain,
    Expression<bool>? showSub,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orderW != null) 'order_w': orderW,
      if (productW != null) 'product_w': productW,
      if (subW != null) 'sub_w': subW,
      if (mainW != null) 'main_w': mainW,
      if (productItem != null) 'product_item': productItem,
      if (mainItem != null) 'main_item': mainItem,
      if (subItem != null) 'sub_item': subItem,
      if (showMain != null) 'show_main': showMain,
      if (showSub != null) 'show_sub': showSub,
    });
  }

  PosSettingCompanion copyWith(
      {Value<int>? id,
      Value<int?>? orderW,
      Value<int?>? productW,
      Value<int?>? subW,
      Value<int?>? mainW,
      Value<int?>? productItem,
      Value<int?>? mainItem,
      Value<int?>? subItem,
      Value<bool?>? showMain,
      Value<bool?>? showSub}) {
    return PosSettingCompanion(
      id: id ?? this.id,
      orderW: orderW ?? this.orderW,
      productW: productW ?? this.productW,
      subW: subW ?? this.subW,
      mainW: mainW ?? this.mainW,
      productItem: productItem ?? this.productItem,
      mainItem: mainItem ?? this.mainItem,
      subItem: subItem ?? this.subItem,
      showMain: showMain ?? this.showMain,
      showSub: showSub ?? this.showSub,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (orderW.present) {
      map['order_w'] = Variable<int>(orderW.value);
    }
    if (productW.present) {
      map['product_w'] = Variable<int>(productW.value);
    }
    if (subW.present) {
      map['sub_w'] = Variable<int>(subW.value);
    }
    if (mainW.present) {
      map['main_w'] = Variable<int>(mainW.value);
    }
    if (productItem.present) {
      map['product_item'] = Variable<int>(productItem.value);
    }
    if (mainItem.present) {
      map['main_item'] = Variable<int>(mainItem.value);
    }
    if (subItem.present) {
      map['sub_item'] = Variable<int>(subItem.value);
    }
    if (showMain.present) {
      map['show_main'] = Variable<bool>(showMain.value);
    }
    if (showSub.present) {
      map['show_sub'] = Variable<bool>(showSub.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PosSettingCompanion(')
          ..write('id: $id, ')
          ..write('orderW: $orderW, ')
          ..write('productW: $productW, ')
          ..write('subW: $subW, ')
          ..write('mainW: $mainW, ')
          ..write('productItem: $productItem, ')
          ..write('mainItem: $mainItem, ')
          ..write('subItem: $subItem, ')
          ..write('showMain: $showMain, ')
          ..write('showSub: $showSub')
          ..write(')'))
        .toString();
  }
}

class $PrinterEntityTable extends PrinterEntity
    with TableInfo<$PrinterEntityTable, PrinterEntityData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PrinterEntityTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _printerTypeMeta =
      const VerificationMeta('printerType');
  @override
  late final GeneratedColumn<String> printerType = GeneratedColumn<String>(
      'printer_type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _printerNameMeta =
      const VerificationMeta('printerName');
  @override
  late final GeneratedColumn<String> printerName = GeneratedColumn<String>(
      'printer_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, printerType, printerName, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'printer_entity';
  @override
  VerificationContext validateIntegrity(Insertable<PrinterEntityData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('printer_type')) {
      context.handle(
          _printerTypeMeta,
          printerType.isAcceptableOrUnknown(
              data['printer_type']!, _printerTypeMeta));
    }
    if (data.containsKey('printer_name')) {
      context.handle(
          _printerNameMeta,
          printerName.isAcceptableOrUnknown(
              data['printer_name']!, _printerNameMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PrinterEntityData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PrinterEntityData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      printerType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}printer_type']),
      printerName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}printer_name']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $PrinterEntityTable createAlias(String alias) {
    return $PrinterEntityTable(attachedDatabase, alias);
  }
}

class PrinterEntityData extends DataClass
    implements Insertable<PrinterEntityData> {
  final int id;
  final String? printerType;
  final String? printerName;
  final DateTime createdAt;
  const PrinterEntityData(
      {required this.id,
      this.printerType,
      this.printerName,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || printerType != null) {
      map['printer_type'] = Variable<String>(printerType);
    }
    if (!nullToAbsent || printerName != null) {
      map['printer_name'] = Variable<String>(printerName);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PrinterEntityCompanion toCompanion(bool nullToAbsent) {
    return PrinterEntityCompanion(
      id: Value(id),
      printerType: printerType == null && nullToAbsent
          ? const Value.absent()
          : Value(printerType),
      printerName: printerName == null && nullToAbsent
          ? const Value.absent()
          : Value(printerName),
      createdAt: Value(createdAt),
    );
  }

  factory PrinterEntityData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PrinterEntityData(
      id: serializer.fromJson<int>(json['id']),
      printerType: serializer.fromJson<String?>(json['printerType']),
      printerName: serializer.fromJson<String?>(json['printerName']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'printerType': serializer.toJson<String?>(printerType),
      'printerName': serializer.toJson<String?>(printerName),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PrinterEntityData copyWith(
          {int? id,
          Value<String?> printerType = const Value.absent(),
          Value<String?> printerName = const Value.absent(),
          DateTime? createdAt}) =>
      PrinterEntityData(
        id: id ?? this.id,
        printerType: printerType.present ? printerType.value : this.printerType,
        printerName: printerName.present ? printerName.value : this.printerName,
        createdAt: createdAt ?? this.createdAt,
      );
  @override
  String toString() {
    return (StringBuffer('PrinterEntityData(')
          ..write('id: $id, ')
          ..write('printerType: $printerType, ')
          ..write('printerName: $printerName, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, printerType, printerName, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PrinterEntityData &&
          other.id == this.id &&
          other.printerType == this.printerType &&
          other.printerName == this.printerName &&
          other.createdAt == this.createdAt);
}

class PrinterEntityCompanion extends UpdateCompanion<PrinterEntityData> {
  final Value<int> id;
  final Value<String?> printerType;
  final Value<String?> printerName;
  final Value<DateTime> createdAt;
  const PrinterEntityCompanion({
    this.id = const Value.absent(),
    this.printerType = const Value.absent(),
    this.printerName = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PrinterEntityCompanion.insert({
    this.id = const Value.absent(),
    this.printerType = const Value.absent(),
    this.printerName = const Value.absent(),
    required DateTime createdAt,
  }) : createdAt = Value(createdAt);
  static Insertable<PrinterEntityData> custom({
    Expression<int>? id,
    Expression<String>? printerType,
    Expression<String>? printerName,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (printerType != null) 'printer_type': printerType,
      if (printerName != null) 'printer_name': printerName,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PrinterEntityCompanion copyWith(
      {Value<int>? id,
      Value<String?>? printerType,
      Value<String?>? printerName,
      Value<DateTime>? createdAt}) {
    return PrinterEntityCompanion(
      id: id ?? this.id,
      printerType: printerType ?? this.printerType,
      printerName: printerName ?? this.printerName,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (printerType.present) {
      map['printer_type'] = Variable<String>(printerType.value);
    }
    if (printerName.present) {
      map['printer_name'] = Variable<String>(printerName.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PrinterEntityCompanion(')
          ..write('id: $id, ')
          ..write('printerType: $printerType, ')
          ..write('printerName: $printerName, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $PrinterSettingEntityTable extends PrinterSettingEntity
    with TableInfo<$PrinterSettingEntityTable, PrinterSettingEntityData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PrinterSettingEntityTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _billPrinterMeta =
      const VerificationMeta('billPrinter');
  @override
  late final GeneratedColumn<int> billPrinter = GeneratedColumn<int>(
      'bill_printer', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _reportPrinterMeta =
      const VerificationMeta('reportPrinter');
  @override
  late final GeneratedColumn<int> reportPrinter = GeneratedColumn<int>(
      'report_printer', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _fontSizeMeta =
      const VerificationMeta('fontSize');
  @override
  late final GeneratedColumn<double> fontSize = GeneratedColumn<double>(
      'font_size', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _isFullOrderMeta =
      const VerificationMeta('isFullOrder');
  @override
  late final GeneratedColumn<bool> isFullOrder = GeneratedColumn<bool>(
      'is_full_order', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_full_order" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _showUnitMeta =
      const VerificationMeta('showUnit');
  @override
  late final GeneratedColumn<bool> showUnit = GeneratedColumn<bool>(
      'show_unit', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("show_unit" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _showVatMeta =
      const VerificationMeta('showVat');
  @override
  late final GeneratedColumn<bool> showVat = GeneratedColumn<bool>(
      'show_vat', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("show_vat" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _showProductDescriptionMeta =
      const VerificationMeta('showProductDescription');
  @override
  late final GeneratedColumn<bool> showProductDescription =
      GeneratedColumn<bool>('show_product_description', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'CHECK ("show_product_description" IN (0, 1))'),
          defaultValue: const Constant(false));
  static const VerificationMeta _tailPrintMeta =
      const VerificationMeta('tailPrint');
  @override
  late final GeneratedColumn<String> tailPrint = GeneratedColumn<String>(
      'tail_print', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _headerPrintMeta =
      const VerificationMeta('headerPrint');
  @override
  late final GeneratedColumn<String> headerPrint = GeneratedColumn<String>(
      'header_print', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        billPrinter,
        reportPrinter,
        fontSize,
        isFullOrder,
        showUnit,
        showVat,
        showProductDescription,
        tailPrint,
        headerPrint
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'printer_setting_entity';
  @override
  VerificationContext validateIntegrity(
      Insertable<PrinterSettingEntityData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('bill_printer')) {
      context.handle(
          _billPrinterMeta,
          billPrinter.isAcceptableOrUnknown(
              data['bill_printer']!, _billPrinterMeta));
    }
    if (data.containsKey('report_printer')) {
      context.handle(
          _reportPrinterMeta,
          reportPrinter.isAcceptableOrUnknown(
              data['report_printer']!, _reportPrinterMeta));
    }
    if (data.containsKey('font_size')) {
      context.handle(_fontSizeMeta,
          fontSize.isAcceptableOrUnknown(data['font_size']!, _fontSizeMeta));
    }
    if (data.containsKey('is_full_order')) {
      context.handle(
          _isFullOrderMeta,
          isFullOrder.isAcceptableOrUnknown(
              data['is_full_order']!, _isFullOrderMeta));
    }
    if (data.containsKey('show_unit')) {
      context.handle(_showUnitMeta,
          showUnit.isAcceptableOrUnknown(data['show_unit']!, _showUnitMeta));
    }
    if (data.containsKey('show_vat')) {
      context.handle(_showVatMeta,
          showVat.isAcceptableOrUnknown(data['show_vat']!, _showVatMeta));
    }
    if (data.containsKey('show_product_description')) {
      context.handle(
          _showProductDescriptionMeta,
          showProductDescription.isAcceptableOrUnknown(
              data['show_product_description']!, _showProductDescriptionMeta));
    }
    if (data.containsKey('tail_print')) {
      context.handle(_tailPrintMeta,
          tailPrint.isAcceptableOrUnknown(data['tail_print']!, _tailPrintMeta));
    }
    if (data.containsKey('header_print')) {
      context.handle(
          _headerPrintMeta,
          headerPrint.isAcceptableOrUnknown(
              data['header_print']!, _headerPrintMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PrinterSettingEntityData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PrinterSettingEntityData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      billPrinter: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bill_printer']),
      reportPrinter: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}report_printer']),
      fontSize: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}font_size']),
      isFullOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_full_order'])!,
      showUnit: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}show_unit'])!,
      showVat: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}show_vat'])!,
      showProductDescription: attachedDatabase.typeMapping.read(
          DriftSqlType.bool,
          data['${effectivePrefix}show_product_description'])!,
      tailPrint: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tail_print']),
      headerPrint: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}header_print']),
    );
  }

  @override
  $PrinterSettingEntityTable createAlias(String alias) {
    return $PrinterSettingEntityTable(attachedDatabase, alias);
  }
}

class PrinterSettingEntityData extends DataClass
    implements Insertable<PrinterSettingEntityData> {
  final int id;
  final int? billPrinter;
  final int? reportPrinter;
  final double? fontSize;
  final bool isFullOrder;
  final bool showUnit;
  final bool showVat;
  final bool showProductDescription;
  final String? tailPrint;
  final String? headerPrint;
  const PrinterSettingEntityData(
      {required this.id,
      this.billPrinter,
      this.reportPrinter,
      this.fontSize,
      required this.isFullOrder,
      required this.showUnit,
      required this.showVat,
      required this.showProductDescription,
      this.tailPrint,
      this.headerPrint});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || billPrinter != null) {
      map['bill_printer'] = Variable<int>(billPrinter);
    }
    if (!nullToAbsent || reportPrinter != null) {
      map['report_printer'] = Variable<int>(reportPrinter);
    }
    if (!nullToAbsent || fontSize != null) {
      map['font_size'] = Variable<double>(fontSize);
    }
    map['is_full_order'] = Variable<bool>(isFullOrder);
    map['show_unit'] = Variable<bool>(showUnit);
    map['show_vat'] = Variable<bool>(showVat);
    map['show_product_description'] = Variable<bool>(showProductDescription);
    if (!nullToAbsent || tailPrint != null) {
      map['tail_print'] = Variable<String>(tailPrint);
    }
    if (!nullToAbsent || headerPrint != null) {
      map['header_print'] = Variable<String>(headerPrint);
    }
    return map;
  }

  PrinterSettingEntityCompanion toCompanion(bool nullToAbsent) {
    return PrinterSettingEntityCompanion(
      id: Value(id),
      billPrinter: billPrinter == null && nullToAbsent
          ? const Value.absent()
          : Value(billPrinter),
      reportPrinter: reportPrinter == null && nullToAbsent
          ? const Value.absent()
          : Value(reportPrinter),
      fontSize: fontSize == null && nullToAbsent
          ? const Value.absent()
          : Value(fontSize),
      isFullOrder: Value(isFullOrder),
      showUnit: Value(showUnit),
      showVat: Value(showVat),
      showProductDescription: Value(showProductDescription),
      tailPrint: tailPrint == null && nullToAbsent
          ? const Value.absent()
          : Value(tailPrint),
      headerPrint: headerPrint == null && nullToAbsent
          ? const Value.absent()
          : Value(headerPrint),
    );
  }

  factory PrinterSettingEntityData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PrinterSettingEntityData(
      id: serializer.fromJson<int>(json['id']),
      billPrinter: serializer.fromJson<int?>(json['billPrinter']),
      reportPrinter: serializer.fromJson<int?>(json['reportPrinter']),
      fontSize: serializer.fromJson<double?>(json['fontSize']),
      isFullOrder: serializer.fromJson<bool>(json['isFullOrder']),
      showUnit: serializer.fromJson<bool>(json['showUnit']),
      showVat: serializer.fromJson<bool>(json['showVat']),
      showProductDescription:
          serializer.fromJson<bool>(json['showProductDescription']),
      tailPrint: serializer.fromJson<String?>(json['tailPrint']),
      headerPrint: serializer.fromJson<String?>(json['headerPrint']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'billPrinter': serializer.toJson<int?>(billPrinter),
      'reportPrinter': serializer.toJson<int?>(reportPrinter),
      'fontSize': serializer.toJson<double?>(fontSize),
      'isFullOrder': serializer.toJson<bool>(isFullOrder),
      'showUnit': serializer.toJson<bool>(showUnit),
      'showVat': serializer.toJson<bool>(showVat),
      'showProductDescription': serializer.toJson<bool>(showProductDescription),
      'tailPrint': serializer.toJson<String?>(tailPrint),
      'headerPrint': serializer.toJson<String?>(headerPrint),
    };
  }

  PrinterSettingEntityData copyWith(
          {int? id,
          Value<int?> billPrinter = const Value.absent(),
          Value<int?> reportPrinter = const Value.absent(),
          Value<double?> fontSize = const Value.absent(),
          bool? isFullOrder,
          bool? showUnit,
          bool? showVat,
          bool? showProductDescription,
          Value<String?> tailPrint = const Value.absent(),
          Value<String?> headerPrint = const Value.absent()}) =>
      PrinterSettingEntityData(
        id: id ?? this.id,
        billPrinter: billPrinter.present ? billPrinter.value : this.billPrinter,
        reportPrinter:
            reportPrinter.present ? reportPrinter.value : this.reportPrinter,
        fontSize: fontSize.present ? fontSize.value : this.fontSize,
        isFullOrder: isFullOrder ?? this.isFullOrder,
        showUnit: showUnit ?? this.showUnit,
        showVat: showVat ?? this.showVat,
        showProductDescription:
            showProductDescription ?? this.showProductDescription,
        tailPrint: tailPrint.present ? tailPrint.value : this.tailPrint,
        headerPrint: headerPrint.present ? headerPrint.value : this.headerPrint,
      );
  @override
  String toString() {
    return (StringBuffer('PrinterSettingEntityData(')
          ..write('id: $id, ')
          ..write('billPrinter: $billPrinter, ')
          ..write('reportPrinter: $reportPrinter, ')
          ..write('fontSize: $fontSize, ')
          ..write('isFullOrder: $isFullOrder, ')
          ..write('showUnit: $showUnit, ')
          ..write('showVat: $showVat, ')
          ..write('showProductDescription: $showProductDescription, ')
          ..write('tailPrint: $tailPrint, ')
          ..write('headerPrint: $headerPrint')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      billPrinter,
      reportPrinter,
      fontSize,
      isFullOrder,
      showUnit,
      showVat,
      showProductDescription,
      tailPrint,
      headerPrint);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PrinterSettingEntityData &&
          other.id == this.id &&
          other.billPrinter == this.billPrinter &&
          other.reportPrinter == this.reportPrinter &&
          other.fontSize == this.fontSize &&
          other.isFullOrder == this.isFullOrder &&
          other.showUnit == this.showUnit &&
          other.showVat == this.showVat &&
          other.showProductDescription == this.showProductDescription &&
          other.tailPrint == this.tailPrint &&
          other.headerPrint == this.headerPrint);
}

class PrinterSettingEntityCompanion
    extends UpdateCompanion<PrinterSettingEntityData> {
  final Value<int> id;
  final Value<int?> billPrinter;
  final Value<int?> reportPrinter;
  final Value<double?> fontSize;
  final Value<bool> isFullOrder;
  final Value<bool> showUnit;
  final Value<bool> showVat;
  final Value<bool> showProductDescription;
  final Value<String?> tailPrint;
  final Value<String?> headerPrint;
  const PrinterSettingEntityCompanion({
    this.id = const Value.absent(),
    this.billPrinter = const Value.absent(),
    this.reportPrinter = const Value.absent(),
    this.fontSize = const Value.absent(),
    this.isFullOrder = const Value.absent(),
    this.showUnit = const Value.absent(),
    this.showVat = const Value.absent(),
    this.showProductDescription = const Value.absent(),
    this.tailPrint = const Value.absent(),
    this.headerPrint = const Value.absent(),
  });
  PrinterSettingEntityCompanion.insert({
    this.id = const Value.absent(),
    this.billPrinter = const Value.absent(),
    this.reportPrinter = const Value.absent(),
    this.fontSize = const Value.absent(),
    this.isFullOrder = const Value.absent(),
    this.showUnit = const Value.absent(),
    this.showVat = const Value.absent(),
    this.showProductDescription = const Value.absent(),
    this.tailPrint = const Value.absent(),
    this.headerPrint = const Value.absent(),
  });
  static Insertable<PrinterSettingEntityData> custom({
    Expression<int>? id,
    Expression<int>? billPrinter,
    Expression<int>? reportPrinter,
    Expression<double>? fontSize,
    Expression<bool>? isFullOrder,
    Expression<bool>? showUnit,
    Expression<bool>? showVat,
    Expression<bool>? showProductDescription,
    Expression<String>? tailPrint,
    Expression<String>? headerPrint,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (billPrinter != null) 'bill_printer': billPrinter,
      if (reportPrinter != null) 'report_printer': reportPrinter,
      if (fontSize != null) 'font_size': fontSize,
      if (isFullOrder != null) 'is_full_order': isFullOrder,
      if (showUnit != null) 'show_unit': showUnit,
      if (showVat != null) 'show_vat': showVat,
      if (showProductDescription != null)
        'show_product_description': showProductDescription,
      if (tailPrint != null) 'tail_print': tailPrint,
      if (headerPrint != null) 'header_print': headerPrint,
    });
  }

  PrinterSettingEntityCompanion copyWith(
      {Value<int>? id,
      Value<int?>? billPrinter,
      Value<int?>? reportPrinter,
      Value<double?>? fontSize,
      Value<bool>? isFullOrder,
      Value<bool>? showUnit,
      Value<bool>? showVat,
      Value<bool>? showProductDescription,
      Value<String?>? tailPrint,
      Value<String?>? headerPrint}) {
    return PrinterSettingEntityCompanion(
      id: id ?? this.id,
      billPrinter: billPrinter ?? this.billPrinter,
      reportPrinter: reportPrinter ?? this.reportPrinter,
      fontSize: fontSize ?? this.fontSize,
      isFullOrder: isFullOrder ?? this.isFullOrder,
      showUnit: showUnit ?? this.showUnit,
      showVat: showVat ?? this.showVat,
      showProductDescription:
          showProductDescription ?? this.showProductDescription,
      tailPrint: tailPrint ?? this.tailPrint,
      headerPrint: headerPrint ?? this.headerPrint,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (billPrinter.present) {
      map['bill_printer'] = Variable<int>(billPrinter.value);
    }
    if (reportPrinter.present) {
      map['report_printer'] = Variable<int>(reportPrinter.value);
    }
    if (fontSize.present) {
      map['font_size'] = Variable<double>(fontSize.value);
    }
    if (isFullOrder.present) {
      map['is_full_order'] = Variable<bool>(isFullOrder.value);
    }
    if (showUnit.present) {
      map['show_unit'] = Variable<bool>(showUnit.value);
    }
    if (showVat.present) {
      map['show_vat'] = Variable<bool>(showVat.value);
    }
    if (showProductDescription.present) {
      map['show_product_description'] =
          Variable<bool>(showProductDescription.value);
    }
    if (tailPrint.present) {
      map['tail_print'] = Variable<String>(tailPrint.value);
    }
    if (headerPrint.present) {
      map['header_print'] = Variable<String>(headerPrint.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PrinterSettingEntityCompanion(')
          ..write('id: $id, ')
          ..write('billPrinter: $billPrinter, ')
          ..write('reportPrinter: $reportPrinter, ')
          ..write('fontSize: $fontSize, ')
          ..write('isFullOrder: $isFullOrder, ')
          ..write('showUnit: $showUnit, ')
          ..write('showVat: $showVat, ')
          ..write('showProductDescription: $showProductDescription, ')
          ..write('tailPrint: $tailPrint, ')
          ..write('headerPrint: $headerPrint')
          ..write(')'))
        .toString();
  }
}

class $CloseBoxSettingTable extends CloseBoxSetting
    with TableInfo<$CloseBoxSettingTable, CloseBoxSettingData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CloseBoxSettingTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _show1000Meta =
      const VerificationMeta('show1000');
  @override
  late final GeneratedColumn<bool> show1000 = GeneratedColumn<bool>(
      'show1000', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("show1000" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _show500Meta =
      const VerificationMeta('show500');
  @override
  late final GeneratedColumn<bool> show500 = GeneratedColumn<bool>(
      'show500', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("show500" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _show200Meta =
      const VerificationMeta('show200');
  @override
  late final GeneratedColumn<bool> show200 = GeneratedColumn<bool>(
      'show200', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("show200" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _show100Meta =
      const VerificationMeta('show100');
  @override
  late final GeneratedColumn<bool> show100 = GeneratedColumn<bool>(
      'show100', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("show100" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _show50Meta = const VerificationMeta('show50');
  @override
  late final GeneratedColumn<bool> show50 = GeneratedColumn<bool>(
      'show50', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("show50" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _show20Meta = const VerificationMeta('show20');
  @override
  late final GeneratedColumn<bool> show20 = GeneratedColumn<bool>(
      'show20', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("show20" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _show10Meta = const VerificationMeta('show10');
  @override
  late final GeneratedColumn<bool> show10 = GeneratedColumn<bool>(
      'show10', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("show10" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _show5Meta = const VerificationMeta('show5');
  @override
  late final GeneratedColumn<bool> show5 = GeneratedColumn<bool>(
      'show5', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("show5" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _show2Meta = const VerificationMeta('show2');
  @override
  late final GeneratedColumn<bool> show2 = GeneratedColumn<bool>(
      'show2', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("show2" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _show1Meta = const VerificationMeta('show1');
  @override
  late final GeneratedColumn<bool> show1 = GeneratedColumn<bool>(
      'show1', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("show1" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _show050Meta =
      const VerificationMeta('show050');
  @override
  late final GeneratedColumn<bool> show050 = GeneratedColumn<bool>(
      'show050', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("show050" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _show025Meta =
      const VerificationMeta('show025');
  @override
  late final GeneratedColumn<bool> show025 = GeneratedColumn<bool>(
      'show025', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("show025" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _show010Meta =
      const VerificationMeta('show010');
  @override
  late final GeneratedColumn<bool> show010 = GeneratedColumn<bool>(
      'show010', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("show010" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _show005Meta =
      const VerificationMeta('show005');
  @override
  late final GeneratedColumn<bool> show005 = GeneratedColumn<bool>(
      'show005', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("show005" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _show001Meta =
      const VerificationMeta('show001');
  @override
  late final GeneratedColumn<bool> show001 = GeneratedColumn<bool>(
      'show001', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("show001" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createAtMeta =
      const VerificationMeta('createAt');
  @override
  late final GeneratedColumn<DateTime> createAt = GeneratedColumn<DateTime>(
      'create_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        show1000,
        show500,
        show200,
        show100,
        show50,
        show20,
        show10,
        show5,
        show2,
        show1,
        show050,
        show025,
        show010,
        show005,
        show001,
        createAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'close_box_setting';
  @override
  VerificationContext validateIntegrity(
      Insertable<CloseBoxSettingData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('show1000')) {
      context.handle(_show1000Meta,
          show1000.isAcceptableOrUnknown(data['show1000']!, _show1000Meta));
    }
    if (data.containsKey('show500')) {
      context.handle(_show500Meta,
          show500.isAcceptableOrUnknown(data['show500']!, _show500Meta));
    }
    if (data.containsKey('show200')) {
      context.handle(_show200Meta,
          show200.isAcceptableOrUnknown(data['show200']!, _show200Meta));
    }
    if (data.containsKey('show100')) {
      context.handle(_show100Meta,
          show100.isAcceptableOrUnknown(data['show100']!, _show100Meta));
    }
    if (data.containsKey('show50')) {
      context.handle(_show50Meta,
          show50.isAcceptableOrUnknown(data['show50']!, _show50Meta));
    }
    if (data.containsKey('show20')) {
      context.handle(_show20Meta,
          show20.isAcceptableOrUnknown(data['show20']!, _show20Meta));
    }
    if (data.containsKey('show10')) {
      context.handle(_show10Meta,
          show10.isAcceptableOrUnknown(data['show10']!, _show10Meta));
    }
    if (data.containsKey('show5')) {
      context.handle(
          _show5Meta, show5.isAcceptableOrUnknown(data['show5']!, _show5Meta));
    }
    if (data.containsKey('show2')) {
      context.handle(
          _show2Meta, show2.isAcceptableOrUnknown(data['show2']!, _show2Meta));
    }
    if (data.containsKey('show1')) {
      context.handle(
          _show1Meta, show1.isAcceptableOrUnknown(data['show1']!, _show1Meta));
    }
    if (data.containsKey('show050')) {
      context.handle(_show050Meta,
          show050.isAcceptableOrUnknown(data['show050']!, _show050Meta));
    }
    if (data.containsKey('show025')) {
      context.handle(_show025Meta,
          show025.isAcceptableOrUnknown(data['show025']!, _show025Meta));
    }
    if (data.containsKey('show010')) {
      context.handle(_show010Meta,
          show010.isAcceptableOrUnknown(data['show010']!, _show010Meta));
    }
    if (data.containsKey('show005')) {
      context.handle(_show005Meta,
          show005.isAcceptableOrUnknown(data['show005']!, _show005Meta));
    }
    if (data.containsKey('show001')) {
      context.handle(_show001Meta,
          show001.isAcceptableOrUnknown(data['show001']!, _show001Meta));
    }
    if (data.containsKey('create_at')) {
      context.handle(_createAtMeta,
          createAt.isAcceptableOrUnknown(data['create_at']!, _createAtMeta));
    } else if (isInserting) {
      context.missing(_createAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CloseBoxSettingData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CloseBoxSettingData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      show1000: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}show1000'])!,
      show500: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}show500'])!,
      show200: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}show200'])!,
      show100: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}show100'])!,
      show50: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}show50'])!,
      show20: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}show20'])!,
      show10: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}show10'])!,
      show5: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}show5'])!,
      show2: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}show2'])!,
      show1: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}show1'])!,
      show050: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}show050'])!,
      show025: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}show025'])!,
      show010: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}show010'])!,
      show005: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}show005'])!,
      show001: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}show001'])!,
      createAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}create_at'])!,
    );
  }

  @override
  $CloseBoxSettingTable createAlias(String alias) {
    return $CloseBoxSettingTable(attachedDatabase, alias);
  }
}

class CloseBoxSettingData extends DataClass
    implements Insertable<CloseBoxSettingData> {
  final int id;
  final bool show1000;
  final bool show500;
  final bool show200;
  final bool show100;
  final bool show50;
  final bool show20;
  final bool show10;
  final bool show5;
  final bool show2;
  final bool show1;
  final bool show050;
  final bool show025;
  final bool show010;
  final bool show005;
  final bool show001;
  final DateTime createAt;
  const CloseBoxSettingData(
      {required this.id,
      required this.show1000,
      required this.show500,
      required this.show200,
      required this.show100,
      required this.show50,
      required this.show20,
      required this.show10,
      required this.show5,
      required this.show2,
      required this.show1,
      required this.show050,
      required this.show025,
      required this.show010,
      required this.show005,
      required this.show001,
      required this.createAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['show1000'] = Variable<bool>(show1000);
    map['show500'] = Variable<bool>(show500);
    map['show200'] = Variable<bool>(show200);
    map['show100'] = Variable<bool>(show100);
    map['show50'] = Variable<bool>(show50);
    map['show20'] = Variable<bool>(show20);
    map['show10'] = Variable<bool>(show10);
    map['show5'] = Variable<bool>(show5);
    map['show2'] = Variable<bool>(show2);
    map['show1'] = Variable<bool>(show1);
    map['show050'] = Variable<bool>(show050);
    map['show025'] = Variable<bool>(show025);
    map['show010'] = Variable<bool>(show010);
    map['show005'] = Variable<bool>(show005);
    map['show001'] = Variable<bool>(show001);
    map['create_at'] = Variable<DateTime>(createAt);
    return map;
  }

  CloseBoxSettingCompanion toCompanion(bool nullToAbsent) {
    return CloseBoxSettingCompanion(
      id: Value(id),
      show1000: Value(show1000),
      show500: Value(show500),
      show200: Value(show200),
      show100: Value(show100),
      show50: Value(show50),
      show20: Value(show20),
      show10: Value(show10),
      show5: Value(show5),
      show2: Value(show2),
      show1: Value(show1),
      show050: Value(show050),
      show025: Value(show025),
      show010: Value(show010),
      show005: Value(show005),
      show001: Value(show001),
      createAt: Value(createAt),
    );
  }

  factory CloseBoxSettingData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CloseBoxSettingData(
      id: serializer.fromJson<int>(json['id']),
      show1000: serializer.fromJson<bool>(json['show1000']),
      show500: serializer.fromJson<bool>(json['show500']),
      show200: serializer.fromJson<bool>(json['show200']),
      show100: serializer.fromJson<bool>(json['show100']),
      show50: serializer.fromJson<bool>(json['show50']),
      show20: serializer.fromJson<bool>(json['show20']),
      show10: serializer.fromJson<bool>(json['show10']),
      show5: serializer.fromJson<bool>(json['show5']),
      show2: serializer.fromJson<bool>(json['show2']),
      show1: serializer.fromJson<bool>(json['show1']),
      show050: serializer.fromJson<bool>(json['show050']),
      show025: serializer.fromJson<bool>(json['show025']),
      show010: serializer.fromJson<bool>(json['show010']),
      show005: serializer.fromJson<bool>(json['show005']),
      show001: serializer.fromJson<bool>(json['show001']),
      createAt: serializer.fromJson<DateTime>(json['createAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'show1000': serializer.toJson<bool>(show1000),
      'show500': serializer.toJson<bool>(show500),
      'show200': serializer.toJson<bool>(show200),
      'show100': serializer.toJson<bool>(show100),
      'show50': serializer.toJson<bool>(show50),
      'show20': serializer.toJson<bool>(show20),
      'show10': serializer.toJson<bool>(show10),
      'show5': serializer.toJson<bool>(show5),
      'show2': serializer.toJson<bool>(show2),
      'show1': serializer.toJson<bool>(show1),
      'show050': serializer.toJson<bool>(show050),
      'show025': serializer.toJson<bool>(show025),
      'show010': serializer.toJson<bool>(show010),
      'show005': serializer.toJson<bool>(show005),
      'show001': serializer.toJson<bool>(show001),
      'createAt': serializer.toJson<DateTime>(createAt),
    };
  }

  CloseBoxSettingData copyWith(
          {int? id,
          bool? show1000,
          bool? show500,
          bool? show200,
          bool? show100,
          bool? show50,
          bool? show20,
          bool? show10,
          bool? show5,
          bool? show2,
          bool? show1,
          bool? show050,
          bool? show025,
          bool? show010,
          bool? show005,
          bool? show001,
          DateTime? createAt}) =>
      CloseBoxSettingData(
        id: id ?? this.id,
        show1000: show1000 ?? this.show1000,
        show500: show500 ?? this.show500,
        show200: show200 ?? this.show200,
        show100: show100 ?? this.show100,
        show50: show50 ?? this.show50,
        show20: show20 ?? this.show20,
        show10: show10 ?? this.show10,
        show5: show5 ?? this.show5,
        show2: show2 ?? this.show2,
        show1: show1 ?? this.show1,
        show050: show050 ?? this.show050,
        show025: show025 ?? this.show025,
        show010: show010 ?? this.show010,
        show005: show005 ?? this.show005,
        show001: show001 ?? this.show001,
        createAt: createAt ?? this.createAt,
      );
  @override
  String toString() {
    return (StringBuffer('CloseBoxSettingData(')
          ..write('id: $id, ')
          ..write('show1000: $show1000, ')
          ..write('show500: $show500, ')
          ..write('show200: $show200, ')
          ..write('show100: $show100, ')
          ..write('show50: $show50, ')
          ..write('show20: $show20, ')
          ..write('show10: $show10, ')
          ..write('show5: $show5, ')
          ..write('show2: $show2, ')
          ..write('show1: $show1, ')
          ..write('show050: $show050, ')
          ..write('show025: $show025, ')
          ..write('show010: $show010, ')
          ..write('show005: $show005, ')
          ..write('show001: $show001, ')
          ..write('createAt: $createAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      show1000,
      show500,
      show200,
      show100,
      show50,
      show20,
      show10,
      show5,
      show2,
      show1,
      show050,
      show025,
      show010,
      show005,
      show001,
      createAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CloseBoxSettingData &&
          other.id == this.id &&
          other.show1000 == this.show1000 &&
          other.show500 == this.show500 &&
          other.show200 == this.show200 &&
          other.show100 == this.show100 &&
          other.show50 == this.show50 &&
          other.show20 == this.show20 &&
          other.show10 == this.show10 &&
          other.show5 == this.show5 &&
          other.show2 == this.show2 &&
          other.show1 == this.show1 &&
          other.show050 == this.show050 &&
          other.show025 == this.show025 &&
          other.show010 == this.show010 &&
          other.show005 == this.show005 &&
          other.show001 == this.show001 &&
          other.createAt == this.createAt);
}

class CloseBoxSettingCompanion extends UpdateCompanion<CloseBoxSettingData> {
  final Value<int> id;
  final Value<bool> show1000;
  final Value<bool> show500;
  final Value<bool> show200;
  final Value<bool> show100;
  final Value<bool> show50;
  final Value<bool> show20;
  final Value<bool> show10;
  final Value<bool> show5;
  final Value<bool> show2;
  final Value<bool> show1;
  final Value<bool> show050;
  final Value<bool> show025;
  final Value<bool> show010;
  final Value<bool> show005;
  final Value<bool> show001;
  final Value<DateTime> createAt;
  const CloseBoxSettingCompanion({
    this.id = const Value.absent(),
    this.show1000 = const Value.absent(),
    this.show500 = const Value.absent(),
    this.show200 = const Value.absent(),
    this.show100 = const Value.absent(),
    this.show50 = const Value.absent(),
    this.show20 = const Value.absent(),
    this.show10 = const Value.absent(),
    this.show5 = const Value.absent(),
    this.show2 = const Value.absent(),
    this.show1 = const Value.absent(),
    this.show050 = const Value.absent(),
    this.show025 = const Value.absent(),
    this.show010 = const Value.absent(),
    this.show005 = const Value.absent(),
    this.show001 = const Value.absent(),
    this.createAt = const Value.absent(),
  });
  CloseBoxSettingCompanion.insert({
    this.id = const Value.absent(),
    this.show1000 = const Value.absent(),
    this.show500 = const Value.absent(),
    this.show200 = const Value.absent(),
    this.show100 = const Value.absent(),
    this.show50 = const Value.absent(),
    this.show20 = const Value.absent(),
    this.show10 = const Value.absent(),
    this.show5 = const Value.absent(),
    this.show2 = const Value.absent(),
    this.show1 = const Value.absent(),
    this.show050 = const Value.absent(),
    this.show025 = const Value.absent(),
    this.show010 = const Value.absent(),
    this.show005 = const Value.absent(),
    this.show001 = const Value.absent(),
    required DateTime createAt,
  }) : createAt = Value(createAt);
  static Insertable<CloseBoxSettingData> custom({
    Expression<int>? id,
    Expression<bool>? show1000,
    Expression<bool>? show500,
    Expression<bool>? show200,
    Expression<bool>? show100,
    Expression<bool>? show50,
    Expression<bool>? show20,
    Expression<bool>? show10,
    Expression<bool>? show5,
    Expression<bool>? show2,
    Expression<bool>? show1,
    Expression<bool>? show050,
    Expression<bool>? show025,
    Expression<bool>? show010,
    Expression<bool>? show005,
    Expression<bool>? show001,
    Expression<DateTime>? createAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (show1000 != null) 'show1000': show1000,
      if (show500 != null) 'show500': show500,
      if (show200 != null) 'show200': show200,
      if (show100 != null) 'show100': show100,
      if (show50 != null) 'show50': show50,
      if (show20 != null) 'show20': show20,
      if (show10 != null) 'show10': show10,
      if (show5 != null) 'show5': show5,
      if (show2 != null) 'show2': show2,
      if (show1 != null) 'show1': show1,
      if (show050 != null) 'show050': show050,
      if (show025 != null) 'show025': show025,
      if (show010 != null) 'show010': show010,
      if (show005 != null) 'show005': show005,
      if (show001 != null) 'show001': show001,
      if (createAt != null) 'create_at': createAt,
    });
  }

  CloseBoxSettingCompanion copyWith(
      {Value<int>? id,
      Value<bool>? show1000,
      Value<bool>? show500,
      Value<bool>? show200,
      Value<bool>? show100,
      Value<bool>? show50,
      Value<bool>? show20,
      Value<bool>? show10,
      Value<bool>? show5,
      Value<bool>? show2,
      Value<bool>? show1,
      Value<bool>? show050,
      Value<bool>? show025,
      Value<bool>? show010,
      Value<bool>? show005,
      Value<bool>? show001,
      Value<DateTime>? createAt}) {
    return CloseBoxSettingCompanion(
      id: id ?? this.id,
      show1000: show1000 ?? this.show1000,
      show500: show500 ?? this.show500,
      show200: show200 ?? this.show200,
      show100: show100 ?? this.show100,
      show50: show50 ?? this.show50,
      show20: show20 ?? this.show20,
      show10: show10 ?? this.show10,
      show5: show5 ?? this.show5,
      show2: show2 ?? this.show2,
      show1: show1 ?? this.show1,
      show050: show050 ?? this.show050,
      show025: show025 ?? this.show025,
      show010: show010 ?? this.show010,
      show005: show005 ?? this.show005,
      show001: show001 ?? this.show001,
      createAt: createAt ?? this.createAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (show1000.present) {
      map['show1000'] = Variable<bool>(show1000.value);
    }
    if (show500.present) {
      map['show500'] = Variable<bool>(show500.value);
    }
    if (show200.present) {
      map['show200'] = Variable<bool>(show200.value);
    }
    if (show100.present) {
      map['show100'] = Variable<bool>(show100.value);
    }
    if (show50.present) {
      map['show50'] = Variable<bool>(show50.value);
    }
    if (show20.present) {
      map['show20'] = Variable<bool>(show20.value);
    }
    if (show10.present) {
      map['show10'] = Variable<bool>(show10.value);
    }
    if (show5.present) {
      map['show5'] = Variable<bool>(show5.value);
    }
    if (show2.present) {
      map['show2'] = Variable<bool>(show2.value);
    }
    if (show1.present) {
      map['show1'] = Variable<bool>(show1.value);
    }
    if (show050.present) {
      map['show050'] = Variable<bool>(show050.value);
    }
    if (show025.present) {
      map['show025'] = Variable<bool>(show025.value);
    }
    if (show010.present) {
      map['show010'] = Variable<bool>(show010.value);
    }
    if (show005.present) {
      map['show005'] = Variable<bool>(show005.value);
    }
    if (show001.present) {
      map['show001'] = Variable<bool>(show001.value);
    }
    if (createAt.present) {
      map['create_at'] = Variable<DateTime>(createAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CloseBoxSettingCompanion(')
          ..write('id: $id, ')
          ..write('show1000: $show1000, ')
          ..write('show500: $show500, ')
          ..write('show200: $show200, ')
          ..write('show100: $show100, ')
          ..write('show50: $show50, ')
          ..write('show20: $show20, ')
          ..write('show10: $show10, ')
          ..write('show5: $show5, ')
          ..write('show2: $show2, ')
          ..write('show1: $show1, ')
          ..write('show050: $show050, ')
          ..write('show025: $show025, ')
          ..write('show010: $show010, ')
          ..write('show005: $show005, ')
          ..write('show001: $show001, ')
          ..write('createAt: $createAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDataBase extends GeneratedDatabase {
  _$AppDataBase(QueryExecutor e) : super(e);
  late final $PosSettingTable posSetting = $PosSettingTable(this);
  late final $PrinterEntityTable printerEntity = $PrinterEntityTable(this);
  late final $PrinterSettingEntityTable printerSettingEntity =
      $PrinterSettingEntityTable(this);
  late final $CloseBoxSettingTable closeBoxSetting =
      $CloseBoxSettingTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [posSetting, printerEntity, printerSettingEntity, closeBoxSetting];
}
