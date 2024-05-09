import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:repairmodule/components/Cards.dart';
import 'package:repairmodule/models/Lists.dart';
//import 'package:repairmodule/components/Cards.dart;
import 'package:http/http.dart' as http;


class scrListScreen extends StatefulWidget {
  final String sprName;

  scrListScreen({super.key, required this.sprName});

  @override
  State<scrListScreen> createState() => _scrListScreenState();
}

class _scrListScreenState extends State<scrListScreen> {
  var objectList = [];

  Future httpGetListObject() async {
    var _url=Uri(path: '/a/centrremonta/hs/v1/sprList/${widget.sprName}', host: 's1.rntx.ru', scheme: 'https');
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': 'Basic YWNlOkF4V3lJdnJBS1prdzY2UzdTMEJP'
    };
    try {
      var response = await http.get(_url, headers: _headers);
      if (response.statusCode == 200) {
        var notesJson = json.decode(response.body);
        for (var noteJson in notesJson) {
          objectList.add(sprList.fromJson(noteJson));
        }
      }
    } catch (error) {
      print("Ошибка при формировании списка: $error");
    }
  }

  @override
  void initState() {
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
        title: Text('Справочник'),
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
            itemBuilder: (_, index) => sprCardList(event: objectList[index], onType: 'pop',),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: Text('+'),)
          //backgroundColor: Colors.grey[900]),
    );
  }
}

