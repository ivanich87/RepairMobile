import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:repairmodule/screens/task/taskLists.dart';

import '../../models/Lists.dart';


class scrTaskCloseScreen extends StatefulWidget {
  final taskList task;
  scrTaskCloseScreen({super.key, required this.task});

  @override
  State<scrTaskCloseScreen> createState() => _scrTaskCloseScreenState();
}

class _scrTaskCloseScreenState extends State<scrTaskCloseScreen> {
  int resultType =1;
  int resultTypeClose=1;
  TextEditingController resultText = TextEditingController(text: '');
  GlobalKey _formKey= new GlobalKey<FormState>();

  Future<bool> httpCloseTask() async {
    bool _result=false;
    var _url=Uri(path: '${Globals.anPath}taskclose/${widget.task.id}', host: Globals.anServer, scheme: 'https');
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': Globals.anAuthorization
    };
    print(_url.path);
    var _body = <String, String> {
      "resultText": resultText.text
    };
    try {
      print(jsonEncode(_body));
      var response = await http.post(_url, headers: _headers, body: jsonEncode(_body));
      print('Код ответа: ${response.statusCode} Тело ответа: ${response.body}');
      var data = json.decode(response.body);
      _result = data['Успешно'] ?? '';
      String _message = data['Сообщение'] ?? '';

      if (response.statusCode != 200 || _result==false) {
        _result = false;
        final snackBar = SnackBar(content: Text('Статус не поменялся! $_message'), );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (error) {
      _result = false;
      print("Ошибка при выгрузке платежа: $error");
      final snackBar = SnackBar(content: Text('$error'), );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    return _result ?? false;
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Закрытие задачи'),
          //bottom: TabBar(tabs: _tabs),
          centerTitle: true,
        ),
        body: ListView(
          children: [
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Завершение задачи № ${widget.task.number}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                  //Divider(),
                  Text('Задача: ${widget.task.name}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Divider(),
                  SizedBox(height: 20,),
                  TextFormField(
                    autofocus: false,
                    minLines: 4,
                    maxLines: 8,
                    controller: resultText,
                    validator: (value) => valid(value, widget.task.resultControl),
                    decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), labelText: 'Результат'),
                  ),
                  SizedBox(height: 30,),
                ],
              ),
            ),
          ),
            SizedBox(height: 20),
            Container(alignment: Alignment.center,
                child: ElevatedButton(onPressed: _closeTask,
                  child: Text('Завершить задачу', style: TextStyle(color: Colors.black)),
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.green[400]),
                      shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                      minimumSize: WidgetStateProperty.all(Size(250, 40))
                  ),)),
      ]
        ),
    );
  }

  void _closeTask() {
    //вызываем метод закрытия задачи со всеми проверками и если все успешно, закрываем задачу
    httpCloseTask().then((value) async {
      print('Процедура закрытия задачи - $value');
      if (value==true) {
        setState(() {
          widget.task.resultText = resultText.text;
          if(widget.task.resultControl==true) {
            widget.task.statusId='753614d8-7366-421e-84fc-0a62cacc6124';
            widget.task.status='Выполнена';
          }
          else {
            widget.task.statusId='6e209268-b210-4920-ac97-1221175b8b08';
            widget.task.status='Закрыта';
          }
        });
        Navigator.pop(context);
      }
    });

  }

}

valid(String? value, bool resultControl) {
  if (resultControl==false)
    return null;
  else
    return value
    !.trim()
        .length > 0 ? null : 'Нужно заполнить результат задачи';
}