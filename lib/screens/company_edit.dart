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

class scrCompanyEditScreen extends StatefulWidget {

  scrCompanyEditScreen({super.key});

  @override
  State<scrCompanyEditScreen> createState() => _scrCompanyEditScreenState();
}

class _scrCompanyEditScreenState extends State<scrCompanyEditScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  bool userDataEdit = false;


  TextEditingController _companyName=TextEditingController(text: '');
  TextEditingController _companyComment=TextEditingController(text: '');

  Future<bool> httpCompanyUpdate() async {
    bool _result=false;
    String _message = '';
    var _url=Uri(path: '${Globals.anPath}company/${Globals.anCompanyId}/', host: Globals.anServer, scheme: 'https');
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': Globals.anAuthorization
    };
    var _body = <String, String> {
      'companyId': Globals.anCompanyId,
      'companyName': _companyName.text,
      'companyComment': _companyComment.text,
    };
    try {
      print(json.encode(_body));
      var response = await http.post(_url, headers: _headers, body: json.encode(_body));
      print('Код ответа: ${response.statusCode} Тело ответа: ${response.body}');
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        _result = data['Успешно'] ?? '';
        String _message = data['Сообщение'] ?? '';

        print('Объект и договор созданы. Результат:  $_result. Сообщение:  $_message. ');
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
      _companyName.text = Globals.anCompanyName;
      _companyComment.text = Globals.anCompanyComment;

      userDataEdit = true;
    }


    return Scaffold(
        appBar: AppBar(
          title: Text('Данные компании'),
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
                  Divider(),
                  SingleSection(title: 'Данные компании',
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            textAlign: TextAlign.start,
                            controller: _companyName,
                            keyboardType: TextInputType.text,
                            style: TextStyle(fontSize: 18),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Название компании',
                            ),
                              textInputAction: TextInputAction.done,
                              validator: (value) {
                                if (value == null || value.isEmpty) {return 'Заполните название компании';}
                                return null;
                              }
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                              textAlign: TextAlign.start,
                              minLines: 3,
                              maxLines: 10,
                              controller: _companyComment,
                              keyboardType: TextInputType.text,
                              style: TextStyle(fontSize: 18),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Комментарий',
                              ),
                              textInputAction: TextInputAction.done,
                          ),
                        )
                      ])
                    ],
                  ),
                ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print('Данные введены правильно');
            httpCompanyUpdate().then((value) {
              if (value==true) {
                Globals.setCompanyName(_companyName.text);
                Globals.setCompanyComment(_companyComment.text);
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



