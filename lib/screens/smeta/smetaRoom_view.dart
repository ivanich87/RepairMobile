import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:repairmodule/components/Cards.dart';
import 'package:repairmodule/models/ListWorks.dart';
import 'package:repairmodule/models/Lists.dart';
import 'package:http/http.dart' as http;
import 'package:repairmodule/models/httpRest.dart';



class scrSmetaRoomViewScreen extends StatefulWidget {
  final String smeta_id;
  final String room_id;
  final String room_name;
  final List <Works> works;

  scrSmetaRoomViewScreen(this.smeta_id, this.room_id, this.room_name, this.works);

  @override
  State<scrSmetaRoomViewScreen> createState() => _scrSmetaRoomViewScreenState();
}

class _scrSmetaRoomViewScreenState extends State<scrSmetaRoomViewScreen> {
  List <ListSmetaRoom> roomList = [];
  List <ListSmetaParam> paramList = [];


  @override
  void initState() {
    print('initState');

    httpGetSmetaWorkRoom(widget.smeta_id, widget.room_id).then((value) {
      setState(() {
      });
    });
    // TODO: implement initState
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.room_name}'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.menu))
        ],
      ),
        body: Column(
          children: [
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
                        onTap: () {},
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

