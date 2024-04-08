//scrCashCategoriesScreen
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:repairmodule/models/Lists.dart';
import 'package:repairmodule/components/Cards.dart';
import 'package:http/http.dart' as http;


class scrCashCategoriesScreen extends StatefulWidget {

  final String idCash;
  final String cashName;
  scrCashCategoriesScreen({super.key, required this.idCash, required this.cashName});

  @override
  State<scrCashCategoriesScreen> createState() => _scrCashCategoriesScreenState();
}

class _scrCashCategoriesScreenState extends State<scrCashCategoriesScreen> {
  var notes = [];
  var notesPlus = [];
  var notesMinus = [];
  var accountId = '';

  Future httpGetListSklad() async {
    print('idCash = ' + widget.idCash.toString());

    var _url=Uri(path: '/a/centrremonta/hs/v1/cashCategories/'+widget.idCash+'/', host: 's1.rntx.ru', scheme: 'https');
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': 'Basic YWNlOkF4V3lJdnJBS1prdzY2UzdTMEJP'
    };
    print(_url.path);
    try {
      var response = await http.get(_url, headers: _headers);
      if (response.statusCode == 200) {
        var notesJson = json.decode(response.body);
        for (var noteJson in notesJson) {
          if (AccountCategoryMoneyInfo.fromJson(noteJson).summaMinus!=0) {
            notesMinus.add(AccountCategoryMoneyInfo.fromJson(noteJson));
          };
          if (AccountCategoryMoneyInfo.fromJson(noteJson).summaPlus!=0) {
            notesPlus.add(AccountCategoryMoneyInfo.fromJson(noteJson));
          };
          notes.add(AccountCategoryMoneyInfo.fromJson(noteJson));
        }
      }
    } catch (error) {
      print("Ошибка при формировании списка: $error");
    }
  }

  @override
  void initState() {
    httpGetListSklad().then((value) {
      setState(() {
      });
    });
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // final arg = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic> {'accountId': 'Пусто', 'title': 'Пусто'}) as Map<String, dynamic>;
    // accountId = arg['accountId'];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cashName.toString()),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.menu))
        ],
      ),
      body: Column(
        children: [
          Text('Аналитика', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10),
              physics: BouncingScrollPhysics(),
              reverse: false,
              itemCount: notes.length,
              itemBuilder: (_, index) => CardCategorySums(event: notes[index]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: (){
            //httpGetListSklad();
            initState();
          },
          child: Icon(Icons.add),
          ),
    );
  }
}

// class test extends StatefulWidget {
//   final int ids;
//   const test({super.key, required this.ids});
//
//   @override
//   State<test> createState() => _testState();
// }
//
// class _testState extends State<test> {
//   @override
//   Widget build(BuildContext context) {
//     print(widget.ids.toString());
//     return const Placeholder();
//   }
// }
