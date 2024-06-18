import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:repairmodule/components/Cards.dart';
import 'package:repairmodule/models/Lists.dart';
//import 'package:repairmodule/components/Cards.dart;
import 'package:http/http.dart' as http;

import 'object_create.dart';
import 'object_view.dart';


class scrObjectsScreen extends StatefulWidget {


  scrObjectsScreen();

  @override
  State<scrObjectsScreen> createState() => _scrObjectsScreenState();
}

class _scrObjectsScreenState extends State<scrObjectsScreen> {
  var objectList = [];

  Future httpGetListObject() async {
    var _url=Uri(path: '/a/centrremonta/hs/v1/obList/0/', host: 's1.rntx.ru', scheme: 'https');
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': 'Basic YWNlOkF4V3lJdnJBS1prdzY2UzdTMEJP'
    };
    try {
      var response = await http.get(_url, headers: _headers);
      if (response.statusCode == 200) {
        var notesJson = json.decode(response.body);
        for (var noteJson in notesJson) {
          objectList.add(ListObject.fromJson(noteJson));
        }
      }
    } catch (error) {
      print("Ошибка при формировании списка: $error");
    }
  }

  @override
  void initState() {
    print('initState');
    objectList.clear();

    httpGetListObject().then((value) {
      setState(() {
      });
    });
    // TODO: implement initState
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Объекты в работе'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.menu))
        ],
      ),
        body: ListView.builder(
          padding: EdgeInsets.all(10),
          physics: BouncingScrollPhysics(),
          reverse: false,
          itemCount: objectList.length,
            itemBuilder: (_, index) => CardObjectList(event: objectList[index], onType: 'push',),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final newObjectId = await Navigator.push(context, MaterialPageRoute(builder: (context) => scrObjectCreateScreen(),)) ?? '';
              if (newObjectId!='') {
                Navigator.push(context, MaterialPageRoute( builder: (context) => scrObjectsViewScreen(id: newObjectId)));
                initState();
              }
            },
            child: Text('+'),)
          //backgroundColor: Colors.grey[900]),
    );
  }
}

