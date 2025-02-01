import 'dart:convert';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:repairmodule/screens/task/taskLists.dart';
import 'package:repairmodule/screens/task/userList.dart';

import '../../components/SingleSelections.dart';
import '../../models/Lists.dart';
import '../sprList.dart';


class scrTaskEditScreen extends StatefulWidget {
  final taskList task;
  final List<taskObservertList> TaskObservertList;
  scrTaskEditScreen({super.key, required this.task, required this.TaskObservertList});

  @override
  State<scrTaskEditScreen> createState() => _scrTaskEditScreenState();
}

class _scrTaskEditScreenState extends State<scrTaskEditScreen> {
  List<taskObservertList> _TaskObservertList = [];

  bool downloadData = false;

  TextEditingController _controlleName = TextEditingController(text: '');
  TextEditingController _controlleContent = TextEditingController(text: '');
  TextEditingController _resultTextContent = TextEditingController(text: '');

  DateTime _dateTo = DateTime.now();
  String _directorId = '';
  String _director = '';
  String _executorId = '';
  String _executor = '';
  String _generalTaskName = '';
  String _generalTaskId = '';
  String _objectName = '';
  String _objectId = '';
  String _resultText = '';
  bool _schemeTaxi = false;

  Future<bool> httpTaskSave() async {
    bool _result=false;
    final _queryParameters = {
      'userId': Globals.anPhone
    };
    String id = 'add';
    if (widget.task.id!='')
      id=widget.task.id;
    var _url=Uri(path: '${Globals.anPath}taskupdate/${id}', host: Globals.anServer, scheme: 'https', queryParameters: _queryParameters);
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': Globals.anAuthorization
    };
    print('mass observer');
    print(_TaskObservertList.toList());

    var _body = <String, dynamic> {
      'id': widget.task.id,
      'name': _controlleName.text,
      'content': _controlleContent.text,
      'directorId': _directorId,
      'executorId': _executorId,
      'dateTo': _dateTo.toIso8601String(),
      'reportToEnd': widget.task.reportToEnd,
      'resultText': _resultText,
      'objectId': _objectId,
      'generalTaskId': _generalTaskId,
      'timeTracking': widget.task.timeTracking,
      'changeDeadline': widget.task.changeDeadline,
      'resultControl': widget.task.resultControl,
      'taskCloseAuto': widget.task.taskCloseAuto,
      'deadlineFromSubtask': widget.task.deadlineFromSubtask,
      'schemeTaxi': _schemeTaxi,
      'taskObservertList': _TaskObservertList.toList()
    };
    print(jsonEncode(_body));
    print(_url.path);
    try {
      var response = await http.post(_url, headers: _headers, body: jsonEncode(_body));
      print('Код ответа: ${response.statusCode} Тело ответа: ${response.body}');
      var data = json.decode(response.body);
      _result = data['Успешно'] ?? '';
      String _message = data['Сообщение'] ?? '';

      if (response.statusCode != 200 || _result==false) {
        _result = false;
        final snackBar = SnackBar(content: Text('При сохранении произошла ошибка! $_message'), backgroundColor: Colors.red,);
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
  Widget build(BuildContext context) {
    if (downloadData==false) {
      _schemeTaxi = widget.task.schemeTaxi;
      _controlleName.text = widget.task.name;
      _controlleContent.text = widget.task.content;
      _resultTextContent.text= widget.task.resultText;

      _dateTo = widget.task.dateTo;
      _directorId = widget.task.directorId;
      _director = widget.task.director;
      _executorId = widget.task.executorId;
      _executor = widget.task.executor;
      _generalTaskName = (widget.task.generalTaskName=='') ? 'Выбрать' : widget.task.generalTaskName;
      _generalTaskId = widget.task.generalTaskId;
      _objectName = (widget.task.objectName=='') ? 'Выбрать' : widget.task.objectName;
      _objectId = widget.task.objectId;

      for (var noteJson in widget.TaskObservertList) {
        _TaskObservertList.add(noteJson);
      }

      downloadData = true;
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Редактирование задачи'),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                ListView(padding: EdgeInsets.only(bottom: 45, top: 2),
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Задача №${widget.task.number} от ${DateFormat('dd.MM.yyyy – kk:mm').format(widget.task.dateCreate)}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, fontStyle: FontStyle.italic),),
                        SizedBox(height: 12,),
                        TextFormField(
                          autofocus: true,
                          controller: _controlleName,
                          validator: (value) {

                          },
                          decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), labelText: 'Заголовок задачи'),
                        ),
                        SizedBox(height: 12,),
                        TextFormField(
                          minLines: 2,
                          maxLines: 10,
                          controller: _controlleContent,
                          validator: (value) {

                          },
                          decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), labelText: 'Краткое описание'),
                        ),
                        Divider(),
                        titleHeader('Крайний срок'),
                        ListTile(leading: Icon(Icons.calendar_month), title: Text(DateFormat('dd.MM.yyyy – kk:mm').format(_dateTo).toString()),
                          onTap: () async {
                            FocusManager.instance.primaryFocus?.unfocus();
                            DatePicker.showDatePicker(context, locale: DateTimePickerLocale.ru,
                              dateFormat: 'dd MMMM yyyy HH:mm',
                              initialDateTime: _dateTo,
                              minDateTime: DateTime(2024), maxDateTime: DateTime(2040),
                              onMonthChangeStartWithFirstDate: true,
                              onConfirm: (dateTime, List<int> index) {
                                setState(() {
                                  _dateTo = dateTime;
                                });
                              },
                            );
                          },
                        ),
                        Divider(),
                        titleHeader('Участники'),
                        ListTile(
                          title: Text(_director),
                          subtitle: Text('Постановщик'),
                          leading: Icon(Icons.manage_accounts_rounded),
                          onTap: () async {
                            FocusManager.instance.primaryFocus?.unfocus();
                            var res = await Navigator.push(context, MaterialPageRoute( builder: (context) => scrListScreen(sprName: 'Сотрудники', onType: 'pop')));
                            setState(() {
                              _directorId = res.id;
                              _director = res.name;
                            });
                          },
                        ),
                        ListTile(
                          title: Text(_executor),
                          subtitle: Text('Исполнитель'),
                          leading: Icon(Icons.man),
                          onTap: () async {
                            FocusManager.instance.primaryFocus?.unfocus();
                            bool _selectGroup = false;
                            if (_schemeTaxi==true)
                              _selectGroup = true;

                            var res = await Navigator.push(context, MaterialPageRoute( builder: (context) => scrListScreen(sprName: 'Сотрудники', onType: 'pop')));
                            setState(() {
                              _executorId = res.id;
                              _executor = res.name;
                            });
                          },
                        ),
                        ListTile(
                          title: Text(_textListObserver()),
                          subtitle: Text('Наблюдатели'),
                          leading: Icon(Icons.people),
                          trailing: Icon(Icons.add),
                          onTap: () async {
                            FocusManager.instance.primaryFocus?.unfocus();
                            var res = await Navigator.push(context, MaterialPageRoute( builder: (context) => scrListScreen(sprName: 'Сотрудники', onType: 'pop')));
                            setState(() {
                              _TaskObservertList.add(taskObservertList(userId: res.id, userName: res.name));
                            });
                          },
                        ),
                        Divider(),
                        titleHeader('Основная задача'),
                        ListTile(
                          title: Text(_generalTaskName),
                          trailing: Icon(Icons.navigate_next),
                          onTap: () async {
                            FocusManager.instance.primaryFocus?.unfocus();
                            var res = await Navigator.push(context, MaterialPageRoute( builder: (context) => scrListScreen(sprName: 'Задачи', onType: 'pop',)));
                            setState(() {
                              _generalTaskId = res.id;
                              _generalTaskName = res.name;
                            });
                          },
                        ),
                        //Text(widget.task.generalTaskName),
                        Divider(),
                        titleHeader('Привязка к объекту'),
                        ListTile(
                          title: Text(_objectName),
                          //subtitle: Text('Клиент'),
                          onTap: () async {
                            FocusManager.instance.primaryFocus?.unfocus();
                            var res = await Navigator.push(context, MaterialPageRoute( builder: (context) => scrListScreen(sprName: 'Объекты', onType: 'pop',)));
                            setState(() {
                              _objectId = res.id;
                              _objectName = res.name;
                            });
                          },
                        ),
                        Divider(),
                        if (widget.task.resultText!='' || widget.task.resultText!='')
                          titleHeader('Результаты'),
                        if (widget.task.resultText!='')
                          ListTile(
                            title: Text(widget.task.resultText),
                            subtitle: Text('Итоговый результат'),
                          ),
                      ],
                    )

                  ],
                ),
                if (widget.task.statusId!='6e209268-b210-4920-ac97-1221175b8b08' && widget.task.statusId!='753614d8-7366-421e-84fc-0a62cacc6124')
                  Align(alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12.0, left: 8, right: 8),
                      child: SafeArea(
                        child:
                        ElevatedButton.icon(
                          icon: Icon(Icons.save, color: Colors.black),
                          label: Text('Сохранить', style: TextStyle(color: Colors.black, fontSize: 15)),
                          onPressed: () {
                            httpTaskSave().then((value) {
                              if (value==true) {
                                widget.task.directorId = _directorId;
                                widget.task.director = _director;
                                widget.task.executorId = _executorId;
                                widget.task.executor = _executor;
                                widget.task.name = _controlleName.text;
                                widget.task.content = _controlleContent.text;
                                widget.task.generalTaskId = _generalTaskId;
                                widget.task.generalTaskName = _generalTaskName;
                                widget.task.objectId = _objectId;
                                widget.task.objectName = _objectName;
                                widget.task.resultText = _resultText;
                                widget.task.dateTo = _dateTo;
                                String _resultSave = '';
                                if (widget.task.id=='')
                                  _resultSave = 'Создана новая задача';
                                else
                                  _resultSave = 'Задача ${widget.task.number} изменена';

                                Navigator.pop(context, _resultSave);
                              }
                          });
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ),
    );
  }


  String _textListObserver() {
    String _name = '';
    if (_TaskObservertList.length>0){
      for (int i=0; i<_TaskObservertList.length; i++) {
        if (_name=='')
          _name=_name+_TaskObservertList[i].userName;
        else
          _name=_name+'\n'+_TaskObservertList[i].userName;
      }
    }
    else
      _name='Нет наблюдателей';
    return _name;
  }
}

