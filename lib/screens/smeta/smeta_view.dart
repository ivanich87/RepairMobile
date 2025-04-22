import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:repairmodule/components/Cards.dart';
import 'package:repairmodule/models/ListWorks.dart';
import 'package:repairmodule/models/Lists.dart';
import 'package:http/http.dart' as http;
import 'package:repairmodule/models/httpRest.dart';
import 'package:repairmodule/screens/pdf2.dart';
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
  bool isChange = false;

  bool _writeName = false;
  bool _writeAddres = false;
  TextEditingController smetaName = TextEditingController(text: '');
  TextEditingController smetaAddres = TextEditingController(text: '');

  @override
  void initState() {
    print('initState');

    _refSmeta();

    // TODO: implement initState
    super.initState();
  }

  _refSmeta() async {
    await httpGetSmetaInfo(widget.smeta.id, roomList, widget.smeta);
    setState(() {

    });
  }

  _saveSmeta() async {
    await httpPostSmetaInfo(widget.smeta, roomList);
    setState(() {

    });
    isChange = false;
  }

  _title(type, val){
    if (type==1) {
      if (val==true)
        return TextFormField(
            textAlign: TextAlign.start,
            controller: smetaName,
            keyboardType: TextInputType.text,
            style: TextStyle(fontSize: 18),
            decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Название сметы',
            ),
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.isEmpty) {return 'Заполните название сметы';}
              return null;
            }
        );
      else
        return Text('${widget.smeta.name}', style: TextStyle(fontSize: 18));
    }

    if (type==2) {
      if (val==true)
        return TextFormField(
            textAlign: TextAlign.start,
            controller: smetaAddres,
            keyboardType: TextInputType.text,
            style: TextStyle(fontSize: 18),
            decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Адрес объекта',
            ),
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.isEmpty) {return 'Заполните адрес объекта';}
              return null;
            }
        );
      else
        return Text('${widget.smeta.addres}', style: TextStyle(fontSize: 18));
    }
  }

  PopupMenuButton<MenuEditCommands> _menuAppBar() {
    return PopupMenuButton<MenuEditCommands>(
        icon: const Icon(Icons.menu, ),
        offset: const Offset(0, 40),
        onSelected: (MenuEditCommands item) async {
          if (item == MenuEditCommands.printPriceClient) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => PDFViewerFromUrl(url: 'https://ace:AxWyIvrAKZkw66S7S0BO@${Globals.anServer}${Globals.anPath}print/${widget.smeta.id}/2/',)));
          }
          if (item == MenuEditCommands.printPriceSeb) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => PDFViewerFromUrl(url: 'https://ace:AxWyIvrAKZkw66S7S0BO@${Globals.anServer}${Globals.anPath}print/${widget.smeta.id}/22/',)));
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuEditCommands>>[
          const PopupMenuItem<MenuEditCommands>(
            value: MenuEditCommands.printPriceClient,
            child: Text('Печать сметы по ценам клиента'),
          ),
          const PopupMenuItem<MenuEditCommands>(
            value: MenuEditCommands.printPriceSeb,
            child: Text('Печать сметы по ценам мастеров'),
          ),
        ].toList());
  }


  Widget build(BuildContext context) {
    smetaName.text = widget.smeta.name;
    smetaAddres.text = widget.smeta.addres;
    return Scaffold(
      appBar: AppBar(
        title: Text('Смета № ${widget.smeta.number}'),
        centerTitle: true,
        actions: [_menuAppBar()],
      ),
        body: (isLoad==false) ? Center(child: CircularProgressIndicator()) : Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              Center(child: Text('Смета № ${widget.smeta.number} от ${DateFormat('dd.MM.yyyy').format(widget.smeta.date)}', style: TextStyle(fontSize: 16),)),
              Divider(),
              Card(
                child: ListTile(
                  title: _title(1, _writeName),
                  subtitle: (_writeName==true) ? null : Text('Название сметы'),
                  trailing: IconButton(icon: (_writeName==true) ? Icon(Icons.check) : Icon(Icons.edit), onPressed: (){
                    _writeName= !_writeName;
                    widget.smeta.name = smetaName.text;
                    if (_writeAddres==true) {
                      _writeAddres=false;
                      widget.smeta.addres = smetaAddres.text;
                    }
                    isChange = true;
                    setState(() {

                    });
                    },),
                ),
              ),
              Card(
                child: ListTile(
                  title: _title(2, _writeAddres),
                  subtitle: (_writeAddres==true) ? null : Text('Адрес'),
                  trailing: IconButton(icon: (_writeAddres==true) ? Icon(Icons.check) : Icon(Icons.edit), onPressed: (){
                    _writeAddres= !_writeAddres;
                    widget.smeta.addres = smetaAddres.text;
                    if (_writeName==true) {
                      _writeName=false;
                      widget.smeta.name = smetaName.text;
                    }
                    isChange=true;
                    setState(() {

                    });
                  },),
                ),
              ),
              Card(
                child: ListTile(
                  title: Text('${widget.smeta.price}', style: TextStyle(fontSize: 18)),
                  subtitle: Text('Прайс'),
                  trailing: IconButton(icon: Icon(Icons.edit), onPressed: () async {
                    if (_writeAddres==true) {
                      _writeAddres=false;
                      widget.smeta.addres = smetaAddres.text;
                    }
                    if (_writeName==true) {
                      _writeName=false;
                      widget.smeta.name = smetaName.text;
                    }
                    final newObjectId = await Navigator.push(context, MaterialPageRoute(builder: (context) => scrListScreen(sprName: 'Прайсы', onType: 'pop'),)) ?? '';
                    if (newObjectId.id!='') {
                      setState(() {
                        widget.smeta.priceId = newObjectId.id;
                        widget.smeta.price = newObjectId.name;
                      });
                      isChange = true;
                    }
                  },),
                ),
              ),

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
                          if (_writeAddres==true) {
                            _writeAddres=false;
                            widget.smeta.addres = smetaAddres.text;
                          }
                          if (_writeName==true) {
                            _writeName=false;
                            widget.smeta.name = smetaName.text;
                          }
                          if (widget.smeta.priceId=="" || widget.smeta.priceId.length<6) {
                            final snackBar = SnackBar(content: Text('Выберите прайс!'), );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          }
                          else {
                            if (isChange)
                              await _saveSmeta();
                            if (widget.smeta.id == '' || widget.smeta.id ==
                                'new') {
                              final snackBar = SnackBar(
                                content: Text('Ошибка сохранения сметы!'),);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  snackBar);
                            }
                            else {
                              await Navigator.push(context, MaterialPageRoute(
                                  builder: (context) =>
                                      scrSmetaRoomViewScreen(
                                          widget.smeta.id, roomList[index].id,
                                          roomList[index].name)));
                              _refSmeta();
                            }
                          }
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
                      if (_writeAddres==true) {
                        _writeAddres=false;
                        widget.smeta.addres = smetaAddres.text;
                      }
                      if (_writeName==true) {
                        _writeName=false;
                        widget.smeta.name = smetaName.text;
                      }
                      final newObjectId = await Navigator.push(context, MaterialPageRoute(builder: (context) => scrListScreen(sprName: 'Помещения', onType: 'pop'),)) ?? '';
                      if (newObjectId.id!='') {
                        setState(() {
                          roomList.add(ListSmetaRoom(newObjectId.id, newObjectId.name, 0, 0));
                        });
                        isChange = true;
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
          floatingActionButton: (Globals.anCreateObject==false || isChange==false) ? null : FloatingActionButton(
            onPressed: () async {
              _saveSmeta();
              Navigator.pop(context);
            },
            child: Icon(Icons.save),)
    );
  }
}

enum MenuEditCommands { printPriceClient, printPriceSeb }
