import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:repairmodule/models/Lists.dart';
import 'package:http/http.dart' as http;

import '../../models/ListAccess.dart';
import '../sprList.dart';



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
  String kassaKol = '0';
  bool accessCreatePlat = false;
  bool accessApprovalPlat  = false;
  String kassaApprovedKol = '0';
  bool kassaApprovedEnabled = false;

  List<accessObject> objectList = [];

  Future httpGetListObject() async {
    final _queryParameters = {'userId': Globals.anPhone};

    var _url=Uri(path: '${Globals.anPath}accessuser/${widget.id}', host: Globals.anServer, scheme: 'https', queryParameters: _queryParameters);
    print(_url.path);
    print(Globals.anAuthorization);
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': Globals.anAuthorization
    };

    objectKol = 'Все';
    dogovorKol = '6';
    accessCreatePlat = true;
    kassaKol = '1';
    accessCreatePlat = true;
    kassaApprovedKol = '0';


    try {
      var response = await http.get(_url, headers: _headers);
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        print(response.body.toString());
        var notesJson = json.decode(response.body);
        for (var noteJson in notesJson) {
          objectList.add(accessObject.fromJson(noteJson));
        }
      }
      else
        throw 'Код ответа: ${response.statusCode.toString()}. Ответ: ${response.body}';
    } catch (error) {
      print("Ошибка при формировании списка: $error");
    }
  }

  @override
  void initState() {
    print('initState');
    objectList.clear();

    httpGetListObject().then((value) {
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
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
        body: Column(
          children: [
            Text('${widget.name}', style: TextStyle(fontSize: 16)),
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
              onTap: () {

              },
            ),
            ListTile(
              title: Text('Доступные договора: ', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),),
              subtitle: Text('Список доступных договоров'),
              trailing: Text(dogovorKol, style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),),
              onTap: () {

              },
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
              subtitle: Text('Список доступных касс/счетов для списания при создании платежей'),
              trailing: Text(kassaKol, style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),),
              onTap: () {

              },
            ),
            Divider(),
            ListTile(
              title: Text('Подтверждение платежей:', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),),
              subtitle: Text('Данный функционал в разработке'),
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
            if (accessApprovalPlat)
              ListTile(
                title: Text('Доступные кассы: ', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),),
                subtitle: Text('Список доступных касс/счетов для подтверждения созданных платежей'),
                trailing: Text(kassaApprovedKol, style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),),
                onTap: () {

                },
              ),
            Divider(),
          ],
        ),

    );
  }
}

