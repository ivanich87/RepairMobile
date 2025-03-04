import 'dart:convert';

import 'package:flutter/material.dart';
//import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';
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
  final int priceDefault;

  scrWorksEditScreen(this.id, this.type, this.dogId, this.additionalWork, this.priceDefault);

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
      var response = await http.post(_url, headers: _headers, body: json.encode(filteredListWorks));
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
        titleName = 'Редактирование';
      case 2:
        titleName = 'Редактирование';
      case 3:
        titleName = 'Выбор работы';
    }
    return Scaffold(
      appBar: AppBar(
        title: SearchBar(), //Text(titleName),
        centerTitle: true,
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
                                  filteredListWorks = List.from(ListWorks);
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
                scrWorksEditScreen(widget.id, 3, widget.dogId, true, widget.priceDefault)));
            if (_res!=null) {
              print('Закрыли подбор доп работ');
              print(_res.workName);
              var _filt = ListWorks.where((element) => element.workId!.toLowerCase()==(_res.parentId.toLowerCase())).toList();
              if (_filt.length==0) {
                print('Нов');
                print('workId ${_res.parentId}');
                print('parentId ${ListWorksTitle[0].roomId}');
                ListWorks.add(Works(workId: _res.parentId, parentId: ListWorksTitle[0].roomId, workName: 'Доп работы', isFolder: true, summa: 100, roomId: ListWorksTitle[0].roomId, price: 100, kol: 0, kolRemains: 0,kolSmeta: 0,kolUsed: 0,priceSub: 0,summaSub: 0));
                filteredListWorks.add(Works(workId: _res.parentId, parentId: ListWorksTitle[0].roomId, workName: 'Доп работы', isFolder: true, summa: 100, roomId: ListWorksTitle[0].roomId, price: 100, kol: 0, kolRemains: 0,kolSmeta: 0,kolUsed: 0,priceSub: 0,summaSub: 0));
              }
              ListWorks.add(_res);
              filteredListWorks.add(_res);
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
                    str.summa = str.kol! * str.price!;
                    str.summaSub = str.kol! * str.priceSub!;
                    if (widget.priceDefault==1)
                      summaDifference = str.price! * str.kol!;
                    else
                      summaDifference = str.priceSub! * str.kol!;
                  }
                  else {
                    if (widget.priceDefault==1)
                      summaDifference = -1*(str.price! * str.kol!);
                    else
                      summaDifference = -1*(str.priceSub! * str.kol!);
                    str.kol=0;
                    str.summa=0;
                  }

                  _ref(str, summaDifference);
                  _refListWorks(str);
                  //_ref2(str, summaDifference);

                });
              }, ),
              subtitle: Text('Цена: ${(widget.priceDefault==1) ? str.price.toString() : str.priceSub.toString()}; Кол-во: ${str.kol}; Сумма: ${(widget.priceDefault==1) ? str.summa : str.summaSub}', style: TextStyle(fontStyle: FontStyle.italic, color: _colors(str.kol)),),
              onTap: () async {
                num summaDifference_old = (widget.priceDefault==1) ? str.price! : str.priceSub! * str.kol!;
                print(summaDifference_old);
                await Navigator.push(context, MaterialPageRoute(builder: (context) => scrWorkEditingScreen(str, widget.additionalWork)));
                setState(() {
                  num summaDifference = 0;
                  if (widget.priceDefault==1)
                    summaDifference = (str.price! * str.kol!) - summaDifference_old;
                  else
                    summaDifference = (str.priceSub! * str.kol!) - summaDifference_old;
                  print(summaDifference);
                  _ref(str, summaDifference);
                  _refListWorks(str);
                  //_ref2(str, summaDifference);
                });
                if (widget.type==3) {
                  print('Закрываем окно подбора доп работа');
                  print(str.workName);
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
          subtitle: Text('Сумма: ${NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 0).format((widget.priceDefault==1) ? str.summa : str.summaSub)}', style: TextStyle(fontWeight: FontWeight.w700, fontStyle: FontStyle.italic, color: _colors(str.summa))),
          children: _generateChildrens(str, level+10),
        ),
        );
    }

    return widgetList;
  }

  _colors(kol) {

    if (kol==0)
      return Colors.blueGrey;
    if (widget.priceDefault==1)
      return Colors.green.shade800;
    else
      return Colors.red.shade800;
  }

  _ref(var str, summaDifference) {
    var _filtered2 = filteredListWorks.where((element) => element.workId!.toLowerCase() == (str.parentId!.toLowerCase())).toList();
    for (var str2 in _filtered2) {
      print('_ref1: ${str2.workName} = ${str2.summa}');
      str2.summa = str2.summa! + summaDifference;
      print('_ref1: ${str2.workName} = ${str2.summa}');
      //print('${str2.workName} = ${str2.summa}');
      _ref(str2, summaDifference);
    }
  }

  _ref2(var str, summaDifference) {
    var _filtered3 = ListWorks.where((element) => element.workId!.toLowerCase()==(str.parentId!.toLowerCase())).toList();
    for (var str3 in _filtered3) {
      print('_ref2: ${str3.workName} = ${str3.summa}');
      str3.summa=str3.summa!+summaDifference;
      print('_ref2: ${str3.workName} = ${str3.summa}');
      //str3.summaSub=str3.summaSub!+summaDifference;
      _ref2(str3, summaDifference);
    }
  }

  _refListWorks(var str) {
    var _filtered2 = ListWorks.where((element) => element.workId!.toLowerCase()==(str.workId!.toLowerCase())).toList();
    for (var str2 in _filtered2) {
      str2.kol=str.kol;
      str2.summa=str.summa;
      str2.summaSub=str.summaSub;
      print('${str2.workName} = ${str2.summa}');
    }
  }
}

enum MenuEditWorks { itemWorkAdd }