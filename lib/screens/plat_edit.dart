import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:repairmodule/components/SingleSelections.dart';
import 'package:repairmodule/screens/profileMan.dart';
import 'package:repairmodule/models/Lists.dart';
import 'package:repairmodule/screens/object_view.dart';
import 'package:repairmodule/screens/sprList.dart';

import 'objects.dart';
import 'objectsListSelected.dart';

class scrPlatEditScreen extends StatefulWidget {
  final ListPlat plat2;
  //final String id;

  scrPlatEditScreen({super.key, required this.plat2});

  @override
  State<scrPlatEditScreen> createState() => _scrPlatEditScreenState();
}

class _scrPlatEditScreenState extends State<scrPlatEditScreen> {

  TextEditingController _summaController = TextEditingController(text: '');
  TextEditingController _commentController = TextEditingController(text: '');

  bool firstInit = true;
  bool userDataEdit = false;
  late ListPlat plat4;

  Future<bool> httpPlatUpdate(ListPlat _body) async {
    bool _result=false;
    final _queryParameters = {'userId': Globals.anPhone};
    var _url=Uri(path: '${Globals.anPath}platUpdate/', host: Globals.anServer, scheme: 'https', queryParameters: _queryParameters);
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': Globals.anAuthorization
    };
    try {
      print('Start export plat!!!!');
      print(json.encode(_body.toJson()));
      var response = await http.post(_url, headers: _headers, body: json.encode(_body.toJson()));
      print('Код ответа: ${response.statusCode} Тело ответа: ${response.body}');
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        String _id = data['Код'] ?? '';
        _result = data['Успешно'] ?? '';
        String _message = data['Сообщение'] ?? '';
        if (widget.plat2.id=='')
          _body.id = _id;

        print('Платеж выгружен. Результат:  $_result. Сообщение:  $_message');
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
      _result = false;
      final snackBar = SnackBar(
        content: Text('$error'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    return _result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    ListPlat plat3 = widget.plat2;
    if (firstInit==true) {
      plat4 = widget.plat2.copyWith();
      print('Скопировали бэкап');
      _summaController.text = (plat3.platType=='Расход') ? plat3.summaDown.toString() : plat3.summaUp.toString();
      _commentController.text = plat3.comment;
    }
    firstInit=false;
    print(plat3.platType);
    return PopScope(
        canPop: true,
        onPopInvoked: (bool didPop) async {
      if (userDataEdit==false) {
        ListPlat.fromTo(plat3, plat4);
        print('Вернули данные из бэкапа');
      }
      return;
    },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Платеж'),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.menu))],
        ),
        body: ListView(
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
                        plat3.type,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '№ ${plat3.number} от ${DateFormat('dd.MM.yyyy').format(plat3.date)}',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                //Divider(),
                //_payer(widget: widget,),
                Divider(),
                if (plat3.platType!='Перемещение' && plat3.type!='Выдача денежных средств в подотчет')
                SingleSection(
                  title: 'Сведения об объекте',
                  children: [
                    widgetDogovor(plat3)
                  ],
                ),
                //Divider(),
                //_recipient(widget: widget,),
                Divider(),
                SingleSection(
                  title: 'Аналитика и комментарий',
                  children: [
                    if (plat3.type!='Выдача денежных средств в подотчет' && plat3.platType!='Перемещение')
                    CustomTitle(plat: plat3,
                        titles: plat3.analyticName,
                        icon: Icons.analytics,
                        id: (plat3.platType=='Приход') ? 'АналитикаДвиженийДСПриход' : 'АналитикаДвиженийДСРасход',
                        idType: 'sprAnalyticsListSelected', trailing: null),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        controller: _commentController,
                        keyboardType: TextInputType.text,
                        minLines: 3,
                        maxLines: 6,
                        decoration: InputDecoration(
                          icon: Icon(Icons.comment_outlined),
                          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                          hintText: 'Комментарий к платежу',
                        ),
                        // onChanged: (value) {
                        //   plat3.comment = value;
                        // },
                      ),
                    ),
                  ],
                ),
                //],
                Divider(),
                SingleSection(
                  title: (plat3.platType!='Приход') ? 'Списать деньги с' : 'Зачислить деньги на',
                  children: [
                    if (plat3.type!='Выдача денежных средств в подотчет')
                    Column(
                      children: [
                        RadioListTile(title: Text('Касса/Банк'), value: 0, groupValue: plat3.kassaType, onChanged: (value){
                            setState(() {
                              plat3.kassaType = value!;
                            });
                          }
                        ),
                        RadioListTile(title: Text('Подотчетные средства'), value: 1, groupValue: plat3.kassaType, onChanged: (value) {
                            setState(() {
                              plat3.kassaType = value!;
                            });
                          }
                          ),
                        ],
                      ),
                    CustomTitle(plat: plat3,
                        titles: (plat3.kassaType==0) ? plat3.kassaName : plat3.kassaSotrName,
                        icon: Icons.payment_outlined,
                        id: (plat3.kassaType==0) ? 'Кассы' : 'Сотрудники',
                        idType: (plat3.kassaType==0) ? 'sprKassaListSelected' : 'sprSotrListSelected', trailing: null),
                ],
              ),
                Divider(),
                if (plat3.platType=='Перемещение') //if ((plat3.platType=='Приход' || plat3.platType=='Перемещение') && plat3.type!='Выдача денежных средств в подотчет')
                SingleSection(
                  title: 'Зачислить деньги на',
                  children: [
                    Column(
                      children: [
                        RadioListTile(title: Text('Касса/Банк'), value: 0, groupValue: plat3.kassaType2, onChanged: (value){
                          setState(() {
                            plat3.kassaType2 = value!;
                          });
                        }
                        ),
                        RadioListTile(title: Text('Подотчетные средства'), value: 1, groupValue: plat3.kassaType2, onChanged: (value) {
                          setState(() {
                            plat3.kassaType2 = value!;
                          });
                        }
                        ),
                      ],
                    ),
                    CustomTitle(plat: plat3,
                        titles: (plat3.kassaType2==0) ? plat3.kassaName2 : plat3.kassaSotrName2,
                        icon: Icons.payment_outlined,
                        id: (plat3.kassaType2==0) ? 'Кассы' : 'Сотрудники',
                        idType: (plat3.kassaType2==0) ? 'sprKassaListSelected2' : 'sprSotrListSelected2', trailing: null),
                  ],
                ),
                if (plat3.type=='Выдача денежных средств в подотчет')
                  SingleSection(
                    title: (plat3.platType=='Приход') ? 'Сведения о плательщике' : 'Сведения о получателе',
                    children: [
                      if (plat3.type=='Движение денежных средтв')
                        ListTile(title: Text('Учитывать в движениях по контрагенту'), trailing: CupertinoSwitch(value: plat3.contractorUse, onChanged: (bool val) => setState(() => plat3.contractorUse = val))),
                      CustomTitle(plat: plat3,
                          titles: plat3.kassaSotrName,
                          icon: Icons.man,
                          id: 'Сотрудники',
                          idType: 'sprSotrListSelected', trailing: null)
                    ],
                  ),
                if ((plat3.platType=='Расход' || plat3.platType=='Приход') && plat3.type!='Выдача денежных средств в подотчет')
                SingleSection(
                  title: (plat3.platType=='Приход') ? 'Сведения о плательщике' : 'Сведения о получателе',
                  children: [
                    if (plat3.type=='Движение денежных средтв')
                      ListTile(title: Text('Учитывать в движениях по контрагенту'), trailing: CupertinoSwitch(value: plat3.contractorUse, onChanged: (bool val) => setState(() => plat3.contractorUse = val))),
                    CustomTitle(plat: plat3,
                        titles: plat3.contractorName,
                        icon: Icons.man,
                        id: 'Контрагенты',
                        idType: 'sprContractorListSelected', trailing: null,
                        Enabled: (plat3.dogUse==true && plat3.type!='Движение денежных средтв' && plat3.type!='Выдача денежных средств в подотчет') ? false : true)
                  ],
                ),
                Divider(),
                SingleSection(title: 'Сумма',
                    children: [
                      TextField(
                        textAlign: TextAlign.center,
                        controller: _summaController,
                        keyboardType: TextInputType.number,
                        style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: (plat3.summa>=0) ? Colors.green : Colors.red),
                        //onSubmitted: (value) {
                          // if (plat3.platType=='Расход')
                          //   plat3.summaDown=num.tryParse(value) ?? 0;
                          // if (plat3.platType=='Приход')
                          //   plat3.summaUp=num.tryParse(value) ?? 0;
                          // if (plat3.platType=='Перемещение') {
                          //   plat3.summaDown=num.tryParse(value) ?? 0;
                          //   plat3.summaUp=num.tryParse(value) ?? 0;
                          // }
                          // plat3.summa=plat3.summaUp - plat3.summaDown;
                          // print('изменили сумму платежа на ${plat3.summa}');
                        //},
                      )
                    ]),

          ],
        ),
        ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (plat3.platType=='Расход')
              plat3.summaDown=num.tryParse(_summaController.text) ?? 0;
            if (plat3.platType=='Приход')
              plat3.summaUp=num.tryParse(_summaController.text) ?? 0;
            if (plat3.platType=='Перемещение') {
              plat3.summaDown=num.tryParse(_summaController.text) ?? 0;
              plat3.summaUp=num.tryParse(_summaController.text) ?? 0;
            }
            plat3.summa=plat3.summaUp - plat3.summaDown;
            print('изменили сумму платежа на ${plat3.summa}');

            plat3.comment = _commentController.text;

            if (plat3.platType=='Перемещение') {
              plat3.contractorId = (plat3.kassaType2==1) ? plat3.kassaSotrId2 : plat3.kassaId2;
              plat3.contractorName = (plat3.kassaType2==1) ? plat3.kassaSotrName2 : plat3.kassaName2;
              plat3.kassa = (plat3.kassaType==1) ? plat3.kassaSotrName : plat3.kassaName;
              plat3.summa = plat3.summaUp;
            };
            if (plat3.platType=='Расход' && plat3.type=='Выдача денежных средств в подотчет') {
              plat3.kassa = plat3.kassaName;
            }
            //httpPlatUpdate(plat3);
            httpPlatUpdate(plat3).then((value) {
              userDataEdit = value;
              print('userDataEdit = $value');
              if (userDataEdit==true)
                Navigator.pop(context);
            });
            },
          child: Icon(Icons.save),
        )
      //backgroundColor: Colors.grey[900]),
    )
    );
  }

  widgetDogovor(ListPlat plat) {
    return Column(
      children: [
        if (plat.type=='Движение денежных средтв')
          ListTile(title: Text('Учитывать в договоре'), trailing: CupertinoSwitch(value: plat.dogUse, onChanged: (bool val) => setState(() => plat.dogUse = val))),
        if (plat.dogUse==true)
        CustomTitle(plat: plat,
            titles: 'Договор № ${plat.dogNumber} от ${DateFormat('dd.MM.yyyy').format(plat.dogDate)}',
            icon: Icons.paste_rounded,
            trailing: Icon(Icons.label_important_sharp),
            id: '',
            idType: 'objectsListSelected'),
        if (plat.dogUse==true)
        CustomTitle(plat: plat,
            titles: 'Объект: ${plat.objectName}',
            icon: Icons.location_on_outlined,
            trailing: Icon(Icons.label_important_sharp),
            id: '',
            idType: 'objectsListSelected'),
      ],
    );
  }


  CustomTitle({required String titles, required IconData icon, required Widget? trailing, required String id, required String idType, required ListPlat plat, bool Enabled = true}) {
    return ListTile(
      enabled: Enabled,
      title: Text(titles ?? 'ggg'),
      leading: Icon(icon),
      trailing: trailing,
      onTap: () async {
        var res = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) {
                    if (idType=='scrProfileMan') {
                      return scrProfileMan(id: plat.id,);
                    };
                    if (idType=='scrObjectsViewScreen') {
                      return scrObjectsViewScreen(id: plat.id,);
                    };
                    if (idType=='objectsListSelected') {
                      return objectsListSelected();
                    };
                    if (idType=='sprAnalyticsListSelected') {
                      return scrListScreen(sprName: id, onType: 'pop',);
                    };
                    if (idType=='sprKassaListSelected' || idType=='sprKassaListSelected2') {
                      return scrListScreen(sprName: id, onType: 'pop');
                    };
                    if (idType=='sprSotrListSelected' || idType=='sprSotrListSelected2') {
                      return scrListScreen(sprName: id, onType: 'pop');
                    };
                    if (idType=='sprContractorListSelected') {
                      return scrListScreen(sprName: id, onType: 'pop');
                    };
                    return scrProfileMan(id: id,);
                  } ));
        print(idType);
          if (idType=='objectsListSelected'){
            setState(() {
              plat.dogId = res.dogId;
              plat.dogNumber = res.dogNumber;
              plat.dogDate = res.dogDate;
              plat.objectId = res.objectId;
              plat.objectName = res.objectName;
              if (plat.type=='Оплата по договору' || plat.type=='Оплата стройматериалов')
                plat.contractorName=res.objectContractor;
            });
          };
          if (idType=='sprAnalyticsListSelected'){
            print(plat.analyticName);
            print(res.name);
          setState(() {
            plat.analyticId = res.id;
            plat.analyticName = res.name;
            print(plat.analyticName);
          });
        };
        if (idType=='sprKassaListSelected'){
          setState(() {
            plat.kassaId = res.id;
            plat.kassaName = res.name;
          });
        };
        if (idType=='sprSotrListSelected'){
          setState(() {
            plat.kassaSotrId = res.id;
            plat.kassaSotrName = res.name;
          });
        };
        if (idType=='sprKassaListSelected2'){
          setState(() {
            plat.kassaId2 = res.id;
            plat.kassaName2 = res.name;
          });
        };
        if (idType=='sprSotrListSelected2'){
          setState(() {
            plat.kassaSotrId2 = res.id;
            plat.kassaSotrName2 = res.name;
          });
        };
        if (idType=='sprContractorListSelected'){
          setState(() {
            plat.contractorId = res.id;
            plat.contractorName = res.name;
          });
        }
      },
    );

  }
}



