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

class scrListCreateScreen extends StatefulWidget {
  final String sprName;
  late sprList sprObject;


  scrListCreateScreen({super.key, required this.sprObject, required this.sprName});

  @override
  State<scrListCreateScreen> createState() => _scrListCreateScreenState();
}

class _scrListCreateScreenState extends State<scrListCreateScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool userDataEdit = false;

  TextEditingController name=TextEditingController(text: '');
  TextEditingController comment=TextEditingController(text: '');

  Future<bool> httpSprCreate() async {
    bool _result=false;
    var _url=Uri(path: '/a/centrremonta/hs/v1/sprList/${widget.sprName}/', host: 's1.rntx.ru', scheme: 'https');
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': 'Basic YWNlOkF4V3lJdnJBS1prdzY2UzdTMEJP'
    };
    widget.sprObject.name=name.text;
    widget.sprObject.comment=comment.text;

    var _body = <String, String> {
      'name': widget.sprObject.name,
      'comment': widget.sprObject.comment,
      'id': widget.sprObject.id,
      'code': widget.sprObject.code,
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
          widget.sprObject.id = data['Код'];

        print('Справочник создан. Результат:  $_result. Сообщение:  $_message. Код объекта = ${widget.sprObject.id}');
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
      name.text = widget.sprObject.name;
      comment.text = widget.sprObject.comment;
      userDataEdit = true;
    }
    print('Тип: '+widget.sprObject.code + 'Вот');
    return Scaffold(
        appBar: AppBar(
          title: Text('Создание элемента'),
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
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Text('Заполните данные ', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), ),
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
                              labelText: 'Введите название',
                            ),
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value == null || value.isEmpty) {return 'Заполните название';}
                                return null;
                              }
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                              textAlign: TextAlign.start,
                              controller: comment,
                              minLines: 3,
                              maxLines: 6,
                              keyboardType: TextInputType.text,
                              style: TextStyle(fontSize: 16),
                              decoration: InputDecoration(
                                icon: Icon(Icons.comment_outlined),
                                border: OutlineInputBorder(),
                                labelText: 'Комментарий',
                                //hintText: 'Укажите описание элемента справочника'
                              ),
                              textInputAction: TextInputAction.done,
                              validator: (value) {
                                return null;
                              }
                          ),
                        )
                      ]),
                  Divider(),
                  //Далее идет блок только для справочника создания аналитики и выводит на экран тип аналитики (зашифровано в поле code)
                  if (widget.sprName=='АналитикаДвиженийДСРасход' || widget.sprName=='АналитикаДвиженийДСПриход' || widget.sprName=='АналитикаДвиженийДС')
                  SingleSection(title: 'Тип аналитики',
                    children: [
                      Column(
                        children: [
                          RadioListTile(title: Text('Приход'), subtitle: Text('Будет выходить только в поступлениях денег'), value: '0', groupValue: widget.sprObject.code, onChanged: (value){
                            setState(() {
                              widget.sprObject.code = value!;
                            });
                          }
                          ),
                          RadioListTile(title: Text('Расход'), subtitle: Text('Будет выходить только в списании денег'), value: '1', groupValue: widget.sprObject.code, onChanged: (value) {
                            setState(() {
                              widget.sprObject.code = value!;
                            });
                          }
                          ),
                        ],
                    )],
                  )
            ],
          ),
                ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Данные сохраняются'), backgroundColor: Colors.green,));
            print('Данные введены правильно');
            httpSprCreate().then((value) {
              if (value==true)
                Navigator.pop(context);
            });
            },
          child: Icon(Icons.save),
        )
      //backgroundColor: Colors.grey[900]),
    );
  }

}



