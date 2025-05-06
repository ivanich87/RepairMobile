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

class scrObjectCreateScreen extends StatefulWidget {
  final String smetaId;
  final String fio;
  final String address;
  final num summaClient;
  final num summaSeb;
  scrObjectCreateScreen({super.key, this.smetaId = '', this.fio='', this.address='', this.summaClient = 0, this.summaSeb = 0});

  @override
  State<scrObjectCreateScreen> createState() => _scrObjectCreateScreenState();
}

class _scrObjectCreateScreenState extends State<scrObjectCreateScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  DateTimeRange dateRange = DateTimeRange(start: DateTime.now(), end: DateTime.now());

  bool userDataEdit = false;
  TextEditingController clientName = TextEditingController(text: '');
  TextEditingController clientPhone=TextEditingController(text: '');
  TextEditingController clientEMail=TextEditingController(text: '');

  String managerId = '';
  String managerName = 'Выберите менеджера';

  String prorabId = '';
  String prorabName = 'Выбрерите прораба';

  TextEditingController address=TextEditingController(text: '');
  TextEditingController area=TextEditingController(text: '');
  DateTime dtStart=DateTime.now();
  DateTime dtStop=DateTime.now();
  int statusId=0;


  TextEditingController summa=TextEditingController(text: '');
  TextEditingController summaSeb=TextEditingController(text: '');

  TextEditingController nameDog = TextEditingController(text: '');

  String newObjectId = '';

  Future<bool> httpDogCreate() async {
    newObjectId = '';
    bool _result=false;
    final _queryParameters = {'userId': Globals.anPhone};
    var _url=Uri(path: '${Globals.anPath}objectcreate/', host: Globals.anServer, scheme: 'https', queryParameters: _queryParameters);
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': Globals.anAuthorization
    };
    var _body = <String, String> {
      'clientName': clientName.text,
      'clientPhone': clientPhone.text,
      'clientEMail': clientEMail.text,
      'clientType': '1',
      'managerId': managerId,
      'prorabId': prorabId,
      'address': address.text,
      'area': area.text,
      'dtStart': DateFormat('yyyyMMdd').format(dtStart),
      'dtStop': DateFormat('yyyyMMdd').format(dtStop),
      'nameDog': nameDog.text,
      'summa': summa.text,
      'summaSeb': summaSeb.text,
      'smetaId': widget.smetaId
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
          newObjectId = data['Код'];

        print('Объект и договор созданы. Результат:  $_result. Сообщение:  $_message. Код объекта = $newObjectId');
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
      newObjectId='';
      final snackBar = SnackBar(
        content: Text('$error'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    return _result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    dtStart = dateRange.start;
    dtStop = dateRange.end;
    print(widget.summaClient);
    if (widget.summaClient>0)
      summa.text = '${widget.summaClient}';
    if (widget.summaSeb>0)
      summaSeb.text = '${widget.summaSeb}';
    clientName.text = '${widget.fio}';
    address.text = '${widget.address}';

    return Scaffold(
        appBar: AppBar(
          title: Text('Создание нового объекта'),
          centerTitle: true,
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
                          'Заполните данные',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  SingleSection(title: 'Данные клиента',
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            textAlign: TextAlign.start,
                            controller: clientName,
                            keyboardType: TextInputType.text,
                            style: TextStyle(fontSize: 18),
                            decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'ФИО',
                            ),
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value == null || value.isEmpty) {return 'Заполните ФИО клиента';}
                                return null;
                              }
                              ),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            controller: clientPhone,
                            keyboardType: TextInputType.phone,
                            style: TextStyle(fontSize: 18),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Номер телефона',
                            ),
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value == null || value.isEmpty) {return 'Заполните телефон клиента';}
                                return null;
                              }
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            controller: clientEMail,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(fontSize: 18),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'E-Mail',
                            ),
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                //if (value == null || value.isEmpty) {return 'Заполните EMail клиента';}
                                return null;
                              }
                          ),
                        )
                      ]),
                  Divider(),
                  SingleSection(title: 'Данные объекта',
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            textAlign: TextAlign.start,
                            controller: address,
                            keyboardType: TextInputType.text,
                            style: TextStyle(fontSize: 18),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Адрес',
                            ),
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value == null || value.isEmpty) {return 'Заполните адрес объекта';}
                                return null;
                              }
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            controller: area,
                            keyboardType: TextInputType.number,
                            style: TextStyle(fontSize: 18),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Площадь',
                            ),
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value == null || value.isEmpty || !new RegExp(r'^[0-9]+$').hasMatch(value)) {
                                  return 'Площадь должна быть числом';
                                }
                                return null;
                              }
                          ),
                        ),
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
                      CustomTitle(DataId: prorabId, DataName: prorabName,
                          titles: prorabName,
                          icon: Icons.hardware_sharp,
                          id: 'Сотрудники',
                          idType: 'sprSotrListSelected',
                          trailing: null),
                      CustomTitle(DataId: managerId, DataName: managerName,
                          titles: managerName,
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
                Navigator.pop(context, newObjectId);
            });
            },
          child: Icon(Icons.save),
        )
      //backgroundColor: Colors.grey[900]),
    );
  }

  Future pickDateRange() async {
    DateTimeRange? newDateRange = await showDateRangePicker(locale: Locale("ru", "RU"),
        context: context, firstDate: DateTime(2020), lastDate: DateTime(2050), initialDateRange: dateRange);
    if (newDateRange ==null) return;

    setState(() {
      dateRange = newDateRange;
    });
    initState();
  }


  CustomTitle({required String DataId, required String DataName, required String titles, required IconData icon, required Widget? trailing, required String id, required String idType, bool Enabled = true}) {
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
            prorabId = res.id;
            prorabName = res.name;
          });
        };
        if (idType=='sprSotrListSelected2'){
          setState(() {
            managerId = res.id;
            managerName = res.name;
          });
        };
      },
    );

  }
}



