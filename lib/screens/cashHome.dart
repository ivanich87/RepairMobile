import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:repairmodule/components/SingleSelections.dart';
import 'package:repairmodule/models/Lists.dart';
import 'package:repairmodule/models/httpRest.dart';
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
  List<accountableFounds> AccountableFounds = [];
  List<accountableFounds> AccountableContractor = [];

  num AccountableFoundsBalance = 0;
  num AccountableContractorBalance=0;
  num allSumma = 0 ;

  ref() async {
    AccountableFoundsBalance=0;
    AccountableContractorBalance=0;
    allSumma=0;
    await httpGetListBalance(cashBankList, cashKassList, AccountableFounds, AccountableContractor);
    for (var ded in AccountableFounds) {
      AccountableFoundsBalance = AccountableFoundsBalance + ded.summa;
    }

    for (var ded in cashKassList) {
      allSumma = allSumma + ded.summa;
    }
    for (var ded in cashBankList) {
      allSumma = allSumma + ded.summa;
    }
    for (var ded in AccountableContractor) {
      AccountableContractorBalance = AccountableContractorBalance + ded.summa;
    }
    setState(() {
    });
  }
  @override
  void initState() {
    ref();
    // TODO: implement initState
    //super.initState();
  }
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(tabs: _tabs, isScrollable: true,),
            title: Text('Финансы'),
            centerTitle: true,
            actions: [
              IconButton(onPressed: () {}, icon: Icon(Icons.menu))
            ],
          ),
          body: TabBarView(
            children: <Widget> [
              _OneScreenTab(),
              _TwoScreenTab(),
              _ThreeScreenTab()
            ],),
            floatingActionButton: FloatingActionButton(
              onPressed: () {print('Нажали кнопку меню');},
              child: _AddMenuIcon(),
          )
      //backgroundColor: Colors.grey[900]),
      ),
    );
    }

  _OneScreenTab() {
    return RefreshIndicator(
      onRefresh: () async {
        initState();
        return Future<void>.delayed(const Duration(seconds: 1));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
                    TextSpan(text: NumberFormat.simpleCurrency(locale: 'ru-RU', decimalDigits: 2).format(allSumma), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColors(allSumma))),
                  ],
                  )
                  ),
                  trailing: Icon(Icons.navigate_next),
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => scrCashListScreen(idCash: '0', cashName: 'Все', analytic: '', analyticName: '', objectId: '',objectName: '', platType: '', dateRange: DateTimeRange(start: DateTime.now(), end: DateTime.now()), kassaSotrId: '', kassaSortName: '',)));
                  },
                ),
              ],
            ),
            //Divider(),
            //),
          ],
        ),
      ),
    );
  }

  _TwoScreenTab() {
    return RefreshIndicator(
      onRefresh: () async {
        initState();
        return Future<void>.delayed(const Duration(seconds: 1));
      },
      child: Container(
        child: Column(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 500, minHeight: 200.0),
              child: ListView.builder(
                padding: EdgeInsets.all(10),
                physics: AlwaysScrollableScrollPhysics(),
                reverse: false,
                shrinkWrap: true,
                itemCount: AccountableFounds.length,
                itemBuilder: (_, index) {
                  return Card(
                    child: ListTile(
                      title: Text(AccountableFounds[index].name, style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18)),
                      trailing: Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(AccountableFounds[index].summa), style: TextStyle(fontSize: 16, color: textColors(AccountableFounds[index].summa))),
                      onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => scrCashListScreen(idCash: '0', cashName: 'Все', analytic: '', analyticName: '', objectId: '', objectName: '', platType: '', dateRange: DateTimeRange(start: DateTime(2023), end: DateTime.now()), kassaSotrId: AccountableFounds[index].id, kassaSortName: AccountableFounds[index].name,  )));},
                    ),
                  );
                }
              ),
            ),
            Expanded(
              child: ListTile(
                title: Text.rich(TextSpan(children: [
                  TextSpan(text: 'Всего: ', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  TextSpan(text: NumberFormat.simpleCurrency(locale: 'ru-RU', decimalDigits: 2).format(AccountableFoundsBalance), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColors(AccountableFoundsBalance))),
                ],
                )
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _ThreeScreenTab() {
    return RefreshIndicator(
      onRefresh: () async {
        initState();
        return Future<void>.delayed(const Duration(seconds: 1));
      },
      child: Container(
        child: Column(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 500, minHeight: 200.0),
              child: ListView.builder(
                  padding: EdgeInsets.all(10),
                  physics: AlwaysScrollableScrollPhysics(),
                  reverse: false,
                  shrinkWrap: true,
                  itemCount: AccountableContractor.length,
                  itemBuilder: (_, index) =>
                      Card(
                        child: ListTile(
                          title: Text(AccountableContractor[index].name, style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18)),
                          trailing: Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(AccountableContractor[index].summa), style: TextStyle(fontSize: 16, color: textColors(AccountableContractor[index].summa))),
                          onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => scrCashListScreen(idCash: '0', cashName: 'Все', analytic: '', analyticName: '', objectId: '', objectName: '', platType: '', dateRange: DateTimeRange(start: DateTime(2023), end: DateTime.now()), kassaSotrId: '', kassaSortName: '', kassaContractorId: AccountableContractor[index].id, kassaContractorName: AccountableContractor[index].name,  )));},
                        ),
                      )
              ),
            ),
            Expanded(
              child: ListTile(
                title: Text.rich(TextSpan(children: [
                  TextSpan(text: 'Всего: ', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  TextSpan(text: NumberFormat.simpleCurrency(locale: 'ru-RU', decimalDigits: 2).format(AccountableContractorBalance), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColors(AccountableContractorBalance))),
                ],
                )
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _AddMenuIcon() {
    return PopupMenuButton<Menu>(
        icon: const Icon(Icons.add),
        offset: const Offset(0, 40),
        onSelected: (Menu item) async {
          String _sprName = (item.name=='kassa') ? 'Кассы' : 'БанковскиеСчетаОрганизаций';
          sprList _newSpr = sprList('', '', '', '', false, false);
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

const _tabs = [
  Tab(icon: Icon(Icons.account_balance),
      text: "Деньги фирмы",
  ),
  Tab(icon: Icon(Icons.emoji_people),
    text: "Подотчетные средства"),
  Tab(icon: Icon(Icons.people),
      text: "Контрагенты")
];

enum Menu { kassa, bank}

