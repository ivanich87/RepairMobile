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
  List <sprList> objectList = [];
  List <sprList> objectListFiltered = [];
  bool _isActive = false;

  Future httpGetListObject() async {
    print(widget.sprName);
    var _url=Uri(path: '/a/centrremonta/hs/v1/sprList/${widget.sprName}', host: 's1.rntx.ru', scheme: 'https');
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': 'Basic YWNlOkF4V3lJdnJBS1prdzY2UzdTMEJP'
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
            itemBuilder: (_, index) => sprCardList(event: objectListFiltered[index], onType: 'pop',),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
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

