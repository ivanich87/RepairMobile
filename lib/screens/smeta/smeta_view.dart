import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:repairmodule/components/Cards.dart';
import 'package:repairmodule/models/ListWorks.dart';
import 'package:repairmodule/models/Lists.dart';
import 'package:http/http.dart' as http;
import 'package:repairmodule/models/httpRest.dart';
import 'package:repairmodule/screens/smeta/smetaPrice_view.dart';
import 'package:repairmodule/screens/smeta/smetaRoom_view.dart';
import 'package:repairmodule/screens/sprList.dart';



class scrSmetaViewScreen extends StatefulWidget {
  final ListSmeta smeta;

  scrSmetaViewScreen(this.smeta);

  @override
  State<scrSmetaViewScreen> createState() => _scrSmetaViewScreenState();
}

class _scrSmetaViewScreenState extends State<scrSmetaViewScreen> {
  List <ListSmetaRoom> roomList = [];
  bool isLoad = true;

  @override
  void initState() {
    print('initState');

    _refSmeta();

    // TODO: implement initState
    super.initState();
  }

  _refSmeta() async {
    await httpGetSmetaInfo(widget.smeta.id, roomList);
    setState(() {

    });
  }

  _saveSmeta() async {
    await httpPostSmetaInfo(widget.smeta, roomList);
    setState(() {

    });

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
        body: (isLoad==false) ? Center(child: CircularProgressIndicator()) : Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(),
              Text('Смета № ${widget.smeta.number} от ${DateFormat('dd.MM.yyyy').format(widget.smeta.date)}', style: TextStyle(fontSize: 16),),
              Text(widget.smeta.name, style: TextStyle(fontSize: 16),),
              Text(widget.smeta.addres, style: TextStyle(fontSize: 16),),
              Divider(),
              Text('Сумма сметы: ${NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(widget.smeta.summa)}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green.shade800)),
              Text('Себестоимость: ${NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(widget.smeta.seb)}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red.shade800)),
              Divider(),
              SizedBox(height: 8,),
              Text('Помещения:', style: TextStyle(fontSize: 16)),
              ListView.builder(
                shrinkWrap: true,
                //padding: EdgeInsets.all(10),
                physics: BouncingScrollPhysics(),
                reverse: false,
                itemCount: roomList.length,
                  itemBuilder: (_, index) {
                    return Card(
                      child: ListTile(
                        title: Text(roomList[index].name, style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18)),
                        trailing: Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(roomList[index].summa), style: TextStyle(fontSize: 16)),
                        onTap: () async {
                          // setState(() {
                          //   isLoad = false;
                          // });

                          // await httpGetSmetaRoomWorks(widget.smeta.id, roomList[index].id, workList);
                          // setState(() {
                          //   isLoad = true;
                          // });
                          //Navigator.push(context, MaterialPageRoute(builder: (context) => scrSmetaPriceViewScreen(workList, '00000000-0000-0000-0000-000000000000', roomList[index].name, SmetaAllWork(false))));
                          Navigator.push(context, MaterialPageRoute(builder: (context) => scrSmetaRoomViewScreen(widget.smeta.id, roomList[index].id, roomList[index].name)));
                        },
                      ),
                    );

                  },
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Center(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.add, color: Colors.black),
                    label: Text('Добавить помещение', style: TextStyle(color: Colors.black, fontSize: 15)),
                    onPressed: () async {
                      final newObjectId = await Navigator.push(context, MaterialPageRoute(builder: (context) => scrListScreen(sprName: 'Помещения', onType: 'pop'),)) ?? '';
                      if (newObjectId.id!='') {
                        setState(() {
                          roomList.add(ListSmetaRoom(newObjectId.id, newObjectId.name, 0, 0));
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ),
              )

            ],
          ),
        ),
          floatingActionButton: (Globals.anCreateObject==false) ? null : FloatingActionButton(
            onPressed: () async {
              _saveSmeta();
            },
            child: Icon(Icons.save),)
    );
  }
}


