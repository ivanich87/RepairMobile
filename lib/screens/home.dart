import 'dart:convert';

import 'package:flutter/material.dart';

class scrHomeScreen extends StatefulWidget {
  scrHomeScreen();

  @override
  State<scrHomeScreen> createState() => _scrHomeScreenState();
}

class _scrHomeScreenState extends State<scrHomeScreen> {
  @override
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
                  subtitle: Text('Денег в кассе'),
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
