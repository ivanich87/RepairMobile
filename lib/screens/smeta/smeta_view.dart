import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:repairmodule/components/Cards.dart';
import 'package:repairmodule/models/ListWorks.dart';
import 'package:repairmodule/models/Lists.dart';
import 'package:http/http.dart' as http;
import 'package:repairmodule/models/httpRest.dart';
import 'package:repairmodule/screens/smeta/smetaPrice_view.dart';



class scrSmetaViewScreen extends StatefulWidget {
  final ListSmeta smeta;

  scrSmetaViewScreen(this.smeta);

  @override
  State<scrSmetaViewScreen> createState() => _scrSmetaViewScreenState();
}

class _scrSmetaViewScreenState extends State<scrSmetaViewScreen> {
  List <ListSmetaRoom> roomList = [];
  List <ListSmetaParam> paramList = [];
  List <Works> workList = [];

  @override
  void initState() {
    print('initState');

    httpGetSmetaInfo(widget.smeta.id, roomList, paramList, workList).then((value) {
      setState(() {
        workList.clear();
      });
    });
    // TODO: implement initState
    super.initState();
  }

  _getWorkRoom(smetaid, roomid, workList) {
    httpGetSmetaRoomWorks(smetaid, roomid, workList);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Смета № ${widget.smeta.number}'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.menu))
        ],
      ),
        body: Column(
          children: [
            Text('Сумма сметы: ${NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(widget.smeta.summa)}'),
            Text('Сумма субподрядчика: ${NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(widget.smeta.seb)}'),
            Text(widget.smeta.number),
            Text(widget.smeta.date.toString()),
            Text(widget.smeta.name),
            Text(widget.smeta.addres),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(10),
                physics: BouncingScrollPhysics(),
                reverse: false,
                itemCount: roomList.length,
                  itemBuilder: (_, index) {
                    return Card(
                      child: ListTile(
                        title: Text(roomList[index].name, style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18)),
                        trailing: Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(roomList[index].summa), style: TextStyle(fontSize: 16)),
                        onTap: () async {
                          await httpGetSmetaRoomWorks(widget.smeta.id, roomList[index].id, workList);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => scrSmetaPriceViewScreen(workList, '00000000-0000-0000-0000-000000000000', roomList[index].name, SmetaAllWork(false))));
                        },
                      ),
                    );
              
                  },
                ),
            ),
          ],
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

