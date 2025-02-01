import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:repairmodule/models/Lists.dart';
import 'package:http/http.dart' as http;

import '../../models/ListAccess.dart';
import '../sprList.dart';
import 'accessUserKassa.dart';



class scrAccessUserScreen extends StatefulWidget {
  final String id;
  final String name;
  final bool access;
  final String role;
  //final String roleId;

  scrAccessUserScreen(this.id, this.name, this.access, this.role);

  @override
  State<scrAccessUserScreen> createState() => _scrAccessUserScreenState();
}

class _scrAccessUserScreenState extends State<scrAccessUserScreen> {
  bool accessEnable = true;
  bool _load = true;
  bool access = false;
  String roleName = '';
  String roleId = '';
  String objectKol = '';
  String dogovorKol = '';
  int objectKolAll=0;
  int dogovorKolAll=0;
  String kassaKol = '0';
  int kassaKolAll = 0;
  bool accessCreatePlat = false;
  bool accessCreateObject=false;
  bool accessApprovalPlat  = false;
  bool accessFinTech = false;
  String kassaApprovedKol = '0';
  int kassaApprovedKolAll=0;
  bool kassaApprovedEnabled = true;
  List<sprListSelected> selectedObject=[];
  List<sprListSelected> selectedDogovor=[];
  List<sprListSelected> selectedKassaPay=[];

  List<accessObject> objectList = [];


  Future httpGetUserAccess() async {
    final _queryParameters = {'userId': Globals.anPhone};

    var _url=Uri(path: '${Globals.anPath}accessuser/${widget.id}', host: Globals.anServer, scheme: 'https', queryParameters: _queryParameters);
    print(_url.path);
    print(Globals.anAuthorization);
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': Globals.anAuthorization
    };

    try {
      var response = await http.get(_url, headers: _headers);
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        print(response.body.toString());
        var notesJson = json.decode(response.body);
        access = notesJson['access'];
        roleName = notesJson['role'];
        roleId = notesJson['roleId'];
        objectKol = notesJson['objectKol'];
        dogovorKol = notesJson['dogovorKol'];
        objectKolAll = notesJson['objectKolAll'];
        dogovorKolAll = notesJson['dogovorKolAll'];
        accessCreatePlat = notesJson['accessCreatePlat'];
        accessCreateObject = notesJson['accessCreateObject'];
        accessFinTech = notesJson['accessFinTech'];

        kassaKol = notesJson['kassaKol'];
        kassaKolAll = notesJson['kassaKolAll'];

        accessApprovalPlat = notesJson['accessApprovalPlat'];
        kassaApprovedKol = notesJson['kassaApprovedKol'];
        kassaApprovedKolAll = notesJson['kassaApprovedKolAll'];

        selectedObject.clear();
        selectedDogovor.clear();
        selectedKassaPay.clear();
        for (var noteJson in notesJson['selectedObject']) {
          selectedObject.add(sprListSelected.fromJson(noteJson));
        }
        for (var noteJson in notesJson['selectedDogovor']) {
          selectedDogovor.add(sprListSelected.fromJson(noteJson));
        }
        for (var noteJson in notesJson['selectedKassaPay']) {
          selectedKassaPay.add(sprListSelected.fromJson(noteJson));
        }
      }
      else
        throw 'Код ответа: ${response.statusCode.toString()}. Ответ: ${response.body}';
    } catch (error) {
      print("Ошибка при формировании списка: $error");
    }
  }

  Future<bool> httpUpdateUserAccess() async {
    bool _result=false;
    final _queryParameters = {'userId': Globals.anPhone};
    var _url=Uri(path: '${Globals.anPath}accessuser/${widget.id}', host: Globals.anServer, scheme: 'https', queryParameters: _queryParameters);
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': Globals.anAuthorization
    };

    var _body = <String, dynamic> {
      'id': widget.id,
      'access': access,
      'roleId': roleId,
      'accessCreateObject': accessCreateObject,
      'accessCreatePlat': accessCreatePlat,
      'accessApprovalPlat': accessApprovalPlat,
      'accessFinTech': accessFinTech,
      'selectedObject': selectedObject!.map((v) => v.toJson()).toList(),
      'selectedDogovor': selectedDogovor!.map((v) => v.toJson()).toList(),
      'selectedKassaPay': selectedKassaPay!.map((v) => v.toJson()).toList()
    };

    try {
      var response = await http.post(_url, headers: _headers, body: json.encode(_body));
      print('Код ответа: ${response.statusCode} Тело ответа: ${response.body}');
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        _result = data['Успешно'] ?? '';
        String _message = data['Сообщение'] ?? '';

        print('Данные пользователя сохранены. Результат:  $_result. Сообщение:  $_message. Код объекта = ${widget.id}');
      }
      else {
        _result = false;
        final snackBar = SnackBar(
          content: Text('${response.body}'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (error) {
      _result = false;
      print("Ошибка  сохранения доступа пользователя: $error");
      _result = false;
      final snackBar = SnackBar(
        content: Text('$error'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    return _result ?? false;
  }


  @override
  void initState() {
    print('initState');
    objectList.clear();

    httpGetUserAccess().then((value) {
      setState(() {
      });
    });
    // TODO: implement initState
    //super.initState();
  }
  Widget build(BuildContext context) {
    if (_load==true) {
      access = widget.access;
      roleName = widget.role;
      if (roleName.length==0)
        roleName='Выберите роль';

      _load = false;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Настройки доступа'),
        centerTitle: true,
      ),
        body: ListView(
          children: [
            Text('${widget.name}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
            Divider(),
            ListTile(
              title: Text('Доступ в приложение:', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),),
              trailing: Switch.adaptive(
                value: access,
                onChanged: !accessEnable
                    ? null
                    : (bool value) {
                  setState(() {
                    access = value;
                  });
                },
              ),
            ),
            Divider(),
            if (access==true) ...[
              ListTile(
                title: Text('Роль: ', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),),
                trailing: Text(roleName, style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),),
                onTap: () async {
                  var res = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) {
                            return scrListScreen(sprName: 'Роли', onType: 'pop');

                          }));
                  setState(() {
                    roleId = res.id;
                    roleName = res.name;
                  });
                },
              ),
              Divider(),
              ListTile(
                title: Text('Доступные объекты: ', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),),
                subtitle: Text('Список доступных объектов'),
                trailing: Text(objectKol, style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),),
                onTap: () async {
                  var res = await Navigator.push(context, MaterialPageRoute(builder: (context) {return scrAccessUserKassaSelectedScreen(sprName: 'Объекты', onType: 'pop', selectedList: selectedObject,);}));
                  if (res!=null)
                  setState(() {
                    selectedObject = res;
                    var objectListAccess = selectedObject.where((element) => element.selected==true).toList();
                    objectKol = '${objectListAccess.length}/${objectKolAll}';
                  });
                },
              ),
              // ListTile(
              //   title: Text('Доступные договора: ', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),),
              //   subtitle: Text('Список доступных договоров'),
              //   trailing: Text(dogovorKol, style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),),
              //   onTap: () {
              //
              //   },
              // ),
              Divider(),
              ListTile(
                title: Text('Вкладка финансы:', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),),
                subtitle: Text('Доступ к информаци ина вкладке финансы в объекте или договоре'),
                trailing: Switch.adaptive(
                  value: accessFinTech,
                  onChanged: !accessEnable
                      ? null
                      : (bool value) {
                    setState(() {
                      accessFinTech = value;
                    });
                  },
                ),
              ),
              Divider(),
              ListTile(
                title: Text('Создание новых объектов:', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),),
                subtitle: Text('Может ли сотрудник создавать новые объекты и договора'),
                trailing: Switch.adaptive(
                  value: accessCreateObject,
                  onChanged: !accessEnable
                      ? null
                      : (bool value) {
                    setState(() {
                      accessCreateObject = value;
                    });
                  },
                ),
              ),
              Divider(),
              ListTile(
                title: Text('Создание платежей:', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),),
                subtitle: Text('Может ли сотрудник создавать новые платежи в приложении'),
                trailing: Switch.adaptive(
                  value: accessCreatePlat,
                  onChanged: !accessEnable
                      ? null
                      : (bool value) {
                    setState(() {
                      accessCreatePlat = value;
                    });
                  },
                ),
              ),
              if (accessCreatePlat)
                ListTile(
                  title: Text('Доступные кассы: ', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),),
                  subtitle: Text('Список доступных касс/счетов для списания при создании платежей. Если нет доступа ни к одному элементу, то он может создавать платежи только из подотчетных стредств.'),
                  trailing: Text(kassaKol, style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),),
                  onTap: () async {
                    var res = await Navigator.push(context, MaterialPageRoute(builder: (context) {return scrAccessUserKassaSelectedScreen(sprName: 'Кассы', onType: 'pop', selectedList: selectedKassaPay,);}));
                    if (res!=null)
                      setState(() {
                        selectedKassaPay = res;
                        var selectedKassaPayAccess = selectedKassaPay.where((element) => element.selected==true).toList();
                        kassaKol = '${selectedKassaPayAccess.length}/${kassaKolAll}';
                      });
                  },
                ),
              Divider(),
              ListTile(
                title: Text('Подтверждение платежей:', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),),
                subtitle: Text('Функция проверки и подтверждения правильности создания платежей прорабами.'),
                trailing: Switch.adaptive(
                  value: accessApprovalPlat,
                  onChanged: !kassaApprovedEnabled
                      ? null
                      : (bool value) {
                    setState(() {
                      accessApprovalPlat = value;
                    });
                  },
                ),
              ),
              // if (accessApprovalPlat)
              //   ListTile(
              //     title: Text('Доступные кассы: ', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),),
              //     subtitle: Text('Список доступных касс/счетов для подтверждения созданных платежей'),
              //     trailing: Text(kassaApprovedKol, style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),),
              //     onTap: () {
              //
              //     },
              //   ),
              Divider(),
              SizedBox(height: 40,)
            ],
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async{
            print('Начало сохранения');
            httpUpdateUserAccess().then((value) {
              Map<String, dynamic> _result = {'access': access, 'role': roleName, 'roleId': roleId};
              if (value==true)
                Navigator.pop(context, _result);
            });
          },
          child: Icon(Icons.save),)
    );
  }
}

