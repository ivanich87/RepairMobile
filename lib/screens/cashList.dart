import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:repairmodule/components/Cards.dart';
import 'package:repairmodule/models/Lists.dart';
import 'package:repairmodule/screens/plat_edit.dart';
//import 'package:repairmodule/components/Cards.dart;
import 'package:http/http.dart' as http;
import 'package:repairmodule/screens/plat_view.dart';

import '../models/httpRest.dart';
import 'ReceiptEdit.dart';
import 'ReceiptView.dart';


class scrCashListScreen extends StatefulWidget {

  final String idCash;
  final String cashName;
  final String analytic;
  final String analyticName;
  final String objectId;
  final String objectName;
  final String platType;
  DateTimeRange dateRange;
  final String kassaSotrId;
  final String kassaSortName;
  final String kassaContractorId;
  final String kassaContractorName;
  final bool selected;
  final bool approve;

  scrCashListScreen({required this.idCash, required this.cashName, required this.analytic, required this.analyticName, required this.objectId, required this.objectName, required this.platType, required this.dateRange, required this.kassaSotrId, required this.kassaSortName, this.kassaContractorId='', this.kassaContractorName='', this.selected = false, this.approve = false});

  @override
  State<scrCashListScreen> createState() => _scrCashListScreenState();
}

class _scrCashListScreenState extends State<scrCashListScreen> {
  //var objectList = [];
  List<ListPlat> objectList = [];


  @override
  void initState() {
    objectList.clear();
    httpGetListPlat(objectList, widget.analytic, widget.objectId, widget.platType, widget.kassaSotrId, widget.kassaContractorId, widget.idCash, widget.approve, widget.dateRange).then((value) {
      setState(() {});
    });
    // TODO: implement initState
    //super.initState();
  }

  Widget build(BuildContext context) {
    final start = widget.dateRange.start;
    final end = widget.dateRange.end;

    return Scaffold(
        appBar: AppBar(
          title: Text('Платежи и переводы'),
          centerTitle: true,
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.menu))
          ],
        ),
        body: Column(
          children: [
            ElevatedButton(onPressed: pickDateRange,
                child: Text(DateFormat('dd.MM.yyyy').format(start) + ' - ' + DateFormat('dd.MM.yyyy').format(end))),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  initState();
                  return Future<void>.delayed(const Duration(seconds: 2));
                },
                child: (objectList.length==0) ? Center(child: Text('Нет платежей')) : ListView.builder(
                  padding: EdgeInsets.all(10),
                  physics: AlwaysScrollableScrollPhysics(),
                  reverse: false,
                  itemCount: objectList.length,
                  itemBuilder: (_, index) =>
                      _cardItem(objectList[index]), //PlatObjectList
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: (Globals.anCreatePlat==false) ? null : FloatingActionButton(
          onPressed: () {},
          child: _AddMenuIcon())
    );

  }

  _cardItem(ListPlat event){
    return Card(
      child: ListTile(
          title: Text('${event.name} № ${event.number} от ${DateFormat('dd.MM.yyyy').format(event.date)}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, decoration: textDelete(event.del)),),
          subtitle: Text(event.comment),
          trailing: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(event.summa), style: TextStyle(fontSize: 16, color: textColors(event.summa), decoration: textDelete(event.del))),
              if (event.accept==false)
                Icon(Icons.warning_amber, color: Colors.amber)
            ],
          ),
          onTap: () async {
            if (widget.selected==true)
              Navigator.pop(context, event.id);
            else {
              await Navigator.push(context, MaterialPageRoute(builder: (context) {
                if (event.type=='Покупка стройматериалов')
                  return scrReceiptViewScreen(id: event.id, event: event);
                else
                  return scrPlatsViewScreen(plat: event);
              }));
              setState(() {
                if (event.del==true) {
                  print('Удаляем этот платеж');
                  //initState();
                }
                print('Пересчет формы');
              });
            }
          },
          onLongPress: () async {
            await Navigator.push(context, MaterialPageRoute(builder: (context) {
              if (event.type=='Покупка стройматериалов')
                return scrReceiptViewScreen(id: event.id, event: event);
              else
                return scrPlatsViewScreen(plat: event);
            }));

            setState(() {
              if (event.del==true) {
                print('Удаляем этот платеж');
                //initState();
              }
              print('Пересчет формы');
            });
          }),
    );

  }

  Future pickDateRange() async {
    DateTimeRange? newDateRange = await showDateRangePicker(locale: Locale("ru", "RU"),
        context: context, firstDate: DateTime(2020), lastDate: DateTime(2050), initialDateRange: widget.dateRange);
    if (newDateRange ==null) return;

    setState(() {
      widget.dateRange = newDateRange;
    });
    initState();
  }

  _AddMenuIcon() {
    return PopupMenuButton<Menu>(
        icon: const Icon(Icons.add),
        offset: const Offset(0, 40),
        onSelected: (Menu item) async {
          if (item.name=='check') //если покупка стройматериалов
              {
            Receipt recipientdata = Receipt('', '', DateTime.now(), true, false, false, '', '', widget.objectId, widget.objectName, true, '', '', DateTime.now(), 0, 0, 0, false, '', '', '', 'Расход', 0, '7fa144f2-14ca-11ed-80dd-00155d753c19', 'Покупка стройматериалов', '', '', defaultkassaSotr(widget.kassaSotrId, true), defaultkassaSotr(widget.kassaSortName, false), (defaultkassaSotr(widget.kassaSotrId, true)=='') ? 0 : 1, 'Покупка стройматериалов', 0, []);
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => scrReceiptEditScreen(receiptData: recipientdata,)));
          }
          else
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => scrPlatEditScreen(plat2: ListPlat('', 'Новый платеж', DateTime.now(), false, '', true, '', '', '', useDog(item.name), (analyticId(item.name, true)=='') ? widget.analytic : analyticId(item.name, true), (analyticId(item.name, false)=='') ? widget.analyticName : analyticId(item.name, false), 0, 0, 0, widget.objectId, widget.objectName, '', '', DateTime.now(), useDog(item.name), '', '', defaultkassaSotr(widget.kassaSotrId, true), defaultkassaSotr(widget.kassaSortName, false), (defaultkassaSotr(widget.kassaSotrId, true)=='') ? 0 : 1, '', '', '', platType(item.name), type(item.name), '', '', '', '', 0, 0),)));

          initState();
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
            value: Menu.platMove,
            child: Text('Перемещение денег'),
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





enum Menu { oplataDog, oplataMaterials, platUp, platDown, check, platDownSotr, platUpSotr , platMove}


String platType(String item) {
  if (item=='platMove')
    return('Перемещение');
  if(item=='oplataDog' || item=='oplataMaterials' || item=='platUp' || item=='platUpSotr')
    return('Приход');
  else
    return('Расход');
}

String type(String item) {
  if (item=='platMove')
    return('Перемещение денежных средств');
  if (item=='oplataDog')
    return('Оплата по договору');
  if (item=='oplataMaterials')
    return('Оплата стройматериалов');
  if (item=='platUp')
    return('Движение денежных средтв');
  if (item=='platDown')
    return('Движение денежных средтв');
  if (item=='platUpSotr')
    return('Выдача денежных средств в подотчет');
  if (item=='platDownSotr')
    return('Выдача денежных средств в подотчет');

  return('неопределено');
}

String analyticId(String item, bool identity) {
  if (item=='oplataDog')
    if (identity==true)
      return('7fa144f5-14ca-11ed-80dd-00155d753c19');
    else
      return('Оплата клиентом отделочных работ');
  if (item=='oplataMaterials')
    if (identity==true)
      return('7fa144fa-14ca-11ed-80dd-00155d753c19');
    else
      return('Оплата клиентом стройматериалов');


  return('');
}

bool useDog(String item) {
  if (item=='platDown' || item=='platUp')
    return(false);

  return(true);
}

String defaultkassaSotr(String kassaSotr, bool identity) {
  String _res=kassaSotr;
  if (_res!='')
    return(_res);

  if (Globals.anUserRoleId!=3 && Globals.anUserRoleId!=4 && Globals.anUserRoleId!=5) {
    if (identity==true)
      _res = Globals.anUserId;
    else
      _res = Globals.anUserName;
  }

  return(_res);

}
