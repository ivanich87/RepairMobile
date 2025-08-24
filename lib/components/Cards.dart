import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:repairmodule/models/Lists.dart';
import 'package:repairmodule/screens/ReceiptView.dart';
import 'package:repairmodule/screens/object_view.dart';
import 'package:repairmodule/screens/plat_view.dart';

import 'package:http/http.dart' as http;

import '../screens/cashList.dart';
import '../screens/dogovor_view.dart';
import '../screens/objectsListSelectedDog.dart';
import '../screens/profileMan.dart';
import '../screens/profileMan_edit.dart';
import '../screens/sprList_create.dart';

class CardCategorySums extends StatefulWidget {
  const CardCategorySums({
    super.key,
    required this.event,
  });

  final AccountCategoryMoneyInfo event;

  @override
  State<CardCategorySums> createState() => _CardCategorySumsState();
}

class _CardCategorySumsState extends State<CardCategorySums> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
          title: Text(
            widget.event.name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          trailing: Text(widget.event.summa.toString(),
              style: TextStyle(fontSize: 20, color: textColors(widget.event.summa))),
          //leading: Icon(Icons.monetization_on_outlined, size: 35,),
          onTap: () {},
          onLongPress: () {}),
    );
  }
}

textColors(summ) {
  if (summ<0)
    return Colors.red;
  else
  if (summ==0)
    return null;
        else
    return Colors.green;
}

textDelete(del) {
  if (del==true)
    return TextDecoration.lineThrough;
  else
    return TextDecoration.none;
}

Future<bool> httpEventDelete(String id, bool delete, context) async {
  bool _result=false;
  int del = 0;
  if (delete==false)
    del = 1;
  print(del.toString());
  final _queryParameters = {'userId': Globals.anPhone};
  var _url=Uri(path: '${Globals.anPath}delete/$id/$del/', host: Globals.anServer, scheme: 'https', queryParameters: _queryParameters);
  var _headers = <String, String> {
    'Accept': 'application/json',
    'Authorization': Globals.anAuthorization
  };
  try {
    var response = await http.get(_url, headers: _headers);
    print('Код ответа: ${response.statusCode} Тело ответа: ${response.body}');
    if (response.statusCode == 200) {
      _result=true;

      print('Платеж удален.');
    }
    else {
      _result = false;
      final snackBar = SnackBar(
        content: Text('${response.body}'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  } catch (error) {
    _result = false;
    print("Ошибка при выгрузке платежа: $error");
    final snackBar = SnackBar(
      content: Text('$error'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  return _result ?? false;
}


class CardCashList extends StatefulWidget {
  const CardCashList({
    super.key,
    required this.event,
  });

  final ListCash event;

  @override
  State<CardCashList> createState() => _CardCashListState();
}

class _CardCashListState extends State<CardCashList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(
          widget.event.name,
          style: TextStyle(fontSize: 17),
        ),
        trailing: Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(widget.event.summa), style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic, color: (widget.event.summa<0) ? Colors.red : Colors.green)),
        leading: Icon(widget.event.tip == 1 ? Icons.credit_card: Icons.home_filled),
        onTap: () async {
          Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => scrCashListScreen(idCash: widget.event.id, cashName: 'Все', analytic: '', analyticName: '', objectId: '', objectName: '', platType: '', dateRange: DateTimeRange(start: DateTime.now(), end: DateTime.now()), kassaSotrId: '', kassaSortName: '',  )));},
        onLongPress: () async {
          sprList _newSpr = sprList(widget.event.id, widget.event.name, widget.event.comment, '', false, false);
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => scrListCreateScreen(sprName: (widget.event.tip==1) ? 'Кассы' : 'БанковскиеСчетаОрганизаций', sprObject: _newSpr,)));
          setState(() {
            widget.event.name = _newSpr.name;
            widget.event.comment = _newSpr.comment;
          });
        });
    //scrCashCategoriesScreen(idCash: widget.event.id, cashName: widget.event.name)
  }
}

class sprCardList extends StatefulWidget {
  const sprCardList({
    super.key,
    required this.event,
    required this.onType,
    required this.name
  });

  final sprList event;
  final String onType;
  final String name;

  @override
  State<sprCardList> createState() => _sprCardListState();
}

class _sprCardListState extends State<sprCardList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
            title: Text(widget.event.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
            subtitle: Text(widget.event.comment),
            onTap: () async {
              if (widget.onType=='push') {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>
                            openSpr(widget.name, widget.event)
                ));
              }
              else {
                Navigator.pop(context, SelectedSPR(widget.event.id, widget.event.name));};
            },
            onLongPress: () async {
              if (widget.name=='Сотрудники' || widget.name=='Контрагенты' || widget.name=='КонтрагентыДляФондов') {
                await Navigator.push(context, MaterialPageRoute(builder: (context) => scrProfileMan(id: widget.event.id)));
              }
              else
                await Navigator.push(context, MaterialPageRoute(builder: (context) => scrListCreateScreen(sprName: widget.name, sprObject: widget.event, ))
              );
              setState(() {

              });
            })
    );
  }
}

openSpr(sprName, object) {
  if (sprName=='Сотрудники' || sprName=='Контрагенты' || sprName=='КонтрагентыДляФондов')
    return scrProfileMan(id: object.id);
  if (sprName=='Кассы')
    return scrListCreateScreen(sprName: sprName, sprObject: object);
  if (sprName=='Касса')
    return scrListCreateScreen(sprName: sprName, sprObject: object);
  if (sprName=='БанковскиеСчетаОрганизаций')
    return scrListCreateScreen(sprName: sprName, sprObject: object);
  if (sprName=='АналитикаДвиженийДСРасход' || sprName=='АналитикаДвиженийДСПриход')
    return scrListCreateScreen(sprName: sprName, sprObject: object);

  return scrObjectsViewScreen(id: object.id);
}

class CardObjectList extends StatefulWidget {
  const CardObjectList({
    super.key,
    required this.event,
    required this.onType
  });

  final ListObject event;
  final String onType;

  @override
  State<CardObjectList> createState() => _CardObjectListState();
}

class _CardObjectListState extends State<CardObjectList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
          title: Text(widget.event.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
          subtitle: Text(widget.event.addres),
          trailing: Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(widget.event.summa), style: TextStyle(fontSize: 16, color: Colors.green)),
          onTap: () async {
            if (widget.onType=='push') {
              print('push');
              Navigator.push(context, MaterialPageRoute( builder: (context) => scrObjectsViewScreen(id: widget.event.id)));
            }
            else {
              if (widget.onType=='SelectDogovor') {
                final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            objectsListSelectedDog(objectId: widget.event.id, objectName: '', clientId: '', clientName: '', onType: 'pop',)));
                if (result != null) {
                  SelectedDogovor resultSelected = SelectedDogovor(widget.event.id, widget.event.addres, widget.event.name, result.id, result.Number, result.Date);
                  Navigator.pop(context, resultSelected);
                }
              }
              else {
                Navigator.pop(context, widget.event.id);};
            }
            },
        onLongPress: () {})
    );
  }
}

class CardDogObjectList extends StatefulWidget {
  const CardDogObjectList({
    super.key,
    required this.event,
    required this.onType
  });

  final DogListObject event;
  final String onType;

  @override
  State<CardDogObjectList> createState() => _CardDogObjectListState();
}

class _CardDogObjectListState extends State<CardDogObjectList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
            title: Text('${widget.event.Number} от ${DateFormat('dd.MM.yyyy').format(widget.event.Date)}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
            subtitle: Text(widget.event.name),
            trailing: Text(NumberFormat.simpleCurrency(locale: 'ru-RU', decimalDigits: 2).format(widget.event.summa), style: TextStyle(fontSize: 16, color: Colors.green)),
            onTap: () async {
              if (widget.onType=='push') {
                if (widget.event.TipId==0)
                  Navigator.push(context, MaterialPageRoute(builder: (context) => scrObjectsViewScreen(id: widget.event.id)));
                else
                  Navigator.push(context, MaterialPageRoute(builder: (context) => scrDogovorViewScreen(id: widget.event.id)));
              } else {
                Navigator.pop(
                    context, widget.event);
              };
            },
            onLongPress: () {})
    );
  }
}

class PlatObjectList extends StatefulWidget {
  const PlatObjectList({
    super.key,
    required this.event,
  });

  final ListPlat event;

  @override
  State<PlatObjectList> createState() => _PlatObjectListState();
}

class _PlatObjectListState extends State<PlatObjectList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
          title: Text('${widget.event.name} № ${widget.event.number} от ${DateFormat('dd.MM.yyyy').format(widget.event.date)}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
          subtitle: Text(widget.event.comment),
          trailing: Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(widget.event.summa), style: TextStyle(fontSize: 16, color: textColors(widget.event.summa))),
          onTap: () async {
            await Navigator.push(context, MaterialPageRoute(builder: (context) {
                      if (widget.event.type=='Покупка стройматериалов')
                        return scrReceiptViewScreen(id: widget.event.id, event: widget.event);
                      else
                        return scrPlatsViewScreen(plat: widget.event);
                    }));
            setState(() {
              if (widget.event.del==true) {
                print('Удаляем этот платеж');
              }
              print('Пересчет формы');
            });
            },
          onLongPress: () {}),
    );
  }
}


class CardObjectAnalyticList extends StatefulWidget {
  const CardObjectAnalyticList({
    super.key,
    required this.event,
    required this.onType,
    required this.objectId,
    required this.objectName
  });

  final analyticObjectList event;
  final String onType;
  final String objectId;
  final String objectName;

  @override
  State<CardObjectAnalyticList> createState() => _CardObjectAnalyticListState();
}

class _CardObjectAnalyticListState extends State<CardObjectAnalyticList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
          title: Text(widget.event.analyticName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
          //subtitle: Text(widget.event.addres),
          trailing: Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(widget.event.summa), style: TextStyle(fontSize: 16, color: textColors(widget.event.summa))),
          onTap: () async {
            if (widget.onType=='push') {
              print('push');
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          scrCashListScreen(idCash: '0', cashName: 'Все', analytic: widget.event.analyticId, analyticName: widget.event.analyticName, objectId: widget.objectId, objectName: widget.objectName, platType: '', dateRange: DateTimeRange(start: DateTime(2023), end: DateTime.now()), kassaSotrId: '', kassaSortName: '',  )));
            }
          },
          onLongPress: () {}),
    );
  }
}

class ObjectTileView extends StatelessWidget {
  final String nameClient;
  final String idClient;
  final String startDate;
  final String stopDate;
  final String address;
  final num area;

  const ObjectTileView(
      {Key? key, required this.nameClient, required this.idClient, required this.startDate, required this.stopDate, required this.address, required this.area})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(
              nameClient,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
            ),
            subtitle: Text('Посмотреть данные по клиенту'),
            trailing: Icon(Icons.navigate_next),
            leading: Icon(Icons.account_circle),
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => scrProfileMan(id: idClient,)));
            },
          ),
          CustomListTile(
              title: startDate.toString() + ' - ' + stopDate.toString(),
              icon: Icons.calendar_month,
              id: '', idType: ''),
          CustomListTile(
              title: "Площадь объекта $area м2",
              icon: Icons.rectangle_outlined,
              id: '', idType: ''),
          CustomListTile(
              title: address,//InfoObject['address'],//ObjectData,  //infoObjectData['address'].toString()
              icon: Icons.location_on_outlined,
              id: '', idType: ''),
        ],
      ),
    );
  }

}

class CustomListTile extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Widget? trailing;
  final String id;
  final String idType;

  const CustomListTile(
      {Key? key, required this.title, required this.icon, this.trailing, required this.id, required this.idType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(dense: false, visualDensity: VisualDensity(vertical: -4),
      title: Text(title ?? 'ggg'),
      leading: (icon==null ? null: Icon(icon)),
      trailing: trailing,
      onTap: () {
        if (id != '') {
          if (idType=='objectsListSelectedDog') {
            Map valueMap = json.decode(id);
            Navigator.push(context, MaterialPageRoute(builder: (context) => objectsListSelectedDog(objectId: valueMap['objectId'], objectName: valueMap['objectName'], clientId: valueMap['clientId'],  clientName: valueMap['clientName'],onType: 'push',)));
          }
          if (idType=='scrProfileMan')
            Navigator.push(context, MaterialPageRoute(builder: (context) => scrProfileMan(id: id,)));
        }
      },
    );
  }

}
