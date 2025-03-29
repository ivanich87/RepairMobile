import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:repairmodule/components/Cards.dart';
import 'package:repairmodule/models/Lists.dart';
import 'package:http/http.dart' as http;
import 'package:repairmodule/models/httpRest.dart';



class scrSmetaListScreen extends StatefulWidget {


  scrSmetaListScreen();

  @override
  State<scrSmetaListScreen> createState() => _scrSmetaListScreenState();
}

class _scrSmetaListScreenState extends State<scrSmetaListScreen> {
  var objectList = [];


  @override
  void initState() {
    print('initState');
    objectList.clear();

    httpGetListSmeta(objectList).then((value) {
      setState(() {
      });
    });
    // TODO: implement initState
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Объекты в работе'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.menu))
        ],
      ),
        body: (objectList.length==0) ? Center(child: Text('У вас еще нет смет. Добавьте смету по кнопке справа внизу')) :
        ListView.builder(
          padding: EdgeInsets.all(10),
          physics: BouncingScrollPhysics(),
          reverse: false,
          itemCount: objectList.length,
            itemBuilder: (_, index) {
              return Card(
                child: ListTile(
                  title: Text(objectList[index].name, style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18)),
                  subtitle: Text(objectList[index].addres),
                  trailing: Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(objectList[index].summa), style: TextStyle(fontSize: 16)),
                  onTap: () {},
                ),
              );

            },
          ),
          floatingActionButton: (Globals.anCreateObject==false) ? null : FloatingActionButton(
            onPressed: () async {
              // final newObjectId = await Navigator.push(context, MaterialPageRoute(builder: (context) => scrObjectCreateScreen(),)) ?? '';
              // if (newObjectId!='') {
              //   Navigator.push(context, MaterialPageRoute( builder: (context) => scrObjectsViewScreen(id: newObjectId)));
              //   initState();
              // }
            },
            child: Icon(Icons.add),)
          //backgroundColor: Colors.grey[900]),
    );
  }
}

