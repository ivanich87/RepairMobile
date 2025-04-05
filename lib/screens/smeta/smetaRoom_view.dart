import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:repairmodule/components/Cards.dart';
import 'package:repairmodule/models/ListWorks.dart';
import 'package:repairmodule/models/Lists.dart';
import 'package:http/http.dart' as http;
import 'package:repairmodule/models/httpRest.dart';
import 'package:repairmodule/screens/smeta/smetaParamCalculation.dart';
import 'package:repairmodule/screens/smeta/smetaPrice_view.dart';



class scrSmetaRoomViewScreen extends StatefulWidget {
  final String smeta_id;
  final String room_id;
  final String room_name;
  final List <ListSmetaParam> param;

  scrSmetaRoomViewScreen(this.smeta_id, this.room_id, this.room_name, this.param);

  @override
  State<scrSmetaRoomViewScreen> createState() => _scrSmetaRoomViewScreenState();
}

class _scrSmetaRoomViewScreenState extends State<scrSmetaRoomViewScreen> {
  List <ListSmetaParam> filtered_param = [];
  bool _isLoad = true;
  List <Works> workList = [];

  @override
  void initState() {
    print('initState');

    // httpGetSmetaWorkRoom(widget.smeta_id, widget.room_id).then((value) {
    //   setState(() {
    //   });
    // });
    // TODO: implement initState
    super.initState();
  }


  Widget build(BuildContext context) {
    _findList(widget.room_id);
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.room_name}'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.menu))
        ],
      ),
        body: (_isLoad==false) ? Center(child: CircularProgressIndicator()) : ListView(
          children: [
              Container(height: 300, color: Colors.brown, margin: EdgeInsets.all(8),
                child: Center(
                  child: Text('Тут будет фото')
              ),),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Divider(height: 3),
              ),
              ListTile(title: Text('ПАРАМЕТРЫ ПОМЕЩЕНИЯ', style: TextStyle(fontSize: 18),), leading: Icon(Icons.crop_free), ),
              _pageParam(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton.icon(
                  icon: Icon(Icons.abc, color: Colors.black),
                  label: Text('Помощник расчета параметров', style: TextStyle(color: Colors.black, fontSize: 15)),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => scrSmetaParamCalculationScreen(widget.smeta_id, widget.room_id, widget.room_name, widget.param)));
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Divider(height: 3),
              ),
              ListTile(title: Text('СУММЫ', style: TextStyle(fontSize: 18),), leading: Icon(Icons.currency_ruble), ),
              Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    Card(child:
                      ListTile(
                        title: Text('Сумма сметы', style: TextStyle(fontSize: 18)),
                        subtitle: Text('Сумма за работы', style: TextStyle(fontSize: 12)),
                        trailing: Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(134000), style: TextStyle(fontSize: 16, color: Colors.green.shade800, fontWeight: FontWeight.bold),),
                      )
                    ),
                    Card(child:
                      ListTile(
                        title: Text('Себестоимость', style: TextStyle(fontSize: 18)),
                        subtitle: Text('Сумма мастеров', style: TextStyle(fontSize: 12)),
                        trailing: Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(134000), style: TextStyle(fontSize: 16, color: Colors.red.shade800, fontWeight: FontWeight.bold),),
                      )
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: ElevatedButton.icon(
                  icon: Icon(Icons.edit, color: Colors.black),
                  label: Text('Редактирование работ', style: TextStyle(color: Colors.black, fontSize: 15)),
                  onPressed: () async {
                    setState(() {
                      _isLoad = false;
                    });

                    await httpGetSmetaRoomWorks(widget.smeta_id, widget.room_id, workList);
                    setState(() {
                      _isLoad = true;
                    });
                    Navigator.push(context, MaterialPageRoute(builder: (context) => scrSmetaPriceViewScreen(workList, '00000000-0000-0000-0000-000000000000', widget.room_name, SmetaAllWork(false))));
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              )
            ],

          ),
    );
  }

  _pageParam() {
    return ListView.builder(shrinkWrap: true,
      padding: EdgeInsets.all(10),
      physics: BouncingScrollPhysics(),
      reverse: false,
      itemCount: filtered_param.length,
      itemBuilder: (_, index) {
        return Card(
          child: ListTile(
            title: Text(filtered_param[index].param_name, style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18)),
            trailing: Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(filtered_param[index].value), style: TextStyle(fontSize: 16)),
            onTap: () {},
          ),
        );

      },
    );
  }

  void _findList(value) {
    setState(() {
      filtered_param = widget.param.where((element) => element.room_id!.toLowerCase().contains(value.toLowerCase())).toList();
    });
  }



}

