import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:repairmodule/screens/task/resultList.dart';
import 'package:repairmodule/screens/task/taskLists.dart';

import '../../models/Lists.dart';
import '../sprList.dart';


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
      "resultId": widget.task.resultId,
      "resultText": resultText.text,
      "resultType": resultType.toString(),
      "resultTypeClose": resultTypeClose.toString()
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
    if (widget.task.result=='')
      widget.task.result='Выберите причину';
    // TODO: implement initState
    //super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Закрытие задачи'),
          //bottom: TabBar(tabs: _tabs),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          //actions: [IconButton(onPressed: () {}, icon: Icon(Icons.menu))],
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
                  Text('Выберите вариант завершения:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
                  RadioListTile(secondary: Icon(Icons.done_outline_rounded, color: Colors.green,), title: Text('Выполнена полностью'), value: 1, groupValue: resultType, onChanged: (value){
                    setState(() {
                      if (widget.task.resultId=='d3814d8d-6b7c-11ef-a580-00155d02d23d' || widget.task.resultId=='853c6e7a-56fb-11ef-a769-00155d02d23d' || widget.task.resultId=='f8cf925e-589e-11ef-a769-00155d02d23d') {
                        widget.task.resultId='';
                        widget.task.result='Выберите причину';
                      }
                      resultType = value!;
                      //userDataEdit = true;
                      //Navigator.pop(context);
                    });
                  }
                  ),
                  if (widget.task.resultId!='dfc90248-765b-11ef-a580-00155d02d23d') //если это заказ запчастей, то не показывать Не выполнение
                  RadioListTile( secondary: Icon(Icons.close, color: Colors.red,), title: Text('Задача не выполнена'), value: 2, groupValue: resultType, onChanged: (value) {
                    setState(() {
                      if (resultTypeClose==1) {
                        widget.task.resultId='d3814d8d-6b7c-11ef-a580-00155d02d23d';
                        widget.task.result='Делегирование другому исполнителю';
                      }
                      resultType = value!;
                      //userDataEdit = true;
                      //Navigator.pop(context);
                    });
                  }),
                  if (resultType==2)
                    Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: Column(
                        children: [
                          RadioListTile(secondary: Icon(Icons.task_outlined), title: Text('Делегировать'), value: 1, groupValue: resultTypeClose, onChanged: (value){
                            setState(() {
                              widget.task.resultId='d3814d8d-6b7c-11ef-a580-00155d02d23d';
                              widget.task.result='Делегирование другому исполнителю';
                              resultTypeClose = value!;
                              //userDataEdit = true;
                              //Navigator.pop(context);
                            });
                          }
                          ),
                          RadioListTile(secondary: Icon(Icons.add_task), title: Text('Заказ запчастей'), value: 2, groupValue: resultTypeClose, onChanged: (value) {
                            setState(() {
                              widget.task.resultId='853c6e7a-56fb-11ef-a769-00155d02d23d';
                              widget.task.result='Заказ запчастей';
                              resultTypeClose = value!;
                              //userDataEdit = true;
                              //Navigator.pop(context);
                            });
                          }),
                          RadioListTile(secondary: Icon(Icons.cancel), title: Text('Проблема другова подразделения'), value: 3, groupValue: resultTypeClose, onChanged: (value){
                            setState(() {
                              widget.task.resultId='f8cf925e-589e-11ef-a769-00155d02d23d';
                              widget.task.result='Решение проблемы в другом подразделении';
                              resultTypeClose = value!;
                              //userDataEdit = true;
                              //Navigator.pop(context);
                            });
                          }
                          )
                        ],
                      ),
                    ),
                  SizedBox(height: 20,),
                  TextFormField(
                    autofocus: false,
                    minLines: 4,
                    maxLines: 8,
                    controller: resultText,
                    validator: (value) => valid(value, widget.task.resultControl),
                    decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), labelText: 'Результат'),
                  ),
                  SizedBox(height: 20,),
                  if (!(widget.task.resultId=='d3814d8d-6b7c-11ef-a580-00155d02d23d' || widget.task.resultId=='853c6e7a-56fb-11ef-a769-00155d02d23d' || widget.task.resultId=='f8cf925e-589e-11ef-a769-00155d02d23d')) ... [
                    Card(
                        child: ListTile(
                          title: Text(widget.task.problemName, style: TextStyle(fontWeight: FontWeight.bold),),
                          trailing: Icon(Icons.navigate_next),
                          subtitle: Text('Кликните для смены типа причины'),
                          onTap: () async {
                            FocusScope.of(context).unfocus();
                            var res = await Navigator.push(context, MaterialPageRoute( builder: (context) => scrListScreen(sprName: 'ТипыПроблем', onType: 'pop')));
                            setState(() {
                              widget.task.problemId = res.id;
                              widget.task.problemName = res.name;
                            });
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                        )
                    ),
                    Card(
                        child: ListTile(
                          title: Text(widget.task.result, style: TextStyle(fontWeight: FontWeight.bold),),
                          enabled: !(widget.task.resultId=='d3814d8d-6b7c-11ef-a580-00155d02d23d' || widget.task.resultId=='853c6e7a-56fb-11ef-a769-00155d02d23d' || widget.task.resultId=='f8cf925e-589e-11ef-a769-00155d02d23d') ,
                          trailing: Icon(Icons.navigate_next),
                          subtitle: Text('Кликните для выбора причины'),
                          onTap: () async {
                            FocusScope.of(context).unfocus();
                            var res = await Navigator.push(context, MaterialPageRoute( builder: (context) => scrResultListScreen(widget.task.problemId)));
                            setState(() {
                              widget.task.resultId = res.id;
                              widget.task.result = res.name;
                            });
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                        )
                    ),
                  ],
                ],
              ),
            ),
          ),
            SizedBox(height: 20),
            Container(alignment: Alignment.center,
                child: ElevatedButton(onPressed: _closeTask,
                  child: Text('Завершить задачу', style: TextStyle(color: Colors.black)),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green[400]),
                      shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                      minimumSize: MaterialStateProperty.all(Size(250, 40))
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
          if(widget.task.resultControl==true && resultType==1) {
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