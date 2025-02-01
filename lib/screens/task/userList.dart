import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:repairmodule/screens/task/taskLists.dart';

import '../../models/Lists.dart';




class scrUserListScreen extends StatefulWidget {
  final bool selectGroup;

  scrUserListScreen(this.selectGroup);

  @override
  State<scrUserListScreen> createState() => _scrUserListScreenState();
}

class _scrUserListScreenState extends State<scrUserListScreen> {
  List<resultList> objectList = [];
  List<resultList> objectListFiltered = [];
  bool _isActive = false;

  Future httpGetListUser() async {
    var _queryParameters = <String, dynamic>
    {
      'userId': Globals.anPhone,
      'selectGroup': (widget.selectGroup==true) ? '1' : '2'
    };
    var _url=Uri(path: '${Globals.anPath}userlist/', host: Globals.anServer, scheme: 'https', queryParameters: _queryParameters);
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': Globals.anAuthorization
    };
    try {
      var response = await http.get(_url, headers: _headers);
      print('Выполнен запрос, ответ ${response.statusCode.toString()}');
      if (response.statusCode == 200) {
        var notesJson = json.decode(response.body);
        for (var noteJson in notesJson) {
          objectList.add(resultList.fromJson(noteJson));
          objectListFiltered.add(resultList.fromJson(noteJson));
        }
      }
    } catch (error) {
      print("Ошибка при формировании списка: $error");
    }
  }

  void _findList(value) {
    setState(() {
      objectListFiltered = objectList.where((element) => element.resultFind.toLowerCase().contains(value.toLowerCase())).toList();
    });
  }

  @override
  void initState() {
    print('initState');
    objectList.clear();
    objectListFiltered.clear();

    httpGetListUser().then((value) {
      setState(() {
      });
    });
    // TODO: implement initState
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SearchBar(),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        physics: BouncingScrollPhysics(),
        reverse: false,
        itemCount: objectListFiltered.length,
        itemBuilder: (_, index) =>
            Card(
                child: ListTile(
                    title: Text(objectListFiltered[index].resultName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                    subtitle: Text('${objectListFiltered[index].resultComment} (таб. ${objectListFiltered[index].resultCode.toString()})'),
                    onTap: () async {
                      Navigator.pop(context, SelectedSPR(objectListFiltered[index].resultId, objectListFiltered[index].resultName));
                    },
                    onLongPress: () {
                      print(objectListFiltered[index].resultName);
                    })
            ),
      ),
    );
  }


  SearchBar() {
    return Row(
      children: [
        if (!_isActive)
          Text("Типы",
              style: Theme.of(context).appBarTheme.titleTextStyle),
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
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Введите строку для поиска',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isActive = false;
                              objectListFiltered = objectList;
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
}
