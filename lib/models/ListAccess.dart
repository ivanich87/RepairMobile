class accessObject {
  String? id;
  String? name;
  String? role;
  String? roleId;

  accessObject({this.id, this.name, this.role, this.roleId});

  accessObject.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    role = json['role'];
    roleId = json['roleId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['role'] = this.role;
    data['roleId'] = this.roleId;
    return data;
  }
}