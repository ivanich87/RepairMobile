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

class scrConnectionEditScreen extends StatefulWidget {



  scrConnectionEditScreen({super.key});

  @override
  State<scrConnectionEditScreen> createState() => _scrConnectionEditScreenState();
}

class _scrConnectionEditScreenState extends State<scrConnectionEditScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  bool userDataEdit = false;


  TextEditingController server=TextEditingController(text: '');
  TextEditingController path=TextEditingController(text: '');
  TextEditingController phone=TextEditingController(text: '');
  TextEditingController login = TextEditingController(text: '');
  TextEditingController password = TextEditingController(text: '');



  Future<bool> httpConnection() async {
    bool _result=false;
    String _message = '';
    var _url=Uri(path: '${path.text}connection/${phone.text}/', host: server.text, scheme: 'https');
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': Globals.anAuthorization
    };

    try {
      print(_url.path);
      var response = await http.get(_url, headers: _headers);
      print('Код ответа: ${response.statusCode} Тело ответа: ${response.body}');
      var data = json.decode(response.body);
      _message = data['Сообщение'] ?? '';
      if (response.statusCode == 200) {
        _result = data['Успешно'] ?? '';
      }
      else {
        _result = false;
        final snackBar = SnackBar(
          content: Text('${_message}'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    } catch (error) {
      _result = false;
      _message = 'Не верное Имя сервера или Путь до сервисов';
      final snackBar = SnackBar(
        content: Text('$_message'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    return _result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    if (userDataEdit==false) {
      server.text = Globals.anServer;
      path.text = Globals.anPath;
      phone.text = Globals.anPhone;

      userDataEdit = true;
    }
    String _typeText = 'Подключение';


    return Scaffold(
        appBar: AppBar(
          title: Text('Настройки подключения'),
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
                        Text(_typeText, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), ),
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
                            controller: server,
                            keyboardType: TextInputType.text,
                            style: TextStyle(fontSize: 18),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Имя сервера',
                            ),
                              textInputAction: TextInputAction.done,
                              validator: (value) {
                                if (value == null || value.isEmpty) {return 'Заполните имя сервере';}
                                return null;
                              }
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                              textAlign: TextAlign.start,
                              controller: path,
                              keyboardType: TextInputType.text,
                              style: TextStyle(fontSize: 18),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Путь до сервисов',
                              ),
                              textInputAction: TextInputAction.done,
                              validator: (value) {
                                if (value == null || value.isEmpty) {return 'Заполните путь до сервисов';}
                                return null;
                              }
                          ),
                        )
                      ]),
                  Divider(),
                  SingleSection(title: 'Авторизация',
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            controller: phone,
                            keyboardType: TextInputType.phone,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Введите номер телефона',
                            ),
                              textInputAction: TextInputAction.done,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Введиете номер телефона';
                                }
                                return null;
                              }
                          ),
                        )]),
                    ],
                  ),
                ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {

            print('Данные введены правильно');
            httpConnection().then((value) {
              if (value==true) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Успешное подключение'), backgroundColor: Colors.green,));
                Globals.setServer(server.text);
                Globals.setPath(path.text);
                Globals.setPhone(phone.text);
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



