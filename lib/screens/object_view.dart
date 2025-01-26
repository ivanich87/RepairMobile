import 'dart:convert';
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

class scrObjectsViewScreen extends StatefulWidget {
  final String id;
  scrObjectsViewScreen({super.key, required this.id});

  @override
  State<scrObjectsViewScreen> createState() => _scrObjectsViewScreenState();
}

class _scrObjectsViewScreenState extends State<scrObjectsViewScreen> with SingleTickerProviderStateMixin {
  List<analyticObjectList> AnalyticObjectList = [];
  List<DogListObject> dogList = [];

  late TabController _tabController;

  num summaDown = 0;
  num summaUp = 0;

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
    httpGetListObject();
    await httpGetInfoObject();
    await httpGetAnalyticListObject();
    setState(() {

    });
  }

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabIndex);
    ref();
    // TODO: implement initState
    //super.initState();
  }
  @override
  void dispose() {
    _tabController.removeListener(_handleTabIndex);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabIndex() {
    setState(() {});
  }

  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Карточка объекта'),
            //bottom: TabBar(tabs: _tabs),
            bottom: TabBar(controller: _tabController, tabs: _tabs, isScrollable: true,),
            centerTitle: true,
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            actions: [IconButton(onPressed: () {}, icon: Icon(Icons.menu))],
          ),
          body: Column(
            children: [
              Text(
                name,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Divider(),

              Expanded(
                child: TabBarView(controller: _tabController, children: <Widget> [
                  _pageGeneral(),
                  _pageDogList(),
                  _pageFinteh()
                ], ),
              ),
            ],
          ),
          floatingActionButton: _bottomButtons(),
          //(Globals.anUserRoleId!=3) ? null : (_visibleFloatingActionButton==false) ? null : FloatingActionButton(
          //  onPressed: () async {
          //    await Navigator.push(context, MaterialPageRoute(builder: (context) => scrObjectEditScreen(objectId: widget.id, clientId: idClient, clientName: nameClient, clientEMail: emailClient, clientPhone: phoneClient, address: address, area: area),));
          //    initState();
          //  },
          //  child: Icon(Icons.edit),
          //)
          //backgroundColor: Colors.grey[900]),
          ),
    );
  }

  _pageGeneral() {
    return RefreshIndicator(
      onRefresh: () async {
        initState();
        return Future<void>.delayed(const Duration(seconds: 2));
      },
      child: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            //crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ListTile(
                title: Text(
                  nameClient,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                ),
                subtitle: Text('Посмотреть данные по клиенту'),
                trailing: Icon(Icons.info_outlined),
                leading: Icon(Icons.account_circle),
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => scrProfileMan(id: idClient,)));
                },
              ),
              Divider(),
              SingleSection(
                title: 'Основное',
                children: [
                  _CustomListTile(
                      title: startDate.toString() + ' - ' + stopDate.toString(),
                      icon: Icons.calendar_month,
                      id: '', idType: ''),
                  _CustomListTile(
                      title: "Площадь объекта $area м2",
                      icon: Icons.rectangle_outlined,
                      id: '', idType: ''),
                  _CustomListTile(
                      title: address,//InfoObject['address'],//ObjectData,  //infoObjectData['address'].toString()
                      icon: Icons.location_on_outlined,
                      id: '', idType: ''),
                  ListTile(
                    title: Text('Настройки доступа'),
                    leading: Icon(Icons.key),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => scrAccessObjectsScreen(widget.id, address)));
                    },
                  ),
                ],
              ),
              Divider(),
              SingleSection(
                title: 'Ответственные за объект',
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
              ),
              Divider(),
              // SingleSection(
              //   title: 'Документы',
              //   children: [
              //     _CustomListTile(
              //         title: "Договора и соглашения",
              //         icon: Icons.document_scanner,
              //         id: '{"objectId": "${widget.id}", "objectName": "${address}", "clientId": "${idClient}", "clientName": "${nameClient.replaceAll('"', '')}"}',
              //         idType: 'objectsListSelectedDog'),
              //     _CustomListTile(
              //         title: "Акты выполненных работ",
              //         icon: Icons.document_scanner_outlined,
              //         id: '', idType: ''),
              //     _CustomListTile(
              //         title: "Финансовые показатели",
              //         icon: Icons.monetization_on_outlined,
              //         id: '', idType: '',),
              //   ],
              // ),
              SingleSection(
                title: 'Суммы',
                children: [
                  _CustomListTile(
                      title: "Сумма договоров ${NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(summa)} руб.",
                      icon: Icons.currency_ruble,
                      id: '', idType: ''),
                  _CustomListTile(
                      title: "Себестоимость ${NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(summaSeb)} руб.",
                      icon: Icons.currency_ruble,
                      id: '', idType: ''),
                  _CustomListTile(
                      title: "Внесено клиентом ${NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(summaOpl)} руб.",
                      icon: Icons.currency_ruble,
                      id: '', idType: '')
                ],
              )
            ],
          )

        ],
      ),
    );
  }

  _pageDogList() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleHeader('Общие показатели'),
        Container(height: 100,
          child: ListView(scrollDirection: Axis.horizontal,
              children: [
                InkWell(
                  onTap: () {},
                  child: _CustomRowTile(
                    title: 'Клиент',
                    subtitle: summa,
                    icon: Icons.trending_neutral,
                    id: '',
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: _CustomRowTile(
                    title: 'Мастера',
                    subtitle: -summaSeb,
                    icon: Icons.trending_down,
                    id: '',
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: _CustomRowTile(
                    title: 'Оплата',
                    subtitle: summaOpl,
                    icon: Icons.trending_up,
                    id: '',
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: _CustomRowTile(
                    title: 'Выполнено (%)',
                    subtitle: (summa!=0) ? summaAkt/summa*100 : 0,
                    icon: Icons.trending_up,
                    id: '',
                  ),
                ),
              ]
          ),
        ),
        Divider(),
        titleHeader('Список договоров'),
        Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                initState();
                return Future<void>.delayed(const Duration(seconds: 2));
              },
              child: ListView.builder(
                padding: EdgeInsets.all(10),
                physics: BouncingScrollPhysics(),
                reverse: false,
                itemCount: dogList.length,
                itemBuilder: (_, index) => Card(
                  child: ListTile(
                    title: Text('№${dogList[index].Number} от ${DateFormat('dd.MM.yyyy').format(dogList[index].Date)}'),
                    subtitle: Text('${dogList[index].name}'),
                    trailing: Column(
                      children: [
                        Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 0).format(dogList[index].summa), style: TextStyle(fontSize: 16, color: Colors.green)),
                        Text('${NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 0).format(dogList[index].summaAkt/dogList[index].summa*100)}%', style: TextStyle(fontSize: 16, color: Colors.green)),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => scrDogovorViewScreen(id: dogList[index].id)));
                    },
                  ),
                ),
              ),
            )
        ),
      ],
    );
  }

  _pageFinteh() {
    return (Globals.anFinTech==false) ? Center(child: Text('Нет доступа')) :
    Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleHeader('Общие показатели'),
        Container(height: 100,
          child: ListView(scrollDirection: Axis.horizontal,
              children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => scrCashListScreen(idCash: '0', cashName: 'Все', analytic: '', analyticName: '', objectId: widget.id, objectName: name, platType: '', dateRange: DateTimeRange(start: DateTime(2023), end: DateTime.now()), kassaSotrId: '', kassaSortName: '',  )));
                    },
                    child: _CustomRowTile(
                      title: 'Баланс',
                      subtitle: summaUp-summaDown,
                      icon: Icons.trending_neutral,
                      id: '',
                    ),
                  ),
                  InkWell(
                    onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => scrCashListScreen(idCash: '0', cashName: 'Все', analytic: '', analyticName: '', objectId: widget.id, objectName: name, platType: 'Расход', dateRange: DateTimeRange(start: DateTime(2023), end: DateTime.now()), kassaSotrId: '', kassaSortName: '',  )));},
                    child: _CustomRowTile(
                      title: 'Расходы',
                      subtitle: -summaDown,
                      icon: Icons.trending_down,
                      id: '',
                    ),
                  ),
                  InkWell(
                    onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => scrCashListScreen(idCash: '0', cashName: 'Все', analytic: '', analyticName: '', objectId: widget.id, objectName: name, platType: 'Приход', dateRange: DateTimeRange(start: DateTime(2023), end: DateTime.now()), kassaSotrId: '', kassaSortName: '',  )));},
                    child: _CustomRowTile(
                      title: 'Поступления',
                      subtitle: summaUp,
                      icon: Icons.trending_up,
                      id: '',
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: _CustomRowTile(
                      title: 'Маржа',
                      subtitle: (summaUp!=0) ? (summaUp-summaDown)/summaUp*100 : 0,
                      icon: Icons.trending_up,
                      id: '',
                    ),
                  ),
                ]
              ),
            ),
            Divider(),
            titleHeader('Аналитика движения денег'),
            Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    initState();
                    return Future<void>.delayed(const Duration(seconds: 2));
                  },
                  child: ListView.builder(
                    padding: EdgeInsets.all(10),
                    physics: BouncingScrollPhysics(),
                    reverse: false,
                    itemCount: AnalyticObjectList.length,
                    itemBuilder: (_, index) => CardObjectAnalyticList(event: AnalyticObjectList[index], onType: 'push', objectId: widget.id, objectName: address),
                  ),
                )
            ),
      ],
    );
  }

  Widget? _bottomButtons() {
    switch (_tabController.index) {
      case 0:
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
      case 1:
        return FloatingActionButton(
          onPressed: () async {
            DateTimeRange dateRange = DateTimeRange(start: DateTime.now(), end: DateTime.now());
            await Navigator.push(context, MaterialPageRoute(builder: (context) => scrDogovorCreateScreen(objectId: widget.id, objectName: name, clientId: idClient, clientName: nameClient, newDogovorId: '', managerId: idManager, managerName: nameManager, prorabId: idProrab, prorabName: nameProrab, nameDog: '', summa: 0, summaSeb: 0, dateRange: dateRange,),));
            ref();
          },
          child: Icon(Icons.add),
        );
      case 2:
        return FloatingActionButton(
            onPressed: () {},
            child: _AddMenuIcon());


    }
  }

  _AddMenuIcon() {
    return PopupMenuButton<Menu>(
        icon: const Icon(Icons.add),
        offset: const Offset(0, 40),
        onSelected: (Menu item) async {
          if (item.name=='check') //если покупка стройматериалов
              {
            Receipt recipientdata = Receipt('', '', DateTime.now(), true, false, false, '', '', widget.id, name, true, '', '', DateTime.now(), 0, 0, 0, false, '', '', '', 'Расход', 0, '7fa144f2-14ca-11ed-80dd-00155d753c19', 'Покупка стройматериалов', '', '', defaultkassaSotr(Globals.anUserId, true), defaultkassaSotr(Globals.anUserName, false), (defaultkassaSotr(Globals.anUserId, true)=='') ? 0 : 1, 'Покупка стройматериалов', 0, []);
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => scrReceiptEditScreen(receiptData: recipientdata,)));
          }
          else
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => scrPlatEditScreen(plat2: ListPlat('', 'Новый платеж', DateTime.now(), false, '', true, '', '', '', useDog(item.name), analyticId(item.name, true), analyticId(item.name, false), 0, 0, 0, widget.id, name, '', '', DateTime.now(), useDog(item.name), '', '', defaultkassaSotr(Globals.anUserId, true), defaultkassaSotr(Globals.anUserName, false), (defaultkassaSotr(Globals.anUserId, true)=='') ? 0 : 1, '', '', '', platType(item.name), type(item.name), '', '', '', '', 0, 0),)));
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


class _CustomListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? trailing;
  final String id;
  final String idType;

  const _CustomListTile(
      {Key? key, required this.title, required this.icon, this.trailing, required this.id, required this.idType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title ?? 'ggg'),
      leading: Icon(icon),
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

class _CustomRowTile extends StatelessWidget {
  final String title;
  final IconData? icon;
  final num subtitle;
  final String id;

  const _CustomRowTile(
      {Key? key, required this.title, this.icon, required this.subtitle, required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.normal),),
                Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(subtitle), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColors(subtitle)))
              ],
            ),
          )
      ),
    );
  }

}

const _tabs = [
  Tab(icon: Row(children:[Icon(Icons.home_rounded), Text(' Основное')]),
    //text: "Основное"
    iconMargin: EdgeInsets.zero
  ),
  Tab(icon: Row(children:[Icon(Icons.document_scanner), Text(' Договора')]),
    //text: "Договора",
    iconMargin: EdgeInsets.zero,),
  Tab(icon: Row(children:[Icon(Icons.shopping_bag_rounded), Text(' Финансы')]),
    //text: "Финансы",
    iconMargin: EdgeInsets.zero,),
];

enum Menu { oplataDog, oplataMaterials, platUp, platDown, check, platDownSotr, platUpSotr , platMove}