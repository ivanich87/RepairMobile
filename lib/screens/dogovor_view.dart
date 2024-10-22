import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:repairmodule/components/SingleSelections.dart';
import 'package:repairmodule/models/Lists.dart';
import 'package:repairmodule/screens/akt_view.dart';
import 'package:repairmodule/screens/profileMan.dart';
import 'package:repairmodule/screens/settings/accessObjects.dart';

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

class _scrDogovorViewScreenState extends State<scrDogovorViewScreen> {
  List<analyticObjectList> AnalyticObjectList = [];
  List<Akt> aktList = [];
  num summaDown = 0;
  num summaUp = 0;

  String idObject = '';
  String address = '';
  String name = '';
  String number = '';
  String date = '';
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
        date = DateFormat('dd-MM-yyyy').format(DateTime.parse(data['date'] ?? DateTime.now().toString())) ;
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
    httpGetInfoObject().then((value) async {
      await httpGetAnalyticListObject();

      setState(() {
      });
    });
    // TODO: implement initState
    super.initState();
  }
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Карточка договора'),
            bottom: TabBar(tabs: _tabs, isScrollable: true,),
            centerTitle: false,
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
              //TabBar(tabs: _tabs, isScrollable: true,),
              Expanded(
                child: TabBarView(children: <Widget> [
                  _pageGeneral(),
                  _pageComplit(),
                  _pageFinteh()
                ]),
              ),
            ],
          ),
          floatingActionButton: (Globals.anUserRoleId!=3) ? null : FloatingActionButton(
            onPressed: () async {
              DateTimeRange dateRange = DateTimeRange(start: dtStart, end: dtStop);
              await Navigator.push(context, MaterialPageRoute(builder: (context) => scrDogovorCreateScreen(objectId: idObject, objectName: address, clientId: idClient, clientName: nameClient, newDogovorId: widget.id, managerId: idManager, managerName: nameManager, prorabId: idProrab, prorabName: nameProrab, nameDog: name, summa: summa, summaSeb: summaSeb, dateRange: dateRange,),));
              initState();
            },
            child: Icon(Icons.edit),
          )
          //backgroundColor: Colors.grey[900]),
          ),
    );
  }

  _pageGeneral() {
    return ListView(
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => scrProfileMan(id: idClient,)));
              },
            ),
            Divider(),
            if (smetaId!='00000000-0000-0000-0000-000000000000')
            Card(
              child: ListTile(
                  title: Text('Открыть смету в PDF'),
                  leading: Icon(Icons.calculate),
                  trailing: Icon(Icons.navigate_next),
                onTap: () {

                },
              ),
            ),
            SingleSection(
              title: 'Основное',
              children: [
                _CustomListTile(
                    title: '№' + number + ' от ' + date,
                    icon: Icons.document_scanner,
                    id: '', idType: ''),
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
                )
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
            SingleSection(
              title: 'Суммы',
              children: [
                _CustomListTile(
                    title: "Сумма ${NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(summa)} руб.",
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
    );
  }

  _pageComplit() {
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
        titleHeader('Акты выполненных работ'),
        Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10),
              physics: BouncingScrollPhysics(),
              reverse: false,
              itemCount: aktList.length,
              itemBuilder: (_, index) =>
                  Card(
                    child: ListTile(
                      title: Text('Акт ${aktList[index].number} от ${DateFormat('dd.MM.yyyy').format(aktList[index].date)}'),
                      trailing: Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(aktList[index].summa), style: TextStyle(fontSize: 18, color: Colors.green)),
                      //subtitle: Text(objectList[index].name, textAlign: TextAlign.center,),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => scrAktViewScreen(aktList[index])));
                      },
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
                child: ListView.builder(
                  padding: EdgeInsets.all(10),
                  physics: BouncingScrollPhysics(),
                  reverse: false,
                  itemCount: AnalyticObjectList.length,
                  itemBuilder: (_, index) => CardObjectAnalyticList(event: AnalyticObjectList[index], onType: 'push', objectId: widget.id, objectName: address),
                )
            ),
      ],
    );
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
          if (idType=='objectsListSelectedDog')
              Navigator.push(context, MaterialPageRoute(builder: (context) => objectsListSelectedDog(objectId: id, onType: 'push', objectName: '', clientId: '', clientName: '',)));
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
  Tab(icon: Row(children:[Icon(Icons.home_rounded), Text('  Основное')]),
    //text: "Основное"
    iconMargin: EdgeInsets.zero
  ),
  Tab(icon: Row(children:[Icon(Icons.bar_chart), Text('  Выполнение')]),
    //text: "Выполнение",
    iconMargin: EdgeInsets.zero,),
  Tab(icon: Row(children:[Icon(Icons.shopping_bag_rounded), Text('  Финансы')]),
    //text: "Финансы",
    iconMargin: EdgeInsets.zero,),
];