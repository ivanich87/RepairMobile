import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:repairmodule/components/SingleSelections.dart';
import 'package:repairmodule/models/Lists.dart';
import 'package:repairmodule/screens/profileMan.dart';
import 'package:repairmodule/screens/sprList.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'company_edit.dart';
import 'connection_edit.dart';
import 'logon.dart';

class scrSettingsScreen extends StatefulWidget {
  scrSettingsScreen();

  @override
  State<scrSettingsScreen> createState() => _scrSettingsScreenState();
}

class _scrSettingsScreenState extends State<scrSettingsScreen> {
  num CashSummaAll = 0;
  int ObjectKol = 0;

  Future httpGetInfo() async {
    final _queryParameters = {'userId': Globals.anPhone};
    var _url=Uri(path: '${Globals.anPath}info/', host: Globals.anServer, scheme: 'https', queryParameters: _queryParameters);
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': Globals.anAuthorization
    };
    try {
      var response = await http.get(_url, headers: _headers);
      if (response.statusCode == 200) {
        var notesJson = json.decode(response.body);
        print(notesJson['summa']);
        print(notesJson['objectKol']);
        CashSummaAll = notesJson['summa'];
        ObjectKol = notesJson['objectKol'];
      }
    } catch (error) {
      print("Ошибка при формировании списка: $error");
    }
  }

  Future<bool> httpDeleteUser() async {
    final _queryParameters = {'userId': Globals.anPhone};
    bool result = true;
    bool success = false;
    String message = '';
    var _url=Uri(path: '${Globals.anPath}company/${Globals.anCompanyId}/', host: Globals.anServer, scheme: 'https', queryParameters: _queryParameters);
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': Globals.anAuthorization
    };
    try {
      var response = await http.delete(_url, headers: _headers);
      if (response.statusCode != 200) {
        var notesJson = json.decode(response.body);
        success = notesJson['success'] ?? false;
        message = notesJson['message'] ?? '';
        result = notesJson['response'] ?? false;
        throw message;
      }
    } catch (error) {
      result = false;
      final snackBar = SnackBar(content: Text('$error'),);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    return result;
  }



  @override
  void initState() {
    httpGetInfo().then((value) {
      setState(() {
      });
    });
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Настройки'),
          centerTitle: true,
          //backgroundColor: Colors.grey[900],
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          //actions: [IconButton(onPressed: () {}, icon: Icon(Icons.settings))],
        ),
        body: ListView(
          //mainAxisAlignment: MainAxisAlignment.start,
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(),
            titleHeader('Настройки подключения'),
            Card(
              child: ListTile(
                title: Text(
                  Globals.anServer,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
                subtitle: Text(Globals.anPhone),
                leading: Icon(Icons.connect_without_contact_sharp),
                trailing: Icon(Icons.edit),
                onTap: () {Navigator.push(context, MaterialPageRoute( builder: (context) => scrConnectionEditScreen()));},
              ),
            ),
            Card(
              child: ListTile(
                title: Text(
                  'Выйти из учетной записи',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
                subtitle: Text('Выйти из ${Globals.anUserName}'),
                leading: Icon(Icons.exit_to_app),
                //trailing: Icon(Icons.edit),
                onTap: () async {
                  String userInfoKey = 'userInfoKey';
                  var prefs = await SharedPreferences.getInstance();
                  prefs.remove(userInfoKey);
                  Globals.setLogin('');
                  Globals.setPhone('');
                  Globals.setPasswodr('');
                  Globals.setServer('ut.acewear.ru');
                  Globals.setPath('/repair/hs/v1/');
                  Globals.setCompanyId('');
                  Globals.setCompanyName('');
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                      scrLogonScreen()), (Route<dynamic> route) => false);
                  //Navigator.popUntil(context, );
                  },
              ),
            ),
            Divider(),
            titleHeader('Данные компании'),
            Card(
              child: ListTile(
                title: Text(
                  Globals.anCompanyName,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
                subtitle: Text('Название компании'),
                leading: Icon(Icons.account_balance),
                trailing: Icon(Icons.edit),
                onTap: () async {
                  await Navigator.push(context, MaterialPageRoute(builder: (context) => scrCompanyEditScreen()));
                  setState(() {

                  });
                },
                ),
              ),
            Card(
              child: ListTile(
                title: Text(
                  Globals.anUserName,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
                subtitle: Text('Мои данные'),
                leading: Icon(Icons.account_circle),
                trailing: Icon(Icons.edit),
                onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => scrProfileMan(id: Globals.anUserId,)));},
              ),
            ),
            Divider(),
            titleHeader('Основные справочники'),
            Card(
              child: ListTile(
                title: Text(
                  'Сотрудники',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
                subtitle: Text('Все участники компании'),
                leading: Icon(Icons.list),
                //trailing: Icon(Icons.edit),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => scrListScreen(sprName: 'Сотрудники', onType: 'push')));
                },
              ),
            ),
            Card(
              child: ListTile(
                title: Text(
                  'Контрагенты',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
                subtitle: Text('Партнеры, поставщики, посредники'),
                leading: Icon(Icons.list),
                //trailing: Icon(Icons.edit),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => scrListScreen(sprName: 'КлиентыКонтрагенты', onType: 'push')));
                },
              ),
            ),
            Divider(thickness: 2),
            SizedBox(height: 30,),
            Card(
              child: ListTile(
                title: Text('Удалить аккаунт компании', style: TextStyle(color: Colors.red)),
                leading: Icon(Icons.delete),
                onTap: () async {
                  final _res = await showAlertDialog(context, 'Удалить аккаунт?', 'Все ваши данные, данные компании, данные сотрудников, объекты и документы будут удалены!');
                  if (_res==true) {
                    httpDeleteUser().then((value) {
                      if (value==true)
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => scrLogonScreen()), (Route<dynamic> route) => false);
                    });
                  }
                },
              ),
            )
          ],
        ),
    );
  }
}

Future<bool> showAlertDialog(BuildContext context, String title, String message) async {
  // set up the buttons
  Widget cancelButton = ElevatedButton(
    child: Text('Отмена'),
    onPressed: () {
      // returnValue = false;
      Navigator.of(context).pop(false);
    },
  );
  Widget continueButton = ElevatedButton(
    child: Text('Удалить', style: TextStyle(color: Colors.red)),
    onPressed: () {
      // returnValue = true;
      Navigator.of(context).pop(true);
    },
  ); // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(message),
    actions: [
      cancelButton,
      continueButton,
    ],
  ); // show the dialog
  final result = await showDialog<bool?>(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
  return result ?? false;
}