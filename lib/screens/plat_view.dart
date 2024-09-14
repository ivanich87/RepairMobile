import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:repairmodule/components/SingleSelections.dart';
import 'package:repairmodule/screens/filesAttached.dart';
import 'package:repairmodule/screens/profileMan.dart';
import 'package:repairmodule/models/Lists.dart';
import 'package:repairmodule/screens/object_view.dart';
import 'package:repairmodule/screens/plat_edit.dart';

import '../components/Cards.dart';

class scrPlatsViewScreen extends StatefulWidget {
  //final String id;
  final ListPlat plat;
  scrPlatsViewScreen({super.key, required this.plat});

  @override
  State<scrPlatsViewScreen> createState() => _scrPlatsViewScreenState();
}

class _scrPlatsViewScreenState extends State<scrPlatsViewScreen> {
  bool isVideo = false;

  String address = 'no address';
  String name = 'no name';

  //String id = 'no id';
  String nameClient = 'no nameClient';
  String idClient = 'no idClient';
  String nameManager = 'no nameManager';
  String idManager = 'no idManager';
  String nameProrab = 'no nameProrab';
  String idProrab = 'no idProrab';
  String startDate = '20010101';
  String stopDate = '20010101';
  int summa = 0;
  int summaSeb = 0;
  int summaAkt = 0;
  int percent = 0;
  int payment = 0;
  int area = 0;

  bool userDataEdit = false;

  Future<bool> httpStatusUpdate(bool _accept) async {
    bool _result=false;
    String _message = 'Ошибка';
    final _queryParameters = {'userId': Globals.anPhone};
    var _url=Uri(path: '${Globals.anPath}plataccept/${widget.plat.id}/${(_accept==true) ? '1' : '0'}', host: Globals.anServer, scheme: 'https', queryParameters: _queryParameters);
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': Globals.anAuthorization
    };
    try {
      var response = await http.get(_url, headers: _headers);
      print('Код ответа: ${response.statusCode} Тело ответа: ${response.body}');
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        _result = data['Успешно'] ?? '';
        _message = data['Сообщение'] ?? '';

        print('Платеж согласован. Результат:  $_result. Сообщение:  $_message');
      }
      else {
        _result = false;
        _message = response.body;
      }
      if (_result == false)
        throw _message;
    }
    catch (error) {
      _result = false;
      print("Ошибка при выгрузке платежа: $error");
      final snackBar = SnackBar(
        content: Text('$error'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    return _result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    print('Идентификатор платежа: ${widget.plat.id}');
    return Scaffold(
        appBar: AppBar(
          title: Text('Платеж'),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: (Globals.anCreatePlat==false || (Globals.anUserRoleId!=3 && widget.plat.accept==true)) ? null : <Widget>[_menuAppBar()],
        ),
        body: Stack(
          children: [
            ListView(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  //crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            widget.plat.name,
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '№ ${widget.plat.number} от ${DateFormat('dd.MM.yyyy').format(widget.plat.date)}',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          if (widget.plat.accept==false && widget.plat.del==false)
                            Text('Платеж не подтвержден', style: TextStyle(color: Colors.amber),),
                          if (widget.plat.del==true)
                            Text('Платеж удален', style: TextStyle(color: Colors.red),),
                        ],
                      ),
                    ),
                    Divider(),
                    Card(
                      child: ListTile(
                        title: Text('Посмотреть фото (${widget.plat.attachedKol})'),
                        leading: Icon(Icons.photo),
                        trailing: Icon(Icons.navigate_next),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => scrAttachedScreen(widget.plat.id)));
                        },
                      ),
                    ),
                    Divider(),
                    _payer(widget: widget,),
                    Divider(),
                    if (widget.plat.objectName!='')
                    SingleSection(
                      title: 'Сведения об объекте',
                      children: [
                        _CustomListTile(
                            title: 'Договор № ${widget.plat.dogNumber} от ${DateFormat('dd.MM.yyyy').format(widget.plat.dogDate)}',
                            icon: Icons.paste_rounded,
                            id: '',
                            idType: ''),
                        _CustomListTile(
                            title: 'Объект: ${widget.plat.objectName}',
                            icon: Icons.location_on_outlined,
                            id: widget.plat.objectId,
                            idType: 'scrObjectsViewScreen'),
                      ],
                    ),
                    if (widget.plat.objectName!='')
                    Divider(),
                    _recipient(widget: widget,),
                    Divider(),
                    SingleSection(
                      title: 'Аналитика и комментарий',
                      children: [
                        if (widget.plat.platType!='Перемещение' && widget.plat.type!='Выдача денежных средств в подотчет')
                        _CustomListTile(
                            title: "${widget.plat.analyticName}",
                            icon: Icons.analytics,
                            id: '',
                            idType: ''),
                        _CustomListTile(
                            title: widget.plat.comment,
                            icon: Icons.comment_outlined,
                            id: '',
                            idType: ''),
                      ],
                    ),
                    Text('${NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(widget.plat.summa)} руб.', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: (widget.plat.summa>=0) ? Colors.green : Colors.red)),
                    SizedBox(height: 55,)
                  ],
                ),
              ],
            ),
            if (widget.plat.accept==false && widget.plat.del==false)
            Align(alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12.0, left: 8, right: 8),
                child: SafeArea(
                  child:
                  Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        icon: Icon(Icons.check, color: Colors.black),
                        label: Text('Согласовать', style: TextStyle(color: Colors.black, fontSize: 15)),
                        onPressed: () {
                          httpStatusUpdate(true).then((value) async {
                            if (value==true) {
                              setState(() {
                                widget.plat.accept=true;
                              });
                              Navigator.pop(context);
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      ElevatedButton.icon(
                          icon: const Icon(Icons.delete, color: Colors.black),
                          label: const Text("Отклонить", style: TextStyle(color: Colors.black, fontSize: 15)),
                          onPressed: () async {
                            httpStatusUpdate(false).then((value) async {
                              if (value==true) {
                                setState(() {
                                  widget.plat.del=true;
                                });
                                Navigator.pop(context);
                              }
                            });
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                          ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: (Globals.anCreatePlat==false || (Globals.anUserRoleId!=3 && widget.plat.accept==true)) ? null : FloatingActionButton(
          onPressed: () async{
            await Navigator.push(context, MaterialPageRoute(builder: (context) => scrPlatEditScreen(plat2: widget.plat,)));
            setState(() {

            });
          },
          child: Icon(Icons.edit),
        )
      //backgroundColor: Colors.grey[900]),
    );
  }

  PopupMenuButton<Menu> _menuAppBar() {
    return PopupMenuButton<Menu>(
        icon: const Icon(Icons.menu, ),
        offset: const Offset(0, 40),
        onSelected: (Menu item) async {
          if (item == Menu.itemEdit) {
            await Navigator.push(context, MaterialPageRoute(builder: (context) => scrPlatEditScreen(plat2: widget.plat,)));
            setState(() {

            });
          }
          if (item == Menu.itemDelete) {
            httpEventDelete(widget.plat.id, widget.plat.del, context).then((value) {
              userDataEdit = value;
              print('userDataEdit = $value');
              if (userDataEdit==true) {
                widget.plat.del=!widget.plat.del;
                Navigator.pop(context);
              }
            });
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
          const PopupMenuItem<Menu>(
            value: Menu.itemEdit,
            child: Text('Редактировать'),
          ),
          const PopupMenuItem<Menu>(
            value: Menu.itemDelete,
            child: Text('Удалить'),
          ),
        ].toList());
  }

}

enum Menu { itemEdit, itemDelete }



class _CustomListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? trailing;
  final String id;
  final String idType;

  const _CustomListTile(
      {Key? key, required this.title, required this.icon, this.trailing, required this.id, required this.idType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title ?? 'ggg'),
      leading: Icon(icon),
      trailing: trailing,
      onTap: () {
        if (id != '') {
          print(id);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) {
                    if (idType=='scrProfileMan') {
                      return scrProfileMan(id: id,);
                    };
                    if (idType=='scrObjectsViewScreen') {
                      return scrObjectsViewScreen(id: id,);
                    };
                    return scrProfileMan(id: id,);
                  } ));
        }
      },
    );
  }

}

class _payer extends StatelessWidget {
  final widget;
  const _payer(
      {Key? key, this.widget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (widget.plat.platType!='Приход') {
      return SingleSection(
        title: 'Сведения о плательщике',
        children: [
          _CustomListTile(
              title: '${widget.plat.kassa}',
              icon: (widget.plat.kassaType == 1
                  ? Icons.account_balance_wallet
                  : Icons.credit_card),
              id: (widget.plat.kassaType == 1 ? widget.plat.kassaSotrId : ''),
              idType: 'scrProfileMan'),
          if (widget.plat.companyName!='')
          _CustomListTile(
              title: '${widget.plat.companyName}',
              icon: Icons.account_balance,
              id: '',
              idType: ''),
          ],
        );
      };
    return SingleSection(
          title: 'Сведения о плательщике',
          children: [
            _CustomListTile(
                title: (widget.plat.type=='Выдача денежных средств в подотчет') ? widget.plat.kassaSotrName : widget.plat.contractorName,
                icon: Icons.man,
                id: '',
                idType: '')
          ]
      );
  }

}

class _recipient extends StatelessWidget {
  final widget;
  const _recipient(
      {Key? key, this.widget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (widget.plat.platType=='Приход') {
      return SingleSection(
        title: 'Сведения о получателе',
        children: [
          _CustomListTile(
              title: '${widget.plat.kassaName}', //было widget.plat.kassa
              icon: (widget.plat.kassaType == 1
                  ? Icons.account_balance_wallet
                  : Icons.credit_card),
              id: (widget.plat.kassaType == 1 ? widget.plat.kassaSotrId : ''),
              idType: 'scrProfileMan'),
          if (widget.plat.companyName!='')
          _CustomListTile(
              title: '${widget.plat.companyName}',
              icon: Icons.account_balance,
              id: '',
              idType: ''),
        ],
      );
    }
    return SingleSection(
        title: 'Сведения о получателе',
        children: [
          _CustomListTile(
              title: (widget.plat.type=='Выдача денежных средств в подотчет') ? widget.plat.kassaSotrName : widget.plat.contractorName,
              icon: Icons.man,
              id: '',
              idType: '')
        ]
    );
  }

}

