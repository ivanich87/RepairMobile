import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';
import 'package:intl/intl.dart';
import 'package:repairmodule/components/Cards.dart';
import 'package:repairmodule/components/SingleSelections.dart';
import 'package:repairmodule/models/ListWorks.dart';
import 'package:repairmodule/models/Lists.dart';
import 'package:http/http.dart' as http;
import 'package:repairmodule/screens/work_editing.dart';

import 'object_create.dart';
import 'object_view.dart';


class scrWorksEditScreen extends StatefulWidget {
  String id;
  final int type;
  final String dogId;
  final bool additionalWork;

  scrWorksEditScreen(this.id, this.type, this.dogId, this.additionalWork);

  @override
  State<scrWorksEditScreen> createState() => _scrWorksEditScreenState();
}

class _scrWorksEditScreenState extends State<scrWorksEditScreen> {
  List<Works> ListWorks = [];
  List<Works> filteredListWorks = [];
  List<Works> ListWorksTitle = [];
  var myObjects = [];
  bool _isActive=false;
  bool _isUpdating = false;
  String titleName = '';

  Future httpGetInfoObject() async {
    final _queryParameters = {'userId': Globals.anPhone, 'dogId': widget.dogId};

    var _url=Uri(path: '${Globals.anPath}workedit/${widget.id}/${widget.type}/', host: Globals.anServer, scheme: 'https', queryParameters: _queryParameters);
    print(_url.path);
    print(_queryParameters);
    print(Globals.anAuthorization);
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': Globals.anAuthorization
    };
    try {
      var response = await http.get(_url, headers: _headers);
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        print('Ответ = ' + response.body.toString());
        var notesJson = json.decode(response.body)['sost'];
        for (var noteJson in notesJson) {
          ListWorks.add(Works.fromJson(noteJson));
          filteredListWorks.add(Works.fromJson(noteJson));
          if (noteJson['parentId']==null)
            ListWorksTitle.add(Works.fromJson(noteJson));
        }
      }
      else
        throw 'Код ответа: ${response.statusCode.toString()}. Ответ: ${response.body}';
    } catch (error) {
      print("Ошибка при формировании списка: $error");
    }
  }

  Future<bool> httpObjectUpdate() async {
    bool _result=false;
    bool _accept = false;
    //final _queryParameters = {'userId': Globals.anPhone};
    print('dogId: ${widget.dogId}');
    final _queryParameters = {'userId': Globals.anPhone, 'dogId': widget.dogId};

    var _url=Uri(path: '${Globals.anPath}workedit/${widget.id}/${widget.type}/', host: Globals.anServer, scheme: 'https', queryParameters: _queryParameters);
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': Globals.anAuthorization
    };

    try {
      print('Start export works!!!!');
      print(json.encode(ListWorks));
      var response = await http.post(_url, headers: _headers, body: json.encode(ListWorks));
      print('Код ответа: ${response.statusCode} Тело ответа: ${response.body}');

      var data = json.decode(response.body);
      String _id = data['Код'] ?? '';
      _result = data['Успешно'] ?? false;
      String _message = data['Сообщение'] ?? '';

      widget.id = _id;

      print('Работы по акту выгружены. Результат:  $_result. Сообщение:  $_message');

      if (response.statusCode != 200) {
        _result = false;
        final snackBar = SnackBar(
          content: Text('${_message}'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (error) {
      _result = false;
      print("Ошибка при выгрузке работ по акту: $error");
      _result = false;
      final snackBar = SnackBar(
        content: Text('$error'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    return _result ?? false;
  }

  void _findList(value) {
    setState(() {
      filteredListWorks = ListWorks.where((element) => element.workName.toString().toLowerCase().contains(value.toLowerCase())).toList();
    });
  }

  @override
  void initState() {
    print('initState');
    ListWorks.clear();
    filteredListWorks.clear();
    ListWorksTitle.clear();

    httpGetInfoObject().then((value) {
      setState(() {
      });
    });
    // TODO: implement initState
    super.initState();
  }
  Widget build(BuildContext context) {
    switch (widget.type) {
      case 1:
        titleName = 'Редактирвоание сметы';
      case 2:
        titleName = 'Редактирование акта';
      case 3:
        titleName = 'Выбор работы';
    }
    return Scaffold(
      appBar: AppBar(
        title: SearchBar(), //Text(titleName),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: <Widget>[_menuAppBar()], //(widget.additionalWork==true) ? null :
      ),
        body: (_isUpdating==true) ? Center(child: CircularProgressIndicator()) : Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(10),
                physics: BouncingScrollPhysics(),
                reverse: false,
                itemCount: ListWorksTitle.length,
                itemBuilder: (_, index) => Card(
                  child:
                  ExpansionTile(
                    title: Text(ListWorksTitle[index].workName ?? 'dd', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
                    children: //<Widget>[
                    _generateChildrens(ListWorksTitle[index], 0),
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
          print('Сохраняем работы');
          setState(() {
            _isUpdating = true;
          });
          httpObjectUpdate().then((value) {
            setState(() {
              _isUpdating = false;
            });
            if (value==true) {
              Navigator.pop(context, widget.id);
            }
          });
          },
          child: Icon(Icons.save),
    )

    );
  }

  SearchBar() {
    return Row(
      children: [
        if (!_isActive)
          Text(titleName, style: Theme.of(context).appBarTheme.titleTextStyle),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: AnimatedSize(
              duration: const Duration(milliseconds: 250),
              child: (_isActive==true)
                  ? Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.white30,
                      borderRadius: BorderRadius.circular(4.0)),
                    child: TextField(autofocus: true,
                        decoration: InputDecoration(
                          hintText: 'Введите строку для поиска',

                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isActive = false;
                                  filteredListWorks = ListWorks;
                                  print('Сбросили фильтр');
                                });
                              },
                              icon: const Icon(Icons.close))),
                      onChanged: (value) {
                        _findList(value);
                      },
                    ),
              )
                  : IconButton(
                  onPressed: () {
                    setState(() {
                      _isActive = true;
                    });
                  },
                  icon: const Icon(Icons.search)),
            ),
          ),
        ),
      ],
    );
  }


  PopupMenuButton<MenuEditWorks> _menuAppBar() {
    return PopupMenuButton<MenuEditWorks>(
        icon: const Icon(Icons.menu, ),
        offset: const Offset(0, 40),
        onSelected: (MenuEditWorks item) async {
          if (item == MenuEditWorks.itemWorkAdd) {
            var _res = await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                scrWorksEditScreen(widget.id, 3, widget.dogId, false)));
            if (_res!=null) {
              ListWorks.add(_res);
              setState(() {

              });
            }
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuEditWorks>>[
          const PopupMenuItem<MenuEditWorks>(
            value: MenuEditWorks.itemWorkAdd,
            child: Text('Добавить доп работу'),
          ),
        ].toList());
  }

  List<Widget> _generateChildrens(event, double level) {
    var widgetList = <Widget>[];

    var value = event.workId;
    //print(event.workName);
    var _filtered = filteredListWorks.where((element) => element.parentId!.toLowerCase()==(value.toLowerCase())).toList();

    for (var str in _filtered) {
      //print(str);
      if (str.isFolder != true)
        widgetList.add(
          Card(color: Colors.white54,
            child: ListTile(
              title: Text(str.workName ?? '', style: TextStyle(fontSize: 18, ),),
              trailing: (widget.type==3) ? null : Checkbox(value: (str.kol==0) ? false : true, onChanged: (value) {
                setState(() {
                  num summaDifference = 0;
                  if (value==true) {
                    str.kol = str.kolRemains;
                    summaDifference = str.price! * str.kol!;
                  }
                  else {
                    summaDifference = -1*(str.price! * str.kol!);
                    str.kol=0;
                  }
                  _ref(str, summaDifference);
                });
              }, ),
              subtitle: Text('Цена: ${str.price.toString()}; Кол-во: ${str.kol}', style: TextStyle(fontStyle: FontStyle.italic),),
              onTap: () async {
                num summaDifference_old = str.price! * str.kol!;
                await Navigator.push(context, MaterialPageRoute(builder: (context) => scrWorkEditingScreen(str, widget.additionalWork)));
                setState(() {
                  num summaDifference = 0;
                  summaDifference = (str.price! * str.kol!) - summaDifference_old;
                  _ref(str, summaDifference);
                });
                if (widget.type==3) {
                  Navigator.pop(context, str);
                }
              },
            ),
          )
        );
      else
        widgetList.add(ExpansionTile(
          title: Text('${str.workName}'),
          //leading: Container(child: Text(str.workName ?? '', style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),), width: 200,),
          subtitle: Text('Сумма: ${NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 0).format(str.summa)}', style: TextStyle(fontWeight: FontWeight.w700, fontStyle: FontStyle.italic)),
          children: _generateChildrens(str, level+10),
        ),
        );
    }

    return widgetList;
  }

  _ref(var str, summaDifference) {
    var _filtered2 = filteredListWorks.where((element) => element.workId!.toLowerCase()==(str.parentId!.toLowerCase())).toList();
    for (var str2 in _filtered2) {
      str2.summa=str2.summa!+summaDifference;
      _ref(str2, summaDifference);
    }
  }
}

enum MenuEditWorks { itemWorkAdd }