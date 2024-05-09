import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:repairmodule/components/Cards.dart';
import 'package:repairmodule/models/Lists.dart';
import 'package:repairmodule/screens/plat_edit.dart';
//import 'package:repairmodule/components/Cards.dart;
import 'package:http/http.dart' as http;


class scrCashListScreen extends StatefulWidget {

  final String idCash;
  final String cashName;

  scrCashListScreen({required this.idCash, required this.cashName});

  @override
  State<scrCashListScreen> createState() => _scrCashListScreenState();
}

class _scrCashListScreenState extends State<scrCashListScreen> {
  var objectList = [];
  DateTimeRange dateRange = DateTimeRange(
      start: DateTime.now(), end: DateTime.now());

  Future httpGetListPlat() async {
    var _url = Uri(path: '/a/centrremonta/hs/v1/platlist/${DateFormat('yyyyMMdd').format(dateRange.start)}/${DateFormat('yyyyMMdd').format(dateRange.end)}/',
        host: 's1.rntx.ru',
        scheme: 'https');
    var _headers = <String, String>{
      'Accept': 'application/json',
      'Authorization': 'Basic YWNlOkF4V3lJdnJBS1prdzY2UzdTMEJP'
    };
    try {
      var response = await http.get(_url, headers: _headers);
      if (response.statusCode == 200) {
        var notesJson = json.decode(response.body);
        for (var noteJson in notesJson) {
          objectList.add(ListPlat.fromJson(noteJson));
        }
      }
    } catch (error) {
      print("Ошибка при формировании списка платежей: $error");
    }
  }

  @override
  void initState() {
    httpGetListPlat().then((value) {
      setState(() {});
    });
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    final start = dateRange.start;
    final end = dateRange.end;

    print(objectList.length.toString());

    return Scaffold(
        appBar: AppBar(
          title: Text('Платежи и переводы'),
          centerTitle: true,
          backgroundColor: Theme
              .of(context)
              .colorScheme
              .inversePrimary,
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.menu))
          ],
        ),
        body: Column(
          children: [
            ElevatedButton(onPressed: pickDateRange,
                child: Text(DateFormat('dd.MM.yyyy').format(start) + ' - ' + DateFormat('dd.MM.yyyy').format(end))),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(10),
                physics: BouncingScrollPhysics(),
                reverse: false,
                itemCount: objectList.length,
                itemBuilder: (_, index) =>
                    PlatObjectList(event: objectList[index]),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: _AddMenuIcon())
      //backgroundColor: Colors.grey[900]),
    );
  }

  Future pickDateRange() async {
    DateTimeRange? newDateRange = await showDateRangePicker(
        context: context, firstDate: DateTime(2020), lastDate: DateTime(2050), initialDateRange: dateRange);
    if (newDateRange ==null) return;

    setState(() {
      dateRange = newDateRange;
    });
    initState();
  }
}

enum Menu { oplataDog, oplataMaterials, platUp, platDown, check, platDownSotr, platUpSotr }

class _AddMenuIcon extends StatelessWidget {
  const _AddMenuIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Menu>(
        icon: const Icon(Icons.add),
        offset: const Offset(0, 40),
        onSelected: (Menu item) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => scrPlatEditScreen(plat2: ListPlat('', '', DateTime.now(), false, '', true, '', '', '', true, '', '', 0, 0, 0, '', 'Не выбран', '', '', DateTime.now(), true,'', '', '', '', 0, '', '', '', 'Приход', ''),)));
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
          const PopupMenuItem<Menu>(
            value: Menu.oplataDog,
            child: Text('Оплата от клиента по договору'),
          ),
          const PopupMenuItem<Menu>(
            value: Menu.oplataMaterials,
            child: Text('Оплата от клиента за материалы'),
          ),
          const PopupMenuItem<Menu>(
            value: Menu.platUp,
            child: Text('Поступление денег'),
          ),
          const PopupMenuItem<Menu>(
            value: Menu.platDown,
            child: Text('Списание денег'),
          ),
          const PopupMenuItem<Menu>(
            value: Menu.check,
            child: Text('Покупка стройматериалов'),
          ),
          const PopupMenuItem<Menu>(
            value: Menu.platDownSotr,
            child: Text('Выдача в подотчет'),
          ),
          const PopupMenuItem<Menu>(
            value: Menu.platUpSotr,
            child: Text('Возврат из подотчета'),
          ),
        ]);
  }
}
