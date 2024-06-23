import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:repairmodule/components/SingleSelections.dart';
import 'package:repairmodule/models/Lists.dart';
import 'package:repairmodule/screens/cashCategories.dart';
import 'package:repairmodule/components/Cards.dart';
import 'package:repairmodule/screens/cashList.dart';
import 'package:repairmodule/screens/sprList_create.dart';

class scrCashHomeScreen extends StatefulWidget {


  scrCashHomeScreen();

  @override
  State<scrCashHomeScreen> createState() => _scrCashHomeScreenState();
}

class _scrCashHomeScreenState extends State<scrCashHomeScreen> {
  var cashKassList = [];
  var cashBankList = [];

  Future httpGetListCash() async {
    var _url=Uri(path: '/a/centrremonta/hs/v1/cashList/', host: 's1.rntx.ru', scheme: 'https');
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': 'Basic YWNlOkF4V3lJdnJBS1prdzY2UzdTMEJP'
    };
    try {
      var response = await http.get(_url, headers: _headers);
      if (response.statusCode == 200) {
        var notesJson = json.decode(response.body);
        for (var noteJson in notesJson) {

          if (ListCash.fromJson(noteJson).tip==1) {
            cashKassList.add(ListCash.fromJson(noteJson));
          };
          if (ListCash.fromJson(noteJson).tip!=1) {
            cashBankList.add(ListCash.fromJson(noteJson));
          };
        }
      }
    } catch (error) {
      print("Ошибка при формировании списка: $error");
    }
  }


  @override
  void initState() {
    cashBankList.clear();
    cashKassList.clear();
    httpGetListCash().then((value) {
      setState(() {
      });
    });
    // TODO: implement initState
    //super.initState();
  }
  Widget build(BuildContext context) {
    final arg = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic> {'summa': 0, 'title': 'Пусто'}) as Map<String, dynamic>;
    num allSumma = arg['summa'];
    return Scaffold(
        appBar: AppBar(
          title: Text('Финансы'),
          centerTitle: true,
          //backgroundColor: Colors.grey[900],
          backgroundColor: Theme
              .of(context)
              .colorScheme
              .inversePrimary,
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.menu))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: RefreshIndicator(
            onRefresh: () async {
              initState();
              return Future<void>.delayed(const Duration(seconds: 1));
            },
            child: ListView(
              //mainAxisAlignment: MainAxisAlignment.start,
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: [
               Divider(),
              //Expanded(child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Банк', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 200, minHeight: 56.0),
                        child: ListView(
                          shrinkWrap: true,
                          padding: EdgeInsets.all(1),
                          physics: BouncingScrollPhysics(),
                          reverse: false,
                          //itemCount: notes.length,
                          //itemBuilder: (_, index) => CardCashList(event: notes[index]),
                          children: cashBankList.map((e) => CardCashList(event: e)).toList(),
                        ),
                      ),
                      Divider(),
                      Text('Касса', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 200, minHeight: 56.0),
                        child: ListView(
                          shrinkWrap: true,
                          padding: EdgeInsets.all(1),
                          physics: BouncingScrollPhysics(),
                          reverse: false,
                          //itemCount: notes.length,
                          //itemBuilder: (_, index) => CardCashList(event: notes[index]),
                          children: cashKassList.map((e) => CardCashList(event: e)).toList(),
                        ),
                      ),
                      Divider(),
                      SizedBox(height: 20,),
                      //Text('Всего: 245800 руб.', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                      ListTile(
                        title: Text.rich(TextSpan(children: [
                          TextSpan(text: 'Всего: ', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                          TextSpan(text: NumberFormat.simpleCurrency(locale: 'ru-RU', decimalDigits: 2).format(allSumma), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)),
                          ],
                        )
                        ),
                        trailing: Icon(Icons.navigate_next),
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  //builder: (context) => scrCashCategoriesScreen(idCash: '0', cashName: 'Все',)));
                                  builder: (context) => scrCashListScreen(idCash: '0', cashName: 'Все', analytic: '', analyticName: '', objectId: '',objectName: '', platType: '', dateRange: DateTimeRange(start: DateTime.now(), end: DateTime.now()),)));
                        },
                      )
                    ],
                  ),
                  //Divider(),
              //),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {print('Нажали кнопку меню');},
          child: _AddMenuIcon(),
        )
    //backgroundColor: Colors.grey[900]),
    );
    }


  _AddMenuIcon() {
    return PopupMenuButton<Menu>(
        icon: const Icon(Icons.add),
        offset: const Offset(0, 40),
        onSelected: (Menu item) async {
          String _sprName = (item.name=='kassa') ? 'Кассы' : 'БанковскиеСчетаОрганизаций';
          sprList _newSpr = sprList('', '', '', '');
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => scrListCreateScreen(sprName: _sprName, sprObject: _newSpr,)));
          initState();
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
          const PopupMenuItem<Menu>(
            value: Menu.kassa,
            child: Text('Создать кассу'),
          ),
          const PopupMenuItem<Menu>(
            value: Menu.bank,
            child: Text('Создать банковский счет'),
          ),
        ]);
  }

  }


enum Menu { kassa, bank}

