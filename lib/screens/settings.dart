import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:repairmodule/components/SingleSelections.dart';
import 'package:repairmodule/models/Lists.dart';

import 'connection_edit.dart';

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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
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
            Divider(),
            titleHeader('Данные компании'),
            Card(
              child: ListTile(
                title: Text(
                  'Бригада 43',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
                subtitle: Text('Название компании'),
                leading: Icon(Icons.account_balance),
                trailing: Icon(Icons.edit),
                ),
              ),
            Card(
              child: ListTile(
                title: Text(
                  'Роганов Владимир Иванович',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
                subtitle: Text('Мои данные'),
                leading: Icon(Icons.account_circle),
                trailing: Icon(Icons.info_outline),
                onTap: () {},
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
                onTap: () {},
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
                onTap: () {},
              ),
            ),
          ],
        ),
    );
  }
}
