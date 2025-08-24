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
import 'package:repairmodule/screens/object_List_DDS.dart';
import 'package:repairmodule/screens/object_List_Dog.dart';
import 'package:repairmodule/screens/plat_edit.dart';
import 'package:repairmodule/screens/profileMan.dart';
import 'package:repairmodule/screens/settings/accessObjects.dart';

import '../components/Cards.dart';
import 'cashList.dart';
import 'object_edit.dart';
import 'objectsListSelectedDog.dart';

import 'package:url_launcher/url_launcher.dart';

class scrObjectsViewScreen extends StatefulWidget {
  final String id;
  scrObjectsViewScreen({super.key, required this.id});

  @override
  State<scrObjectsViewScreen> createState() => _scrObjectsViewScreenState();
}

class _scrObjectsViewScreenState extends State<scrObjectsViewScreen> with SingleTickerProviderStateMixin {
  List<analyticObjectList> AnalyticObjectList = [];
  List<DogListObject> dogList = [];

  num summaDown = 0;
  num summaUp = 0;

  num avgRab = 0;
  num avgMat = 0;

  String address = '';
  String name = '';
  String nameClient = '';
  String emailClient = '';
  String phoneClient = '';
  String idClient = '';
  String nameManager = '';
  String idManager = '';
  String nameProrab = '';
  String idProrab = '';
  String startDate = '20010101';
  String stopDate = '20010101';
  num summa = 0;
  num summaSeb = 0;
  num summaAkt = 0;
  num summaOpl = 0;
  int percent = 0;
  int payment = 0;
  num area = 0;
  bool _visibleFloatingActionButton = true;

  Future httpGetInfoObject() async {
    print('!!!!!!!!!!!!!!!!!!' + widget.id.toString());
    final _queryParameters = {'userId': Globals.anPhone};
    var _url=Uri(path: '${Globals.anPath}obinfo/'+widget.id+'/', host: Globals.anServer, scheme: 'https', queryParameters: _queryParameters);
    print(_url.path);
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': Globals.anAuthorization
    };
    try {
      var response = await http.get(_url, headers: _headers);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        //id = data['id'] ?? 'no id';
        name = data['nameObject'] ?? '';
        nameClient = data['nameClient'] ?? '';
        phoneClient = data['phoneClient'] ?? '';
        emailClient = data['emailClient'] ?? '';
        idClient = data['idClient'] ?? '';
        nameManager = data['nameManager'] ?? '';
        idManager = data['idManager'] ?? '';
        nameProrab = data['nameProrab'] ?? '';
        idProrab = data['idProrab'] ?? '';
        address = data['address'] ?? '';

        avgRab = data['avgRab'] ?? 0;
        avgMat = data['avgMat'] ?? 0;

        startDate = DateFormat('dd-MM-yyyy').format(DateTime.parse(data['StartDate']));
        stopDate = DateFormat('dd-MM-yyyy').format(DateTime.parse(data['StopDate']));

        summa = data['summa'];
        summaSeb = data['summaSeb'];
        summaAkt = data['summaAkt'];
        summaOpl = data['summaOpl'];

        area = data['area'];


        // final s4 = double.parse(data['ПроцентВыпол нения'].toString());
        // percent = s4.toInt();
        //
        // final s5 = double.parse(data['ПроцентВыполнения'].toString());
        // payment = s5.toInt();
      }
      else {
    print('Код ответа сервера: ' + response.statusCode.toString());
    };
    } catch (error) {
      print("Ошибка при формировании списка: $error");
    }
  }

  Future httpGetAnalyticListObject() async {
    AnalyticObjectList.clear();
    summaUp=0;
    summaDown=0;

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
    //httpGetListObject();
    await httpGetInfoObject();
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
          title: Text('Карточка объекта'),
          //bottom: TabBar(controller: _tabController, tabs: _tabs, isScrollable: true,),
          centerTitle: true,
          actions: <Widget>[_menuAppBar()],
        ),
        body: _pageGeneral(),
        floatingActionButton: _bottomButtons(),
        );
  }

  _pageGeneral() {
    return RefreshIndicator(
      onRefresh: () async {
        ref();
        return Future<void>.delayed(const Duration(seconds: 2));
      },
      child: ListView(padding: EdgeInsets.symmetric(horizontal: 4),
        children: [
          SizedBox(height: 8,),
          ObjectTileView(nameClient: nameClient, idClient: idClient, startDate: startDate, stopDate: stopDate, address: address, area: area),
          SizedBox(height: 4,),
          Card(
              child: Column(
                children: [
                  _CustomListTile(
                      title: nameProrab,
                      icon: Icons.hardware_sharp,
                      id: idProrab, idType: 'scrProfileMan'),
                  _CustomListTile(
                      title: nameManager,
                      icon: Icons.headset_mic_sharp,
                      id: idManager, idType: 'scrProfileMan'),
                ],
              )
          ),
          SizedBox(height: 4,),
          Card(
            child: Column(
              children: [
                _CustomListTile(
                  title: 'Баланс',
                  trailing: Text('${NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(summaUp-summaDown)} руб.', style: TextStyle(fontSize: 14, color: textColors(summaUp-summaDown))),
                  icon: null,//Icons.trending_neutral,
                  id: '', idType: '',
                ),
                _CustomListTile(
                  title: 'Поступления',
                  trailing: Text('${NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(summaUp)} руб.', style: TextStyle(fontSize: 14, color: textColors(summaUp)),),
                  icon: null,//Icons.trending_neutral,
                  id: '', idType: '',
                ),
                _CustomListTile(
                  title: 'Расходы',
                  trailing: Text('${NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(summaDown)} руб.', style: TextStyle(fontSize: 14, color: textColors(-summaDown)),),
                  icon: null,//Icons.trending_neutral,
                  id: '', idType: '',
                ),
                _CustomListTile(
                  title: 'Маржа',
                  trailing: Text('${NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format((summaUp!=0) ? (summaUp-summaDown)/summaUp*100 : 0)}%', style: TextStyle(fontSize: 14),),
                  icon: null,//Icons.trending_neutral,
                  id: '', idType: '',
                ),
                _CustomListTile(
                  title: 'Сумма смет',
                  trailing: Text('${NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(summa)} руб.', style: TextStyle(fontSize: 14),),
                  icon: null,//Icons.trending_neutral,
                  id: '', idType: '',
                ),
                _CustomListTile(
                  title: 'Остаток выплаты',
                  trailing: Text('${NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(summa-summaOpl)} руб.', style: TextStyle(fontSize: 14, color: textColors(summaOpl-summa)),),
                  icon: null,//Icons.trending_neutral,
                  id: '', idType: '',
                )
              ],
            ),
          ),
          SizedBox(height: 4,),
          Card(
            child: Column(
              children: [
                _CustomListTile(
                  title: 'Стоимость работ м2',
                  trailing: Text('${NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(avgRab)} руб.', style: TextStyle(fontSize: 14),),
                  icon: null,//Icons.trending_neutral,
                  id: '', idType: '',
                ),
                _CustomListTile(
                  title: 'Стоимость материалов м2',
                  trailing: Text('${NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(avgMat)} руб.', style: TextStyle(fontSize: 14),),
                  icon: null,//Icons.trending_neutral,
                  id: '', idType: '',
                )
              ],
            )
            ,
          ),
          SizedBox(height: 4,),
          Card(
            child: ListTile(
              title: Text('Этапы работ/сметы'),
              trailing: Icon(Icons.navigate_next),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => scrObjectsListDogScreen(id: widget.id, address: address, area: area, idClient: idClient, nameClient: nameClient, idManager: idManager,nameManager: nameManager, idProrab: idProrab, nameProrab: nameProrab, startDate: startDate, stopDate: stopDate)));
              },
            ),
          ),
          SizedBox(height: 4,),
          Card(
            child: ListTile(
              title: Text('Аналитика ДДС'),
              trailing: Icon(Icons.navigate_next),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => scrObjectsListDDSScreen(id: widget.id, summa: summa, summaDown: summaDown, summaOpl: summaOpl,summaUp: summaUp, address: address,)));
              },
            ),
          ),
          SizedBox(height: 4,),
          Card(
            child: ListTile(
              title: Text('План производства работ'),
              trailing: Icon(Icons.navigate_next),
              onTap: (){
                //Navigator.push(context, MaterialPageRoute(builder: (context) => scrProfileMan(id: idClient,)));
                final snackBar = SnackBar(content: Text('Кнопка в разработке'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            ),
          ),
          SizedBox(height: 4,),
          Card(
            child: ListTile(
              title: Text('Документы'),
              trailing: Icon(Icons.navigate_next),
              onTap: (){
                //Navigator.push(context, MaterialPageRoute(builder: (context) => scrProfileMan(id: idClient,)));
                final snackBar = SnackBar(content: Text('Кнопка в разработке'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            ),
          ),
          SizedBox(height: 8,),
        ],
      ),
    );
  }

  Widget? _bottomButtons() {
    if (Globals.anUserRoleId!=3)
      return null;
    else
      return (Globals.anUserRoleId!=3) ? null : (_visibleFloatingActionButton==false) ? null : FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) => scrObjectEditScreen(objectId: widget.id, clientId: idClient, clientName: nameClient, clientEMail: emailClient, clientPhone: phoneClient, address: address, area: area),));
          ref();
        },
        child: Icon(Icons.edit),
      );
  }

  PopupMenuButton<Menu> _menuAppBar() {
    return PopupMenuButton<Menu>(
        icon: const Icon(Icons.menu, ),
        offset: const Offset(0, 40),
        onSelected: (Menu item) async {
          if (item == Menu.itemAccess) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => scrAccessObjectsScreen(widget.id, address)));
          }
          if (item == Menu.itemOther) {

          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
          const PopupMenuItem<Menu>(
            value: Menu.itemAccess,
            child: Text('Настройки доступа'),
          ),
          // const PopupMenuItem<Menu>(
          //   value: Menu.itemOther,
          //   child: Text('Удалить'),
          // ),
        ].toList());
  }

}

enum Menu { itemAccess, itemOther }

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
            Navigator.push(context, MaterialPageRoute(builder: (context) => objectsListSelectedDog(objectId: valueMap['objectId'], objectName: valueMap['objectName'], clientId: valueMap['clientId'],  clientName: valueMap['clientName'],onType: 'push',)));
          }
          if (idType=='scrProfileMan')
              Navigator.push(context, MaterialPageRoute(builder: (context) => scrProfileMan(id: id,)));
        }
      },
    );
  }

}

