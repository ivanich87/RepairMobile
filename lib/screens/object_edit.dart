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

class scrObjectEditScreen extends StatefulWidget {
  final String objectId;
  final String clientId;
  late String address;
  late String clientName;
  late String clientPhone;
  late String clientEMail;
  late num area;

  scrObjectEditScreen({super.key, required this.address, required this.clientId, required this.clientName, required this.clientPhone, required this.clientEMail, required this.objectId, required this.area});

  @override
  State<scrObjectEditScreen> createState() => _scrObjectEditScreenState();
}

class _scrObjectEditScreenState extends State<scrObjectEditScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool userDataEdit = false;
  TextEditingController clientName = TextEditingController(text: '');
  TextEditingController clientPhone= TextEditingController(text: '');
  TextEditingController clientEMail= TextEditingController(text: '');
  TextEditingController address=TextEditingController(text: '');
  TextEditingController area=TextEditingController(text: '');


  Future<bool> httpDogCreate() async {
    bool _result=false;
    final _queryParameters = {'userId': Globals.anPhone};
    var _url=Uri(path: '${Globals.anPath}objectcreate/', host: Globals.anServer, scheme: 'https', queryParameters: _queryParameters);
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': Globals.anAuthorization
    };
    var _body = <String, String> {
      'objectId': widget.objectId,
      'clientId': widget.clientId,
      'clientName': clientName.text,
      'clientPhone': clientPhone.text,
      'clientEMail': clientEMail.text,
      'clientType': '1',
      'address': address.text,
      'area': area.text,
    };

    try {
      print(json.encode(_body));
      var response = await http.post(_url, headers: _headers, body: json.encode(_body));
      print('Код ответа: ${response.statusCode} Тело ответа: ${response.body}');
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        _result = data['Успешно'] ?? '';
        String _message = data['Сообщение'] ?? '';

        print('Объект и договор созданы. Результат:  $_result. Сообщение:  $_message');
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
    clientName.text=widget.clientName;
    clientPhone.text=widget.clientPhone;
    clientEMail.text=widget.clientEMail;
    address.text=widget.address;
    area.text=(widget.area==0) ? '' : widget.area.toString();

    return Scaffold(
        appBar: AppBar(
          title: Text('Редактирование объекта'),
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
              if (value==true) {
                widget.clientName = clientName.text;
                widget.clientEMail = clientEMail.text;
                widget.clientPhone = clientPhone.text;
                widget.address = address.text;
                String areaText = (area.text=='' || area.text.isEmpty) ? '0' : area.text;
                widget.area = num.tryParse(areaText) ?? 0;
                Navigator.pop(context);
              }
            });
            },
          child: Icon(Icons.save),
        )
      //backgroundColor: Colors.grey[900]),
    );
  }
}



