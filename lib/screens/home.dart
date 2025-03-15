import 'dart:async';
import 'dart:convert';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:repairmodule/models/Lists.dart';
import 'package:repairmodule/screens/ReceiptEdit.dart';
import 'package:repairmodule/screens/ReceiptView.dart';
import 'package:repairmodule/screens/cashList.dart';
import 'package:repairmodule/screens/cashListFind.dart';
import 'package:repairmodule/screens/inputSaredFiles.dart';
import 'package:repairmodule/screens/object_create.dart';
import 'package:repairmodule/screens/object_view.dart';
import 'package:repairmodule/screens/plat_edit.dart';
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

class _scrHomeScreenState extends State<scrHomeScreen> with TickerProviderStateMixin {

  late TabController _taskTabController;
  late TabController _platTabController;

  TextEditingController _textFindController = TextEditingController(text: '');

  late StreamSubscription _intentSub;
  final _sharedFiles = <SharedMediaFile>[];

  var objectList = [];
  List <ListPlat> platList = [];
  List <ListPlat>  platListFiltered = [];
  List <ListPlat>  platListApproved = [];
  var taskLists = [];
  var taskListAssignet = [];
  var taskListDone = [];
  var taskListClose = [];
  var cashKassList = [];
  var cashBankList = [];
  List<accountableFounds> AccountableFounds = [];
  List<accountableFounds> AccountableContractor = [];

  num allSumma = 0;
  num AccountableFoundsBalance=0;
  num AccountableContractorBalance=0;

  int _selectedIndex = 0;

  //можно будет закоментить код ниже
  num CashSummaAll = 0;
  num CashSummaPO = 0;
  int ObjectKol = 0;
  int ApprovalKol=0;
  //--------------------------------
  num balance = 0;
  num balancePO = 0;
  num balanceCo = 0;
  num balanceRepair=0;
  num balanceDesing=0;
  num moneyIn=0;
  num moneyOut=0;
  num moneyBalance=0;
  int kolObject = 0;
  int kolSmeta = 0;
  int kolAkt = 0;
  num aktSumma = 0;
  num aktSeb = 0;
  num aktBalance = 0;
  num aktBalanceAve = 0;
  num margin = 0;
  num otherOut = 0;
  num otherIn = 0;
  num otherOwnOut = 0;
  num otherOwnIn = 0;
  num profit = 0;
  num mAvePrice = 0;
  num mAvePriceM = 0;
  num mAvePriceR = 0;
  num mAveSeb = 0;
  num mAveSebM = 0;
  num mAveSebR = 0;


  bool _isSearch = false;
  bool _isLoad = false;
  bool isDarkMode = false;

  DateTimeRange dateRange = DateTimeRange(start: DateTime.now().subtract(Duration(days: 30)), end: DateTime.now());
  DateTimeRange dateRangeApproved = DateTimeRange(start: DateTime.now().subtract(Duration(days: 30)), end: DateTime.now());

  filtered _filter = filtered(idCash: '0', cashName: 'Выберите кассу или банк', analytic: '', analyticName: 'Выберите аналитику', objectId: '', objectName: 'Выберите объект', platType: '', kassaSotrId: '', kassaSortName: 'Выберите подотчетное лицо', kassaContractorId: '', kassaContractorName: 'Выберите контрагента');

  Future _httpGetInfo() async {
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
        Globals.setCompanyAvatar(notesJson['companyAvatar']);

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

  Future httpGetGeneralReport() async {
    final _queryParameters = {'userId': Globals.anPhone};
    String dt = '';
    dt = DateFormat('yyyyMMdd').format(DateTime.now());
    var _url=Uri(path: '${Globals.anPath}reportgeneral/$dt/', host: Globals.anServer, scheme: 'https', queryParameters: _queryParameters);
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

        balance = notesJson['ТекущийБаланс'];
        balancePO = notesJson['ТекущийБалансВПодотчете'];
        balanceCo = notesJson['БалансПоКонтрагентам'];
        balanceRepair =notesJson['БалансПоДоговорамНаРемонт'];
        balanceDesing = notesJson['БалансПоДоговорамНаДизайн'];
        moneyIn = notesJson['Выручка'];
        moneyOut=notesJson['Расходы'];
        moneyBalance=notesJson['Прибыль'];
        kolObject = notesJson['КоличествоОбъектов'];
        kolSmeta = notesJson['КоличествоСмет'];
        kolAkt = notesJson['ПодписанныеАктыКоличество'];
        aktSumma = notesJson['ПодписанныеАктыСумма'];
        aktSeb = notesJson['ПодписанныеАктыСебестоимость'];
        aktBalance = notesJson['ПодписанныеАктыПрибыль'];
        aktBalanceAve = notesJson['ПодписанныеАктыПрибыльСредняя'];
        margin = notesJson['Маржа'];
        otherOut = notesJson['ПрочиеРасходы'];
        otherIn = notesJson['ПрочиеПриходы'];
        otherOwnOut = notesJson['ВыводПрибылиСобственнику'];
        otherOwnIn = notesJson['ВнесениеДенегСобственником'];
        profit = notesJson['ПрибыльРасчетная'];
        mAvePrice = notesJson['М2_Цена'];
        mAvePriceM = notesJson['М2_ЦенаМатериалы'];
        mAvePriceR = notesJson['М2_ЦенаРаботы'];
        mAveSeb = notesJson['М2_Себестоимость'];
        mAveSebM = notesJson['М2_СебестоимостьМатериалы'];
        mAveSebR = notesJson['М2_СебестоимостьРаботы'];
      }
      else
        throw 'Ответ от процедуры /reportgeneral: ${response.statusCode}; ${response.body}';
    } catch (error) {
      print("Ошибка при формировании reportgeneral: $error");
    }

  }


  @override
  void initState() {
    var brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
    isDarkMode = brightness == Brightness.dark;

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

    _taskTabController = TabController(length: 4, vsync: this, initialIndex: 0);
     httpGetInfo(CashSummaAll, CashSummaPO, ObjectKol, ApprovalKol).then((value) {
       setState(() {
         _platTabController = TabController(length: (Globals.anApprovalPlat==true) ? 3: 2, vsync: this);
       });
     });


    httpGetListObject(objectList).then((value) {
       setState(() {
         _isLoad = true;
       });
    });

    ref();

    // TODO: implement initState
    //super.initState();

  }

  void dispose() {
    _intentSub.cancel();
    _taskTabController.dispose();
    _platTabController.dispose();

    super.dispose();
  }

  ref() async {
    await httpGetInfo(CashSummaAll, CashSummaPO, ObjectKol, ApprovalKol);
    if (Globals.anUserRoleId!=3) {
      _filter.kassaSotrId = Globals.anUserId;
      _filter.kassaSortName = Globals.anUserName;
    }
    await httpGetListPlat(platList, _filter.analytic, _filter.objectId, _filter.platType, _filter.kassaSotrId, _filter.kassaContractorId, _filter.idCash, false, dateRange);
    platListFiltered = platList;
    await httpGetListPlat(platListApproved, _filter.analytic, _filter.objectId, _filter.platType, _filter.kassaSotrId, _filter.kassaContractorId, _filter.idCash, true, dateRangeApproved);
    await httpGetListTask(taskLists, taskListAssignet, taskListDone, taskListClose);

    await httpGetListBalance(cashBankList, cashKassList, AccountableFounds, AccountableContractor);

    await httpGetListObject(objectList);

    AccountableFoundsBalance=0;
    AccountableContractorBalance=0;
    allSumma=0;
    for (var ded in AccountableFounds) {
      AccountableFoundsBalance = AccountableFoundsBalance + ded.summa;
    }

    for (var ded in cashKassList) {
      allSumma = allSumma + ded.summa;
    }
    for (var ded in cashBankList) {
      allSumma = allSumma + ded.summa;
    }
    for (var ded in AccountableContractor) {
      AccountableContractorBalance = AccountableContractorBalance + ded.summa;
    }
    await httpGetGeneralReport();

    setState(() {
    });

  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Image.asset('assets/images/title.png', height: 40,),//Text('СметаНа'),
          centerTitle: true,
          actions: [
            IconButton(onPressed: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (context) => scrSettingsScreen()));
                ref();
              }, icon: Icon(Icons.settings))],
        ),
        body: _pageWidget(_selectedIndex),
            floatingActionButton: _bottomButtons(),
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
        );
  }

  Widget? _bottomButtons() {
    switch (_selectedIndex) {
      case 0:
        return (Globals.anCreateObject==false) ? null : FloatingActionButton(
          onPressed: () async {
            final newObjectId = await Navigator.push(context, MaterialPageRoute(builder: (context) => scrObjectCreateScreen(),)) ?? '';
            if (newObjectId!='') {
              Navigator.push(context, MaterialPageRoute( builder: (context) => scrObjectsViewScreen(id: newObjectId)));
              ref();
            }
          },
          child: Icon(Icons.add),);
      case 1:
        return (Globals.anCreatePlat==false) ? null : FloatingActionButton(
            onPressed: () {},
            child: _AddMenuIcon());
      case 2:
        return FloatingActionButton(
          onPressed: () async {
              List<taskObservertList> taskObservers=[];
              taskList newTask = taskList(id: '', number: 0, name: '', content: '', directorId: Globals.anUserId, director: Globals.anUserName, executorId: '', executor: '', dateCreate: DateTime.now(), dateTo: DateTime.now(), statusId: '52139514-180a-4b78-a882-187cc6832af2', status: 'Ждет исполнителя', reportToEnd: true, resultText: '', objectId: '', objectName: '', generalTaskId: '', generalTaskName: '', generalTaskNumber: 0, generalTaskDateCreate: DateTime.now(), generalTaskExecutor: '', timeTracking: false, changeDeadline: false, resultControl: false, taskCloseAuto: false, deadlineFromSubtask: false, schemeTaxi: true);
              await Navigator.push(context, MaterialPageRoute(builder: (context) => scrTaskEditScreen(task: newTask, TaskObservertList: taskObservers))) ?? '';
              ref();
            },
          child: Icon(Icons.add),);
      case 3:
        null;
    }
  }

  _pageWidget(ind) {
    switch (ind) {
      case 0:
        if (_isLoad==false)
          return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              (isDarkMode) ? Image.asset('assets/images/logo_white.png') : Image.asset('assets/images/logo_black.png'),
              CircularProgressIndicator(),
            ],
          ));
        else
          return _pageObjects();
      case 1:
        return _pagePlat();
      case 2:
        return _pageTask();
      case 3:
        return (Globals.anUserRoleId!=3) ? _pageProfile_backup() :  _pageProfile();
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
        TabBar(controller: _platTabController, tabs: _tabsPlat, isScrollable: true,),
        Expanded(
          child: TabBarView(
            controller: _platTabController,
            children: <Widget> [
              _platOneScreen(),
              _platTwoScreen(),
              if (Globals.anApprovalPlat==true)
                _platThreeScreen(),
            ],
          ),
        ),
      ],
    );
  }

  _pageTask() {
    return Column(
      children: [
        TabBar(controller: _taskTabController, tabs: _tabsTask, isScrollable: true,),
        Expanded(
          child: TabBarView(
            controller: _taskTabController,
              children: <Widget> [
                      _taskOneScreen(),
                      _taskTwoScreen(),
                      _taskThreeScreen(),
                      _taskFourScreen()
                   ],
          ),
        ),
      ],
    );
  }

  _pageProfile_backup() {
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
                            Image.asset('assets/images/title.png', height: 30,),
                            //Text('СметаНа', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24, fontStyle: FontStyle.italic),)
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
                            ref();
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
                              ref();
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
                            ref();
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
                              ref();
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
                  Text('Версия: 1.0.30', textAlign: TextAlign.right, style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, fontStyle: FontStyle.italic)),
                ],
              ),
            ),
          ]
      ),
    );
  }

  _pageProfile() {
    String _logoPath = Globals.anCompanyAvatar;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              height: 110,
              child: Row(
                children: [
                  Expanded(
                    child: Container(padding: EdgeInsets.all(8),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Строительная компания:', style: TextStyle(fontWeight: FontWeight.bold),),
                          SizedBox(height: 4,),
                          DecoratedBox(
                            decoration: BoxDecoration(color: Colors.green[400],
                                borderRadius: BorderRadius.circular(8)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Text('${Globals.anCompanyName}', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                  Container(width: 80,
                    child:
                      (_logoPath=='') ? Image.asset('assets/icons/repair.png', height: 100,) : Image.network(_logoPath),
                  ),
                  Expanded(
                    child: Container(padding: EdgeInsets.all(8),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('${Globals.anUserName}', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold), ),
                          SizedBox(height: 4,),
                          DecoratedBox(
                            decoration: BoxDecoration(color: Colors.green[400],
                                borderRadius: BorderRadius.circular(8)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Text('${Globals.anUserRole}', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Divider(height: 3),
            ),
            Expanded(
              child: ListView(shrinkWrap: true,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(title: Text('ДЕНЬГИ БИЗНЕСА', style: TextStyle(fontSize: 18),), leading: Icon(Icons.currency_ruble), ),
                        Row(
                          children: [
                            Expanded(
                              child: Card(margin: EdgeInsets.zero,
                                child: ListTile(title: Text('Баланс', style: TextStyle(fontSize: 15)), trailing: Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(balance), style: TextStyle(fontSize: 14, color: Colors.green),),contentPadding: EdgeInsets.symmetric(horizontal: (balance>=1000000) ? 8 : 10, vertical: 0),),
                              ),
                            ),
                            SizedBox(width: 10,),
                            Expanded(
                              child: Card(margin: EdgeInsets.zero,
                                child: ListTile(title: Text('Подотчет', style: TextStyle(fontSize: 15)), trailing: Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(balancePO), style: TextStyle(fontSize: 14, color: Colors.red),),contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),),
                              ),
                            )
                          ],
                       ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                          child: Divider(height: 3),
                        ),
                        ListTile(title: Text('ПЛАТЕЖИ ЗА МЕСЯЦ', style: TextStyle(fontSize: 18),), leading: Icon(Icons.wallet_outlined), ),
                        Card(child:
                          ListTile(
                            title: Text('Выручка', style: TextStyle(fontSize: 18)),
                            subtitle: Text('Сумма всех поступлений', style: TextStyle(fontSize: 12)),
                            trailing: Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(moneyIn), style: TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold),),
                          )
                        ),
                        Card(child:
                          ListTile(
                            title: Text('Расходы', style: TextStyle(fontSize: 18)),
                            subtitle: Text('Сумма всех расходов', style: TextStyle(fontSize: 12)),
                            trailing: Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(moneyOut), style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold),),
                          )
                        ),
                        Card(child:
                          ListTile(
                            title: Text('Прибыль', style: TextStyle(fontSize: 18)),
                            subtitle: Text('Выручка - расходы', style: TextStyle(fontSize: 12)),
                            trailing: Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(moneyBalance), style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold),),
                          )
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                          child: Divider(height: 3),
                        ),
                        ListTile(title: Text('ВЫПОЛНЕНИЕ', style: TextStyle(fontSize: 18),), leading: Icon(Icons.equalizer), ),
                        Card(child:
                          ListTile(
                            title: Text('Количество объектов в работе', style: TextStyle(fontSize: 18)),
                            trailing: Text('$kolObject шт', style: TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold),),
                          )
                        ),
                        Card(child:
                          ListTile(
                            title: Text('Количество смет в работе', style: TextStyle(fontSize: 18)),
                            trailing: Text('$kolSmeta шт', style: TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold),),
                          )
                        ),Card(child:
                          ListTile(
                            title: Text('Количество подписанных актов', style: TextStyle(fontSize: 18)),
                            trailing: Text('$kolAkt шт', style: TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold),),
                          )
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                          child: Divider(height: 3),
                        ),
                        ListTile(title: Text('ПРИБЫЛЬ ПО ПОДПИСАННЫМ АКТАМ', style: TextStyle(fontSize: 18),), leading: Icon(Icons.trending_up), ),
                        Card(child:
                          ListTile(
                            title: Text('Сумма', style: TextStyle(fontSize: 18)),
                            trailing: Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(aktSumma), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                          )
                        ),
                        Card(child:
                          ListTile(
                            title: Text('Себестоимость', style: TextStyle(fontSize: 18)),
                            trailing: Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(aktSeb), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                          )
                        ),Card(child:
                          ListTile(
                            title: Text('Прибыль', style: TextStyle(fontSize: 18)),
                            trailing: Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(aktBalance), style: TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold),),
                          )
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                          child: Divider(height: 3),
                        ),
                        ListTile(title: Text('УСРЕДНЕННЫЕ ПОКАЗАТЕЛИ', style: TextStyle(fontSize: 18),), leading: Icon(Icons.percent), ),
                        Card(child:
                          ListTile(
                            title: Text('Маржа (средняя)', style: TextStyle(fontSize: 18)),
                            trailing: Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(margin), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                          )
                        ),
                        Card(child:
                          ListTile(
                            title: Text('Прибыль за акт (средняя)', style: TextStyle(fontSize: 18)),
                            trailing: Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(aktBalanceAve), style: TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold),),
                          )
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                          child: Divider(height: 3),
                        ),
                        ListTile(title: Text('ПРОЧИЕ РАСХОДЫ И ПРИБЫЛЬ', style: TextStyle(fontSize: 18),), leading: Icon(Icons.money), ),
                        Card(child:
                          ListTile(
                            title: Text('Прочие расходы', style: TextStyle(fontSize: 18)),
                            trailing: Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(otherOut), style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold),),
                          )
                        ),
                        Card(child:
                          ListTile(
                            title: Text('Прочие приходы', style: TextStyle(fontSize: 18)),
                            trailing: Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(otherIn), style: TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold),),
                          )
                        ),
                        Card(child:
                          ListTile(
                            title: Text('Прибыль компании', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            subtitle: Text('Прибыль по актам + прочие приходы - прочие расходы', style: TextStyle(fontSize: 12)),
                            trailing: Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(profit), style: TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold),),
                          )
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                          child: Divider(height: 3),
                        ),
                        ListTile(title: Text('СРЕДНИЕ ЦЕНЫ ЗА М2', style: TextStyle(fontSize: 18),), leading: Icon(Icons.calculate), ),
                        Card(child:
                          ListTile(
                            title: Text('Цена за м2', style: TextStyle(fontSize: 18)),
                            subtitle: Text('Работы и материалы', style: TextStyle(fontSize: 12)),
                            trailing: Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(mAvePrice), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                          )
                        ),
                        Card(child:
                          ListTile(
                            title: Text('Цена за м2', style: TextStyle(fontSize: 18)),
                            subtitle: Text('Работы', style: TextStyle(fontSize: 12)),
                            trailing: Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(mAvePriceR), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                          )
                        ),
                        Card(child:
                          ListTile(
                            title: Text('Цена за м2', style: TextStyle(fontSize: 18)),
                            subtitle: Text('Материалы', style: TextStyle(fontSize: 12)),
                            trailing: Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(mAvePriceM), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                          )
                        ),
                        Card(child:
                          ListTile(
                            title: Text('Себестоимость за м2', style: TextStyle(fontSize: 18)),
                            subtitle: Text('Работы и материалы', style: TextStyle(fontSize: 12)),
                            trailing: Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(mAveSeb), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                          )
                        ),
                        Card(child:
                          ListTile(
                            title: Text('Себестоимость за м2', style: TextStyle(fontSize: 18)),
                            subtitle: Text('Работы', style: TextStyle(fontSize: 12)),
                            trailing: Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(mAveSebR), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                          )
                        ),
                        Card(child:
                          ListTile(
                            title: Text('Себестоимость за м2', style: TextStyle(fontSize: 18)),
                            subtitle: Text('Материалы', style: TextStyle(fontSize: 12)),
                            trailing: Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(mAveSebM), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                          )
                        ),

                        //Text('${Globals.anCompanyName}', textAlign: TextAlign.right, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
                        //Text('${Globals.anUserName}', textAlign: TextAlign.right, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
                        //Text('${Globals.anUserRole}', textAlign: TextAlign.right, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),


                        SizedBox(height: 30,)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
                //ref();
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
                //ref();
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
    ref();
  }

  Future pickDateRangeApproved() async {
    DateTimeRange? newDateRange = await showDateRangePicker(locale: Locale("ru", "RU"),
        context: context, firstDate: DateTime(2020), lastDate: DateTime(2050), initialDateRange: dateRangeApproved);
    if (newDateRange ==null) return;

    setState(() {
      dateRangeApproved = newDateRange;
    });
    ref();
  }

  _platOneScreen() {
    return Column(
      children: [
        //TabBar(tabs: _tabs, isScrollable: true,),
        Row(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: pickDateRange, child: Text(DateFormat('dd.MM.yyyy').format(dateRange.start) + ' - ' + DateFormat('dd.MM.yyyy').format(dateRange.end))),
            IconButton(
                onPressed: () async {
                  setState(() {
                    _isSearch = !_isSearch;
                  });
                },
                icon: const Icon(Icons.search)),
            IconButton(
                onPressed: () async {
                  await Navigator.push(context, MaterialPageRoute(builder: (context) => scrCashListFindScreen(filter: _filter)));
                  await httpGetListPlat(platList, _filter.analytic, _filter.objectId, _filter.platType, _filter.kassaSotrId, _filter.kassaContractorId, _filter.idCash, false, dateRange);
                  setState(() {
                  });
                },
                icon: const Icon(Icons.tune))

          ],
        ),
        if (_filter.idCash!='0' || _filter.analytic!='' || _filter.kassaSotrId!='' || _filter.objectId!='' || _filter.platType!='')
        Container(
          height: 30,
          child: ListView(shrinkWrap: true, scrollDirection: Axis.horizontal,
            children: [
              if (_filter.idCash!='0') ElevatedButton(onPressed: null, child: Row(children: [Text(_filter.cashName), IconButton(onPressed: () async {_filter.idCash='0'; _filter.cashName='Выберите кассу или банк'; await httpGetListPlat(platList, _filter.analytic, _filter.objectId, _filter.platType, _filter.kassaSotrId, _filter.kassaContractorId, _filter.idCash, false, dateRange); setState(() {});}, icon: Icon(Icons.close,), padding: EdgeInsets.zero,)],), style: ElevatedButton.styleFrom(padding: EdgeInsets.only(left: 10, bottom: 0, top: 0, right: 0))),
              if (_filter.analytic!='') ElevatedButton(onPressed: null, child: Row(children: [Text(_filter.analyticName), IconButton(onPressed: () async {_filter.analytic=''; _filter.analyticName='Выберите аналитику'; await httpGetListPlat(platList, _filter.analytic, _filter.objectId, _filter.platType, _filter.kassaSotrId, _filter.kassaContractorId, _filter.idCash, false, dateRange); setState(() {});}, icon: Icon(Icons.close,), padding: EdgeInsets.zero,)],), style: ElevatedButton.styleFrom(padding: EdgeInsets.only(left: 10, bottom: 0, top: 0, right: 0))),
              if (_filter.kassaSotrId!='' && Globals.anUserRoleId==3) ElevatedButton(onPressed: null, child: Row(children: [Text(_filter.kassaSortName), IconButton(onPressed: () async {_filter.kassaSotrId=''; _filter.kassaSortName='Выберите подотчетное лицо'; await httpGetListPlat(platList, _filter.analytic, _filter.objectId, _filter.platType, _filter.kassaSotrId, _filter.kassaContractorId, _filter.idCash, false, dateRange); setState(() {});}, icon: Icon(Icons.close,), padding: EdgeInsets.zero,)],), style: ElevatedButton.styleFrom(padding: EdgeInsets.only(left: 10, bottom: 0, top: 0, right: 0))),
              if (_filter.objectId!='') ElevatedButton(onPressed: null, child: Row(children: [Text(_filter.objectName), IconButton(onPressed: () async {_filter.objectId=''; _filter.objectName='Выберите объект'; await httpGetListPlat(platList, _filter.analytic, _filter.objectId, _filter.platType, _filter.kassaSotrId, _filter.kassaContractorId, _filter.idCash, false, dateRange); setState(() {});}, icon: Icon(Icons.close,), padding: EdgeInsets.zero,)],), style: ElevatedButton.styleFrom(padding: EdgeInsets.only(left: 10, bottom: 0, top: 0, right: 0))),
              if (_filter.platType!='') ElevatedButton(onPressed: null, child: Row(children: [Text(_filter.platType), IconButton(onPressed: () async {_filter.platType=''; await httpGetListPlat(platList, _filter.analytic, _filter.objectId, _filter.platType, _filter.kassaSotrId, _filter.kassaContractorId, _filter.idCash, false, dateRange); setState(() {});}, icon: Icon(Icons.close,), padding: EdgeInsets.zero,)],), style: ElevatedButton.styleFrom(padding: EdgeInsets.only(left: 10, bottom: 0, top: 0, right: 0))),
            ],

          ),
        ),
        if (_isSearch) ...[
        Container(
          height: 35,
          child: SearchBar(),
        ),
        SizedBox(height: 8,),
        ],
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              ref();
              return Future<void>.delayed(const Duration(seconds: 2));
            },
            child: (platListFiltered.length==0) ? Center(child: Text('Нет платежей')) : ListView.builder(
              padding: EdgeInsets.all(10),
              physics: AlwaysScrollableScrollPhysics(),
              reverse: false,
              itemCount: platListFiltered.length,
              itemBuilder: (_, index) =>
                  _cardItem(platListFiltered[index]), //PlatObjectList
            ),
          ),
        ),
      ],
    );
  }

  _platTwoScreen() {
    return RefreshIndicator(
      onRefresh: () async {
        ref();
        return Future<void>.delayed(const Duration(seconds: 1));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          //mainAxisAlignment: MainAxisAlignment.start,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //Divider(),
            //Expanded(child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Банк', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(1),
                  physics: BouncingScrollPhysics(),
                  reverse: false,
                  children: cashBankList.map((e) => CardCashList(event: e)).toList(),
                ),
                //Divider(),
                Text('Касса', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(1),
                  physics: BouncingScrollPhysics(),
                  reverse: false,
                  //itemCount: notes.length,
                  //itemBuilder: (_, index) => CardCashList(event: notes[index]),
                  children: cashKassList.map((e) => CardCashList(event: e)).toList(),
                ),
                //Divider(),
                SizedBox(height: 2,),
                ListTile(
                  title: Text.rich(TextSpan(children: [
                    TextSpan(text: 'Всего денег: ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    TextSpan(text: NumberFormat.simpleCurrency(locale: 'ru-RU', decimalDigits: 2).format(allSumma), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColors(allSumma))),
                  ],
                  )
                  ),
                ),
                Divider(height: 5,),
                SizedBox(height: 20,),
                Text('Подотчетные средства', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(1),
                  physics: BouncingScrollPhysics(),
                  reverse: false,
                  itemCount: AccountableFounds.length,
                  itemBuilder: (_, index) {
                    return ListTile(
                        leading: Icon(Icons.man),
                        title: Text(AccountableFounds[index].name, style: TextStyle(fontSize: 17),),
                        trailing: Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(AccountableFounds[index].summa), style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic, color: textColors(AccountableFounds[index].summa))),
                        onLongPress: () {});
                  } //CardCashList(event: notes[index])
                ),
                SizedBox(height: 2,),
                ListTile(
                  title: Text((AccountableFoundsBalance>=0) ? 'Задолженность сотрудников: ': 'Компания должна: ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  trailing: Text(NumberFormat.simpleCurrency(locale: 'ru-RU', decimalDigits: 2).format(AccountableFoundsBalance), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColors(AccountableFoundsBalance))),
                ),
                Divider(height: 5,),
                SizedBox(height: 20,),
                Text('Контрагенты', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(1),
                    physics: BouncingScrollPhysics(),
                    reverse: false,
                    itemCount: AccountableContractor.length,
                    itemBuilder: (_, index) {
                      return ListTile(
                          leading: Icon(Icons.man),
                          title: Text(AccountableContractor[index].name, style: TextStyle(fontSize: 17),),
                          trailing: Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(AccountableContractor[index].summa), style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic, color: textColors(AccountableContractor[index].summa))),
                          onLongPress: () {});
                    } //CardCashList(event: notes[index])
                ),
                SizedBox(height: 2,),
                ListTile(
                  title: Text((AccountableContractorBalance>=0) ? 'Задолженность контрагентов: ': 'Компания должна: ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  trailing: Text(NumberFormat.simpleCurrency(locale: 'ru-RU', decimalDigits: 2).format(AccountableContractorBalance), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColors(AccountableContractorBalance))),
                ),
                Divider(height: 5,),
                SizedBox(height: 30,),
              ],
            ),
            //Divider(),
            //),
          ],
        ),
      ),
    );
  }

  _platThreeScreen() {
    return Column(
      children: [
        //TabBar(tabs: _tabs, isScrollable: true,),
        Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: pickDateRangeApproved,
                child: Text(DateFormat('dd.MM.yyyy').format(dateRangeApproved.start) + ' - ' + DateFormat('dd.MM.yyyy').format(dateRangeApproved.end))),
            // IconButton(onPressed: (){}, icon: Icon(Icons.filter_alt_outlined), ),
          ],
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              ref();
              return Future<void>.delayed(const Duration(seconds: 2));
            },
            child: (platListApproved.length==0) ? Center(child: Text('Нет платежей')) : ListView.builder(
              padding: EdgeInsets.all(10),
              physics: AlwaysScrollableScrollPhysics(),
              reverse: false,
              itemCount: platListApproved.length,
              itemBuilder: (_, index) =>
                  _cardItem(platListApproved[index]), //PlatObjectList
            ),
          ),
        ),
      ],
    );
  }



  _taskOneScreen() {
    return RefreshIndicator(
      onRefresh: () async {
        ref();
        return Future<void>.delayed(const Duration(seconds: 2));
      },
      child: ListView.builder(
          padding: EdgeInsets.all(10),
          physics: AlwaysScrollableScrollPhysics(),
          reverse: false,
          itemCount: taskLists.length,
          itemBuilder: (_, index) => //=>CardObjectList(event: objectList[index], onType: 'push',)
          Card(
              child: ListTile(
                  title: Text(taskLists[index].name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                  subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Задача №${taskLists[index].number} от ${DateFormat('dd.MM.yyyy').format(taskLists[index].dateCreate)}', style: TextStyle(fontStyle: FontStyle.italic)),
                      Text(taskLists[index].content),
                    ],
                  ),
                  //trailing: Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 0).format(widget.event.summa), style: TextStyle(fontSize: 16, color: Colors.green)),
                  onTap: () async {
                    await Navigator.push(context, MaterialPageRoute( builder: (context) => scrTaskViewScreen(task: taskLists[index]..id)));
                    ref();
                  },
                  onLongPress: () {})
          )

      ),
    );
  }

  _taskTwoScreen() {
    return RefreshIndicator(
      onRefresh: () async {
        ref();
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

  _taskThreeScreen() {
    return RefreshIndicator(
      onRefresh: () async {
        ref();
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

  _taskFourScreen() {
    return RefreshIndicator(
      onRefresh: () async {
        ref();
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

  _AddMenuIcon() {
    return PopupMenuButton<Menu>(
        icon: const Icon(Icons.add),
        offset: const Offset(0, 40),
        onSelected: (Menu item) async {
          if (item.name=='check') //если покупка стройматериалов
              {
            Receipt recipientdata = Receipt('', '', DateTime.now(), true, false, false, '', '', '', '', true, '', '', DateTime.now(), 0, 0, 0, false, '', '', '', 'Расход', 0, '7fa144f2-14ca-11ed-80dd-00155d753c19', 'Покупка стройматериалов', '', '', defaultkassaSotr(Globals.anUserId, true), defaultkassaSotr(Globals.anUserName, false), (defaultkassaSotr(Globals.anUserId, true)=='') ? 0 : 1, 'Покупка стройматериалов', 0, []);
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => scrReceiptEditScreen(receiptData: recipientdata,)));
          }
          else
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => scrPlatEditScreen(plat2: ListPlat('', 'Новый платеж', DateTime.now(), false, '', true, '', '', '', useDog(item.name), analyticId(item.name, true), analyticId(item.name, false), 0, 0, 0, '', '', '', '', DateTime.now(), useDog(item.name), '', '', defaultkassaSotr(Globals.anUserId, true), defaultkassaSotr(Globals.anUserName, false), (defaultkassaSotr(Globals.anUserId, true)=='') ? 0 : 1, '', '', '', platType(item.name), type(item.name), '', '', '', '', 0, 0, ''),)));
          ref();
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
          const PopupMenuItem<Menu>(
            value: Menu.oplataDog,
            child: Text('Оплата от клиента по договору'),
          ),
          const PopupMenuItem<Menu>(
            value: Menu.oplataMaterials,
            child: Text('Оплата от клиента за материалы'),
          ),
          const PopupMenuItem<Menu>(
            value: Menu.platUp,
            child: Text('Поступление денег'),
          ),
          const PopupMenuItem<Menu>(
            value: Menu.platDown,
            child: Text('Списание денег'),
          ),
          const PopupMenuItem<Menu>(
            value: Menu.check,
            child: Text('Покупка стройматериалов'),
          ),
          const PopupMenuItem<Menu>(
            value: Menu.platMove,
            child: Text('Перемещение денег'),
          ),
          const PopupMenuItem<Menu>(
            value: Menu.platDownSotr,
            child: Text('Выдача в подотчет'),
          ),
          const PopupMenuItem<Menu>(
            value: Menu.platUpSotr,
            child: Text('Возврат из подотчета'),
          ),
        ]);

  }

  SearchBar() {
    return Row(
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.white30,
                  borderRadius: BorderRadius.circular(4.0)),
              child: TextField(controller: _textFindController,
                decoration: InputDecoration(
                    hintText: 'Введите строку для поиска',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: Container(width: 40,
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  _isSearch = false;
                                  _textFindController.text='';
                                  platListFiltered = platList;
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  print('Сбросили фильтр');

                                });
                              },
                              icon: const Icon(Icons.close)),
                        ],
                      ),
                    )),
                onChanged: (value) {
                  _findList(value);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _findList(value) {
    setState(() {
      platListFiltered = platList.where((element) => element.find.toLowerCase().contains(value.toLowerCase())).toList();
    });
  }

  static const _tabsTask = [
    Tab(icon: Icon(Icons.subdirectory_arrow_right_outlined),
        text: "Делаю"),
    Tab(icon: Icon(Icons.outbond_outlined),
        text: "Наблюдаю"),
    Tab(icon: Icon(Icons.question_mark),
        text: "Выполненные"),
    Tab(icon: Icon(Icons.task_alt),
        text: "Закрытые")
  ];

  static const _tabsPlat = [
    Tab(icon: Icon(Icons.donut_large),
        text: "Все платежи"),
    Tab(icon: Icon(Icons.balance),
        text: "Балансы"),
    Tab(icon: Icon(Icons.warning_amber),
        text: "Согласование"),
  ];

}

enum Menu { oplataDog, oplataMaterials, platUp, platDown, check, platDownSotr, platUpSotr , platMove}

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