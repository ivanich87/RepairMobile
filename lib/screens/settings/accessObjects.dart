import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:repairmodule/components/Cards.dart';
import 'package:repairmodule/models/Lists.dart';
import 'package:http/http.dart' as http;

import '../../models/ListAccess.dart';
import '../sprList.dart';



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

  Future<bool> httpAddAccessObject(String _sotrId) async {
    final _queryParameters = {'userId': Globals.anPhone};
    bool _result = false;
    String _message = 'Ошибка';

    var _url=Uri(path: '${Globals.anPath}accessobject/${widget.id}', host: Globals.anServer, scheme: 'https', queryParameters: _queryParameters);
    print(_url.path);
    print(Globals.anAuthorization);
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': Globals.anAuthorization
    };
    try {
      var _body = {'sotrId': _sotrId};
      var response = await http.post(_url, headers: _headers, body: jsonEncode(_body));

      if (response.statusCode == 200 || response.statusCode == 400) {
        var data = json.decode(response.body);
        _result = data['Успешно'] ?? false;
        _message = data['Сообщение'] ?? '';
      }
      else
        throw 'Код ответа: ${response.statusCode.toString()}. Ответ: ${response.body}';
      if(_result==false)
        throw _message;
    } catch (error) {
      final snackBar = SnackBar(content: Text('$error'),);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    return _result ?? false;
  }

  Future<bool> httpDeleteAccessObject(String _sotrId) async {
    final _queryParameters = {'userId': Globals.anPhone};
    bool _result = false;
    String _message = 'Ошибка';

    var _url=Uri(path: '${Globals.anPath}accessobject/${widget.id}', host: Globals.anServer, scheme: 'https', queryParameters: _queryParameters);
    print(_url.path);
    print(Globals.anAuthorization);
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': Globals.anAuthorization
    };
    try {
      var response = await http.delete(_url, headers: _headers, body: {'sotrId': _sotrId});

      if (response.statusCode == 200 || response.statusCode == 400) {
        var data = json.decode(response.body);
        _result = data['Успешно'] ?? false;
        _message = data['Сообщение'] ?? '';
      }
      else
        throw 'Код ответа: ${response.statusCode.toString()}. Ответ: ${response.body}';
    } catch (error) {
      final snackBar = SnackBar(content: Text('$error'),);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    return _result ?? false;
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
            Text('${widget.name}', style: TextStyle(fontSize: 18)),
            Divider(),
            Text('Можете добавить или удалить доступ', style: TextStyle(fontStyle: FontStyle.italic),),
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
                        trailing: IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
                        //trailing: Text(NumberFormat.simpleCurrency(locale: 'ru-RU', decimalDigits: 2).format(widget.objectList[index].summa), style: TextStyle(fontSize: 18, color: Colors.red),),
                      ),
                    ),
              ),
            ),
          ],
        ),
        floatingActionButton: (Globals.anUserRoleId!=3) ? null : FloatingActionButton(
          onPressed: () async{
            var res = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {return scrListScreen(sprName: 'Сотрудники', onType: 'pop');}));
            print('СотрудникИд' + res.id);
            if (res.id!=null) {
              httpAddAccessObject(res.id).then((value) {
                if (value==true)
                  initState();
              });
            }
          },
          child: Icon(Icons.add),
        )

    );
  }
}

