import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:repairmodule/models/Lists.dart';
import 'package:repairmodule/screens/cashList.dart';
import 'package:repairmodule/screens/plat_edit.dart';
import 'package:http/http.dart' as http;
import '../components/GeneralFunctions.dart';
import 'ReceiptEdit.dart';


class scrInputSharedFilesScreen extends StatefulWidget {
  List<SharedMediaFile> _sharedFiles;

  scrInputSharedFilesScreen(this._sharedFiles);

  @override
  State<scrInputSharedFilesScreen> createState() => _scrInputSharedFilesScreenState();
}

class _scrInputSharedFilesScreenState extends State<scrInputSharedFilesScreen> {
  bool _isLoad = false;
  String _errorParsingJson='';
  String platId='';
  bool _isJson = false;
  DateTime recipientDate = DateTime.now();
  num recipientSumma = 0;
  String recipientContractorId='';
  String recipientContractorName='';
  bool recipientTovarUse = false;
  String recipientComment = '';
  List<ReceiptSost> receiptSost = [];

  Future httpGetJsonUnPacked(File file) async {
    final _queryParameters = {'userId': Globals.anPhone};

    var _url=Uri(path: '${Globals.anPath}recipientjson/', host: Globals.anServer, scheme: 'https', queryParameters: _queryParameters);

    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': Globals.anAuthorization
    };
    // var _body = <String, String> {
    //   "name": "sdgg",
    //   "last_name": "tttt"
    // };
    try {
      _errorParsingJson='';
      print('Отправляем файл json на сервер');
      var response = await http.post(_url, headers: _headers, body: (await file.readAsBytesSync()));
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        //print(response.body.toString());
        var notesJson = json.decode(response.body);
        recipientDate = DateTime.tryParse(notesJson['Дата']) ?? DateTime.now();
        recipientSumma= notesJson['Сумма'] ?? 0;
        recipientContractorName= notesJson['Организация'] ?? '';
        recipientContractorId= notesJson['ОрганизацияИНН'] ?? '';
        recipientTovarUse = true;
        recipientComment = 'Чек импортирован по QR-коду из ФНС';

        print(notesJson['СоставЧека']);
        receiptSost.clear();
        for (var noteJson in notesJson['СоставЧека']) {
          receiptSost.add(ReceiptSost(name: noteJson['Наименование'], kol: noteJson['Количество'], price: noteJson['Цена'], summa: noteJson['Сумма']));
        }
        _isJson=true;
      }
      else
        throw 'Код ответа: ${response.statusCode.toString()}. Ответ: ${response.body}';
    } catch (error) {
      print("Ошибка при формировании списка: $error");
      _errorParsingJson = 'Ошибка чтения JSON: $error';
    }
  }


  addImage(BuildContext context, String objectId, String path) async {
    try {
      String namePhoto = basename(path);
      returnResult res = await httpUploadImage(namePhoto, File(path));
      if (res.resultCode==0) {
        returnResult res2 = await httpSetListAttached(objectId, namePhoto, res.resultText);
        if (res2.resultCode!=0)
          throw res2.resultText;
      }
      else {
        throw res.resultText;
      }

    } catch (error) {
      final snackBar = SnackBar(content: Text('$error'),);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

  }

  createNewPlat(BuildContext context, Menu item) async {
    ListPlat pl = ListPlat('', 'Новый платеж', DateTime.now(), false, '', true, '', '', '', useDog(item.name), analyticId(item.name, true), analyticId(item.name, false), 0, 0, 0, '', '', '', '', DateTime.now(), useDog(item.name), '', '', '', '', 0, '', '', '', platType(item.name), type(item.name), '', '', '', '', 0, 0);
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => scrPlatEditScreen(plat2: pl,)));
    platId = pl.id;
    if (platId!='') {
      print('Платеж создан и можно прикрепить фото');
      for(var i = 0; i < widget._sharedFiles.length; i++){
        print(widget._sharedFiles[i].path);
        setState(() {
          _isLoad=true;
        });
        await addImage(context, platId, widget._sharedFiles[i].path);
        setState(() {
          _isLoad=false;
        });
      }
      widget._sharedFiles.clear();
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    //super.initState();
    print('На всходе пришел файл, будем его проверять на json');
    String pp = widget._sharedFiles[0].path;

    if (pp.substring(widget._sharedFiles[0].path.length-4)=='json') {
      _isJson == true;
      print('На сходе пришел json, будем его распаковывать на сервере');
      httpGetJsonUnPacked(File(pp)).then((value) {
        setState(() {
        });
      });
    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Прикрепить фото'),
        centerTitle: true,
      ),
        body: (_isLoad) ? Center(child: CircularProgressIndicator()) :
        ListView(padding: EdgeInsets.all(8),
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Divider(),
            if (_isJson==false) ... [
              Text('Вложить в существующий документ', textAlign: TextAlign.center, style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14),),
              SizedBox(height: 8,),
              //Divider(),
              Card(
                child: ListTile(
                  title: Text(
                    'Выбрать существующий документ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Text('Найти документ для вложения'),
                  leading: Icon(Icons.list),
                  onTap: () async {
                    platId = await Navigator.push(context, MaterialPageRoute(builder: (context) => scrCashListScreen(idCash: '0', cashName: 'Все', analytic: '', analyticName: '', objectId: '', objectName: '', platType: '', dateRange: DateTimeRange(start: DateTime.now().subtract(const Duration(days: 1)), end: DateTime.now()), kassaSotrId: '', kassaSortName: '', selected: true, )));
                    print('Платеж выбран и можно прикрепить фото');
                    for(var i = 0; i < widget._sharedFiles.length; i++){
                      print(widget._sharedFiles[i].path);
                      setState(() {
                        _isLoad=true;
                      });
                      await addImage(context, platId, widget._sharedFiles[i].path);
                      setState(() {
                        _isLoad=false;
                      });
                    }
                    widget._sharedFiles.clear();
                    Navigator.pop(context);
                    },
                ),
              ),
              Divider(),
              Text('Создание нового документа', textAlign: TextAlign.center, style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14),),
              SizedBox(height: 8,),
              Text('Поступления'),
              Card(
                child: ListTile(
                  title: Text(
                    'Оплата от клиента по договору',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Text('Создать документ внесения денег клиентом за работы'),
                  leading: Icon(Icons.add, color: Colors.green,),
                  onTap: () async {
                    createNewPlat(context, Menu.oplataDog);
                  },
                ),
              ),
              Card(
                child: ListTile(
                  title: Text(
                    'Оплата от клиента за материалы',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Text('Создать документ внесения денег клиентом за материалы'),
                  leading: Icon(Icons.add, color: Colors.green),
                  onTap: () async {
                    createNewPlat(context, Menu.oplataMaterials);
                  },
                ),
              ),
              Card(
                child: ListTile(
                  title: Text(
                    'Поступление денег',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Text('Создать документ поступления денег'),
                  leading: Icon(Icons.add, color: Colors.green),
                  onTap: () async {
                    createNewPlat(context, Menu.platUp);
                  },
                ),
              ),
              Divider(),
              Text('Списания'),
              Card(
                child: ListTile(
                  title: Text(
                    'Списание денег',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Text('Создать документ списания денег'),
                  leading: Icon(Icons.remove, color: Colors.red),
                  onTap: () async {
                    createNewPlat(context, Menu.platDown);
                  },
                ),
              ),
            ],
            Card(
              child: ListTile(
                title: Text(
                  'Покупка стройматериалов',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                subtitle: Text('Создать документ покупки'),
                leading: Icon(Icons.remove, color: Colors.red),
                onTap: () async {
                  Receipt recipientdata = Receipt('', '', recipientDate, true, false, false, '', '', '', '', true, '', '', DateTime.now(), recipientSumma, recipientSumma, recipientSumma, recipientTovarUse, recipientComment, recipientContractorId, recipientContractorName, 'Расход', 0, '7fa144f2-14ca-11ed-80dd-00155d753c19', 'Покупка стройматериалов', '', '', '', '', 0, 'Покупка стройматериалов', 0, receiptSost);
                  await Navigator.push(context, MaterialPageRoute(builder: (context) => scrReceiptEditScreen(receiptData: recipientdata,)));
                  if (recipientdata.id!='') {
                    if (_isJson==false) {
                      print('Платеж создан и можно прикрепить фото');
                      for(var i = 0; i < widget._sharedFiles.length; i++){
                        print(widget._sharedFiles[i].path);
                        setState(() {
                          _isLoad=true;
                        });
                        await addImage(context, recipientdata.id, widget._sharedFiles[i].path);
                        setState(() {
                          _isLoad=false;
                        });
                      }
                    }
                    widget._sharedFiles.clear();
                    Navigator.pop(context);
                  }
                  },
              ),
            ),
            Divider(),
            if (_isJson==false) ... [
              Text('Подотчет и перемещение'),
              Card(
                child: ListTile(
                  title: Text(
                    'Выдача в подотчет',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Text('Создать документ выдачи денег сотруднику'),
                  leading: Icon(Icons.remove, color: Colors.red),
                  onTap: () async {
                    createNewPlat(context, Menu.platDownSotr);
                  },
                ),
              ),
              Card(
                child: ListTile(
                  title: Text(
                    'Возврат из подотчета',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Text('Создать документ возврата денег от сотрудника'),
                  leading: Icon(Icons.add, color: Colors.green),
                  onTap: () async {
                    createNewPlat(context, Menu.platUpSotr);
                  },
                ),
              ),
              SizedBox(height: 18,),
              Card(
                child: ListTile(
                  title: Text(
                    'Внутреннее перемещение',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Text('Создать документ перемещения денег между кассами или счетами'),
                  leading: Icon(Icons.recycling),
                  onTap: () async {
                    createNewPlat(context, Menu.platMove);
                  },
                ),
              ),
              Divider(),
            ],
             // Text(widget._sharedFiles
             //     .map((f) => f.toMap())
             //     .join(",\n****************\n")),
            if (_errorParsingJson.length>0)
              Text(_errorParsingJson)
          ],
        )//backgroundColor: Colors.grey[900]),
    );

  }


}
