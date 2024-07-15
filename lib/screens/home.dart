import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:repairmodule/models/Lists.dart';
import 'package:repairmodule/screens/settings.dart';

import 'cashHome.dart';
import 'objects.dart';

class scrHomeScreen extends StatefulWidget {
  scrHomeScreen();

  @override
  State<scrHomeScreen> createState() => _scrHomeScreenState();
}

class _scrHomeScreenState extends State<scrHomeScreen> {
  num CashSummaAll = 0;
  int ObjectKol = 0;
  
  Future httpGetInfo() async {
    final _queryParameters = {'userId': Globals.anPhone};
    var _url=Uri(path: '${Globals.anPath}info/', host: Globals.anServer, scheme: 'https', queryParameters: _queryParameters);
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': Globals.anAuthorization
    };
    print(_url.path);
    try {
      var response = await http.get(_url, headers: _headers);
      if (response.statusCode == 200) {
        var notesJson = json.decode(response.body);
        print(notesJson['summa']);
        print(notesJson['objectKol']);
        CashSummaAll = notesJson['summa'];
        ObjectKol = notesJson['objectKol'];
        Globals.setOwnerId(notesJson['ownerId']);
        Globals.setOwnerName(notesJson['ownerName']);
        Globals.setUserId(notesJson['userId']);
        Globals.setUserName(notesJson['userName']);
        Globals.setUserRole(notesJson['userRole']);
        Globals.setUserRoleId(notesJson['userRoleId']);
        Globals.setCompanyId(notesJson['companyId']);
        Globals.setCompanyName(notesJson['companyName']);
        Globals.setCompanyComment(notesJson['companyComment']);
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
          title: Text('РемонтКвартир'),
          centerTitle: true,
          //backgroundColor: Colors.grey[900],
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [
            IconButton(onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => scrSettingsScreen()));
              }, icon: Icon(Icons.settings))],
        ),
        body:
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('${Globals.anCompanyName}', textAlign: TextAlign.right, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
                  Text('${Globals.anUserName}', textAlign: TextAlign.right, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
                  Text('${Globals.anUserRole}', textAlign: TextAlign.right, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Версия: 1.0.0', textAlign: TextAlign.right, style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal, fontStyle: FontStyle.italic)),
                ],
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    child: ListTile(
                      title: Text(
                        'Объекты',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                      subtitle: Text('Информация по действующим объектам'),
                      leading: Icon(Icons.account_balance_sharp),
                      trailing: Text(
                        ObjectKol.toString(),
                        style: TextStyle(fontSize: 18, color: Colors.green),
                      ),
                      onTap: () async {
                        final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => scrObjectsScreen()));
                      },
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text(
                        'Финансы',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                      subtitle: Text('Баланс по организации'),
                      leading: Icon(Icons.currency_ruble_rounded),
                      trailing: Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(CashSummaAll), style: TextStyle(fontSize: 18, color: Colors.green),
                      ),
                      onTap: () async {
                        final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => scrCashHomeScreen()));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ]
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {},
        //   child: Text('+'),
        // )
        //backgroundColor: Colors.grey[900]),
        );
  }
}
