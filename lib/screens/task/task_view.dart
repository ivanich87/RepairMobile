import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:repairmodule/screens/task/taskLists.dart';
import 'package:repairmodule/screens/task/task_close.dart';
import 'package:repairmodule/screens/task/task_edit.dart';
import 'package:repairmodule/screens/task/userList.dart';
import 'package:repairmodule/models/Lists.dart';

import '../../components/GeneralFunctions.dart';
import '../../components/SingleSelections.dart';
import '../filesAttachedGallery.dart';
import '../object_view.dart';


class scrTaskViewScreen extends StatefulWidget {
  final taskList task;
  scrTaskViewScreen({super.key, required this.task});

  @override
  State<scrTaskViewScreen> createState() => _scrTaskViewScreenState();
}

class _scrTaskViewScreenState extends State<scrTaskViewScreen> {
  late ImagePicker imagePicker;
  List<ListAttach> listAttached = [];
  List<ListAttach> listAttachedNetwork = [];
  List<String> images = [];

  List<taskCommentList> TaskCommentList = [];
  List<taskObservertList> TaskObservertList = [];
  List<taskSubTaskList> SubTaskList = [];
  final TextEditingController _controlleComment = TextEditingController();

  Future httpGetInfoTask() async {
    images.clear();
    var _queryParameters = {'userId': Globals.anPhone};
    var _url=Uri(path: '${Globals.anPath}task/${widget.task.id}/', host: Globals.anServer, scheme: 'https', queryParameters: _queryParameters);
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': Globals.anAuthorization
    };
    try {
      var response = await http.get(_url, headers: _headers);
      if (response.statusCode == 200) {
        //получаем данные из тела
        var data = json.decode(response.body);

        print(data['taskData']);
        print(data['taskObserver']);
        print(data['taskComment']);

        widget.task.director = data['taskData']['director'];
        widget.task.directorId = data['taskData']['directorId'];
        widget.task.executor = data['taskData']['executor'];
        widget.task.executorId = data['taskData']['executorId'];

        widget.task.generalTaskName = data['taskData']['generalTaskName'];
        widget.task.generalTaskNumber = data['taskData']['generalTaskNumber'];
        widget.task.generalTaskId = data['taskData']['generalTaskId'];
        widget.task.dateCreate = DateTime.tryParse(data['taskData']['dateCreate'])!;
        widget.task.number = data['taskData']['number'];
        print('1');
        widget.task.objectName = data['taskData']['objectName'];
        widget.task.generalTaskExecutor = data['taskData']['generalTaskExecutor'];
        print('2');

        widget.task.generalTaskDateCreate = (data['taskData']['generalTaskDateCreate']=='') ? DateTime.now() : DateTime.tryParse(data['taskData']['generalTaskDateCreate'] ?? DateTime.now().toIso8601String())!;

        widget.task.result = data['taskData']['result'];
        widget.task.name = data['taskData']['name'];
        widget.task.dateTo = DateTime.tryParse(data['taskData']['dateTo'])!;
        widget.task.resultText = data['taskData']['resultText'];
        widget.task.objectId = data['taskData']['objectId'];
        widget.task.content = data['taskData']['content'];
        widget.task.timeTracking = data['taskData']['timeTracking'];
        widget.task.reportToEnd = data['taskData']['reportToEnd'];
        widget.task.resultId = data['taskData']['resultId'];

        widget.task.statusId = data['taskData']['statusId'];
        widget.task.status = data['taskData']['status'];
        widget.task.resultControl = data['taskData']['resultControl'];
        widget.task.changeDeadline = data['taskData']['changeDeadline'];
        widget.task.deadlineFromSubtask = data['taskData']['deadlineFromSubtask'];
        widget.task.schemeTaxi = data['taskData']['schemeTaxi'];
        widget.task.taskCloseAuto = data['taskData']['taskCloseAuto'];

        print('Импорт комментариев');
        //обрабатываем первый массив с комментариями
        TaskCommentList.clear();
        var notesComment = data['taskComment'];
        for (var noteJson in notesComment) {
          TaskCommentList.add(taskCommentList.fromJson(noteJson));
        }

        print('Импорт наблюдателей');
        //обрабатываем второй массив с наблюдателями
        TaskObservertList.clear();
        var notesObserver = data['taskObserver'];
        for (var noteJson in notesObserver) {
          TaskObservertList.add(taskObservertList.fromJson(noteJson));
        }

        print('Импорт подзадач');
        //обрабатываем nhtnbq массив с подзадачами
        SubTaskList.clear();
        var notesSubTask = data['subTask'];
        for (var noteJson in notesSubTask) {
          SubTaskList.add(taskSubTaskList.fromJson(noteJson));
        }

      }
      else {
        print('Код ответа сервера: ' + response.statusCode.toString());
    };
    } catch (error) {
      print("Ошибка при формировании списка: $error");
    }
  }

  Future<bool> httpStatusUpdate(String statusIdNew) async {
    bool _result=false;
    final _queryParameters = {
      'userId': Globals.anPhone
    };
    var _url=Uri(path: '${Globals.anPath}taskupdatestatus/${widget.task.id}/${statusIdNew}', host: Globals.anServer, scheme: 'https', queryParameters: _queryParameters);
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': Globals.anAuthorization
    };
    print(_url.path);
    try {
      var response = await http.get(_url, headers: _headers);
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
        print("Ошибка при выгрузке задачи (статус): $error");
        final snackBar = SnackBar(content: Text('$error'), );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    return _result ?? false;
  }

  Future<bool> httpExecutorUpdate(String executorIdNew) async {
    bool _result=false;
    final _queryParameters = {
      'userId': Globals.anPhone
    };
    var _url=Uri(path: '${Globals.anPath}taskupdateexecutor/${widget.task.id}/${executorIdNew}', host: Globals.anServer, scheme: 'https', queryParameters: _queryParameters);
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': Globals.anAuthorization
    };
    print(_url.path);
    try {
      var response = await http.get(_url, headers: _headers);
      print('Код ответа: ${response.statusCode} Тело ответа: ${response.body}');
      var data = json.decode(response.body);
      _result = data['Успешно'] ?? '';
      String _message = data['Сообщение'] ?? '';

      if (response.statusCode != 200 || _result==false) {
        _result = false;
        final snackBar = SnackBar(content: Text('Исполнитель не поменялся! $_message'), );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (error) {
      _result = false;
      print("Ошибка при выгрузке задачи (исполниель): $error");
      final snackBar = SnackBar(content: Text('$error'), );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    return _result ?? false;
  }

  Future<bool> httpCommentSendMessage(String message) async {
    bool _result=false;
    final _queryParameters = {
      'userId': Globals.anPhone
    };
    var _url=Uri(path: '${Globals.anPath}message/${widget.task.id}/', host: Globals.anServer, scheme: 'https', queryParameters: _queryParameters);
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': Globals.anAuthorization
    };
    print(_url.path);
    try {
      print('Фото прогрузились  ${listAttachedNetwork.length} из ${listAttached.length}');
      if (listAttached.length!=listAttachedNetwork.length)
        throw 'Не все фото прогрузились. Подождите 5 секунд и попробуйте снова (${listAttachedNetwork.length} из ${listAttached.length})';
      var _body = <String, dynamic> {
        "id": "",
        "taskId": widget.task.id,
        "userId": Globals.anUserId,
        "date": DateTime.now().toIso8601String(),
        "comment": message,
        "attachList": listAttachedNetwork!.map((v) => v.toJson()).toList()
      };
      print(jsonEncode(_body));
      var response = await http.post(_url, headers: _headers, body: jsonEncode(_body));
      print('Код ответа: ${response.statusCode} Тело ответа: ${response.body}');
      var data = json.decode(response.body);
      _result = data['Успешно'] ?? '';
      String _message = data['Сообщение'] ?? '';

      if (response.statusCode != 200 || _result==false) {
        _result = false;
        final snackBar = SnackBar(content: Text('Не удалось отправить сообщение! $_message'), );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (error) {
      _result = false;
      print("Ошибка при отправке сообщения: $error");
      final snackBar = SnackBar(content: Text('$error'), );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    return _result ?? false;
  }


  @override
  void initState() {
    listAttached.clear();
    listAttachedNetwork.clear();
    httpGetInfoTask().then((value) async {
      setState(() {
      });
    });
    // TODO: implement initState
    //super.initState();
    imagePicker = ImagePicker();
  }
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Карточка задачи'),
            //bottom: TabBar(tabs: _tabs),
            centerTitle: true,
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            actions: <Widget>[_menuAppBar()],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.task.name, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                Text('Задача №${widget.task.number}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, fontStyle: FontStyle.italic),),
                Divider(),
                //TabBar(tabs: _tabs, ),
                TabBar(isScrollable: true, tabs: [
                  Tab(icon: Row(children:[Icon(Icons.settings), Text(' Основное')]),
                      //text: "Основное"
                      iconMargin: EdgeInsets.zero
                  ),
                  Tab(icon: Row(children:[Icon(Icons.comment), Text(' Комментарии (${TaskCommentList.length})')]),
                    //text: "Финансы",
                    iconMargin: EdgeInsets.zero,),
                ], padding: EdgeInsets.all(5),),
                Expanded(
                  child: TabBarView(children: <Widget> [
                    _pageGeneral(),
                    _pageComment()
                  ]),
                ),
              ],
            ),
          ),
      ),
    );
  }

  _pageGeneral() {
    return Stack(
      children: [
        ListView(padding: EdgeInsets.only(bottom: 45),
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(),
                titleHeader('Описание задачи'),
                Text(widget.task.content, style: TextStyle(fontSize: 20)),
                if (widget.task.generalTaskName !='')
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(),
                      titleHeader('Основная задача'),
                      ListTile(
                        title: Text(widget.task.generalTaskName, style: TextStyle(fontSize: 18)),
                        subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Задача №${widget.task.generalTaskNumber ?? 0} от ${DateFormat('dd.MM.yyyy – kk:mm').format(widget.task.generalTaskDateCreate)}'),
                            Text('Исп.: ${widget.task.generalTaskExecutor}'),
                          ],
                        ),
                        trailing: Icon(Icons.navigate_next_outlined),
                        onTap: () {
                          //нужно получить объект task по widget.task.generalTaskId и открыть форму
                          //objectListFiltered = objectList.where((element) => element.resultFind.toLowerCase().contains(value.toLowerCase())).toList();
                          taskList genTask = taskList(id: widget.task.generalTaskId, number: widget.task.generalTaskNumber, name: widget.task.generalTaskName, content: '', directorId: '', director: '', executorId: '', executor: '', dateCreate: DateTime.now(), dateTo: DateTime.now(), statusId: '', status: '', reportToEnd: true, resultId: '', result: '', resultText: '', objectId: '', objectName: '', generalTaskId: '', generalTaskName: '', generalTaskNumber: 0, generalTaskDateCreate: DateTime.now(), generalTaskExecutor: '', timeTracking: true, changeDeadline: true, resultControl: true, taskCloseAuto: true, deadlineFromSubtask: true, schemeTaxi: false, problemId: '', problemName: '');
                          Navigator.push(context, MaterialPageRoute( builder: (context) => scrTaskViewScreen(task: genTask)));
                        },
                      ),
                      //Text(widget.task.generalTaskName, style: TextStyle(fontSize: 18)),
                    ],
                  ),
                if (SubTaskList.length>0) ... [
                  Divider(),
                  titleHeader('Подзадачи'),
                  ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(10),
                    physics: BouncingScrollPhysics(),
                    reverse: false,
                    itemCount: SubTaskList.length,
                    itemBuilder: (_, index) =>
                        ListTile(
                            title: Text(SubTaskList[index].subTaskName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                            trailing: Icon(Icons.navigate_next_outlined),
                            subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Задача №${SubTaskList[index].subTaskNumber ?? 0} от ${DateFormat('dd.MM.yyyy – kk:mm').format(SubTaskList[index].subTaskDateCreate)}'),
                                Text('Исп.: ${SubTaskList[index].subTaskExecutor}'),
                              ],
                            ),
                            onTap: () async {
                              taskList genTask = taskList(id: SubTaskList[index].id, number: SubTaskList[index].subTaskNumber, name: SubTaskList[index].subTaskName, content: '', directorId: '', director: '', executorId: SubTaskList[index].subTaskExecutorId, executor: SubTaskList[index].subTaskExecutor, dateCreate: SubTaskList[index].subTaskDateCreate, dateTo: DateTime.now(), statusId: '', status: '', reportToEnd: true, resultId: '', result: '', resultText: '', objectId: '', objectName: '', generalTaskId: '', generalTaskName: '', generalTaskNumber: 0, generalTaskDateCreate: DateTime.now(), generalTaskExecutor: '', timeTracking: true, changeDeadline: true, resultControl: true, taskCloseAuto: true, deadlineFromSubtask: true, schemeTaxi: false, problemId: '', problemName: '');
                              Navigator.push(context, MaterialPageRoute( builder: (context) => scrTaskViewScreen(task: genTask)));
                            },
                        ),
                  ),
                ],
                Divider(),
                titleHeader('Даты'),
                ListTile(
                  title: Text(DateFormat('dd.MM.yyyy – kk:mm').format(widget.task.dateCreate), style: TextStyle(fontSize: 18)),
                  subtitle: Text('Дата создания'),
                ),
                ListTile(
                  title: Text(DateFormat('dd.MM.yyyy – kk:mm').format(widget.task.dateTo), style: TextStyle(fontSize: 18)),
                  subtitle: Text('Крайний срок'),
                ),
                //Divider(),
                ListTile(
                  title: Text(widget.task.status, style: _textStyle()),
                  subtitle: Text('Статус'),
                ),
                Divider(),
                titleHeader('Участники'),
                ListTile(
                  title: Text(widget.task.director, style: TextStyle(fontSize: 18)),
                  subtitle: Text('Постановщик'),
                  leading: Icon(Icons.manage_accounts_rounded),
                ),
                ListTile(
                  title: Text(widget.task.executor, style: TextStyle(fontSize: 18)),
                  subtitle: Text('Исполнитель'),
                  leading: Icon(Icons.man),
                ),
                ListTile(
                  title: Text(_textListObserver(), style: TextStyle(fontSize: 18)),
                  subtitle: Text('Наблюдатели'),
                  leading: Icon(Icons.people),
                ),
                Divider(),
                titleHeader('Привязка к оборудованию'),
                ListTile(
                  title: Text(widget.task.objectName, style: TextStyle(fontSize: 18)),
                  subtitle: Text('Оборудование'),
                  trailing: Icon(Icons.navigate_next_outlined),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute( builder: (context) => scrObjectsViewScreen(id: widget.task.objectId)));
                  },
                ),
                Divider(),
                if (widget.task.result!='' || widget.task.resultText!='')
                titleHeader('Результаты'),
                if (widget.task.resultText!='')
                ListTile(
                  title: Text(widget.task.resultText, style: TextStyle(fontSize: 18)),
                  subtitle: Text('Итоговый результат'),
                ),
                if (widget.task.result!='')
                ListTile(
                  title: Text(widget.task.result, style: TextStyle(fontSize: 18)),
                  subtitle: Text('Вид работ'),
                )
              ],
            )

          ],
        ),
        if (widget.task.statusId!='6e209268-b210-4920-ac97-1221175b8b08' && widget.task.statusId!='753614d8-7366-421e-84fc-0a62cacc6124'  && widget.task.statusId!='' && (widget.task.executorId==Globals.anUserId || widget.task.statusId=='52139514-180a-4b78-a882-187cc6832af2'))
        Align(alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12.0, left: 8, right: 8),
            child: SafeArea(
              child:
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  ElevatedButton.icon(
                    icon: Icon(_generateButtonIcon1(), color: Colors.black),
                    label: Text('${_generateButtonName1()}', style: TextStyle(color: Colors.black, fontSize: 14)),
                    onPressed: () => _actionButton1(),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  if (widget.task.statusId!='52139514-180a-4b78-a882-187cc6832af2') ... [
                    SizedBox(width: 8),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.stop, color: Colors.black),
                      label: const Text("Завершить", style: TextStyle(color: Colors.black, fontSize: 14)),
                      onPressed: () async {
                        await Navigator.push(context, MaterialPageRoute( builder: (context) => scrTaskCloseScreen(task: widget.task)));
                        setState(() {

                        });
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                  )
                  ]
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  _pageComment() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
            titleHeader('Комментарии участников'),
            Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    initState();
                    return Future<void>.delayed(const Duration(seconds: 2));
                  },
                  child: ListView.builder(
                    padding: EdgeInsets.all(10),
                    physics: AlwaysScrollableScrollPhysics(),
                    reverse: false,
                    itemCount: TaskCommentList.length,
                    itemBuilder: (_, index) =>
                        Column(
                          children: [
                            if (index>0 && TaskCommentList[index].userName!=TaskCommentList[index-1].userName)
                              SizedBox(height: 8,),
                            Card(
                              child: ListTile(
                                title: RichText(
                                  text: TextSpan(
                                  text: '${TaskCommentList[index].userName} ', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.black),
                                  children: <TextSpan>[
                                    TextSpan(text: '${DateFormat('dd.MM.yyyy – kk:mm').format(TaskCommentList[index].date)}', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12, color: Colors.black)),
                                  ],),
                                ),
                                //trailing: Icon(Icons.message),
                                subtitle: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${TaskCommentList[index].comment}', style: TextStyle(fontStyle: (TaskCommentList[index].system) ? FontStyle.italic : FontStyle.normal)),
                                    if (TaskCommentList[index].file.length>0)
                                    Container(height: 150,
                                      child: ListView.builder(shrinkWrap: true, scrollDirection: Axis.horizontal,
                                        padding: EdgeInsets.all(10),
                                        physics: AlwaysScrollableScrollPhysics(),
                                        reverse: false,
                                        itemCount: TaskCommentList[index].file.length,
                                        itemBuilder: (_, ind) => InkWell(
                                          child: Image.network(TaskCommentList[index].file[ind].path,height: 150),
                                          onTap: () =>
                                              Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                                  scrFilesAttachedGallery(imageItems: TaskCommentList[index].file.map<String>((item) {
                                          return item.path;
                                        }).toList(), defaultIndex: ind))),),

                                      ),
                                    )
                                  ],
                                ),
                                onTap: () async {
                                },
                              ),
                            ),
                          ],
                        )
                  ),
                )
            ),
        SizedBox(height: 12,),
        Container(alignment: Alignment.bottomCenter,
          child: Column(
            children: [
              if (listAttached.length>0)
              Container(height: 150,
                child: ListView.builder(shrinkWrap: true, scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.all(10),
                    physics: AlwaysScrollableScrollPhysics(),
                    reverse: false,
                    itemCount: listAttached.length,
                    itemBuilder: (_, ind) => Image(image: FileImage(File(listAttached[ind].path)), height: 150,),

                    )),
              Row(crossAxisAlignment: CrossAxisAlignment.end, mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _AddMenuIcon(),
                  Expanded(
                    child: TextFormField(
                      minLines: 1,
                      maxLines: 10,
                      controller: _controlleComment,
                      validator: (value) {

                      },
                      decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), labelText: 'Текст комментария'),
                    ),
                  ),
                  IconButton(onPressed: () async {
                      FocusScope.of(context).unfocus();
                      if (_controlleComment.text.length>0 || listAttached.length>0) {
                        if (await httpCommentSendMessage(_controlleComment.text)==true) {
                          _controlleComment.text = '';
                          initState();
                        }
                      }

                    }, icon: Icon(Icons.send,))
                ],
              ),
            ],
          ),
        ),
      ],
    );
    
  }


  _AddMenuIcon() {
    return PopupMenuButton<MenuItemPhotoFile>(
        icon: const Icon(Icons.attach_file),
        //offset: const Offset(40, 0),
        offset: Offset(20, 10),
        onSelected: (MenuItemPhotoFile item) async {
          print(item.name);
          if (item.name=='file') {
            print('Прикрепляем файл с устройства');
          }
          else {
            print('Делаем фото');
            addImage();
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuItemPhotoFile>>[
          const PopupMenuItem<MenuItemPhotoFile>(
            value: MenuItemPhotoFile.photo,
            child: Text('Сделать фото'),
          ),
          const PopupMenuItem<MenuItemPhotoFile>(
            value: MenuItemPhotoFile.file,
            child: Text('Вложить файл'),
          ),
        ]);

  }

  _generateButtonName1() {
    //формирует название кнопки изходя из статуса
    String _name='----';
    if (widget.task.statusId=='52139514-180a-4b78-a882-187cc6832af2') //ждет назначения
      _name='Принять';

    if (widget.task.statusId=='3815be37-b90a-4e77-9327-8f7c55730f4f') //Назначена
      _name='Начать';

    if (widget.task.statusId=='9cbedc69-9f5a-4247-adba-92db3c3cea10') //Выполняется
      _name='Приостановить';

    return _name;
  }

  _generateButtonIcon1() {
    //формирует иконку кнопки изходя из статуса
    IconData _icn = Icons.add;
    if (widget.task.statusId=='52139514-180a-4b78-a882-187cc6832af2') //ждет назначения
      _icn=Icons.add;

    if (widget.task.statusId=='3815be37-b90a-4e77-9327-8f7c55730f4f') //Назначена
      _icn=Icons.play_arrow;

    if (widget.task.statusId=='9cbedc69-9f5a-4247-adba-92db3c3cea10') //Выполняется
      _icn=Icons.pause;

    return _icn;
  }

  _actionButton1() {
    String statusIdNew='';
    String statusNameNew='';

    switch (widget.task.statusId) {
      case '52139514-180a-4b78-a882-187cc6832af2':                        //ждет исполнителя
        statusIdNew='3815be37-b90a-4e77-9327-8f7c55730f4f';
        statusNameNew='Назначена';
      case '3815be37-b90a-4e77-9327-8f7c55730f4f':                        //Назначена
        statusIdNew='9cbedc69-9f5a-4247-adba-92db3c3cea10';
        statusNameNew='Выполняется';
      case '9cbedc69-9f5a-4247-adba-92db3c3cea10':                        //Выполняется
        statusIdNew='3815be37-b90a-4e77-9327-8f7c55730f4f';
        statusNameNew='Назначена';
    }

    httpStatusUpdate(statusIdNew).then((value) async {
      if (value==true) {
        setState(() {
          if (widget.task.statusId=='52139514-180a-4b78-a882-187cc6832af2') {
            widget.task.executorId = Globals.anUserId;
            widget.task.executor = Globals.anUserName;
          }
          widget.task.statusId=statusIdNew;
          widget.task.status=statusNameNew;

        });
      }
    });

  }

  _textStyle() {
    if (widget.task.statusId=='6e209268-b210-4920-ac97-1221175b8b08' || widget.task.statusId=='753614d8-7366-421e-84fc-0a62cacc6124')
      return TextStyle(fontWeight: FontWeight.bold, fontSize: 18);

    return TextStyle(fontWeight: FontWeight.normal, fontSize: 18);
  }


  PopupMenuButton<Menu> _menuAppBar() {
    return PopupMenuButton<Menu>(
        icon: const Icon(Icons.menu, ),
        offset: const Offset(0, 40),
        onSelected: (Menu item) async {
          if (item == Menu.itemCopy) {
            //тут откроем новое окно с созданием новой задачи
            String _res ='';
            _res = await Navigator.push(context, MaterialPageRoute(builder: (context) => scrTaskEditScreen(task: taskList(id: '', number: 0, name: widget.task.name, content: widget.task.content, directorId: Globals.anUserId, director: Globals.anUserName, executorId: '5fac3cbd-3875-11ef-a769-00155d02d23d', executor: 'Механики', dateCreate: DateTime.now(), dateTo: DateTime.now().add(Duration(hours: 4)), statusId: '52139514-180a-4b78-a882-187cc6832af2', status: 'Ждет исполнителя', reportToEnd: true, resultId: '', result: '', resultText: '', objectId: widget.task.objectId, objectName: widget.task.objectName, generalTaskId: widget.task.id, generalTaskName: widget.task.name, generalTaskNumber: widget.task.number, generalTaskDateCreate: widget.task.dateCreate, generalTaskExecutor: widget.task.executor, timeTracking: widget.task.timeTracking, changeDeadline: widget.task.changeDeadline, resultControl: false, taskCloseAuto: widget.task.taskCloseAuto, deadlineFromSubtask: widget.task.deadlineFromSubtask, schemeTaxi: widget.task.schemeTaxi, problemName: widget.task.problemName, problemId: widget.task.problemId), TaskObservertList: TaskObservertList))) ?? '';
            if (_res!='') {
              final snackBar = SnackBar(content: Text(_res), backgroundColor: Colors.green,);
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
            setState(() {

            });
          }
          if (item == Menu.itemEdit) {
            await Navigator.push(context, MaterialPageRoute(builder: (context) => scrTaskEditScreen(task: widget.task, TaskObservertList: TaskObservertList,)));
            setState(() {

            });
          }
          if (item == Menu.itemDelegate) {
            var res = await Navigator.push(context, MaterialPageRoute( builder: (context) => scrUserListScreen(false)));
            if (res!=null) {
              httpExecutorUpdate(res.id).then((value) {
                if (value==true) {
                  setState(() {
                    widget.task.directorId = res.id;
                    widget.task.director = res.name;
                  });
                  Navigator.pop(context);
                }
              });
            }
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
          const PopupMenuItem<Menu>(
            value: Menu.itemEdit,
            child: Text('Редактировать'),
          ),
          const PopupMenuItem<Menu>(
            value: Menu.itemCopy,
            child: Text('Добавить подзадачу (скопировать)'),
          ),
          // const PopupMenuItem<Menu>(
          //   value: Menu.itemDelegate,
          //   child: Text('Делегировать'),
          // ),
        ].toList());
  }

  String _textListObserver() {
    String _name = '';
    if (TaskObservertList.length>0){
      for (int i=0; i<TaskObservertList.length; i++) {
        if (_name=='')
          _name=_name+TaskObservertList[i].userName;
        else
          _name=_name+'; '+TaskObservertList[i].userName;
      }
    }
    else
      _name='Нет наблюдателей';
    return _name;
  }

  addImage() async {
    String _addStatus = '';
    try {
      XFile? selectedImage = await imagePicker.pickImage(source: ImageSource.camera, maxHeight: 800);
      if (selectedImage!=null) {
        String _namePhoto = '${DateFormat('ddMMyyyyHHmmss').format(DateTime.now())}';
        print('_namePhoto = $_namePhoto');
        listAttached.add(ListAttach(selectedImage.path, _namePhoto, selectedImage.path, 0));
        setState(() {

        });
        returnResult res = await httpUploadImage(_namePhoto, File(selectedImage.path));
        if (res.resultCode==0) {
          listAttachedNetwork.add(ListAttach(selectedImage.path, _namePhoto, res.resultText, 0));
          _addStatus = 'Файл ${_namePhoto} успешно загружен на сервер';
        }
        else {
          throw res.resultText;
        }

      }
    } catch (error) {
      _addStatus = error.toString();
    }
    final snackBar = SnackBar(content: Text('$_addStatus'),);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }


}




enum Menu { itemEdit, itemCopy, itemDelegate }

enum MenuItemPhotoFile {photo, file}