import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:repairmodule/components/Cards.dart';
import 'package:repairmodule/models/Lists.dart';
//import 'package:repairmodule/components/Cards.dart;
import 'package:http/http.dart' as http;


class objectsListSelectedDog extends StatefulWidget {
  final String id;

  objectsListSelectedDog({super.key, required this.id});

  @override
  State<objectsListSelectedDog> createState() => _scrobjectsListSelectedDogState();
}

class _scrobjectsListSelectedDogState extends State<objectsListSelectedDog> {
  var objectList = [];
  //List <DogListObject> objectList = [];

  Future httpGetListObject() async {
    var _url=Uri(path: '/a/centrremonta/hs/v1/dogList/${widget.id}/', host: 's1.rntx.ru', scheme: 'https');
    print(_url.path);
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': 'Basic YWNlOkF4V3lJdnJBS1prdzY2UzdTMEJP'
    };
    try {
      var response = await http.get(_url, headers: _headers);
      if (response.statusCode == 200) {
        var notesJson = json.decode(response.body);
        for (var noteJson in notesJson) {
          objectList.add(DogListObject.fromJson(noteJson));
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
        title: Text('Выбор договора'),
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
            itemBuilder: (_, index) => CardDogObjectList(event: objectList[index], onType: 'pop',),
          ),
          //backgroundColor: Colors.grey[900]),
    );
  }
}

