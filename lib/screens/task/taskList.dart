import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:repairmodule/screens/task/taskLists.dart';
import 'package:repairmodule/screens/task/task_edit.dart';
import 'package:repairmodule/screens/task/task_view.dart';

import '../../models/Lists.dart';
import '../objects.dart';




class scrTaskListScreen extends StatefulWidget {


  scrTaskListScreen();

  @override
  State<scrTaskListScreen> createState() => _scrTaskListScreenState();
}

class _scrTaskListScreenState extends State<scrTaskListScreen> {
  List<taskList> objectList = [];
  List<taskList> objectListAssignet = [];
  List<taskList> objectListDone = [];

  Future httpGetListObject() async {
    var _queryParameters = {'userId': Globals.anPhone};
    var _url=Uri(path: '${Globals.anPath}tasklist/', host: Globals.anServer, scheme: 'https', queryParameters: _queryParameters);
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': Globals.anAuthorization
    };
    try {
      print(_url.path);
      var response = await http.get(_url, headers: _headers);
      print('Выполнен запрос, ответ ${response.statusCode.toString()}');
      if (response.statusCode == 200) {
        var notesJson = json.decode(response.body);
        for (var noteJson in notesJson) {
           if (noteJson['statusId']=='52139514-180a-4b78-a882-187cc6832af2')
             objectList.add(taskList.fromJson(noteJson));
           if (noteJson['statusId']=='3815be37-b90a-4e77-9327-8f7c55730f4f' || noteJson['statusId']=='9cbedc69-9f5a-4247-adba-92db3c3cea10')
             objectListAssignet.add(taskList.fromJson(noteJson));
           if (noteJson['statusId']=='753614d8-7366-421e-84fc-0a62cacc6124' || noteJson['statusId']=='6e209268-b210-4920-ac97-1221175b8b08')
             objectListDone.add(taskList.fromJson(noteJson));
           print(noteJson['statusId']);
        }
      }
      else {
        throw 'Сервер вернул код ${response.statusCode}. Ответ: ${response.body}';
      }

    } catch (error) {
      print("Ошибка при формировании списка: $error");
      final snackBar = SnackBar(content: Text('$error'), );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void initState() {
    print('initState');
    objectList.clear();
    objectListAssignet.clear();
    objectListDone.clear();

    httpGetListObject().then((value) {
      setState(() {
      });
    });
    // TODO: implement initState
    //super.initState();
  }
  Widget build(BuildContext context) {
    print('Кол-во задач: ${objectList.length}');
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('${Globals.anUserName}'),
          bottom: TabBar(tabs: _tabs),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: <Widget>[_menuAppBar()],
        ),
          body: TabBarView(children: <Widget> [
            _oneScreen(),
            _twoScreen(),
            _threeScreen()

          ],),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                String _res ='';
                List<taskObservertList> taskObservers=[];
                _res = await Navigator.push(context, MaterialPageRoute(builder: (context) => scrTaskEditScreen(task: taskList(id: '', number: 0, name: '', content: '', directorId: Globals.anUserId, director: Globals.anUserName, executorId: '', executor: '', dateCreate: DateTime.now(), dateTo: DateTime.now(), statusId: '52139514-180a-4b78-a882-187cc6832af2', status: 'Ждет исполнителя', reportToEnd: true, resultId: '', result: '', resultText: '', objectId: '', objectName: '', generalTaskId: '', generalTaskName: '', generalTaskNumber: 0, generalTaskDateCreate: DateTime.now(), generalTaskExecutor: '', timeTracking: false, changeDeadline: false, resultControl: false, taskCloseAuto: false, deadlineFromSubtask: false, schemeTaxi: true, problemId: '', problemName: ''), TaskObservertList: taskObservers))) ?? '';
                if (_res!='') {
                  final snackBar = SnackBar(content: Text(_res), backgroundColor: Colors.green,);
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
                setState(() {

                });
              },
              child: Text('+'),)
            //backgroundColor: Colors.grey[900]),
      ),
    );
  }

  _oneScreen() {
    return RefreshIndicator(
      onRefresh: () async {
        initState();
        return Future<void>.delayed(const Duration(seconds: 2));
      },
      child: ListView.builder(
          padding: EdgeInsets.all(10),
          physics: AlwaysScrollableScrollPhysics(),
          reverse: false,
          itemCount: objectList.length,
          itemBuilder: (_, index) => //=>CardObjectList(event: objectList[index], onType: 'push',)
          Card(
              child: ListTile(
                  title: Text(objectList[index].name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                  subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Задача №${objectList[index].number} от ${DateFormat('dd.MM.yyyy').format(objectList[index].dateCreate)}', style: TextStyle(fontStyle: FontStyle.italic)),
                      Text(objectList[index].content),
                    ],
                  ),
                  //trailing: Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 0).format(widget.event.summa), style: TextStyle(fontSize: 16, color: Colors.green)),
                  onTap: () async {
                    await Navigator.push(context, MaterialPageRoute( builder: (context) => scrTaskViewScreen(task: objectList[index]..id)));
                    initState();
                  },
                  onLongPress: () {})
          )

      ),
    );
  }

  _twoScreen() {
    return RefreshIndicator(
        onRefresh: () async {
      initState();
      return Future<void>.delayed(const Duration(seconds: 1));
      },
      child: ListView.builder(
        padding: EdgeInsets.all(10),
        physics: AlwaysScrollableScrollPhysics(),
        reverse: false,
        itemCount: objectListAssignet.length,
        itemBuilder: (_, index) => //=>CardObjectList(event: objectList[index], onType: 'push',)
        Card(
            child: ListTile(
                title: Text(objectListAssignet[index].name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Задача №${objectListAssignet[index].number} от ${DateFormat('dd.MM.yyyy').format(objectListAssignet[index].dateCreate)}', style: TextStyle(fontStyle: FontStyle.italic)),
                    Text(objectListAssignet[index].content),
                    Divider(),
                    Text('Исп: ${objectListAssignet[index].executor}', style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.w600),),
                  ],
                ),//trailing: Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 0).format(widget.event.summa), style: TextStyle(fontSize: 16, color: Colors.green)),
                onTap: () async {
                  Navigator.push(context, MaterialPageRoute( builder: (context) => scrTaskViewScreen(task: objectListAssignet[index]..id)));
                },
                onLongPress: () {})
        )

      ),
    );
  }

  _threeScreen() {
    return RefreshIndicator(
        onRefresh: () async {
      initState();
      return Future<void>.delayed(const Duration(seconds: 1));
      },
      child: ListView.builder(
        padding: EdgeInsets.all(10),
        physics: AlwaysScrollableScrollPhysics(),
        reverse: false,
        itemCount: objectListDone.length,
        itemBuilder: (_, index) => //=>CardObjectList(event: objectList[index], onType: 'push',)
        Card(
            child: ListTile(
                title: Text(objectListDone[index].name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                //subtitle: Text(objectListDone[index].content),
                subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Задача №${objectListDone[index].number} от ${DateFormat('dd.MM.yyyy').format(objectListDone[index].dateCreate)}', style: TextStyle(fontStyle: FontStyle.italic)),
                    Text(objectListDone[index].result),
                    Text(objectListDone[index].resultText),
                  ],
                ),
                //trailing: Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 0).format(widget.event.summa), style: TextStyle(fontSize: 16, color: Colors.green)),
                onTap: () async {
                  Navigator.push(context, MaterialPageRoute( builder: (context) => scrTaskViewScreen(task: objectListDone[index]..id)));
                },
                onLongPress: () {})
        )

      ),
    );
  }

  PopupMenuButton<MenuTaskList> _menuAppBar() {
    return PopupMenuButton<MenuTaskList>(
        icon: const Icon(Icons.menu, ),
        offset: const Offset(0, 40),
        onSelected: (MenuTaskList item) async {
          if (item == MenuTaskList.itemObjectList) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => scrObjectsScreen()));
          }
          if (item == MenuTaskList.itemRefresh) {
            initState();
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuTaskList>>[
          const PopupMenuItem<MenuTaskList>(
            value: MenuTaskList.itemObjectList,
            child: Text('Открыть список оборудования'),
          ),
          const PopupMenuItem<MenuTaskList>(
            value: MenuTaskList.itemRefresh,
            child: Text('Обновить списки'),
          ),
        ].toList());
  }

}

const _tabs = [
  Tab(icon: Icon(Icons.near_me_outlined),
    text: "Новые"),
  Tab(icon: Icon(Icons.access_alarm),
      text: "В работе"),
  Tab(icon: Icon(Icons.task_alt),
      text: "Закрытые")
];

enum MenuTaskList { itemObjectList, itemRefresh }