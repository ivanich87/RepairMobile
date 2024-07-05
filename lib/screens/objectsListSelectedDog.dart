import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:repairmodule/components/Cards.dart';
import 'package:repairmodule/models/Lists.dart';
//import 'package:repairmodule/components/Cards.dart;
import 'package:http/http.dart' as http;

import 'dogovor_create.dart';


class objectsListSelectedDog extends StatefulWidget {
  final String objectId;
  final String objectName;
  final String clientId;
  final String clientName;
  final String onType;

  objectsListSelectedDog({super.key, required this.objectId, required this.onType, required this.objectName, required this.clientId, required this.clientName});

  @override
  State<objectsListSelectedDog> createState() => _scrobjectsListSelectedDogState();
}

class _scrobjectsListSelectedDogState extends State<objectsListSelectedDog> {
  var objectList = [];
  //List <DogListObject> objectList = [];

  Future httpGetListObject() async {
    final _queryParameters = {'userId': Globals.anPhone};
    var _url=Uri(path: '${Globals.anPath}dogList/${widget.objectId}/', host: Globals.anServer, scheme: 'https', queryParameters: _queryParameters);
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': Globals.anAuthorization
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
            itemBuilder: (_, index) => CardDogObjectList(event: objectList[index], onType: widget.onType,),
          ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            DateTimeRange dateRange = DateTimeRange(start: DateTime.now(), end: DateTime.now());
            final newObjectId = await Navigator.push(context, MaterialPageRoute(builder: (context) => scrDogovorCreateScreen(objectId: widget.objectId, objectName: widget.objectName, clientId: widget.clientId, clientName: widget.clientName, newDogovorId: '', managerId: '', managerName: 'Выберите менеджера', prorabId: '', prorabName: 'Выберите прораба', nameDog: '', summa: 0, summaSeb: 0, dateRange: dateRange,),));
            initState();
          },
          child: Text('+'),)

      //backgroundColor: Colors.grey[900]),
    );
  }
}

