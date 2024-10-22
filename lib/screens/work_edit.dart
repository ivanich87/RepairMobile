import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';
import 'package:intl/intl.dart';
import 'package:repairmodule/components/Cards.dart';
import 'package:repairmodule/components/SingleSelections.dart';
import 'package:repairmodule/models/ListWorks.dart';
import 'package:repairmodule/models/Lists.dart';
import 'package:http/http.dart' as http;

import 'object_create.dart';
import 'object_view.dart';


class scrWorkEditScreen extends StatefulWidget {
  final String id;

  scrWorkEditScreen(this.id);

  @override
  State<scrWorkEditScreen> createState() => _scrWorkEditScreenState();
}

class _scrWorkEditScreenState extends State<scrWorkEditScreen> {
  List<Works> ListWorks = [];
  List<Works> filteredListWorks = [];
  List<Works> ListWorksTitle = [];
  var myObjects = [];

  Future httpGetInfoObject() async {
    final _queryParameters = {'userId': Globals.anPhone};

    var _url=Uri(path: '${Globals.anPath}workedit/${widget.id}/', host: Globals.anServer, scheme: 'https', queryParameters: _queryParameters);
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
        var notesJson = json.decode(response.body)['sost'];
        for (var noteJson in notesJson) {
          ListWorks.add(Works.fromJson(noteJson));
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

  @override
  void initState() {
    print('initState');
    ListWorks.clear();
    ListWorksTitle.clear();

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
        title: Text('Редактирование'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.menu))
        ],
      ),
        body: Column(
          children: [
            ElevatedButton(
              child: Container(width: 220, child: Row(crossAxisAlignment: CrossAxisAlignment.center , mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.edit), Text(' Редактировать работы')],)),
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white70, elevation: 4,
                  //padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal)),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(10),
                physics: BouncingScrollPhysics(),
                reverse: false,
                itemCount: ListWorksTitle.length,
                itemBuilder: (_, index) => Card(
                  child:
                  ExpansionTile(
                    title: Text(ListWorksTitle[index].workName ?? 'dd'),
                    children: //<Widget>[
                    _generateChildrens(ListWorksTitle[index]),
                  ),
                ),
              ),
            ),
          ],
        )
    );
  }

  List<Widget> _generateChildrens(event) {
    var widgetList = <Widget>[];

     var value = event.workId;
     //print(event.workName);
     var _filtered = ListWorks.where((element) => element.parentId!.toLowerCase()==(value.toLowerCase())).toList();

    for (var str in _filtered) {
      //print(str);
      if (str.isFolder != true)
        widgetList.add(
          ListTile(
            title: Text(str.workName ?? ''),
            trailing: Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 0).format(str.summa), style: TextStyle(fontSize: 16)),
            subtitle: Text('Цена: ${str.price.toString()}; Кол-во: ${str.kol}', style: TextStyle(fontStyle: FontStyle.italic),),
          )
        );
      else
        widgetList.add(ExpansionTile(
          title: Text(str.workName.toString()),
          //leading: Container(child: Text(str.workName ?? '', style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),), width: 200,),
          subtitle: Text('Сумма: ${NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 0).format(str.summa)}', style: TextStyle(fontWeight: FontWeight.w700, fontStyle: FontStyle.italic)),
          children: _generateChildrens(str),
        ),
        );
    }
    //widgetList.add(ListTile(title: Text('вава')),);

    return widgetList;

    // var widgetList = <Widget>[];
    // widgetList.add(ListTile(title: Text('Sub-item 01')),);
    // widgetList.add(ListTile(title: Text('Sub-item 02')),);
    // return widgetList.toList().expand((i) => i).toList();

    // var list = myObjects.map<List<Widget>>(
    //       (data) {
    //     var widgetList = <Widget>[];
    //     widgetList.add(ListTile(title: Text('Sub-item 01')),);
    //     widgetList.add(ListTile(title: Text('Sub-item 02')),);
    //     return widgetList;
    //   },
    // ).toList();
    // var flat = list.expand((i) => i).toList();
    // return flat;
  }

}

