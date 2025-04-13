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
    data['isFolder'] = this.isFolder;
    data['parentId'] = this.parentId;
    data['parentName'] = this.parentName;
    return data;
  }
}

class SmetaAllWork{
  late bool allPrice;
  late int priceDefault;

  SmetaAllWork(this.allPrice, this.priceDefault);

}