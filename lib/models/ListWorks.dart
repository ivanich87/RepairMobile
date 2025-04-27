class Works {
  String? roomId;
  String? roomName;
  String? workId;
  String? workName;
  num? kolSmeta;
  num? kolUsed;
  num? kolRemains;
  num? kol;
  num? price;
  num? priceSub;
  num? summa;
  num? summaSub;
  num? materialSumma;
  num? materialSummaSeb;
  bool? isFolder;
  String? parentId;
  String? parentName;

  Works(
      {this.roomId,
        this.roomName,
        this.workId,
        this.workName,
        this.kolSmeta,
        this.kolUsed,
        this.kolRemains,
        this.kol,
        this.price,
        this.priceSub,
        this.summa,
        this.summaSub,
        this.materialSumma,
        this.materialSummaSeb,
        this.isFolder,
        this.parentId,
        this.parentName});

  Works.fromJson(Map<String, dynamic> json) {
    roomId = json['roomId'];
    roomName = json['roomName'];
    workId = json['workId'];
    workName = json['workName'];
    kolSmeta = json['kolSmeta'];
    kolUsed = json['kolUsed'];
    kolRemains = json['kolRemains'];
    kol = json['kol'];
    price = json['price'];
    priceSub = json['priceSub'];
    summa = json['summa'];
    summaSub = json['summaSub'];
    materialSumma = json['materialSumma'];
    materialSummaSeb = json['materialSummaSeb'];
    isFolder = json['isFolder'];
    parentId = json['parentId'] ?? '';
    parentName = json['parentName'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['roomId'] = this.roomId;
    data['roomName'] = this.roomName;
    data['workId'] = this.workId;
    data['workName'] = this.workName;
    data['kolSmeta'] = this.kolSmeta;
    data['kolUsed'] = this.kolUsed;
    data['KolRemains'] = this.kolRemains;
    data['kol'] = this.kol;
    data['price'] = this.price;
    data['priceSub'] = this.priceSub;
    data['summa'] = this.summa;
    data['summaSub'] = this.summaSub;
    data['materialSumma'] = this.materialSumma;
    data['materialSummaSeb'] = this.materialSummaSeb;
    data['isFolder'] = this.isFolder;
    data['parentId'] = this.parentId;
    data['parentName'] = this.parentName;
    return data;
  }
}

class Materials {
  String? roomId;
  String? workId;
  String? materialId;
  String? materialName;
  String? avatar;
  String? formula;
  num? consumption;
  bool? def;
  num? round;
  num? kol;
  num? price;
  num? priceSeb;
  num? summa;
  num? summaSeb;

  Materials(
      {this.roomId,
        this.workId,
        this.materialId,
        this.materialName,
        this.avatar,
        this.formula,
        this.consumption,
        this.def,
        this.round,
        this.kol,
        this.price,
        this.priceSeb,
        this.summa,
        this.summaSeb});

  Materials.fromJson(Map<String, dynamic> json) {
    roomId = json['roomId'];
    workId = json['workId'];
    materialId = json['materialId'];
    materialName = json['materialName'];
    avatar = json['avatar'] ?? 'https://sun1-83.userapi.com/s/v1/ig2/7t9jiWE0Fldp0dmKRxMIAbxCOAYtCjAB2-SQo_yJ_xk8e8jxC8UiSXx8BKIj981EXnpFOmF5UyINu4alIhbyfLr8.jpg?size=400x400&quality=95&crop=40,0,447,447&ava=1';
    formula = json['formula'];
    consumption = json['consumption'];
    def = json['def'];
    round = json['round'];
    kol = json['kol'];
    price = json['price'];
    priceSeb = json['priceSeb'];
    summa = json['summa'];
    summaSeb = json['summaSeb'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['roomId'] = this.roomId;
    data['workId'] = this.workId;
    data['materialId'] = this.materialId;
    data['materialName'] = this.materialName;
    data['avatar'] = this.avatar;
    data['formula'] = this.formula;
    data['consumption'] = this.consumption;
    data['def'] = this.def;
    data['kol'] = this.kol;
    data['price'] = this.price;
    data['priceSeb'] = this.priceSeb;
    data['summa'] = this.summa;
    data['summaSeb'] = this.summaSeb;
    data['round'] = this.round;

    return data;
  }
}


class SmetaAllWork{
  late bool allPrice;
  late int priceDefault;
  late String id;

  SmetaAllWork(this.allPrice, this.priceDefault, this.id);

}