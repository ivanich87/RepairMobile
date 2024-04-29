import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:repairmodule/components/SingleSelections.dart';
import 'package:repairmodule/screens/profileMan.dart';
import 'package:repairmodule/models/Lists.dart';
import 'package:repairmodule/screens/object_view.dart';

import 'objects.dart';
import 'objectsListSelected.dart';

class scrPlatEditScreen extends StatefulWidget {
  //final String id;
  //final ListPlat plat;
  scrPlatEditScreen({super.key});

  @override
  State<scrPlatEditScreen> createState() => _scrPlatEditScreenState();
}

class _scrPlatEditScreenState extends State<scrPlatEditScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Платеж'),
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        'Оплата от клиента за работы',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '№ 0 от ${DateFormat('dd.MM.yyyy').format(DateTime.now())}',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Divider(),
                //_payer(widget: widget,),
                Divider(),
                SingleSection(
                  title: 'Сведения об объекте',
                  children: [
                    _CustomListTile(
                        title: 'Объект: ',
                        icon: Icons.location_on_outlined,
                        id: '',
                        idType: 'objectsListSelected'),
                    _CustomListTile(
                        title: 'Договор № 111 от ${DateFormat('dd.MM.yyyy').format(DateTime.now())}',
                        icon: Icons.paste_rounded,
                        trailing: Icon(Icons.label_important_sharp),
                        id: '',
                        idType: 'objectsListSelected'),
                  ],
                ),
                Divider(),
                //_recipient(widget: widget,),
                Divider(),
                SingleSection(
                  title: 'Аналитика и комментарий',
                  children: [
                    _CustomListTile(
                        title: "",
                        icon: Icons.analytics,
                        id: '',
                        idType: ''),
                    _CustomListTile(
                        title: 'widget.plat.comment',
                        icon: Icons.comment_outlined,
                        id: '',
                        idType: ''),
                  ],
                ),
                Text('0 руб.', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.green))
              ],
            )

          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.save),
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
        if (id == '') {
          print(id);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) {
                    if (idType=='scrProfileMan') {
                      return scrProfileMan(id: id,);
                    };
                    if (idType=='scrObjectsViewScreen') {
                      return scrObjectsViewScreen(id: id,);
                    };
                    if (idType=='objectsListSelected') {
                      return objectsListSelected();
                    };
                    return scrProfileMan(id: id,);
                  } ));
        }
      },
    );
  }

}


