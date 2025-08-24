import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:repairmodule/components/SingleSelections.dart';
import 'package:repairmodule/models/Lists.dart';
import 'package:repairmodule/screens/ReceiptEdit.dart';
import 'package:repairmodule/screens/dogovor_create.dart';
import 'package:repairmodule/screens/dogovor_view.dart';
import 'package:repairmodule/screens/plat_edit.dart';
import 'package:repairmodule/screens/profileMan.dart';
import 'package:repairmodule/screens/settings/accessObjects.dart';

import '../components/Cards.dart';
import 'cashList.dart';
import 'object_edit.dart';
import 'objectsListSelectedDog.dart';

import 'package:url_launcher/url_launcher.dart';

class scrObjectsListDDSScreen extends StatefulWidget {
  final String id;
  final num summaDown;
  final num summaUp;
  final num summa;
  final num summaOpl;
  final String address;

  scrObjectsListDDSScreen({super.key, required this.id, required this.summaDown, required this.summaUp, required this.summa, required this.summaOpl, required this.address});

  @override
  State<scrObjectsListDDSScreen> createState() => _scrObjectsListDDSScreenState();
}

class _scrObjectsListDDSScreenState extends State<scrObjectsListDDSScreen> with SingleTickerProviderStateMixin {
  List<analyticObjectList> AnalyticObjectList = [];
  List<DogListObject> dogList = [];

  bool _visibleFloatingActionButton = true;


  Future httpGetAnalyticListObject() async {
    AnalyticObjectList.clear();

    int i =0;
    final _queryParameters = {'userId': Globals.anPhone};
    var _url=Uri(path: '${Globals.anPath}analyticinfo/${widget.id}/', host: Globals.anServer, scheme: 'https', queryParameters: _queryParameters);
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': Globals.anAuthorization
    };
    try {
      var response = await http.get(_url, headers: _headers);
      print('Код ответа от запроса аналитик: ' + response.statusCode.toString());
      if (response.statusCode == 200) {
        var notesJson = json.decode(response.body);
        for (var noteJson in notesJson) {
          AnalyticObjectList.add(analyticObjectList.fromJson(noteJson));
          i++;
        }
      }
      else
        throw response.body;
    } catch (error) {
      print("Ошибка при формировании списка: $error");
    }
  }


  ref() async {
    await httpGetAnalyticListObject();
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
    return Scaffold(
        appBar: AppBar(
          title: Text('Аналитика ДДС'),
          //bottom: TabBar(controller: _tabController, tabs: _tabs, isScrollable: true,),
          centerTitle: true,
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.menu))],
        ),
        body: _pageDDSList(),
        floatingActionButton: _bottomButtons(),
        );
  }

  _pageDDSList() {
    return ListView(
      padding: EdgeInsets.all(8),
      children: [
        SizedBox(height: 8,),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          child: Center(
            child: Text(widget.address, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ),
        ),
        SizedBox(height: 4,),
        Card(
          child: Column(
            children: [
              _CustomListTile(
                title: 'Баланс',
                trailing: Text('${NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(widget.summaUp-widget.summaDown)} руб.', style: TextStyle(fontSize: 14, color: textColors(widget.summaUp-widget.summaDown)),),
                icon: null,//Icons.trending_neutral,
                id: '', idType: '',
              ),
              _CustomListTile(
                title: 'Поступления',
                trailing: Text('${NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(widget.summaUp)} руб.', style: TextStyle(fontSize: 14, color: textColors(widget.summaUp)),),
                icon: null,//Icons.trending_neutral,
                id: '', idType: '',
              ),
              _CustomListTile(
                title: 'Расходы',
                trailing: Text('${NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(widget.summaDown)} руб.', style: TextStyle(fontSize: 14, color: textColors(-widget.summaDown)),),
                icon: null,//Icons.trending_neutral,
                id: '', idType: '',
              ),
              _CustomListTile(
                title: 'Маржа',
                trailing: Text('${NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format((widget.summaUp!=0) ? (widget.summaUp-widget.summaDown)/widget.summaUp*100 : 0)}%', style: TextStyle(fontSize: 14),),
                icon: null,//Icons.trending_neutral,
                id: '', idType: '',
              ),
              _CustomListTile(
                title: 'Сумма смет',
                trailing: Text('${NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(widget.summa)} руб.', style: TextStyle(fontSize: 14),),
                icon: null,//Icons.trending_neutral,
                id: '', idType: '',
              ),
              _CustomListTile(
                title: 'Остаток выплат',
                trailing: Text('${NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(widget.summa-widget.summaOpl)} руб.', style: TextStyle(fontSize: 14, color: textColors(widget.summaOpl-widget.summa)),),
                icon: null,//Icons.trending_neutral,
                id: '', idType: '',
              )
            ],
          ),
        ),
        SizedBox(height: 6,),
        titleHeader('Статьи расходов'),
        AnalyticObjectList.length==0 ? Container(height:200, child: Center(child: Text('Нет платежей по объекту'))) :
        ListView.builder(shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          reverse: false,
          itemCount: AnalyticObjectList.length,
          itemBuilder: (_, index) => CardObjectAnalyticList(event: AnalyticObjectList[index], onType: 'push', objectId: widget.id, objectName: widget.address),
        )
      ],
    );
  }

  Widget? _bottomButtons() {
    if (Globals.anUserRoleId!=3)
      return null;
    else
      return (Globals.anUserRoleId!=3) ? null : (_visibleFloatingActionButton==false) ? null : FloatingActionButton(
          onPressed: () {},
          child: _AddMenuIcon());;
  }

  _AddMenuIcon() {
    return PopupMenuButton<Menu>(
        icon: const Icon(Icons.add),
        offset: const Offset(0, 40),
        onSelected: (Menu item) async {
          if (item.name=='check') //если покупка стройматериалов
              {
            Receipt recipientdata = Receipt('', '', DateTime.now(), true, false, false, '', '', widget.id, widget.address, true, '', '', DateTime.now(), 0, 0, 0, false, '', '', '', 'Расход', 0, '7fa144f2-14ca-11ed-80dd-00155d753c19', 'Покупка стройматериалов', '', '', defaultkassaSotr(Globals.anUserId, true), defaultkassaSotr(Globals.anUserName, false), (defaultkassaSotr(Globals.anUserId, true)=='') ? 0 : 1, 'Покупка стройматериалов', 0, []);
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => scrReceiptEditScreen(receiptData: recipientdata,)));
          }
          else
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => scrPlatEditScreen(plat2: ListPlat('', 'Новый платеж', DateTime.now(), false, '', true, '', '', '', useDog(item.name), analyticId(item.name, true), analyticId(item.name, false), 0, 0, 0, widget.id, widget.address, '', '', DateTime.now(), useDog(item.name), '', '', defaultkassaSotr(Globals.anUserId, true), defaultkassaSotr(Globals.anUserName, false), (defaultkassaSotr(Globals.anUserId, true)=='') ? 0 : 1, '', '', '', platType(item.name), type(item.name), '', '', '', '', 0, 0, ''),)));
          ref();
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


class _CustomListTile extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Widget? trailing;
  final String id;
  final String idType;

  const _CustomListTile(
      {Key? key, required this.title, required this.icon, this.trailing, required this.id, required this.idType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(dense: false, visualDensity: VisualDensity(vertical: -4),
      title: Text(title ?? 'ggg'),
      leading: (icon==null ? null: Icon(icon)),
      trailing: trailing,
      onTap: () {
        if (id != '') {
          if (idType=='objectsListSelectedDog') {
            Map valueMap = json.decode(id);
            Navigator.push(context, MaterialPageRoute(builder: (context) => objectsListSelectedDog(objectId: valueMap['objectId'], objectName: valueMap['objectName'], clientId: valueMap['clientId'],  clientName: valueMap['clientName'],onType: 'push',)));
          }
          if (idType=='scrProfileMan')
              Navigator.push(context, MaterialPageRoute(builder: (context) => scrProfileMan(id: id,)));
        }
      },
    );
  }

}

enum Menu { oplataDog, oplataMaterials, platUp, platDown, check, platDownSotr, platUpSotr , platMove}
