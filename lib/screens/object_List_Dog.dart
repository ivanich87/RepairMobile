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

class scrObjectsListDogScreen extends StatefulWidget {
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

  scrObjectsListDogScreen({super.key, required this.id, required this.idClient, required this.nameClient, required this.startDate, required this.stopDate, required this.address, required this.area, required this.idManager, required this.nameManager, required this.idProrab, required this.nameProrab});

  @override
  State<scrObjectsListDogScreen> createState() => _scrObjectsListDogScreenState();
}

class _scrObjectsListDogScreenState extends State<scrObjectsListDogScreen> with SingleTickerProviderStateMixin {
  List<analyticObjectList> AnalyticObjectList = [];
  List<DogListObject> dogList = [];

  bool _visibleFloatingActionButton = true;


  Future httpGetListObject() async {
    dogList.clear();
    final _queryParameters = {'userId': Globals.anPhone};
    var _url=Uri(path: '${Globals.anPath}dogList/${widget.id}/', host: Globals.anServer, scheme: 'https', queryParameters: _queryParameters);
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': Globals.anAuthorization
    };
    try {
      var response = await http.get(_url, headers: _headers);
      if (response.statusCode == 200) {
        var notesJson = json.decode(response.body);
        for (var noteJson in notesJson) {
          dogList.add(DogListObject.fromJson(noteJson));
        }
      }
      else {
        print('Код ответа от сервера: ${response.statusCode}');
        print('Ошибка:  ${response.body}');
      }
    } catch (error) {
      print("Ошибка при формировании списка: $error");
    }
  }

  ref() async {
    await httpGetListObject();
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
          title: Text('Этапы работ/сметы'),
          //bottom: TabBar(controller: _tabController, tabs: _tabs, isScrollable: true,),
          centerTitle: true,
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.menu))],
        ),
        body: _pageDogList(),
        floatingActionButton: _bottomButtons(),
        );
  }

  _pageDogList() {
    return ListView(
      padding: EdgeInsets.all(4),
      children: [
        SizedBox(height: 8,),
        ObjectTileView(nameClient: widget.nameClient, idClient: widget.idClient, startDate: widget.startDate, stopDate: widget.stopDate, address: widget.address, area: widget.area),
        SizedBox(height: 4,),
        dogList.length==0 ? Container(height:200, child: Center(child: Text('Нет договоров'))) :
        ListView.builder(shrinkWrap: true,
          //padding: EdgeInsets.all(10),
          physics: BouncingScrollPhysics(),
          reverse: false,
          itemCount: dogList.length,
          itemBuilder: (_, index) => Card(
            child: ListTile(
              //title: Text('№${dogList[index].Number} от ${DateFormat('dd.MM.yyyy').format(dogList[index].Date)}'),
              title: dogList[index].name!='' ? Text('${dogList[index].name}', style: TextStyle(fontWeight: FontWeight.bold),) : Text('№${dogList[index].Number} от ${DateFormat('dd.MM.yyyy').format(dogList[index].Date)}'),
              subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [Icon(Icons.calendar_month), SizedBox(width: 8,), Text('${DateFormat('dd.MM.yyyy').format(dogList[index].StartDate)} - ${DateFormat('dd.MM.yyyy').format(dogList[index].StopDate)}')],),
                  if (dogList[index].nameExecutor!='')
                    Text('${dogList[index].nameExecutor}')
                ],
              ),
              trailing: Column(
                children: [
                  Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(dogList[index].summa), style: TextStyle(fontSize: 16, color: Colors.green)),
                  Text('${NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 0).format(dogList[index].summa == 0 ? 0 : dogList[index].summaAkt/dogList[index].summa*100)}%', style: TextStyle(fontSize: 16, color: Colors.green)),
                ],
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => scrDogovorViewScreen(id: dogList[index].id)));
              },
            ),
          ),
        )
      ],
    );
  }

  Widget? _bottomButtons() {
    if (Globals.anUserRoleId!=3)
      return null;
    else
      return (Globals.anUserRoleId!=3) ? null : (_visibleFloatingActionButton==false) ? null : FloatingActionButton(
        onPressed: () async {
          DateTimeRange dateRange = DateTimeRange(start: DateTime.now(), end: DateTime.now());
          await Navigator.push(context, MaterialPageRoute(builder: (context) => scrDogovorCreateScreen(objectId: widget.id, objectName: widget.address, clientId: widget.idClient, clientName: widget.nameClient, newDogovorId: '', managerId: widget.idManager, managerName: widget.nameManager, prorabId: widget.idProrab, prorabName: widget.nameProrab, nameDog: '', summa: 0, summaSeb: 0, dateRange: dateRange,),));
          ref();
        },
        child: Icon(Icons.add),
      );
  }

}



