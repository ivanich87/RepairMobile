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

class scrDogovorListAktScreen extends StatefulWidget {
  final String id;
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

  scrDogovorListAktScreen({super.key, required this.id, required this.idClient, required this.nameClient, required this.idManager, required this.nameManager, required this.idProrab, required this.nameProrab, required this.startDate, required this.stopDate, required this.address, required this.area, required this.name});

  @override
  State<scrDogovorListAktScreen> createState() => _scrDogovorListAktScreenState();
}

class _scrDogovorListAktScreenState extends State<scrDogovorListAktScreen> with SingleTickerProviderStateMixin {
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
  httpGetInfoObject().then((value) async {
    await httpGetAnalyticListObject();

    setState(() {
    });
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Акты выполненных работ'),
          centerTitle: false,
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.menu))],
        ),
        body: _pageComplit(),
        floatingActionButton: _bottomButtons()
        );
  }

  Widget? _bottomButtons() {
    return FloatingActionButton(
          onPressed: () async {
            await Navigator.push(context, MaterialPageRoute(builder: (context) => scrAktViewScreen(Akt('0', '', DateTime.now(), false, false, false, true, '956d8376-8b56-400a-ab32-1788d71dbb15', 'На согласовании', widget.id, smetaId, DateTime.now(), DateTime.now(), 0, 0))));
            await httpGetInfoObject();
            setState(() {

            });
          },
          child: Icon(Icons.add),
        );
  }


  _pageComplit() {
    return ListView(
      padding: EdgeInsets.all(4),
      children: [
        SizedBox(height: 8,),
        Center(child: Text(widget.name, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
        SizedBox(height: 4,),
        ObjectTileView(nameClient: widget.nameClient, idClient: widget.idClient, startDate: widget.startDate, stopDate: widget.stopDate, address: widget.address, area: widget.area),
        SizedBox(height: 6,),
        aktList.length==0 ? Container(height:200, child: Center(child: Text('Нет актов'))) :
        ListView.builder(shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          reverse: false,
          itemCount: aktList.length,
          itemBuilder: (_, index) =>
              Card(
                child: ListTile(
                  title: Text('Акт ${aktList[index].number} от ${DateFormat('dd.MM.yyyy').format(aktList[index].date)}'),
                  trailing: Column(
                    children: [
                      Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(aktList[index].summa), style: TextStyle(fontSize: 18, color: Colors.green)),
                      Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(aktList[index].seb), style: TextStyle(fontSize: 18, color: Colors.red)),
                    ],
                  ),
                  //subtitle: Text(objectList[index].name, textAlign: TextAlign.center,),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => scrAktViewScreen(aktList[index])));
                  },
                ),
              ),
        )
      ],
    );
  }

}

