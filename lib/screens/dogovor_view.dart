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
import 'package:repairmodule/screens/dogovor_List_Akt.dart';
import 'package:repairmodule/screens/dogovor_List_DDS.dart';
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

class scrDogovorViewScreen extends StatefulWidget {
  final String id;
  scrDogovorViewScreen({super.key, required this.id});

  @override
  State<scrDogovorViewScreen> createState() => _scrDogovorViewScreenState();
}

class _scrDogovorViewScreenState extends State<scrDogovorViewScreen> with SingleTickerProviderStateMixin {
  List<analyticObjectList> AnalyticObjectList = [];
  List<Akt> aktList = [];

  num summaDown = 0;
  num summaUp = 0;

  num avgRab = 0;
  num avgMat = 0;

  String idObject = '';
  String address = '';
  String name = '';
  String number = '';
  String date = '';
  DateTime dateDog = DateTime.now();
  String nameClient = '';
  String idClient = '';
  String nameManager = '';
  String idManager = '';
  String nameProrab = '';
  String idProrab = '';
  String smetaId = '00000000-0000-0000-0000-000000000000';
  String startDate = '';
  String stopDate = '';
  DateTime dtStart = DateTime.now();
  DateTime dtStop = DateTime.now();
  num summa = 0;
  num summaSeb = 0;
  num summaAkt = 0;
  num summaOpl=0;
  num percent = 0;
  num payment = 0;
  num area = 0;

  //PathProviderPlatform get _platform => PathProviderPlatform.instance;

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
        //id = data['id'] ?? 'no id';
        name = data['name'] ?? 'no name';
        number = data['number'] ?? '';
        date = DateFormat('dd.MM.yyyy').format(DateTime.parse(data['date'] ?? DateTime.now().toString())) ;
        dateDog = DateTime.parse(data['date']);
        nameClient = data['nameClient'] ?? 'no nameClient';
        idClient = data['idClient'] ?? 'no idClient';
        nameManager = data['nameManager'] ?? 'no nameManager';
        idManager = data['idManager'] ?? 'no idManager';
        nameProrab = data['nameProrab'] ?? 'no nameProrab';
        idProrab = data['idProrab'] ?? 'no idProrab';
        idObject = data['idObject'] ?? 'no idClient';
        address = data['address'] ?? 'no address';
        smetaId = data['smetaId'] ?? '00000000-0000-0000-0000-000000000000';
        dtStart = DateTime.parse(data['StartDate']);
        dtStop = DateTime.parse(data['StopDate']);

        startDate = DateFormat('dd.MM.yyyy').format(dtStart);
        stopDate = DateFormat('dd.MM.yyyy').format(dtStop);

        avgRab = data['avgRab'] ?? 0;
        avgMat = data['avgMat'] ?? 0;

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
        print('Код ответа сервера: ' + response.body.toString());
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

  // Future httpGetSmetaPDF() async {
  //   int i =0;
  //   final _queryParameters = {'userId': Globals.anPhone};
  //   var _url=Uri(path: '${Globals.anPath}print/${smetaId}/3/', host: Globals.anServer, scheme: 'https', queryParameters: _queryParameters);
  //   var _headers = <String, String> {
  //     'Accept': 'application/json',
  //     'Authorization': Globals.anAuthorization
  //   };
  //   try {
  //     print('1');
  //     //final Directory tempDir = getTemporaryPath();
  //     final String? tempPath = await _platform.getTemporaryPath();
  //
  //     //String tempPath = tempDir.path;
  //     print(tempPath);
  //
  //     var response = await http.get(_url, headers: _headers);
  //     print('Код ответа от запроса аналитик: ' + response.statusCode.toString());
  //     if (response.statusCode == 200) {
  //       if (response.contentLength == 0){
  //         return;
  //       }
  //       File file = new File('$tempPath/${number}.pdf');
  //       print('Начинаем сохранять пдф');
  //       await file.writeAsBytes(response.bodyBytes);
  //       //displayImage(file);
  //       print('Сохранили пдф');
  //     }
  //     else
  //       throw response.body;
  //   } catch (error) {
  //     print("Ошибка при формировании списка: $error");
  //   }
  // }

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
          title: Text('Карточка договора'),
          centerTitle: false,
          actions: <Widget>[_menuAppBar()],
        ),
        body: _pageGeneral(),
        floatingActionButton: _bottomButtons()
        );
  }

  Widget? _bottomButtons() {
    if (Globals.anUserRoleId!=3)
          return null;
        else
          return FloatingActionButton(
            onPressed: () async {
              DateTimeRange dateRange = DateTimeRange(start: dtStart, end: dtStop);
              await Navigator.push(context, MaterialPageRoute(builder: (context) => scrDogovorCreateScreen(objectId: idObject, objectName: address, clientId: idClient, clientName: nameClient, newDogovorId: widget.id, managerId: idManager, managerName: nameManager, prorabId: idProrab, prorabName: nameProrab, nameDog: name, summa: summa, summaSeb: summaSeb, dateRange: dateRange,),));
              _ref();
            },
            child: Icon(Icons.edit),
          );

  }

  _pageGeneral() {
    String nn = (name!='') ? name : '№${number} от ${date}';
    return ListView(padding: EdgeInsets.symmetric(horizontal: 4),
      children: [
        SizedBox(height: 8,),
        Center(child: Text(nn, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
        ObjectTileView(nameClient: nameClient,
            idClient: idClient,
            startDate: startDate,
            stopDate: stopDate,
            address: address,
            area: area),
        if (smetaId != '00000000-0000-0000-0000-000000000000') ...[
          SizedBox(height: 4,),
          Card(
            child: ListTile(
              title: Text('Открыть смету в PDF'),
              leading: Icon(Icons.calculate),
              trailing: Icon(Icons.navigate_next),
              onTap: () {
                printSmetaSelectPrice(context, smetaId);
              },
            ),
          )
        ],
        SizedBox(height: 4,),
        Card(
          child: ListTile(
            title: Text('ППР (фактический)'),
            //leading: Icon(Icons.calculate),
            trailing: Icon(Icons.navigate_next),
            onTap: () {
              //printSmetaSelectPrice(context, smetaId);
            },
          ),
        ),
        SizedBox(height: 4,),
        Card(
          child: ListTile(
            title: Text('Выполнение'),
            //leading: Icon(Icons.calculate),
            trailing: Text('${NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format((summa!=0) ? summaAkt/summa*100 : 0)} %', style: TextStyle(fontSize: 14),),
            onTap: () {
              //printSmetaSelectPrice(context, smetaId);
            },
          ),
        ),
        SizedBox(height: 4,),
        Card(
          child: Column(
            children: [
              CustomListTile(
                title: 'Баланс',
                trailing: Text('${NumberFormat.decimalPatternDigits(
                    locale: 'ru-RU', decimalDigits: 2).format(
                    summaUp - summaDown)} руб.', style: TextStyle(
                    fontSize: 14, color: textColors(summaUp - summaDown))),
                icon: null,
                //Icons.trending_neutral,
                id: '',
                idType: '',
              ),
              CustomListTile(
                title: 'Поступления',
                trailing: Text('${NumberFormat.decimalPatternDigits(
                    locale: 'ru-RU', decimalDigits: 2).format(summaUp)} руб.',
                  style: TextStyle(fontSize: 14, color: textColors(summaUp)),),
                icon: null,
                //Icons.trending_neutral,
                id: '',
                idType: '',
              ),
              CustomListTile(
                title: 'Расходы',
                trailing: Text('${NumberFormat.decimalPatternDigits(
                    locale: 'ru-RU', decimalDigits: 2).format(summaDown)} руб.',
                  style: TextStyle(
                      fontSize: 14, color: textColors(-summaDown)),),
                icon: null,
                //Icons.trending_neutral,
                id: '',
                idType: '',
              ),
              CustomListTile(
                title: 'Маржа',
                trailing: Text('${NumberFormat.decimalPatternDigits(
                    locale: 'ru-RU', decimalDigits: 2).format((summaUp != 0)
                    ? (summaUp - summaDown) / summaUp * 100
                    : 0)}%', style: TextStyle(fontSize: 14),),
                icon: null,
                //Icons.trending_neutral,
                id: '',
                idType: '',
              ),
              CustomListTile(
                title: 'Сумма сметы',
                trailing: Text('${NumberFormat.decimalPatternDigits(
                    locale: 'ru-RU', decimalDigits: 2).format(summa)} руб.',
                  style: TextStyle(fontSize: 14),),
                icon: null,
                //Icons.trending_neutral,
                id: '',
                idType: '',
              ),
              CustomListTile(
                title: 'Остаток выплаты',
                trailing: Text('${NumberFormat.decimalPatternDigits(
                    locale: 'ru-RU', decimalDigits: 2).format(
                    summa - summaOpl)} руб.', style: TextStyle(
                    fontSize: 14, color: textColors(summaOpl - summa)),),
                icon: null,
                //Icons.trending_neutral,
                id: '',
                idType: '',
              )
            ],
          ),
        ),
        SizedBox(height: 4,),
        Card(
          child: Column(
            children: [
              CustomListTile(
                title: 'Стоимость работ м2',
                trailing: Text('${NumberFormat.decimalPatternDigits(
                    locale: 'ru-RU', decimalDigits: 2).format(avgRab)} руб.',
                  style: TextStyle(fontSize: 14),),
                icon: null,
                //Icons.trending_neutral,
                id: '',
                idType: '',
              ),
              CustomListTile(
                title: 'Стоимость материалов м2',
                trailing: Text('${NumberFormat.decimalPatternDigits(
                    locale: 'ru-RU', decimalDigits: 2).format(avgMat)} руб.',
                  style: TextStyle(fontSize: 14),),
                icon: null,
                //Icons.trending_neutral,
                id: '',
                idType: '',
              )
            ],
          ),
        ),
        SizedBox(height: 4,),
        Card(
          child: ListTile(
            title: Text('Акты по этапу работ'),
            //leading: Icon(Icons.calculate),
            trailing: Icon(Icons.navigate_next),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => scrDogovorListAktScreen(id: widget.id, nameProrab: nameProrab,idProrab: idProrab, nameManager: nameManager, idManager: idManager,address: address,area: area,idClient: idClient,  nameClient: nameClient,startDate: startDate,stopDate: stopDate, name: nn)));
            },
          ),
        ),
        SizedBox(height: 4,),
        Card(
          child: ListTile(
            title: Text('Аналитика ДДС'),
            trailing: Icon(Icons.navigate_next),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => scrDogovorListDDSScreen(id: widget.id, idObject: idObject, number: number, dateDog: dateDog, nameProrab: nameProrab,idProrab: idProrab, nameManager: nameManager, idManager: idManager,address: address,area: area,idClient: idClient,  nameClient: nameClient,startDate: startDate,stopDate: stopDate, name: nn)));
            },
          ),
        ),
        SizedBox(height: 12,),
      ],
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

void printSmetaSelectPrice(context, smetaId) {
  showModalBottomSheet(isScrollControlled: true, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), context: context, builder: (BuildContext bc) {
    return Container(
      height: 400,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              title: Text('С ценами клиента'),
              trailing: Icon(Icons.navigate_next),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PDFViewerFromUrl(url: 'https://ace:AxWyIvrAKZkw66S7S0BO@${Globals.anServer}${Globals.anPath}print/${smetaId}/2/',))),
            ),
            ListTile(
              title: Text('С ценами мастеров'),
              trailing: Icon(Icons.navigate_next),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PDFViewerFromUrl(url: 'https://ace:AxWyIvrAKZkw66S7S0BO@${Globals.anServer}${Globals.anPath}print/${smetaId}/22/',))),
            )
          ],
        ),
      ),
    );

  });
}


