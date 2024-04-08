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
  late int summa;

  ListCash(this.id, this.name, this.tip, this.summa);

  ListCash.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '0';
    name = json['name'] ?? 'Пусто';
    tip = json['tip'] ?? 1;
    final s = double.parse(json['summa'].toString());
    summa = s.toInt();
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
  late String kassaId;
  late String kassaName;
  late String kassaSotrId;
  late String kassaSotrName;
  late int kassaType;
  late String kassa;
  late String companyId;
  late String companyName;
  late int platType;

  ListPlat(this.id, this.name, this.date, this.del, this.number, this.accept, this.comment, this.contractorId, this.contractorName, this.analyticId, this.analyticName, this.summaUp, this.summaDown, this.summa, this.objectId, this.objectName, this.dogId, this.dogNumber, this.dogDate, this.kassaId, this.kassaName, this.kassaSotrId, this.kassaSotrName, this.kassaType, this.kassa, this.companyId, this.companyName, this.platType);

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
    analyticId = json['analyticId'] ?? 'Пусто';
    analyticName = json['analyticName'] ?? 'Пусто';
    objectId = json['objectId'] ?? 'Пусто';
    objectName = json['objectName'] ?? 'Пусто';
    dogId = json['dogId'] ?? 'Пусто';
    dogNumber = json['dogNumber'] ?? 'Пусто';
    dogDate = DateTime.tryParse(json['dogDate']) ?? DateTime(2023);
    kassaId = json['kassaId'] ?? 'Пусто';
    kassaName = json['kassaName'] ?? 'Пусто';
    kassaSotrId = json['kassaSotrId'] ?? 'Пусто';
    kassaSotrName = json['kassaSotrName'] ?? 'Пусто';
    kassaType = json['kassaType'] ?? 0;
    companyId = json['companyId'] ?? 'Пусто';
    companyName = json['companyName'] ?? 'Пусто';

    //summaUp = (double.parse(json['summaUp']) ?? 0.00) as Double;
    //summaDown = (double.parse(json['summaDown']) ?? 0.00) as Double;
    summaUp = json['summaUp'] ?? 0;
    summaDown = json['summaDown'] ?? 0;
    if (summaUp>0) {
      summa = summaUp;
      platType = 1; //поступление
    } else {
      summa = -summaDown;
      platType = 0; //списание
    }
    kassa = (kassaType==1 ? kassaSotrName:kassaName);
  }

}