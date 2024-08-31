import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:repairmodule/components/Cards.dart';
import 'package:repairmodule/models/Lists.dart';
import 'package:http/http.dart' as http;

import '../../models/ListAccess.dart';



class scrAccessObjectsScreen extends StatefulWidget {
  final String id;
  final String name;

  scrAccessObjectsScreen(this.id, this.name);

  @override
  State<scrAccessObjectsScreen> createState() => _scrAccessObjectsScreenState();
}

class _scrAccessObjectsScreenState extends State<scrAccessObjectsScreen> {
  List<accessObject> objectList = [];

  Future httpGetListObject() async {
    final _queryParameters = {'userId': Globals.anPhone};

    var _url=Uri(path: '${Globals.anPath}accessobject/${widget.id}', host: Globals.anServer, scheme: 'https', queryParameters: _queryParameters);
    print(_url.path);
    print(Globals.anAuthorization);
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': Globals.anAuthorization
    };
    try {
      var response = await http.get(_url, headers: _headers);
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        print(response.body.toString());
        var notesJson = json.decode(response.body);
        for (var noteJson in notesJson) {
          objectList.add(accessObject.fromJson(noteJson));
        }
      }
      else
        throw 'Код ответа: ${response.statusCode.toString()}. Ответ: ${response.body}';
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
    //super.initState();
  }
  Widget build(BuildContext context) {
    print(objectList.length.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text('Настройки доступа'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
        body: Column(
          children: [
            Text('${widget.name}', style: TextStyle(fontSize: 16)),
            Divider(),
            Expanded(
              child: (objectList.length==0) ? Center(child: Text('Нет данных')) : ListView.builder(
                padding: EdgeInsets.all(10),
                physics: BouncingScrollPhysics(),
                reverse: false,
                itemCount: objectList.length,
                itemBuilder: (_, index) =>
                    Card(
                      child: ListTile(
                        title: Text(objectList[index].name.toString(), style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),),
                        subtitle: Text('${objectList[index].role}', textAlign: TextAlign.start,),
                        //trailing: Text(NumberFormat.simpleCurrency(locale: 'ru-RU', decimalDigits: 2).format(widget.objectList[index].summa), style: TextStyle(fontSize: 18, color: Colors.red),),
                      ),
                    ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async{
            // await Navigator.push(context, MaterialPageRoute(builder: (context) => scrPlatEditScreen(plat2: widget.plat,)));
            // setState(() {
            //
            // });
          },
          child: Icon(Icons.add),
        )

    );
  }
}

