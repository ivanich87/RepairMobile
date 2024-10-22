import 'dart:ffi';


class Globals {
  static var anThemeIndex = 0;
  static var anLogin = '';
  static var anPassword = '';
  static var anPhone = '';
  static var anServer= '';
  static var anPath = '';
  static var anCompanyId = '';
  static var anCompanyName = '';
  static var anCompanyComment = '';
  static var anOwnerId = '';
  static var anOwnerName = '';
  static var anUserId = '';
  static var anUserName = '';
  static var anUserRole = '';
  static var anUserRoleId = 3;
  static var anFCM = '';
  static var anPlatform = '';
  static var anAuthorization = 'Basic YWNlOkF4V3lJdnJBS1prdzY2UzdTMEJP';
  static var anIsDarkTheme = false;
  static var anCreatePlat = true;
  static var anCreateObject = true;
  static var anApprovalPlat = false;
  static var anFinTech = false;

  static printInteger() {
    print(anThemeIndex);
  }

  static setThemeIndex(int a) {
    anThemeIndex = a;
  }

  static setCompanyId(String a) {
    anCompanyId = a;
  }
  static setCompanyName(String a) {
    anCompanyName = a;
  }
  static setCompanyComment(String a) {
    anCompanyComment = a;
  }

  static setOwnerId(String a) {
    anOwnerId = a;
  }
  static setOwnerName(String a) {
    anOwnerName = a;
  }

  static setUserId(String a) {
    anUserId = a;
  }
  static setUserName(String a) {
    anUserName = a;
  }
  static setUserRole(String a) {
    anUserRole = a;
  }
  static setUserRoleId(int a) {
    anUserRoleId = a;
  }

  static setLogin(String a) {
    anLogin = a;
  }

  static setPasswodr(String a) {
    anPassword = a;
  }

  static setPhone(String a) {
    anPhone = a;
  }

  static setServer(String a) {
    anServer = a;
  }

  static setPath(String a) {
    anPath = a;
  }

  static setFCM(String a) {
    anFCM = a;
  }

  static setIsDarkTheme(bool a) {
    anIsDarkTheme = a;
  }

  static setCreatePlat(bool a) {
    anCreatePlat = a;
  }

  static setCreateObject(bool a) {
    anCreateObject = a;
  }

  static setFinTech(bool a) {
    anFinTech = a;
  }

  static setApprovalPlat(bool a) {
    anApprovalPlat = a;
  }

  static setPlatform(String a) {
    anPlatform = a;
  }
}

class returnResult {
  int resultCode;
  String resultText;

  returnResult({
    required this.resultCode,
    required this.resultText,
  });
}

class UserInfo {
  String login;
  String password;
  String phone;
  String server;
  String path;
  String companyId;
  String companyName;
  int themeIndex;

  //Event({required this.name, required this.location, required this.dt});

  UserInfo({
    required this.login,
    required this.password,
    required this.phone,
    required this.server,
    required this.path,
    required this.companyId,
    required this.companyName,
    required this.themeIndex,
  });

  UserInfo.fromJson(Map<String, dynamic> json)
      : login = json['login'],
        password = json['password'],
        server = json['server'],
        path = json['path'],
        companyId = json['companyId'],
        companyName = json['companyName'],
        phone = json['phone'],
        themeIndex = json['themeIndex'];

  Map<String, dynamic> toJson() => {
    'login': login,
    'password': password,
    'server': server,
    'phone': phone,
    'path': path,
    'companyId': companyId,
    'companyName': companyName,
    'themeIndex': themeIndex,
  };
}


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
  late String comment;

  ListCash(this.id, this.name, this.tip, this.summa, this.comment);

  ListCash.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '0';
    name = json['name'] ?? 'Пусто';
    tip = json['tip'] ?? 1;
    summa = json['summa'];
    comment = json['comment'];
    // final s = double.parse(json['summa'].toString());
    // summa = s.toInt();
  }

}

class accountableFounds {
  late String id;
  late String name;
  late num summa;

  accountableFounds(this.id, this.name, this.summa);

  accountableFounds.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '0';
    name = json['name'] ?? '';
    summa = json['summa'];
  }

}

class ListAttach {
  late String id;
  late String name;
  late String path;
  late int TipId;

  ListAttach(this.id, this.name, this.path, this.TipId);

  ListAttach.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '0';
    name = json['name'] ?? 'Пусто';
    path = json['path'] ?? 'Адрес не указан';
    TipId=0;
  }

}

class sprList {
  late String id;
  late String name;
  late String comment;
  late String code;
  late bool del;
  late bool selected;

  sprList(this.id, this.name, this.comment, this.code, this.del, this.selected);

  sprList.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '0';
    name = json['name'] ?? 'Пусто';
    comment = json['comment'] ?? 'Адрес не указан';
    code = json['code'].toString() ?? '0';
    del = json['del'] ?? false;
    selected = json['selected'] ?? false;
  }

}

class sprListSelected {
  late String id;
  late String name;
  late String comment;
  late bool selected;

  sprListSelected(this.id, this.name, this.comment, this.selected);

  sprListSelected.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '0';
    name = json['name'] ?? 'Пусто';
    comment = json['comment'] ?? 'Адрес не указан';
    selected = json['selected'] ?? false;
  }

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'name': name,
        'comment': comment,
        'selected': selected
      };

}

class ListObject {
  late String id;
  late String name;
  late String addres;
  late int summa;
  late int TipId;

  ListObject(this.id, this.name, this.addres, this.summa, this.TipId);

  ListObject.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '0';
    name = json['name'] ?? 'Пусто';
    addres = json['addres'] ?? 'Адрес не указан';
    final s = double.parse(json['СуммыДоговоров'].toString());
    summa = s.toInt();
    TipId=0;
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
  late String name;

  DogListObject(this.id, this.Number, this.Date, this.StartDate, this.StopDate, this.nameProrab, this.Status, this.TipId, this.nameMan, this.summaAkt, this.summaOplata, this.summa, this.name);

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
    name = json['name'];
  }

}

class analyticObjectList {
  late String analyticId;
  late String analyticName;
  late num summa;
  late num summaUp;
  late num summaDown;

  analyticObjectList(this.analyticId, this.analyticName, this.summa, this.summaUp, this.summaDown);

  analyticObjectList.fromJson(Map<String, dynamic> json) {
    analyticId = json['analyticId'] ?? '';
    analyticName = json['analyticName'] ?? 'analyticName';
    summa = json['summa'] ?? 0;
    summaUp = json['summaUp'] ?? 0;
    summaDown = json['summaDown'] ?? 0;
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

  late num summa;
  late num summaSeb;
  late num summaAkt;
  late num summaOpl;
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
    summa = json['summa'] ?? 0;
    summaSeb = json['summaSeb'] ?? 0;
    summaOpl = json['summaOpl'] ?? 0;
    summaAkt = json['summaAkt'] ?? 0;
    percent = json['percent'] ?? 0;
    address = json['address'] ?? 'Адрес не указан';

    // final s = double.parse(json['СуммыДоговоров'].toString());
    // summa = s.toInt();
    //
    // final s2 = double.parse(json['СуммаСебестоимость'].toString());
    // summaSeb = s2.toInt();
    //
    // final s3 = double.parse(json['СуммаАктов'].toString());
    // summaAkt = s3.toInt();

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
  late int attachedKol;

  ListPlat(this.id, this.name, this.date, this.del, this.number, this.accept, this.comment, this.contractorId, this.contractorName, this.contractorUse, this.analyticId, this.analyticName, this.summaUp, this.summaDown, this.summa, this.objectId, this.objectName, this.dogId, this.dogNumber, this.dogDate, this.dogUse, this.kassaId, this.kassaName, this.kassaSotrId, this.kassaSotrName, this.kassaType, this.kassa, this.companyId, this.companyName, this.platType, this.type, this.kassaId2, this.kassaName2, this.kassaSotrId2, this.kassaSotrName2, this.kassaType2, this.attachedKol);

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
    int? kassaType2,
    int? attachedKol
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
        kassaType2 = kassaType2 ?? this.kassaType2,
        attachedKol= attachedKol ?? this.attachedKol
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
    attachedKol= json['attachedKol'] ?? 0;
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
    'kassaType2': kassaType2,
    'attachedKol': attachedKol
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
    attachedKol= a.attachedKol ?? this.attachedKol;
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
    original.attachedKol=a.attachedKol ?? this.attachedKol;
  }
}


class Receipt {
  String id = '';
  String number = '';
  DateTime date = DateTime.now();
  bool accept = true;
  bool del = false;
  bool acceptClient = false;
  String clientId = '';
  String clientNmame = '';
  String objectId = '';
  String objectName = '';
  bool dogUse = true;
  String dogId = '';
  String dogNumber = '';
  DateTime dogDate = DateTime.now();
  num summaClient = 0;
  num summaOrg = 0;
  num summa = 0;
  bool tovarUse = false;
  String comment = '';
  String contractorId = '';
  String contractorName = '';
  String platType = 'Расход';
  int status = 0;
  String analyticId = '';
  String analyticName = '';
  String kassaId = '';
  String kassaName = '';
  String kassaSotrId = '';
  String kassaSotrName = '';
  int kassaType = 0;
  String type = 'Покупка стройматериалов';
  int attachedKol = 0;
  List<ReceiptSost>? receiptSost;


  Receipt(this.id, this.number, this.date, this.accept, this.del, this.acceptClient, this.clientId, this.clientNmame, this.objectId, this.objectName, this.dogUse, this.dogId, this.dogNumber, this.dogDate, this.summaClient, this.summaOrg, this.summa, this.tovarUse, this.comment, this.contractorId, this.contractorName, this.platType, this.status, this.analyticId, this.analyticName, this.kassaId, this.kassaName, this.kassaSotrId, this.kassaSotrName, this.kassaType, this.type, this.attachedKol, this.receiptSost);

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'number': number,
        'date': date.toIso8601String(),
        'accept': accept,
        'del': del,
        'acceptClient': acceptClient,
        'clientId': clientId,
        'clientName': clientNmame ?? '',
        'objectId': objectId ?? '',
        'objectName': objectName ?? '',
        'dogUse': dogUse,
        'dogId': dogId ?? '',
        'dogNumber': dogNumber ?? 'Пусто',
        'dogDate': dogDate.toIso8601String(),
        'summaClient': summaClient,
        'summaOrg': summaOrg,
        'summa': summa,
        'tovarUse': tovarUse,
        'comment': comment,
        'contractorId': contractorId,
        'contractorName': contractorName ,
        'platType': platType,
        'status': status,
        'analyticId': analyticId ?? '',
        'analyticName': analyticName ?? '',
        'kassaId': kassaId,
        'kassaName': kassaName,
        'kassaSotrId': kassaSotrId,
        'kassaSotrName': kassaSotrName,
        'kassaType': kassaType,
        'type': type,
        'attachedKol': attachedKol,
        //if (this.receiptSost != null) {
          'receiptSost': receiptSost!.map((v) => v.toJson()).toList()
        //}
      };

  Receipt copyWith({
    String? id,
    String? number,
    DateTime? date,
    bool? accept,
    bool? del,
    bool? acceptClient,
    String? clientId,
    String? clientNmame,
    String? objectId,
    String? objectName,
    bool? dogUse,
    String? dogId,
    String? dogNumber,
    DateTime? dogDate,
    num? summaClient,
    num? summaOrg,
    num? summa,
    bool? tovarUse,
    String? comment,
    String? contractorId,
    String? contractorName,
    String? platType,
    int? status,
    String? analyticId,
    String? analyticName,
    String? kassaId,
    String? kassaName,
    String? kassaSotrId,
    String? kassaSotrName,
    int? kassaType,
    String? type,
    int? attachedKol,
    List<ReceiptSost>? receiptSost
  }) {
    return Receipt(
        id = id ?? this.id,
        number = number ?? this.number,
        date = date ?? this.date,
        accept = accept ?? this.accept,
        del = del ?? this.del,
        acceptClient = acceptClient ?? this.acceptClient,
        clientId = clientId ?? this.clientId,
        clientNmame = clientNmame ?? this.clientNmame,
        objectId = objectId ?? this.objectId,
        objectName = objectName ?? this.objectName,
        dogUse = dogUse ?? this.dogUse,
        dogId = dogId ?? this.dogId,
        dogNumber = dogNumber ?? this.dogNumber,
        dogDate = dogDate ?? this.dogDate,
        summaClient = summaClient ?? this.summaClient,
        summaOrg = summaOrg ?? this.summaOrg,
        summa = summa ?? this.summa,
        tovarUse = tovarUse ?? this.tovarUse,
        comment = comment ?? this.comment,
        contractorId = contractorId ?? this.contractorId,
        contractorName = contractorName ?? this.contractorName,
        platType = platType ?? this.platType,
        status = status ?? this.status,
        analyticId = analyticId ?? this.analyticId,
        analyticName = analyticName ?? this.analyticName,
        kassaId = kassaId ?? this.kassaId,
        kassaName = kassaName ?? this.kassaName,
        kassaSotrId = kassaSotrId ?? this.kassaSotrId,
        kassaSotrName = kassaSotrName ?? this.kassaSotrName,
        kassaType = kassaType ?? this.kassaType,
        type = type ?? this.type,
        attachedKol = attachedKol ?? this.attachedKol,
        receiptSost = receiptSost ?? this.receiptSost
    );
  }

  Receipt.fromTo(Receipt original, Receipt a) {
    original.id = a.id ?? this.id;
    original.number = a.number ?? this.number;
    original.date = a.date ?? this.date;
    original.accept = a.accept ?? this.accept;
    original.del = a.del ?? this.del;
    original.acceptClient = a.acceptClient ?? this.acceptClient;
    original.clientId = a.clientId ?? this.clientId;
    original.clientNmame = a.clientNmame ?? this.clientNmame;
    original.objectId = a.objectId ?? this.objectId;
    original.objectName = a.objectName ?? this.objectName;
    original.dogUse = a.dogUse ?? this.dogUse;
    original.dogId = a.dogId ?? this.dogId;
    original.dogNumber = a.dogNumber ?? this.dogNumber;
    original.dogDate = a.dogDate ?? this.dogDate;
    original.summaClient = a.summaClient ?? this.summaClient;
    original.summaOrg = a.summaOrg ?? this.summaOrg;
    original.summa = a.summa ?? this.summa;
    original.tovarUse = a.tovarUse ?? this.tovarUse;
    original.comment = a.comment ?? this.comment;
    original.contractorId = a.contractorId ?? this.contractorId;
    original.contractorName = a.contractorName ?? this.contractorName;
    original.platType = a.platType ?? this.platType;
    original.status = a.status ?? this.status;
    original.analyticId = a.analyticId ?? this.analyticId;
    original.analyticName = a.analyticName ?? this.analyticName;
    original.kassaId = a.kassaId ?? this.kassaId;
    original.kassaName = a.kassaName ?? this.kassaName;
    original.kassaSotrId = a.kassaSotrId ?? this.kassaSotrId;
    original.kassaSotrName = a.kassaSotrName ?? this.kassaSotrName;
    original.kassaType = a.kassaType ?? this.kassaType;
    original.type = a.type ?? this.type;
    original.attachedKol=a.attachedKol ?? this.attachedKol;
    original.receiptSost = a.receiptSost ?? this.receiptSost;
  }
}

class ReceiptSost {
  String? name;
  num? kol;
  num? price;
  num? summa;

  ReceiptSost({this.name, this.kol, this.price, this.summa});

  ReceiptSost.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    kol = json['kol'];
    price = json['price'];
    summa = json['summa'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['kol'] = this.kol;
    data['price'] = this.price;
    data['summa'] = this.summa;
    return data;
  }
}


class Akt {
  String id = '';
  String number = '';
  DateTime date = DateTime.now();
  bool accept = true;
  bool del = false;
  bool acceptRuk = false;
  String statusId = '';
  String status = '';
  String dogId = '';
  String smetaId = '';
  DateTime dateStart = DateTime.now();
  DateTime dateStop = DateTime.now();
  num summa = 0;
  num seb = 0;
  //List<AktSost>? aktSost;


  Akt(this.id, this.number, this.date, this.accept, this.del, this.acceptRuk, this.statusId, this.status, this.dogId, this.smetaId, this.dateStart, this.dateStop, this.summa, this.seb);

  Akt.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    number = json['number'] ?? '';
    date = DateTime.tryParse(json['date']) ?? DateTime(2023);
    accept = json['accept'] ?? false;
    del = json['del'] ?? false;
    acceptRuk = json['acceptRuk'] ?? false;
    statusId = json['statusId'] ?? '';
    status = json['status'] ?? '';
    dogId = json['dogId'] ?? '';
    smetaId = json['smetaId'] ?? '';
    dateStart = DateTime.tryParse(json['dateStart']) ?? DateTime(2023);
    dateStop = DateTime.tryParse(json['dateStop']) ?? DateTime(2023);
    summa = json['summa'] ?? 0;
    seb = json['seb'] ?? 0;
  }

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'number': number,
        'date': date.toIso8601String(),
        'accept': accept,
        'del': del,
        'acceptRuk': acceptRuk,
        'statusId': statusId,
        'status': status ?? '',
        'dogId': dogId ?? '',
        'smetaId': smetaId ?? '',
        'dateStart': dateStart.toIso8601String(),
        'dateStop': dateStop.toIso8601String(),
        'summa': summa ?? 'Пусто',
        'seb': seb
        //'aktSost': aktSost!.map((v) => v.toJson()).toList()
      };

  Akt copyWith({
    String? id,
    String? number,
    DateTime? date,
    bool? accept,
    bool? del,
    bool? acceptRuk,
    String? statusId,
    String? status,
    String? dogId,
    String? smetaId,
    DateTime? dateStart,
    DateTime? dateStop,
    num? summa,
    num? seb
    //List<AktSost>? aktSost
  }) {
    return Akt(
        id = id ?? this.id,
        number = number ?? this.number,
        date = date ?? this.date,
        accept = accept ?? this.accept,
        del = del ?? this.del,
        acceptRuk = acceptRuk ?? this.acceptRuk,
        statusId = statusId ?? this.statusId,
        status = status ?? this.status,
        dogId = dogId ?? this.dogId,
        smetaId = smetaId ?? this.smetaId,
        dateStart = dateStart ?? this.dateStart,
        dateStop = dateStop ?? this.dateStop,
        summa = summa ?? this.summa,
        seb = seb ?? this.seb
        //aktSost = aktSost ?? this.aktSost
    );
  }

  Akt.fromTo(Akt original, Akt a) {
    original.id = a.id ?? this.id;
    original.number = a.number ?? this.number;
    original.date = a.date ?? this.date;
    original.accept = a.accept ?? this.accept;
    original.del = a.del ?? this.del;
    original.acceptRuk = a.acceptRuk ?? this.acceptRuk;
    original.statusId = a.statusId ?? this.statusId;
    original.status = a.status ?? this.status;
    original.dogId = a.dogId ?? this.dogId;
    original.smetaId = a.smetaId ?? this.smetaId;
    original.dateStart = a.dateStart ?? this.dateStart;
    original.dateStop = a.dateStop ?? this.dateStop;
    original.seb = a.seb ?? this.seb;
    original.summa = a.summa ?? this.summa;
    //original.aktSost = a.aktSost ?? this.aktSost;
  }
}

class AktSost {
  String? name;
  num? kol;
  num? price;
  num? summa;

  AktSost({this.name, this.kol, this.price, this.summa});

  AktSost.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    kol = json['kol'];
    price = json['price'];
    summa = json['summa'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['kol'] = this.kol;
    data['price'] = this.price;
    data['summa'] = this.summa;
    return data;
  }
}

