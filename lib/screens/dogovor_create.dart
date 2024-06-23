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

class scrDogovorCreateScreen extends StatefulWidget {
  late String newDogovorId;
  int statusId=0;
  final String objectId;
  final String objectName;
  final String clientId;
  final String clientName;

  late DateTimeRange dateRange;

  late String managerId;
  late String managerName;
  late String prorabId;
  late String prorabName;

  final num summa;
  final num summaSeb;

  final String nameDog;

  scrDogovorCreateScreen({super.key, required this.objectId, required this.objectName, required this.clientId, required this.clientName, required this.newDogovorId, required this.dateRange, required this.managerId, required this.managerName, required this.prorabId, required this.prorabName, required this.summa, required this.summaSeb, required this.nameDog});

  @override
  State<scrDogovorCreateScreen> createState() => _scrDogovorCreateScreenState();
}

class _scrDogovorCreateScreenState extends State<scrDogovorCreateScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //DateTimeRange dateRange = DateTimeRange(start: DateTime.now(), end: DateTime.now());

  bool userDataEdit = false;

  DateTime dtStart=DateTime.now();
  DateTime dtStop=DateTime.now();


  TextEditingController summa=TextEditingController(text: '');
  TextEditingController summaSeb=TextEditingController(text: '');
  TextEditingController nameDog = TextEditingController(text: '');



  Future<bool> httpDogCreate() async {
    bool _result=false;
    var _url=Uri(path: '/a/centrremonta/hs/v1/dogovorcreate/', host: 's1.rntx.ru', scheme: 'https');
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': 'Basic YWNlOkF4V3lJdnJBS1prdzY2UzdTMEJP'
    };
    var _body = <String, String> {
      'Id': widget.newDogovorId,
      'objectId': widget.objectId,
      'managerId': widget.managerId,
      'prorabId': widget.prorabId,
      'dtStart': DateFormat('yyyyMMdd').format(dtStart),
      'dtStop': DateFormat('yyyyMMdd').format(dtStop),
      'nameDog': nameDog.text,
      'summa': summa.text,
      'summaSeb': summaSeb.text,
    };

    try {
      print(json.encode(_body));
      var response = await http.post(_url, headers: _headers, body: json.encode(_body));
      print('Код ответа: ${response.statusCode} Тело ответа: ${response.body}');
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        _result = data['Успешно'] ?? '';
        String _message = data['Сообщение'] ?? '';
        if (_result==true)
          widget.newDogovorId = data['Код'];

        print('Объект и договор созданы. Результат:  $_result. Сообщение:  $_message. Код объекта = ${widget.newDogovorId}');
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
    dtStart = widget.dateRange.start;
    dtStop = widget.dateRange.end;
    if (userDataEdit==false) {
      summa.text = (widget.summa == 0) ? '' : widget.summa.toString();
      summaSeb.text = (widget.summaSeb == 0) ? '' : widget.summaSeb.toString();
      nameDog.text = widget.nameDog;
      userDataEdit = true;
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('Создание нового договора'),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.menu))],
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          'Заполните данные договора',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  SingleSection(title: 'Данные объекта',
                      children: [
                        CustomTitle(Enabled: false,
                            titles: widget.objectName,
                            icon: Icons.paste_rounded,
                            id: widget.objectId,
                            idType: 'scrObjectsViewScreen', trailing: null),
                        CustomTitle(Enabled: false,
                            titles: widget.clientName,
                            icon: Icons.account_circle,
                            id: widget.clientId,
                            idType: 'scrObjectsViewScreen', trailing: null)
                      ]),
                  Divider(),
                  SingleSection(title: 'Название договора',
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            textAlign: TextAlign.start,
                            controller: nameDog,
                            keyboardType: TextInputType.text,
                            style: TextStyle(fontSize: 18),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Введите название этапа работ',
                            ),
                              textInputAction: TextInputAction.done,
                              validator: (value) {
                                if (value == null || value.isEmpty) {return 'Заполните название договора, например это может быть обобщенное название работ, например Демонтажные работы';}
                                return null;
                              }
                          ),
                        ),
                      ]),
                  Divider(),
                  SingleSection(
                      title: 'Сроки по договору',
                      children: [
                        TextButton(onPressed: pickDateRange,
                            child: Text(DateFormat('dd.MM.yyyy').format(dtStart) + ' - ' + DateFormat('dd.MM.yyyy').format(dtStop), style: TextStyle(fontSize: 18),))
                  ]),
                  Divider(),
                  SingleSection(
                    title: 'Ответсвенные по договору',
                    children: [
                      CustomTitle(
                          titles: widget.prorabName,
                          icon: Icons.hardware_sharp,
                          id: 'Сотрудники',
                          idType: 'sprSotrListSelected',
                          trailing: null),
                      CustomTitle(
                          titles: widget.managerName,
                          icon: Icons.headset_mic_sharp,
                          id: 'Сотрудники',
                          idType: 'sprSotrListSelected2',
                          trailing: null)
                  ],
                ),
                  Divider(),
                  SingleSection(title: 'Суммы по договору',
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            controller: summa,
                            keyboardType: TextInputType.number,
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Введите сумму договора',
                            ),
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value == null || value.isEmpty || !new RegExp(r'^[0-9]+$').hasMatch(value)) {
                                  return 'Сумма договора должна быть числом';
                                }
                                return null;
                              }
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            controller: summaSeb,
                            keyboardType: TextInputType.number,
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Введите себестоимость',
                            ),
                              textInputAction: TextInputAction.done,
                              validator: (value) {
                                if (value == null || value.isEmpty || !new RegExp(r'^[0-9]+$').hasMatch(value)) {
                                  return 'Себестоимость должна быть числом';
                                }
                                return null;
                              }
                          ),
                        )
          
                      ]),
            ],
          ),
                ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Данные сохраняются'), backgroundColor: Colors.green,));
            print('Данные введены правильно');
            httpDogCreate().then((value) {
              if (value==true)
                Navigator.pop(context, widget.newDogovorId);
            });
            },
          child: Icon(Icons.save),
        )
      //backgroundColor: Colors.grey[900]),
    );
  }

  Future pickDateRange() async {
    DateTimeRange? newDateRange = await showDateRangePicker(locale: Locale("ru", "RU"),
        context: context, firstDate: DateTime(2020), lastDate: DateTime(2050), initialDateRange: widget.dateRange);
    if (newDateRange ==null) return;

    setState(() {
      widget.dateRange = newDateRange;
    });
    initState();
  }


  CustomTitle({required String titles, required IconData icon, required Widget? trailing, required String id, required String idType, bool Enabled = true}) {
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
                      return scrProfileMan(id: id,);
                    };
                    if (idType=='scrObjectsViewScreen') {
                      return scrObjectsViewScreen(id: id,);
                    };
                    if (idType=='objectsListSelected') {
                      return objectsListSelected();
                    };
                    if (idType=='sprAnalyticsListSelected') {
                      return scrListScreen(sprName: id, onType: 'pop');
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
        if (idType=='sprSotrListSelected'){
          setState(() {
            widget.prorabId = res.id;
            widget.prorabName = res.name;
          });
        };
        if (idType=='sprSotrListSelected2'){
          setState(() {
            widget.managerId = res.id;
            widget.managerName = res.name;
          });
        };
      },
    );

  }
}



