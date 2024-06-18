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

class scrProfileManEditScreen extends StatefulWidget {
  late String id;
  final String email;
  final String phone;
  final String name;
  final int type;


  scrProfileManEditScreen({super.key, required this.id, required this.email, required this.phone, required this.name, required this.type});

  @override
  State<scrProfileManEditScreen> createState() => _scrProfileManEditScreenState();
}

class _scrProfileManEditScreenState extends State<scrProfileManEditScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  bool userDataEdit = false;


  TextEditingController email=TextEditingController(text: '');
  TextEditingController phone=TextEditingController(text: '');
  TextEditingController name = TextEditingController(text: '');



  Future<bool> httpManCreate() async {
    bool _result=false;
    var _url=Uri(path: '/a/centrremonta/hs/v1/man/edit/', host: 's1.rntx.ru', scheme: 'https');
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': 'Basic YWNlOkF4V3lJdnJBS1prdzY2UzdTMEJP'
    };
    var _body = <String, String> {
      'id': widget.id,
      'email': email.text,
      'phone': phone.text,
      'name': name.text,
      'type': widget.type.toString(),
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
          widget.id = data['Код'];

        print('Объект и договор созданы. Результат:  $_result. Сообщение:  $_message. Код объекта = ${widget.id}');
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
    if (userDataEdit==false) {
      phone.text = widget.phone;
      email.text = widget.email;
      name.text = widget.name;
      userDataEdit = true;
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('Редактирование профиля'),
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
                          'Заполните данные',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  SingleSection(title: 'Основное',
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            textAlign: TextAlign.start,
                            controller: name,
                            keyboardType: TextInputType.text,
                            style: TextStyle(fontSize: 18),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Введите ФИО',
                            ),
                              textInputAction: TextInputAction.done,
                              validator: (value) {
                                if (value == null || value.isEmpty) {return 'Заполните ФИО';}
                                return null;
                              }
                          ),
                        ),
                      ]),
                  Divider(),
                  SingleSection(title: 'Контакты',
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            controller: phone,
                            keyboardType: TextInputType.number,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Введите номер телефона',
                            ),
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Введиете номер телефона';
                                }
                                return null;
                              }
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            controller: email,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(fontSize: 18),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'email',
                            ),
                              textInputAction: TextInputAction.done,
                              validator: (value) {
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
            httpManCreate().then((value) {
              if (value==true)
                Navigator.pop(context, widget.id);
            });
            },
          child: Icon(Icons.save),
        )
      //backgroundColor: Colors.grey[900]),
    );
  }
}



