import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:repairmodule/components/SingleSelections.dart';
import 'package:repairmodule/models/Lists.dart';
import 'package:repairmodule/screens/profileMan.dart';

import '../components/Cards.dart';

class scrObjectsViewScreen extends StatefulWidget {
  final String id;
  scrObjectsViewScreen({super.key, required this.id});

  @override
  State<scrObjectsViewScreen> createState() => _scrObjectsViewScreenState();
}

class _scrObjectsViewScreenState extends State<scrObjectsViewScreen> {
  List<analyticObjectList> AnalyticObjectList = [];

  num summaDown = 0;
  num summaUp = 0;

  String address = 'no address';
  String name = 'no name';
  String nameClient = 'no nameClient';
  String idClient = 'no idClient';
  String nameManager = 'no nameManager';
  String idManager = 'no idManager';
  String nameProrab = 'no nameProrab';
  String idProrab = 'no idProrab';
  String startDate = '20010101';
  String stopDate = '20010101';
  int summa = 0;
  int summaSeb = 0;
  int summaAkt = 0;
  int percent = 0;
  int payment = 0;
  int area = 0;


  Future httpGetInfoObject() async {
    print('!!!!!!!!!!!!!!!!!!' + widget.id.toString());
    var _url=Uri(path: '/a/centrremonta/hs/v1/obinfo/'+widget.id+'/', host: 's1.rntx.ru', scheme: 'https');
    
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': 'Basic YWNlOkF4V3lJdnJBS1prdzY2UzdTMEJP'
    };
    try {
      var response = await http.get(_url, headers: _headers);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        //id = data['id'] ?? 'no id';
        name = data['nameObject'] ?? 'no name';
        nameClient = data['nameClient'] ?? 'no nameClient';
        idClient = data['idClient'] ?? 'no idClient';
        nameManager = data['nameManager'] ?? 'no nameManager';
        idManager = data['idManager'] ?? 'no idManager';
        nameProrab = data['nameProrab'] ?? 'no nameProrab';
        idProrab = data['idProrab'] ?? 'no idProrab';
        address = data['address'] ?? 'no address';

        startDate = DateFormat('dd-MM-yyyy').format(DateTime.parse(data['StartDate']));
        stopDate = DateFormat('dd-MM-yyyy').format(DateTime.parse(data['StopDate']));

        final a = double.parse(data['area'].toString());
        area = a.toInt();

        final s = double.parse(data['СуммыДоговоров'].toString());
        summa = s.toInt();

        final s2 = double.parse(data['СуммаСебестоимость'].toString());
        summaSeb = s2.toInt();

        final s3 = double.parse(data['СуммаАктов'].toString());
        summaAkt = s3.toInt();

        final s4 = double.parse(data['ПроцентВыполнения'].toString());
        percent = s4.toInt();

        final s5 = double.parse(data['ПроцентВыполнения'].toString());
        payment = s5.toInt();
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
    var _url=Uri(path: '/a/centrremonta/hs/v1/analyticinfo/${widget.id}/', host: 's1.rntx.ru', scheme: 'https');
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': 'Basic YWNlOkF4V3lJdnJBS1prdzY2UzdTMEJP'
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
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Карточка объекта'),
            //bottom: TabBar(tabs: _tabs),
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
              TabBar(tabs: _tabs, ),
              Expanded(
                child: TabBarView(children: <Widget> [
                  _pageGeneral(),
                  _pageFinteh()
                ]),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
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
            // Text(
            //   name,
            //   style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            // ),
            // Divider(),
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
                    id: ''),
                _CustomListTile(
                    title: "Площадь объекта $area м2",
                    icon: Icons.rectangle_outlined,
                    id: ''),
                _CustomListTile(
                    title: address,//InfoObject['address'],//ObjectData,  //infoObjectData['address'].toString()
                    icon: Icons.location_on_outlined,
                    id: ''),
              ],
            ),
            Divider(),
            SingleSection(
              title: 'Ответственные за объект',
              children: [
                _CustomListTile(
                    title: nameProrab,
                    icon: Icons.hardware_sharp,
                    id: idProrab),
                _CustomListTile(
                    title: nameManager,
                    icon: Icons.headset_mic_sharp,
                    id: idManager),
              ],
            ),
            Divider(),
            SingleSection(
              title: 'Документы',
              children: [
                _CustomListTile(
                    title: "Договора и соглашения",
                    icon: Icons.document_scanner,
                    id: ''),
                _CustomListTile(
                    title: "Акты выполненных работ",
                    icon: Icons.document_scanner_outlined,
                    id: ''),
                _CustomListTile(
                    title: "Финансовые показатели",
                    icon: Icons.monetization_on_outlined,
                    id: ''),
              ],
            )
          ],
        )

      ],
    );
  }

  _pageFinteh() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleHeader('Общие показатели'),
        Container(height: 100,
          child: ListView(scrollDirection: Axis.horizontal,
              children: [
                  _CustomRowTile(
                    title: 'Баланс',
                    subtitle: summaUp-summaDown,
                    icon: Icons.trending_neutral,
                    id: '',
                  ),
                  _CustomRowTile(
                    title: 'Расходы',
                    subtitle: -summaDown,
                    icon: Icons.trending_down,
                    id: '',
                  ),
                  _CustomRowTile(
                    title: 'Поступления',
                    subtitle: summaUp,
                    icon: Icons.trending_up,
                    id: '',
                  ),
                  _CustomRowTile(
                    title: 'Маржа',
                    subtitle: (summaUp!=0) ? (summaUp-summaDown)/summaUp*100 : 0,
                    icon: Icons.trending_up,
                    id: '',
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

  const _CustomListTile(
      {Key? key, required this.title, required this.icon, this.trailing, required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title ?? 'ggg'),
      leading: Icon(icon),
      trailing: trailing,
      onTap: () {
        if (id != '') {
        Navigator.push(
        context,
        MaterialPageRoute(
        builder: (context) => scrProfileMan(id: id,)));
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
  Tab(icon: Icon(Icons.home_rounded), text: "Основное"), //icon: Icon(Icons.home_rounded),
  Tab(icon: Icon(Icons.shopping_bag_rounded), text: "Финансы"), //icon: Icon(Icons.shopping_bag_rounded),
];