import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:repairmodule/components/SingleSelections.dart';
import 'package:repairmodule/screens/profileMan.dart';

class scrObjectsViewScreen extends StatefulWidget {
  final String id;
  scrObjectsViewScreen({super.key, required this.id});

  @override
  State<scrObjectsViewScreen> createState() => _scrObjectsViewScreenState();
}

class _scrObjectsViewScreenState extends State<scrObjectsViewScreen> {
  String address = 'no address';
  String name = 'no name';

  //String id = 'no id';
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

  @override
  void initState() {
    httpGetInfoObject().then((value) {
      setState(() {
      });
    });
    // TODO: implement initState
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Карточка объекта'),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.menu))],
        ),
        body: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              //crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Divider(),
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
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.edit),
        )
        //backgroundColor: Colors.grey[900]),
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

