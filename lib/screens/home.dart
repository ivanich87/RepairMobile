import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class scrHomeScreen extends StatefulWidget {
  scrHomeScreen();

  @override
  State<scrHomeScreen> createState() => _scrHomeScreenState();
}

class _scrHomeScreenState extends State<scrHomeScreen> {
  Future httpGetInfo() async {
    var _url=Uri(path: '/a/centrremonta/hs/v1/info/', host: 's1.rntx.ru', scheme: 'https');
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': 'Basic YWNlOkF4V3lJdnJBS1prdzY2UzdTMEJP'
    };
    try {
      var response = await http.get(_url, headers: _headers);
      if (response.statusCode == 200) {
        var notesJson = json.decode(response.body);
        print(notesJson);
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
    int CashSummaAll = 2201455;
    return Scaffold(
        appBar: AppBar(
          title: Text('Главная страница'),
          centerTitle: true,
          //backgroundColor: Colors.grey[900],
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.menu))],
        ),
        body: Center(
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
                    '15',
                    style: TextStyle(fontSize: 18, color: Colors.green),
                  ),
                  onTap: () async {
                    final result = await Navigator.pushNamed(
                        context, '/objects', arguments: {
                      'title': 'ListGridScreen',
                      'newTitle': '!!ListGridScreen'
                    });
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
                  trailing: Text('$CashSummaAll', style: TextStyle(fontSize: 18, color: Colors.green),
                  ),
                  onTap: () async {
                    final result =
                        await Navigator.pushNamed(context, '/cashHome', arguments: {'summa': CashSummaAll});
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Text('+'),
        )
        //backgroundColor: Colors.grey[900]),
        );
  }
}
