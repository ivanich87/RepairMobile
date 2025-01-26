import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:repairmodule/models/Lists.dart';
import 'package:repairmodule/screens/ReceiptView.dart';
import 'package:repairmodule/screens/cashList.dart';
import 'package:repairmodule/screens/inputSaredFiles.dart';
import 'package:repairmodule/screens/plat_view.dart';
import 'package:repairmodule/screens/settings.dart';
import 'package:repairmodule/screens/task/taskList.dart';
import 'package:repairmodule/screens/task/taskLists.dart';
import 'package:repairmodule/screens/task/task_edit.dart';
import 'package:repairmodule/screens/task/task_view.dart';

import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../components/Cards.dart';
import '../models/httpRest.dart';
import 'cashHome.dart';
import 'objects.dart';


class scrHomeScreen extends StatefulWidget {
  scrHomeScreen();

  @override
  State<scrHomeScreen> createState() => _scrHomeScreenState();
}

class _scrHomeScreenState extends State<scrHomeScreen> with SingleTickerProviderStateMixin {

  late TabController _taskTabController;

  late StreamSubscription _intentSub;
  final _sharedFiles = <SharedMediaFile>[];

  var objectList = [];
  var platList = [];
  var taskList = [];
  var taskListAssignet = [];
  var taskListDone = [];
  var taskListClose = [];

  int _selectedIndex = 0;

  num CashSummaAll = 0;
  num CashSummaPO = 0;
  int ObjectKol = 0;
  int ApprovalKol=0;

  DateTime dtStart = DateTime(2024);
  DateTime dtEnd = DateTime.now();
  DateTimeRange dateRange = DateTimeRange(start: DateTime(2024), end: DateTime.now());

  Future httpGetInfo() async {
    final _queryParameters = {'userId': Globals.anPhone};
    var _url=Uri(path: '${Globals.anPath}info/', host: Globals.anServer, scheme: 'https', queryParameters: _queryParameters);
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': Globals.anAuthorization
    };
    print(_url.path);
    print('${_queryParameters}');
    try {
      var response = await http.get(_url, headers: _headers);
      if (response.statusCode == 200) {
        var notesJson = json.decode(response.body);
        print(notesJson['summa']);
        print(notesJson['objectKol']);
        CashSummaAll = notesJson['summa'];
        CashSummaPO = notesJson['summaPO'];
        ObjectKol = notesJson['objectKol'];
        ApprovalKol=notesJson['approvalKol'];
        Globals.setOwnerId(notesJson['ownerId']);
        Globals.setOwnerName(notesJson['ownerName']);
        Globals.setUserId(notesJson['userId']);
        Globals.setUserName(notesJson['userName']);
        Globals.setUserRole(notesJson['userRole']);
        Globals.setUserRoleId(notesJson['userRoleId']);
        Globals.setCompanyId(notesJson['companyId']);
        Globals.setCompanyName(notesJson['companyName']);
        Globals.setCompanyComment(notesJson['companyComment']);

        Globals.setCreateObject(notesJson['createObject']);
        Globals.setCreatePlat(notesJson['createPlat']);
        Globals.setApprovalPlat(notesJson['approvalPlat']);
        Globals.setFinTech(notesJson['finTech']);
      }
      else
        throw 'Ответ от процедуры /info: ${response.statusCode}; ${response.body}';
    } catch (error) {
      print("Ошибка при формировании списка: $error");
    }
  }


  @override
  void initState() {
    print('Запукаем проверку входящих файлов');

    // Listen to media sharing coming from outside the app while the app is in the memory.
    _intentSub = ReceiveSharingIntent.instance.getMediaStream().listen((value) {
      if (value !=null) {
        if (_sharedFiles.length==0) {
          print('Входящие данные1 в приложение в памяти: ' + value[0].toString());
          _sharedFiles.addAll(value);
          if (_sharedFiles.length > 0) {
            print('Пришел файл из вне 1');
            Navigator.push(context, MaterialPageRoute(builder: (context) => scrInputSharedFilesScreen(_sharedFiles)));
          }
        } else {
          print('Пришел файл, но еще не заколнчилась обработка предыдущего. Удаляем');
          value.clear();
        }
      };

      print(_sharedFiles.map((f) => f.toMap()));

    }, onError: (err) {
      print("getIntentDataStream error: $err");
    });

    // Get the media sharing coming from outside the app while the app is closed.
    ReceiveSharingIntent.instance.getInitialMedia().then((value) {
      if (value !=null) {
        print('Входящие данные2: ' + value.toString());

        _sharedFiles.clear();
        _sharedFiles.addAll(value);
        if (_sharedFiles.length>0) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => scrInputSharedFilesScreen(_sharedFiles)));

          print('Пришел файл из вне 2');
          print(_sharedFiles.map((f) => f.toMap()));

          // Tell the library that we are done processing the intent.
          ReceiveSharingIntent.instance.reset();
        }
      }

    });

    objectList.clear();

    httpGetListObject(objectList).then((value) {
      setState(() {
      });
    });

    platList.clear();

    httpGetListPlat(platList,  '', '', '', '', '', '0', false, dateRange).then((value) {
      setState(() {
      });
    });

    httpGetListTask(taskList, taskListAssignet, taskListDone, taskListClose).then((value) {
      setState(() {
      });
    });

    httpGetInfo().then((value) {
      setState(() {
      });
    });

    _taskTabController = TabController(length: 4, vsync: this, initialIndex: 0);

    // TODO: implement initState
    //super.initState();

  }

  void dispose() {
    _intentSub.cancel();
    _taskTabController.dispose();

    super.dispose();
  }


  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('РемонтКвартир'),
          centerTitle: true,
          //backgroundColor: Colors.grey[900],
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [
            IconButton(onPressed: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (context) => scrSettingsScreen()));
                initState();
              }, icon: Icon(Icons.settings))],
        ),
        body: _pageWidget(_selectedIndex),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                String _res ='';
                // List<taskObservertList> taskObservers=[];
                // _res = await Navigator.push(context, MaterialPageRoute(builder: (context) => scrTaskEditScreen(task: taskList(id: '', number: 0, name: '', content: '', directorId: Globals.anUserId, director: Globals.anUserName, executorId: '', executor: '', dateCreate: DateTime.now(), dateTo: DateTime.now(), statusId: '52139514-180a-4b78-a882-187cc6832af2', status: 'Ждет исполнителя', reportToEnd: true, resultText: '', objectId: '', objectName: '', generalTaskId: '', generalTaskName: '', generalTaskNumber: 0, generalTaskDateCreate: DateTime.now(), generalTaskExecutor: '', timeTracking: false, changeDeadline: false, resultControl: false, taskCloseAuto: false, deadlineFromSubtask: false, schemeTaxi: true), TaskObservertList: taskObservers))) ?? '';
                // if (_res!='') {
                //   final snackBar = SnackBar(content: Text(_res), backgroundColor: Colors.green,);
                //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
                // }
                setState(() {

                });
              },
              child: Icon(Icons.add),),
        bottomNavigationBar: SalomonBottomBar(
          currentIndex: _selectedIndex,
          selectedItemColor: const Color(0xff6200ee),
          unselectedItemColor: const Color(0xff757575),
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: _navBarItems),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {},
        //   child: Text('+'),
        // )
        //backgroundColor: Colors.grey[900]),
        );
  }

  _pageWidget(ind) {
    switch (ind) {
      case 0:
        return _pageObjects();
      case 1:
        return _pagePlat();
      case 2:
        return _pageTask();
      case 3:
        return _pageProfile();
    }
  }

  _pageObjects() {
    return (objectList.length==0) ? Center(child: Text('У вас еще нет объектов. Добавьте ваш первый объект по кнопке справа внизу')) :
      ListView.builder(
        padding: EdgeInsets.all(10),
        physics: BouncingScrollPhysics(),
        reverse: false,
        itemCount: objectList.length,
        itemBuilder: (_, index) => CardObjectList(event: objectList[index], onType: 'push',),
      );
  }

  _pagePlat() {
    return Column(
      children: [
        ElevatedButton(onPressed: pickDateRange,
            child: Text(DateFormat('dd.MM.yyyy').format(dtStart) + ' - ' + DateFormat('dd.MM.yyyy').format(dtEnd))),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              initState();
              return Future<void>.delayed(const Duration(seconds: 2));
            },
            child: (platList.length==0) ? Center(child: Text('Нет платежей')) : ListView.builder(
              padding: EdgeInsets.all(10),
              physics: AlwaysScrollableScrollPhysics(),
              reverse: false,
              itemCount: platList.length,
              itemBuilder: (_, index) =>
                  _cardItem(platList[index]), //PlatObjectList
            ),
          ),
        ),
      ],
    );
  }

  _pageTask() {
    return Column(
      children: [
        TabBar(controller: _taskTabController, tabs: _tabs, isScrollable: true,),
        Expanded(
          child: TabBarView(
            controller: _taskTabController,
              children: <Widget> [
                      _taskOneScreen(),
                      _taslTwoScreen(),
                      _taslThreeScreen(),
                      _taslFourScreen()
                   ],
          ),
        ),
      ],
    );
  }

  _pageProfile() {
    return SafeArea(
      child: Stack(
          children: [
            ListView(shrinkWrap: true,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('${Globals.anCompanyName}', textAlign: TextAlign.right, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
                      Text('${Globals.anUserName}', textAlign: TextAlign.right, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
                      Text('${Globals.anUserRole}', textAlign: TextAlign.right, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
                      //Text('Версия 1.0.1', textAlign: TextAlign.right),
                      Container(height: 160,
                        child: Column(mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset('assets/icons/repair.png', height: 100,),
                            SizedBox(height: 8,),
                            Text('РемонтКвартир', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24, fontStyle: FontStyle.italic),)
                          ],
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: Text(
                            'Объекты',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                          ),
                          subtitle: Text('Информация по действующим объектам'),
                          leading: Icon(Icons.account_balance_sharp),
                          trailing: Text(
                            ObjectKol.toString(),
                            style: TextStyle(fontSize: 18, color: Colors.green),
                          ),
                          onTap: () async {
                            await Navigator.push(context, MaterialPageRoute(builder: (context) => scrObjectsScreen()));
                            initState();
                          },
                        ),
                      ),
                      if (Globals.anUserRoleId==3)
                        Card(
                          child: ListTile(
                            title: Text(
                              'Финансы',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                            ),
                            subtitle: Text('Баланс по организации'),
                            leading: Icon(Icons.currency_ruble_rounded),
                            trailing: Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(CashSummaAll), style: TextStyle(fontSize: 18, color: Colors.green),
                            ),
                            onTap: () async {
                              //Navigator.push(context, MaterialPageRoute(builder: (context) => scrInputSharedFilesScreen(_sharedFiles)));
                              await Navigator.push(context, MaterialPageRoute(builder: (context) => scrCashHomeScreen()));
                              initState();
                            },
                          ),
                        ),
                      Card(
                        child: ListTile(
                          title: Text(
                            'Подотчет',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                          ),
                          subtitle: Text('Мой баланс П/О средств'),
                          leading: Icon(Icons.currency_ruble_rounded),
                          trailing: Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(CashSummaPO), style: TextStyle(fontSize: 18, color: (CashSummaPO>0) ? Colors.red : Colors.green),
                          ),
                          onTap: () async {
                            await Navigator.push(context, MaterialPageRoute(builder: (context) => scrCashListScreen(idCash: '0', cashName: 'Все', analytic: '', analyticName: '', objectId: '', objectName: '', platType: '', dateRange: DateTimeRange(start: DateTime(2023), end: DateTime.now()), kassaSotrId: Globals.anUserId, kassaSortName: Globals.anUserName,  )));
                            initState();
                          },
                        ),
                      ),
                      if (Globals.anApprovalPlat==true)
                        Card(
                          child: ListTile(
                            title: Text(
                              'Согласовать',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                            ),
                            subtitle: Text('Платежи, требующие вашего согласования'),
                            leading: Icon(Icons.warning_amber),
                            trailing: Text('${ApprovalKol}', style: TextStyle(fontSize: 18, color: (CashSummaPO>0) ? Colors.red : Colors.green),
                            ),
                            onTap: () async {
                              await Navigator.push(context, MaterialPageRoute(builder: (context) => scrCashListScreen(idCash: '0', cashName: 'Все', analytic: '', analyticName: '', objectId: '', objectName: '', platType: '', dateRange: DateTimeRange(start: DateTime(2023), end: DateTime.now()), kassaSotrId: '', kassaSortName: '', approve: true, )));
                              initState();
                            },
                          ),
                        ),
                      Card(
                        child: ListTile(
                          title: Text(
                            'Задачи',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                          ),
                          subtitle: Text('Управление задачами'),
                          leading: Icon(Icons.event_note_outlined),
                          //trailing: Text('12/3', style: TextStyle(fontSize: 18, color: Colors.green),
                          //),
                          onTap: () async {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => scrTaskListScreen()));

                          },
                        ),
                      ),
                      SizedBox(height: 30,)
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Версия: 1.0.2', textAlign: TextAlign.right, style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, fontStyle: FontStyle.italic)),
                ],
              ),
            ),
          ]
      ),
    );
  }


  _cardItem(ListPlat event){
    return Card(
      child: ListTile(
          title: Text('${event.name} № ${event.number} от ${DateFormat('dd.MM.yyyy').format(event.date)}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, decoration: textDelete(event.del)),),
          subtitle: Text(event.comment),
          trailing: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(event.summa), style: TextStyle(fontSize: 16, color: textColors(event.summa), decoration: textDelete(event.del))),
              if (event.accept==false)
                Icon(Icons.warning_amber, color: Colors.amber)
            ],
          ),
          onTap: () async {
            await Navigator.push(context, MaterialPageRoute(builder: (context) {
              if (event.type=='Покупка стройматериалов')
                return scrReceiptViewScreen(id: event.id, event: event);
              else
                return scrPlatsViewScreen(plat: event);
            }));
            setState(() {
              if (event.del==true) {
                print('Удаляем этот платеж');
                //initState();
              }
              print('Пересчет формы');
            });

          },
          onLongPress: () async {
            await Navigator.push(context, MaterialPageRoute(builder: (context) {
              if (event.type=='Покупка стройматериалов')
                return scrReceiptViewScreen(id: event.id, event: event);
              else
                return scrPlatsViewScreen(plat: event);
            }));

            setState(() {
              if (event.del==true) {
                print('Удаляем этот платеж');
                //initState();
              }
              print('Пересчет формы');
            });
          }),
    );

  }

  Future pickDateRange() async {
    DateTimeRange? newDateRange = await showDateRangePicker(locale: Locale("ru", "RU"),
        context: context, firstDate: DateTime(2020), lastDate: DateTime(2050), initialDateRange: dateRange);
    if (newDateRange ==null) return;

    setState(() {
      dateRange = newDateRange;
    });
    initState();
  }

  _taskOneScreen() {
    return RefreshIndicator(
      onRefresh: () async {
        initState();
        return Future<void>.delayed(const Duration(seconds: 2));
      },
      child: ListView.builder(
          padding: EdgeInsets.all(10),
          physics: AlwaysScrollableScrollPhysics(),
          reverse: false,
          itemCount: taskList.length,
          itemBuilder: (_, index) => //=>CardObjectList(event: objectList[index], onType: 'push',)
          Card(
              child: ListTile(
                  title: Text(taskList[index].name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                  subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Задача №${objectList[index].number} от ${DateFormat('dd.MM.yyyy').format(taskList[index].dateCreate)}', style: TextStyle(fontStyle: FontStyle.italic)),
                      Text(taskList[index].content),
                    ],
                  ),
                  //trailing: Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 0).format(widget.event.summa), style: TextStyle(fontSize: 16, color: Colors.green)),
                  onTap: () async {
                    await Navigator.push(context, MaterialPageRoute( builder: (context) => scrTaskViewScreen(task: taskList[index]..id)));
                    initState();
                  },
                  onLongPress: () {})
          )

      ),
    );
  }

  _taslTwoScreen() {
    return RefreshIndicator(
      onRefresh: () async {
        initState();
        return Future<void>.delayed(const Duration(seconds: 1));
      },
      child: ListView.builder(
          padding: EdgeInsets.all(10),
          physics: AlwaysScrollableScrollPhysics(),
          reverse: false,
          itemCount: taskListAssignet.length,
          itemBuilder: (_, index) => //=>CardObjectList(event: objectList[index], onType: 'push',)
          Card(
              child: ListTile(
                  title: Text(taskListAssignet[index].name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                  subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Задача №${taskListAssignet[index].number} от ${DateFormat('dd.MM.yyyy').format(taskListAssignet[index].dateCreate)}', style: TextStyle(fontStyle: FontStyle.italic)),
                      Text(taskListAssignet[index].content),
                      Divider(),
                      Text('Исп: ${taskListAssignet[index].executor}', style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.w600),),
                    ],
                  ),//trailing: Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 0).format(widget.event.summa), style: TextStyle(fontSize: 16, color: Colors.green)),
                  onTap: () async {
                    Navigator.push(context, MaterialPageRoute( builder: (context) => scrTaskViewScreen(task: taskListAssignet[index]..id)));
                  },
                  onLongPress: () {})
          )

      ),
    );
  }

  _taslThreeScreen() {
    return RefreshIndicator(
      onRefresh: () async {
        initState();
        return Future<void>.delayed(const Duration(seconds: 1));
      },
      child: ListView.builder(
          padding: EdgeInsets.all(10),
          physics: AlwaysScrollableScrollPhysics(),
          reverse: false,
          itemCount: taskListDone.length,
          itemBuilder: (_, index) => //=>CardObjectList(event: objectList[index], onType: 'push',)
          Card(
              child: ListTile(
                  title: Text(taskListDone[index].name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                  //subtitle: Text(objectListDone[index].content),
                  subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Задача №${taskListDone[index].number} от ${DateFormat('dd.MM.yyyy').format(taskListDone[index].dateCreate)}', style: TextStyle(fontStyle: FontStyle.italic)),
                      Text(taskListDone[index].resultText),
                    ],
                  ),
                  //trailing: Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 0).format(widget.event.summa), style: TextStyle(fontSize: 16, color: Colors.green)),
                  onTap: () async {
                    Navigator.push(context, MaterialPageRoute( builder: (context) => scrTaskViewScreen(task: taskListDone[index]..id)));
                  },
                  onLongPress: () {})
          )

      ),
    );
  }

  _taslFourScreen() {
    return RefreshIndicator(
      onRefresh: () async {
        initState();
        return Future<void>.delayed(const Duration(seconds: 1));
      },
      child: ListView.builder(
          padding: EdgeInsets.all(10),
          physics: AlwaysScrollableScrollPhysics(),
          reverse: false,
          itemCount: taskListClose.length,
          itemBuilder: (_, index) => //=>CardObjectList(event: objectList[index], onType: 'push',)
          Card(
              child: ListTile(
                  title: Text(taskListClose[index].name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                  //subtitle: Text(objectListDone[index].content),
                  subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Задача №${taskListClose[index].number} от ${DateFormat('dd.MM.yyyy').format(taskListClose[index].dateCreate)}', style: TextStyle(fontStyle: FontStyle.italic)),
                      Text(taskListClose[index].resultText),
                    ],
                  ),
                  //trailing: Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 0).format(widget.event.summa), style: TextStyle(fontSize: 16, color: Colors.green)),
                  onTap: () async {
                    Navigator.push(context, MaterialPageRoute( builder: (context) => scrTaskViewScreen(task: taskListClose[index]..id)));
                  },
                  onLongPress: () {})
          )

      ),
    );
  }


  static const _tabs = [
    Tab(icon: Icon(Icons.subdirectory_arrow_right_outlined),
        text: "Делаю"),
    Tab(icon: Icon(Icons.outbond_outlined),
        text: "Наблюдаю"),
    Tab(icon: Icon(Icons.question_mark),
        text: "Выполненные"),
    Tab(icon: Icon(Icons.task_alt),
        text: "Закрытые")
  ];

}

final _navBarItems = [
  SalomonBottomBarItem(
    icon: const Icon(Icons.home),
    title: const Text("Объекты"),
    selectedColor: Colors.teal,
  ),
  SalomonBottomBarItem(
    icon: const Icon(Icons.currency_ruble),
    title: const Text("Финансы"),
    selectedColor: Colors.red,
  ),
  SalomonBottomBarItem(
    icon: const Icon(Icons.event_note_outlined),
    title: const Text("Задачи"),
    selectedColor: Colors.orange,
  ),
  SalomonBottomBarItem(
    icon: const Icon(Icons.person),
    title: const Text("Профиль"),
    selectedColor: Colors.grey,
  ),
];