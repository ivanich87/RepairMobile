class ListFloor {
  num a;
  num b;
  String typeid;

  ListFloor({
    required this.a,
    required this.b,
    required this.typeid,
  });

  ListFloor.fromJson(Map<String, dynamic> json) :
        a = json['a'],
        b = json['b'],
        typeid = json['typeid'];
}

class ListPerimeter {
  num a;

  ListPerimeter({
    required this.a,
  });

  ListPerimeter.fromJson(Map<String, dynamic> json) :
        a = json['a'];
}

class ListOpenings {
  num a;
  num b;
  bool isDoor;

  ListOpenings({
    required this.a,
    required this.b,
    required this.isDoor,
  });

  ListOpenings.fromJson(Map<String, dynamic> json) :
        a = json['a'],
        b = json['b'],
        isDoor = json['isDoor'];
}

class ListSlopeDoor {
  num a;
  num b;
  num c;

  ListSlopeDoor({
    required this.a,
    required this.b,
    required this.c,
  });

  ListSlopeDoor.fromJson(Map<String, dynamic> json) :
        a = json['a'],
        b = json['b'],
        c = json['c'];
}

class ListSlopeWindow {
  num a;
  num b;
  num c;

  ListSlopeWindow({
    required this.a,
    required this.b,
    required this.c,
  });

  ListSlopeWindow.fromJson(Map<String, dynamic> json) :
        a = json['a'],
        b = json['b'],
        c = json['c'];
}

class ListSlopeWall {
  num a;
  num b;
  bool isWall;

  ListSlopeWall({
    required this.a,
    required this.b,
    required this.isWall,
  });

  ListSlopeWall.fromJson(Map<String, dynamic> json) :
        a = json['a'],
        b = json['b'],
        isWall = json['isWall'];
}


class ListDataParam {
  num a;
  num b;
  num c;
  bool isBool;
  String typeid;

  ListDataParam({
    required this.a,
    required this.b,
    required this.c,
    required this.isBool,
    required this.typeid,
  });

}
