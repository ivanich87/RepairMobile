import 'dart:ffi';

class ListSkladInfo {
  int id;
  String name;
  String address;
  int level;
  String name_tc;
  int id_brand;


  //Event({required this.name, required this.location, required this.dt});

  ListSkladInfo({
    required this.id,
    required this.name,
    required this.address,
    required this.level,
    required this.name_tc,
    required this.id_brand,
  });

  ListSkladInfo.fromJson(Map<String, dynamic> json) :
    id = json['id'],
    name = json['name'],
    address = json['address'],
    level = json['level'],
    name_tc = json['name_tc'],
    id_brand = json['id_brand'];
}

class AccountCategoryMoneyInfo {
  int id;
  String name;
  int summaPlus;
  int summaMinus;
  int summa;


  //Event({required this.name, required this.location, required this.dt});

  AccountCategoryMoneyInfo({
    required this.id,
    required this.name,
    required this.summaPlus,
    required this.summaMinus,
    required this.summa,
  });

  AccountCategoryMoneyInfo.fromJson(Map<String, dynamic> json) :
        id = json['id'],
        name = json['name'],
        summaPlus = json['summaPlus'],
        summaMinus = json['summaMinus'],
        summa = json['summa'];
}

class ListCash {
  late String id;
  late String name;
  late int tip;
  late num summa;

  ListCash(this.id, this.name, this.tip, this.summa);

  ListCash.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '0';
    name = json['name'] ?? 'Пусто';
    tip = json['tip'] ?? 1;
    summa = json['summa'];
    // final s = double.parse(json['summa'].toString());
    // summa = s.toInt();
  }

}

class sprList {
  late String id;
  late String name;
  late String comment;
  late String code;

  sprList(this.id, this.name, this.comment, this.code);

  sprList.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '0';
    name = json['name'] ?? 'Пусто';
    comment = json['comment'] ?? 'Адрес не указан';
    code = json['code'] ?? '0';
  }

}

class ListObject {
  late String id;
  late String name;
  late String addres;
  late int summa;

  ListObject(this.id, this.name, this.addres, this.summa);

  ListObject.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '0';
    name = json['name'] ?? 'Пусто';
    addres = json['addres'] ?? 'Адрес не указан';
    final s = double.parse(json['СуммыДоговоров'].toString());
    summa = s.toInt();
  }

}

class SelectedDogovor{
  late String objectName;
  late String objectId;
  late String objectContractor;
  late String dogId;
  late String dogNumber;
  late DateTime dogDate;

  SelectedDogovor(this.objectId, this.objectName, this.objectContractor, this.dogId, this.dogNumber, this.dogDate);

}

class SelectedSPR{
  late String name;
  late String id;

  SelectedSPR(this.id, this.name);

}

class DogListObject {
  late String id;
  late String Number;
  late DateTime Date;
  late DateTime StartDate;
  late DateTime StopDate;
  late String nameProrab;
  late String Status;
  late int TipId;
  late String TipName;
  late String nameMan;
  late num summaAkt;
  late num summaOplata;
  late num summa;

  DogListObject(this.id, this.Number, this.Date, this.StartDate, this.StopDate, this.nameProrab, this.Status, this.TipId, this.nameMan, this.summaAkt, this.summaOplata, this.summa);

  DogListObject.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '0';
    Number = json['Number'] ?? 'Number';
    Date = DateTime.tryParse(json['Date'])!;
    StartDate = DateTime.tryParse(json['StartDate'])!;
    StopDate = DateTime.tryParse(json['StopDate'])!;
    nameProrab = json['nameProrab'] ?? 'nameProrab';
    Status = json['Status'] ?? 'Status';
    TipId = json['TipId'] ?? 0;
    TipName = json['TipName'] ?? 'TipName';
    nameMan = json['nameMan'] ?? 'nameMan';
    summaAkt = json['summaAkt'];
    summaOplata = json['summaOplata'];
    summa = json['summa'];

  }

}

class InfoObject {
  late String id;
  late String name;
  late String nameClient;
  late String idClient;
  late String nameManager;
  late String idManager;
  late String nameProrab;
  late String idProrab;

  late String startDate;
  late String stopDate;

  late int summa;
  late int summaSeb;
  late int summaAkt;
  late int percent;
  late int payment;

  late String address;


  InfoObject(this.id, this.name, this.nameClient, this.idClient, this.nameManager, this.idManager, this.nameProrab, this.idProrab, this.startDate, this.stopDate, this.summa, this.summaSeb, this.summaAkt, this.percent, this.payment, this.address);

  InfoObject.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '0';
    name = json['nameObject'] ?? 'Пусто';
    nameClient = json['nameClient'] ?? 'Пусто';
    idClient = json['idClient'] ?? 'Пусто';
    nameManager = json['nameManager'] ?? 'Пусто';
    idManager = json['idManager'] ?? 'Пусто';
    nameProrab = json['nameProrab'] ?? 'Пусто';
    idProrab = json['idProrab'] ?? 'Пусто';
    startDate = json['startDate'] ?? 'Пусто';
    stopDate = json['stopDate'] ?? 'Пусто';
    summa = json['summa'] ?? 'Пусто';
    summaSeb = json['summaSeb'] ?? 'Пусто';
    summaAkt = json['summaAkt'] ?? 'Пусто';
    percent = json['percent'] ?? 'Пусто';
    address = json['address'] ?? 'Адрес не указан';

    final s = double.parse(json['СуммыДоговоров'].toString());
    summa = s.toInt();

    final s2 = double.parse(json['СуммаСебестоимость'].toString());
    summaSeb = s2.toInt();

    final s3 = double.parse(json['СуммаАктов'].toString());
    summaAkt = s3.toInt();

    final s4 = double.parse(json['ПроцентВыполнения'].toString());
    percent = s4.toInt();

    final s5 = double.parse(json['ПроцентВыполнения'].toString());
    payment = s5.toInt();
  }

}


class ListPlat {
  late String id;
  late String name;
  late DateTime date;
  late bool del;
  late String number;
  late bool accept;
  late String comment;
  late String contractorId;
  late String contractorName;
  late bool contractorUse;
  late String analyticId;
  late String analyticName;
  late num summaUp;
  late num summaDown;
  late num summa;
  late String objectId;
  late String objectName;
  late String dogId;
  late String dogNumber;
  late DateTime dogDate;
  late bool dogUse;
  late String kassaId;
  late String kassaName;
  late String kassaSotrId;
  late String kassaSotrName;
  late int kassaType;
  late String kassa;
  late String companyId;
  late String companyName;
  late String platType;
  late String type;
  late String kassaId2;
  late String kassaName2;
  late String kassaSotrId2;
  late String kassaSotrName2;
  late int kassaType2;

  ListPlat(this.id, this.name, this.date, this.del, this.number, this.accept, this.comment, this.contractorId, this.contractorName, this.contractorUse, this.analyticId, this.analyticName, this.summaUp, this.summaDown, this.summa, this.objectId, this.objectName, this.dogId, this.dogNumber, this.dogDate, this.dogUse, this.kassaId, this.kassaName, this.kassaSotrId, this.kassaSotrName, this.kassaType, this.kassa, this.companyId, this.companyName, this.platType, this.type, this.kassaId2, this.kassaName2, this.kassaSotrId2, this.kassaSotrName2, this.kassaType2);

  ListPlat copyWith({
    String? id,
    String? name,
    DateTime? date,
    bool? del,
    String? number,
    bool? accept,
    String? comment,
    String? contractorId,
    String? contractorName,
    bool? contractorUse,
    String? analyticId,
    String? analyticName,
    num? summaUp,
    num? summaDown,
    num? summa,
    String? objectId,
    String? objectName,
    String? dogId,
    String? dogNumber,
    DateTime? dogDate,
    bool? dogUse,
    String? kassaId,
    String? kassaName,
    String? kassaSotrId,
    String? kassaSotrName,
    int? kassaType,
    String? kassa,
    String? companyId,
    String? companyName,
    String? platType,
    String? type,
    String? kassaId2,
    String? kassaName2,
    String? kassaSotrId2,
    String? kassaSotrName2,
    int? kassaType2
  }) {
    return ListPlat(
        id = id ?? this.id,
        name = name ?? this.name,
        date = date ?? this.date,
        del = del ?? this.del,
        number = number ?? this.number,
        accept = accept ?? this.accept,
        comment = comment ?? this.comment,
        contractorId = contractorId ?? this.contractorId,
        contractorName = contractorName ?? this.contractorName,
        contractorUse = contractorUse ?? this.contractorUse,
        analyticId = analyticId ?? this.analyticId,
        analyticName = analyticName ?? this.analyticName,
        summaUp = summaUp ?? this.summaUp,
        summaDown = summaDown ?? this.summaDown,
        summa = summa ?? this.summa,
        objectId = objectId ?? this.objectId,
        objectName = objectName ?? this.objectName,
        dogId = dogId ?? this.dogId,
        dogNumber = dogNumber ?? this.dogNumber,
        dogDate = dogDate ?? this.dogDate,
        dogUse = dogUse ?? this.dogUse,
        kassaId = kassaId ?? this.kassaId,
        kassaName = kassaName ?? this.kassaName,
        kassaSotrId = kassaSotrId ?? this.kassaSotrId,
        kassaSotrName = kassaSotrName ?? this.kassaSotrName,
        kassaType = kassaType ?? this.kassaType,
        kassa = kassa ?? this.kassa,
        companyId = companyId ?? this.companyId,
        companyName = companyName ?? this.companyName,
        platType = platType ?? this.platType,
        type = type ?? this.type,
        kassaId2 = kassaId2 ?? this.kassaId2,
        kassaName2 = kassaName2 ?? this.kassaName2,
        kassaSotrId2 = kassaSotrId2 ?? this.kassaSotrId2,
        kassaSotrName2 = kassaSotrName2 ?? this.kassaSotrName2,
        kassaType2 = kassaType2 ?? this.kassaType2
    );
  }

  ListPlat.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '0';
    name = json['name'] ?? 'no name';
    date = DateTime.tryParse(json['date']) ?? DateTime(2023);
    del = json['del'] ?? false;
    number = json['number'] ?? 'Пусто';
    accept = json['accept'] ?? false;
    comment = json['comment'] ?? 'Пусто';
    contractorId = json['contractorId'] ?? 'Пусто';
    contractorName = json['contractorName'] ?? 'Пусто';
    contractorUse = json['contractorUse'] ?? false;
    analyticId = json['analyticId'] ?? 'Пусто';
    analyticName = json['analyticName'] ?? 'Пусто';
    objectId = json['objectId'] ?? 'Пусто';
    objectName = json['objectName'] ?? 'Пусто';
    dogId = json['dogId'] ?? 'Пусто';
    dogNumber = json['dogNumber'] ?? 'Пусто';
    dogDate = DateTime.tryParse(json['dogDate']) ?? DateTime(2023);
    dogUse = json['dogUse'] ?? false;
    kassaId = json['kassaId'] ?? 'Пусто';
    kassaName = json['kassaName'] ?? 'Пусто';
    kassaSotrId = json['kassaSotrId'] ?? 'Пусто';
    kassaSotrName = json['kassaSotrName'] ?? 'Пусто';
    kassaType = json['kassaType'] ?? 0;
    companyId = json['companyId'] ?? 'Пусто';
    companyName = json['companyName'] ?? 'Пусто';
    summaUp = json['summaUp'] ?? 0;
    summaDown = json['summaDown'] ?? 0;
    summa = (summaUp>0 ? summaUp : -summaDown);
    platType = json['platType'] ?? '';
    type = json['type'] ?? '';
    kassa = (kassaType==1 ? kassaSotrName:kassaName);
    kassaId2 = json['kassaId2'] ?? 'Пусто';
    kassaName2 = json['kassaName2'] ?? 'Пусто';
    kassaSotrId2 = json['kassaSotrId2'] ?? 'Пусто';
    kassaSotrName2 = json['kassaSotrName2'] ?? 'Пусто';
    kassaType2 = json['kassaType2'] ?? 0;
  }

  Map<String, dynamic> toJson() =>
  {
    'id': id,
    'name': name,
    'date': date.toIso8601String(),
    'del': del,
    'number': number,
    'accept': accept,
    'comment': comment,
    'contractorId': contractorId,
    'contractorName': contractorName ?? '',
    'contractorUse': contractorUse ?? false,
    'analyticId': analyticId ?? '',
    'analyticName': analyticName ?? '',
    'objectId': objectId ?? '',
    'objectName': objectName ?? '',
    'dogId': dogId ?? '',
    'dogNumber': dogNumber ?? 'Пусто',
    'dogDate': dogDate.toIso8601String(),
    'dogUse': dogUse,
    'kassaId': kassaId,
    'kassaName': kassaName,
    'kassaSotrId': kassaSotrId,
    'kassaSotrName': kassaSotrName,
    'kassaType': kassaType,
    'companyId': companyId,
    'companyName': companyName,
    'summaUp': summaUp,
    'summaDown': summaDown,
    'summa': summa,
    'platType': platType,
    'type': type,
    'kassa': kassa,
    'kassaId2': kassaId2,
    'kassaName2': kassaName2 ,
    'kassaSotrId2': kassaSotrId2,
    'kassaSotrName2': kassaSotrName2,
    'kassaType2': kassaType2
  };

  ListPlat.from(ListPlat a) {
    id = a.id ?? this.id;
    name = a.name ?? this.name;
    date = a.date ?? this.date;
    del = a.del ?? this.del;
    number = a.number ?? this.number;
    accept = a.accept ?? this.accept;
    comment = a.comment ?? this.comment;
    contractorId = a.contractorId ?? this.contractorId;
    contractorName = a.contractorName ?? this.contractorName;
    contractorUse = a.contractorUse ?? this.contractorUse;
    analyticId = a.analyticId ?? this.analyticId;
    analyticName = a.analyticName ?? this.analyticName;
    summaUp = a.summaUp ?? this.summaUp;
    summaDown = a.summaDown ?? this.summaDown;
    summa = a.summa ?? this.summa;
    objectId = a.objectId ?? this.objectId;
    objectName = a.objectName ?? this.objectName;
    dogId = a.dogId ?? this.dogId;
    dogNumber = a.dogNumber ?? this.dogNumber;
    dogDate = a.dogDate ?? this.dogDate;
    dogUse = a.dogUse ?? this.dogUse;
    kassaId = a.kassaId ?? this.kassaId;
    kassaName = a.kassaName ?? this.kassaName;
    kassaSotrId = a.kassaSotrId ?? this.kassaSotrId;
    kassaSotrName = a.kassaSotrName ?? this.kassaSotrName;
    kassaType = a.kassaType ?? this.kassaType;
    kassa = a.kassa ?? this.kassa;
    companyId = a.companyId ?? this.companyId;
    companyName = a.companyName ?? this.companyName;
    platType = a.platType ?? this.platType;
    type = a.type ?? this.type;
    kassaId2 = a.kassaId2 ?? this.kassaId2;
    kassaName2 = a.kassaName2 ?? this.kassaName2;
    kassaSotrId2 = a.kassaSotrId2 ?? this.kassaSotrId2;
    kassaSotrName2 = a.kassaSotrName2 ?? this.kassaSotrName2;
    kassaType2 = a.kassaType2 ?? this.kassaType2;
  }

  ListPlat.fromTo(ListPlat original, ListPlat a) {
    original.id = a.id ?? this.id;
    original.name = a.name ?? this.name;
    original.date = a.date ?? this.date;
    original.del = a.del ?? this.del;
    original.number = a.number ?? this.number;
    original.accept = a.accept ?? this.accept;
    original.comment = a.comment ?? this.comment;
    original.contractorId = a.contractorId ?? this.contractorId;
    original.contractorName = a.contractorName ?? this.contractorName;
    original.contractorUse = a.contractorUse ?? this.contractorUse;
    original.analyticId = a.analyticId ?? this.analyticId;
    original.analyticName = a.analyticName ?? this.analyticName;
    original.summaUp = a.summaUp ?? this.summaUp;
    original.summaDown = a.summaDown ?? this.summaDown;
    original.summa = a.summa ?? this.summa;
    original.objectId = a.objectId ?? this.objectId;
    original.objectName = a.objectName ?? this.objectName;
    original.dogId = a.dogId ?? this.dogId;
    original.dogNumber = a.dogNumber ?? this.dogNumber;
    original.dogUse = a.dogUse ?? this.dogUse;
    original.dogDate = a.dogDate ?? this.dogDate;
    original.kassaId = a.kassaId ?? this.kassaId;
    original.kassaName = a.kassaName ?? this.kassaName;
    original.kassaSotrId = a.kassaSotrId ?? this.kassaSotrId;
    original.kassaSotrName = a.kassaSotrName ?? this.kassaSotrName;
    original.kassaType = a.kassaType ?? this.kassaType;
    original.kassa = a.kassa ?? this.kassa;
    original.companyId = a.companyId ?? this.companyId;
    original.companyName = a.companyName ?? this.companyName;
    original.platType = a.platType ?? this.platType;
    original.type = a.type ?? this.type;
    original.kassaId2 = a.kassaId2 ?? this.kassaId2;
    original.kassaName2 = a.kassaName2 ?? this.kassaName2;
    original.kassaSotrId2 = a.kassaSotrId2 ?? this.kassaSotrId2;
    original.kassaSotrName2 = a.kassaSotrName2 ?? this.kassaSotrName2;
    original.kassaType2 = a.kassaType2 ?? this.kassaType2;
  }
}