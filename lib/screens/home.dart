import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:repairmodule/models/Lists.dart';
import 'package:repairmodule/screens/cashList.dart';
import 'package:repairmodule/screens/inputSaredFiles.dart';
import 'package:repairmodule/screens/settings.dart';
import 'package:repairmodule/screens/task/taskList.dart';

import 'cashHome.dart';
import 'objects.dart';


class scrHomeScreen extends StatefulWidget {
  scrHomeScreen();

  @override
  State<scrHomeScreen> createState() => _scrHomeScreenState();
}

class _scrHomeScreenState extends State<scrHomeScreen> {
  late StreamSubscription _intentSub;
  final _sharedFiles = <SharedMediaFile>[];

  num CashSummaAll = 0;
  num CashSummaPO = 0;
  int ObjectKol = 0;
  int ApprovalKol=0;
  
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
    
    httpGetInfo().then((value) {
      setState(() {
      });
    });
    // TODO: implement initState
    //super.initState();

  }
  void dispose() {
    _intentSub.cancel();
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
        body:
        SafeArea(
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
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {},
        //   child: Text('+'),
        // )
        //backgroundColor: Colors.grey[900]),
        );
  }
}
