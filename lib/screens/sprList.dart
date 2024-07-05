import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:repairmodule/components/Cards.dart';
import 'package:repairmodule/models/Lists.dart';
//import 'package:repairmodule/components/Cards.dart;
import 'package:http/http.dart' as http;
import 'package:repairmodule/screens/profileMan_edit.dart';
import 'package:repairmodule/screens/sprList_create.dart';


class scrListScreen extends StatefulWidget {
  final String sprName;
  final String onType;

  scrListScreen({super.key, required this.sprName, required this.onType});

  @override
  State<scrListScreen> createState() => _scrListScreenState();
}

class _scrListScreenState extends State<scrListScreen> {
  List <sprList> objectList = [];
  List <sprList> objectListFiltered = [];
  bool _isActive = false;

  Future httpGetListObject() async {
    print(widget.sprName);
    final _queryParameters = {'userId': Globals.anPhone};
    var _url=Uri(path: '${Globals.anPath}sprList/${widget.sprName}', host: Globals.anServer, scheme: 'https', queryParameters: _queryParameters);
    print(_url.path);
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': Globals.anAuthorization
    };
    try {
      var response = await http.get(_url, headers: _headers);
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        var notesJson = json.decode(response.body);
        for (var noteJson in notesJson) {
          objectList.add(sprList.fromJson(noteJson));
        }
        objectListFiltered = objectList;
      }
    } catch (error) {
      print("Ошибка при формировании списка: $error");
    }
  }

  void _findList(value) {
    setState(() {
      objectListFiltered = objectList.where((element) => element.name.toLowerCase().contains(value.toLowerCase())).toList();
    });
  }

  @override
  void initState() {
    objectList.clear();
    httpGetListObject().then((value) {
      setState(() {
      });
    });
    // TODO: implement initState
    super.initState();
  }
  Widget build(BuildContext context) {
    print(widget.sprName);
    return Scaffold(
      appBar: AppBar(
        title: SearchBar(),
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
          itemCount: objectListFiltered.length,
            itemBuilder: (_, index) => sprCardList(event: objectListFiltered[index], onType: widget.onType, name: widget.sprName),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async{
              String _newCode='';
              if (widget.sprName=='АналитикаДвиженийДСПриход')
                _newCode='0';
              if (widget.sprName=='АналитикаДвиженийДСРасход')
                _newCode='1';
              if (widget.sprName=='АналитикаДвиженийДС')
                _newCode='1';
              
              if (widget.sprName=='Сотрудники' || widget.sprName=='Контрагенты' || widget.sprName=='КонтрагентыДляФондов') {
                //тут все неверно. Нужно создавать выпадающее меню с вариантами выбора, создаем сотрудника или контрагнета для фонда. Клиентов не создаем, т.к. они создаются  при создании объетов
                //меню должно быть только если widget.sprName=='Контрагенты'
                //решил доп меню пока не делать. Если тут список НЕ сотрудников, то создавать всегда контрагентаДляФонда
                int _type=4;
                if (widget.sprName=='Сотрудники')
                  _type=1;
                //if (widget.sprName=='КонтрагентыДляФондов')
                //  _type=4;

                await Navigator.push(context, MaterialPageRoute(builder: (context) => scrProfileManEditScreen(id: '', email: '', phone: '', name: '', type: _type,)));
              }
              else {
                sprList _newSpr = sprList('', '', '', _newCode, false);
                await Navigator.push(context, MaterialPageRoute(builder: (context) => scrListCreateScreen(sprName: widget.sprName, sprObject: _newSpr,)));
              }
              initState();
            },
            child: Text('+'),)
          //backgroundColor: Colors.grey[900]),
    );
  }

  SearchBar() {
    return Row(
      children: [
        if (!_isActive)
          Text("Справочник",
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

