import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
//
// export 'package:path_provider_platform_interface/path_provider_platform_interface.dart'
//     show StorageDirectory;

import 'package:repairmodule/components/SingleSelections.dart';
import 'package:repairmodule/models/Lists.dart';
import 'package:repairmodule/screens/ReceiptEdit.dart';
import 'package:repairmodule/screens/akt_view.dart';
import 'package:repairmodule/screens/pdf.dart';
import 'package:repairmodule/screens/pdf2.dart';
import 'package:repairmodule/screens/pdf_viewer.dart';
import 'package:repairmodule/screens/plat_edit.dart';
import 'package:repairmodule/screens/profileMan.dart';
import 'package:repairmodule/screens/settings/accessObjects.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../components/Cards.dart';
import 'cashList.dart';
import 'dogovor_create.dart';
import 'objectsListSelectedDog.dart';

class scrDogovorListDDSScreen extends StatefulWidget {
  final String id;
  final String idObject;
  final String number;
  final DateTime dateDog;
  final String idClient;
  final String nameClient;
  final String idManager;
  final String nameManager;
  final String idProrab;
  final String nameProrab;
  final String startDate;
  final String stopDate;
  final String address;
  final num area;
  final String name;

  scrDogovorListDDSScreen({super.key, required this.id, required this.idObject, required this.number, required this.dateDog, required this.idClient, required this.nameClient, required this.idManager, required this.nameManager, required this.idProrab, required this.nameProrab, required this.startDate, required this.stopDate, required this.address, required this.area, required this.name});

  @override
  State<scrDogovorListDDSScreen> createState() => _scrDogovorListDDSScreenState();
}

class _scrDogovorListDDSScreenState extends State<scrDogovorListDDSScreen> with SingleTickerProviderStateMixin {
  List<analyticObjectList> AnalyticObjectList = [];
  List<Akt> aktList = [];

  num summaDown = 0;
  num summaUp = 0;

  String smetaId = '00000000-0000-0000-0000-000000000000';

  num summa = 0;
  num summaSeb = 0;
  num summaAkt = 0;
  num summaOpl=0;
  num percent = 0;
  num payment = 0;
  num area = 0;


  Future httpGetInfoObject() async {
    print('!!!!!!!!!!!!!!!!!!' + widget.id.toString());
    final _queryParameters = {'userId': Globals.anPhone};
    var _url=Uri(path: '${Globals.anPath}doginfo/'+widget.id+'/', host: Globals.anServer, scheme: 'https', queryParameters: _queryParameters);
    print(_url.path);
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': Globals.anAuthorization
    };
    try {
      var response = await http.get(_url, headers: _headers);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        smetaId = data['smetaId'] ?? '00000000-0000-0000-0000-000000000000';

        summa    = data['summa'] ?? 0;
        summaSeb = data['summaSeb'] ?? 0;
        summaAkt = data['summaAkt'] ?? 0;
        summaOpl = data['summaOpl'] ?? 0;

        area = data['area'] ?? 0;
        aktList.clear();
        for (var noteJson in data['akt']) {
          aktList.add(Akt.fromJson(noteJson));
        }
      }
      else {
    print('Код ответа сервера: ' + response.statusCode.toString());
    };
    } catch (error) {
      print("Ошибка при формировании списка: $error");
    }
  }

  Future httpGetAnalyticListObject() async {
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
        AnalyticObjectList.clear();
        var notesJson = json.decode(response.body);
        for (var noteJson in notesJson) {
          AnalyticObjectList.add(analyticObjectList.fromJson(noteJson));
          summaUp=summaUp+AnalyticObjectList[i].summaUp;
          summaDown=summaDown+AnalyticObjectList[i].summaDown;
          i++;
        }
      }
      else
        throw response.body;
    } catch (error) {
      print("Ошибка при формировании списка: $error");
    }
  }


  @override
  void initState() {
    _ref();
    // TODO: implement initState
    super.initState();
  }

_ref(){
  httpGetAnalyticListObject().then((value) async {
    setState(() {
    });
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Аналитика ДДС'),
          centerTitle: false,
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.menu))],
        ),
        body: _pageFinteh(),
        floatingActionButton: _bottomButtons()
        );
  }

  Widget? _bottomButtons() {
    return FloatingActionButton(
        onPressed: () {},
        child: _AddMenuIcon());
  }

  _AddMenuIcon() {
    return PopupMenuButton<Menu>(
        icon: const Icon(Icons.add),
        offset: const Offset(0, 40),
        onSelected: (Menu item) async {
          if (item.name=='check') //если покупка стройматериалов
              {
            Receipt recipientdata = Receipt('', '', DateTime.now(), true, false, false, widget.idClient, widget.nameClient, widget.idObject, widget.address, true, widget.id, widget.number, widget.dateDog, 0, 0, 0, false, '', '', '', 'Расход', 0, '7fa144f2-14ca-11ed-80dd-00155d753c19', 'Покупка стройматериалов', '', '', defaultkassaSotr(Globals.anUserId, true), defaultkassaSotr(Globals.anUserName, false), (defaultkassaSotr(Globals.anUserId, true)=='') ? 0 : 1, 'Покупка стройматериалов', 0, []);
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => scrReceiptEditScreen(receiptData: recipientdata,)));
          }
          else
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => scrPlatEditScreen(plat2: ListPlat('', 'Новый платеж', DateTime.now(), false, '', true, '', widget.idClient, widget.nameClient, useDog(item.name), analyticId(item.name, true), analyticId(item.name, false), 0, 0, 0, widget.idObject, widget.address, widget.id, widget.number, widget.dateDog, useDog(item.name), '', '', defaultkassaSotr(Globals.anUserId, true), defaultkassaSotr(Globals.anUserName, false), (defaultkassaSotr(Globals.anUserId, true)=='') ? 0 : 1, '', '', '', platType(item.name), type(item.name), '', '', '', '', 0, 0, ''),)));
          _ref();
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


  _pageFinteh() {
    return (Globals.anFinTech==false) ? Center(child: Text('Нет доступа')) :
      ListView(
        padding: EdgeInsets.all(4),
        children: [
          SizedBox(height: 8,),
          Center(child: Text(widget.name, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
          SizedBox(height: 4,),
          ObjectTileView(nameClient: widget.nameClient, idClient: widget.idClient, startDate: widget.startDate, stopDate: widget.stopDate, address: widget.address, area: widget.area),
          SizedBox(height: 6,),
          AnalyticObjectList.length==0 ? Container(height:200, child: Center(child: Text('Нет платежей'))) :
          ListView.builder(shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            reverse: false,
            itemCount: AnalyticObjectList.length,
            itemBuilder: (_, index) => CardObjectAnalyticList(event: AnalyticObjectList[index], onType: 'push', objectId: widget.id, objectName: widget.address),
          )
        ],
      );
  }

}

enum Menu { oplataDog, oplataMaterials, platUp, platDown, check, platDownSotr, platUpSotr , platMove}
