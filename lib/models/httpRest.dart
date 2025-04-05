import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:repairmodule/models/ListCalculationParam.dart';
import 'package:repairmodule/models/ListWorks.dart';
import 'package:repairmodule/models/Lists.dart';
import 'package:repairmodule/screens/task/taskLists.dart';

Future httpGetInfo(CashSummaAll, CashSummaPO, ObjectKol, ApprovalKol) async {
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

Future httpGetListObject(objectList) async {
  final _queryParameters = {'userId': Globals.anPhone};

  var _url=Uri(path: '${Globals.anPath}obList/0/', host: Globals.anServer, scheme: 'https', queryParameters: _queryParameters);
  print(_url.path);
  print(Globals.anAuthorization);
  var _headers = <String, String> {
    'Accept': 'application/json',
    'Authorization': Globals.anAuthorization
  };
  try {
    var response = await http.get(_url, headers: _headers);
    print(response.statusCode.toString());
    if (response.statusCode == 200) {
      objectList.clear();
      var notesJson = json.decode(response.body);
      for (var noteJson in notesJson) {
        objectList.add(ListObject.fromJson(noteJson));
      }
    }
    else
      throw 'Код ответа: ${response.statusCode.toString()}. Ответ: ${response.body}';
  } catch (error) {
    print("Ошибка при формировании списка: $error");
  }
}

Future httpGetListSmeta(objectList) async {
  final _queryParameters = {'userId': Globals.anPhone};

  var _url=Uri(path: '${Globals.anPath}smetaList/', host: Globals.anServer, scheme: 'https', queryParameters: _queryParameters);
  print(_url.path);
  print(Globals.anAuthorization);
  var _headers = <String, String> {
    'Accept': 'application/json',
    'Authorization': Globals.anAuthorization
  };
  try {
    var response = await http.get(_url, headers: _headers);
    print(response.statusCode.toString());
    if (response.statusCode == 200) {
      objectList.clear();
      var notesJson = json.decode(response.body);
      for (var noteJson in notesJson) {
        objectList.add(ListSmeta.fromJson(noteJson));
      }
    }
    else
      throw 'Код ответа: ${response.statusCode.toString()}. Ответ: ${response.body}';
  } catch (error) {
    print("Ошибка при формировании списка смет: $error");
  }
}

Future httpGetSmetaInfo(id, roomList, paramList, workList) async {
  final _queryParameters = {'userId': Globals.anPhone};

  var _url=Uri(path: '${Globals.anPath}smetainfo/$id/', host: Globals.anServer, scheme: 'https', queryParameters: _queryParameters);
  print(_url.path);
  print(Globals.anAuthorization);
  var _headers = <String, String> {
    'Accept': 'application/json',
    'Authorization': Globals.anAuthorization
  };
  try {
    var response = await http.get(_url, headers: _headers);
    print(response.statusCode.toString());
    if (response.statusCode == 200) {
      roomList.clear();
      paramList.clear();

      var notesJson = json.decode(response.body);
      for (var noteJson1 in notesJson['rooms']) {
        roomList.add(ListSmetaRoom.fromJson(noteJson1));
      }
      for (var noteJson2 in notesJson['params']) {
        paramList.add(ListSmetaParam.fromJson(noteJson2));
      }
      for (var noteJson3 in notesJson['works']) {
        workList.add(Works.fromJson(noteJson3));
      }
    }
    else
      throw 'Код ответа: ${response.statusCode.toString()}. Ответ: ${response.body}';
  } catch (error) {
    print("Ошибка импорта данных сметы: $error");
  }
}

Future httpGetSmetaRoomWorks(smetaid, roomid, workList) async {
  final _queryParameters = {'userId': Globals.anPhone};

  var _url=Uri(path: '${Globals.anPath}smetaroomworks/$smetaid/$roomid/', host: Globals.anServer, scheme: 'https', queryParameters: _queryParameters);
  print(_url.path);
  print(Globals.anAuthorization);
  var _headers = <String, String> {
    'Accept': 'application/json',
    'Authorization': Globals.anAuthorization
  };
  try {
    var response = await http.get(_url, headers: _headers);
    print(response.statusCode.toString());
    if (response.statusCode == 200) {
      workList.clear();

      var notesJson = json.decode(response.body);
      for (var noteJson3 in notesJson['works']) {
        workList.add(Works.fromJson(noteJson3));
      }
    }
    else
      throw 'Код ответа: ${response.statusCode.toString()}. Ответ: ${response.body}';
  } catch (error) {
    print("Ошибка импорта данных сметы: $error");
  }
}

Future httpGetSmetaParamCalculation(smetaid, roomid, floor, perimeter, openings, slopeDoor, slopeWindow, slopeWall, slopeConst, hConst) async {
  final _queryParameters = {'userId': Globals.anPhone};

  var _url=Uri(path: '${Globals.anPath}smetacalculationparam/$smetaid/$roomid/', host: Globals.anServer, scheme: 'https', queryParameters: _queryParameters);
  print(_url.path);
  var _headers = <String, String> {
    'Accept': 'application/json',
    'Authorization': Globals.anAuthorization
  };
  try {
    var response = await http.get(_url, headers: _headers);
    print(response.statusCode.toString());
    if (response.statusCode == 200) {
      // roomList.clear();
      // paramList.clear();

      var notesJson = json.decode(response.body);
      slopeConst = notesJson['slopeConst'];
      hConst = notesJson['hConst'];

      for (var noteJson1 in notesJson['floor']) {
        floor.add(ListFloor.fromJson(noteJson1));
      }
      for (var noteJson2 in notesJson['perimeter']) {
        perimeter.add(ListPerimeter.fromJson(noteJson2));
      }
      for (var noteJson3 in notesJson['openings']) {
        openings.add(ListOpenings.fromJson(noteJson3));
      }
      for (var noteJson4 in notesJson['slopeDoor']) {
        slopeDoor.add(ListSlopeDoor.fromJson(noteJson4));
      }
      for (var noteJson5 in notesJson['slopeWindow']) {
        slopeWindow.add(ListSlopeWindow.fromJson(noteJson5));
      }
      for (var noteJson6 in notesJson['slopeWall']) {
        slopeWall.add(ListSlopeWall.fromJson(noteJson6));
      }

    }
    else
      throw 'Код ответа: ${response.statusCode.toString()}. Ответ: ${response.body}';
  } catch (error) {
    print("Ошибка импорта работ сметы по помещению: $error");
  }
}

Future httpGetListPlat(objectList, analyticId, objectId, platType, kassaSotrId, kassaContractorId, idCash, approve, dateRange) async {
  var queryParameters = <String, dynamic> {
    'analyticId': analyticId,
    'objectId': objectId,
    'platType': platType,
    'kassaSortId': kassaSotrId,
    'kassaContractorId': kassaContractorId,
    'userId': Globals.anPhone,
    'approve': approve.toString(),
  };
  var _url = Uri(path: '${Globals.anPath}platlist/${DateFormat('yyyyMMdd').format(dateRange.start)}/${DateFormat('yyyyMMdd').format(dateRange.end)}/${idCash}',
      queryParameters: queryParameters,
      host: Globals.anServer,
      scheme: 'https');
  var _headers = <String, String>{
    'Accept': 'application/json',
    'Authorization': Globals.anAuthorization
  };
  try {
    print(_url.path);
    var response = await http.get(_url, headers: _headers);
    if (response.statusCode == 200) {
      objectList.clear();
      var notesJson = json.decode(response.body);
      for (var noteJson in notesJson) {
        objectList.add(ListPlat.fromJson(noteJson));
      }
    }
    else
      throw response.body;
  } catch (error) {
    print("Ошибка при формировании списка платежей: $error");
  }
}

Future httpGetListTask(objectList, objectListAssignet, objectListDone, objectListClose) async {
  objectList.clear();
  objectListAssignet.clear();
  objectListDone.clear();
  objectListClose.clear();

  print('My id = ${Globals.anUserId}');
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
        if (noteJson['statusId']=='52139514-180a-4b78-a882-187cc6832af2' || noteJson['statusId']=='3815be37-b90a-4e77-9327-8f7c55730f4f' || noteJson['statusId']=='9cbedc69-9f5a-4247-adba-92db3c3cea10') { //новые или назначенные или в процессе выполнения
          if (noteJson['executorId']==Globals.anUserId) //мои
            objectList.add(taskList.fromJson(noteJson));
          else
            objectListAssignet.add(taskList.fromJson(noteJson));
        }
        else
        if (noteJson['statusId']=='753614d8-7366-421e-84fc-0a62cacc6124') //выполненные или закрытые ( || noteJson['statusId']=='6e209268-b210-4920-ac97-1221175b8b08')
          objectListDone.add(taskList.fromJson(noteJson));
        else
          objectListClose.add(taskList.fromJson(noteJson));
      }
    }
    else {
      throw 'Сервер вернул код ${response.statusCode}. Ответ: ${response.body}';
    }

  } catch (error) {
    print("Ошибка при формировании списка: $error");
    //final snackBar = SnackBar(content: Text('$error'), );
    //ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

Future httpGetListBalance(cashBankList, cashKassList, AccountableFounds, AccountableContractor) async {
  num AccountableFoundsBalance = 0;
  num AccountableContractorBalance=0;

  cashBankList.clear();
  cashKassList.clear();
  AccountableFounds.clear();
  AccountableContractor.clear();

  final _queryParameters = {'userId': Globals.anPhone};
  var _url=Uri(path: '${Globals.anPath}cashList/', host: Globals.anServer, scheme: 'https', queryParameters: _queryParameters);
  var _headers = <String, String> {
    'Accept': 'application/json',
    'Authorization': Globals.anAuthorization
  };
  try {
    var response = await http.get(_url, headers: _headers);
    print(response.statusCode.toString());
    if (response.statusCode == 200) {
      var notesJson = json.decode(response.body);
      for (var noteJson in notesJson) {
        if (ListCash.fromJson(noteJson).tip==1) {
          cashKassList.add(ListCash.fromJson(noteJson));
        };
        if (ListCash.fromJson(noteJson).tip!=1) {
          cashBankList.add(ListCash.fromJson(noteJson));
        };
      }
    }
  } catch (error) {
    print("Ошибка при формировании списка счетов: $error");
  }

  //запрос к подотчетным средствам сотрудников
  _url=Uri(path: '${Globals.anPath}accountableFunds/', host: Globals.anServer, scheme: 'https', queryParameters: _queryParameters);
  try {
    AccountableFoundsBalance=0;
    var response2 = await http.get(_url, headers: _headers);
    if (response2.statusCode == 200) {
      var notesJson = json.decode(response2.body);
      for (var noteJson in notesJson) {
        AccountableFounds.add(accountableFounds.fromJson(noteJson));
        AccountableFoundsBalance = AccountableFoundsBalance + accountableFounds.fromJson(noteJson).summa;
      }
    }
    else
      throw 'Код ответа запроса подотчетных денег: ${response2.statusCode}';
  } catch (error) {
    print("Ошибка при формировании списка подотчета: $error");
  }


  //запрос к балансам контрагентов
  _url=Uri(path: '${Globals.anPath}accountableContractors/', host: Globals.anServer, scheme: 'https', queryParameters: _queryParameters);
  try {
    AccountableContractorBalance=0;
    var response3 = await http.get(_url, headers: _headers);
    if (response3.statusCode == 200) {
      var notesJson = json.decode(response3.body);
      for (var noteJson in notesJson) {
        AccountableContractor.add(accountableFounds.fromJson(noteJson));
        AccountableContractorBalance = AccountableContractorBalance + accountableFounds.fromJson(noteJson).summa;
      }
    }
    else
      throw 'Код ответа запроса баланса контрагентов: ${response3.statusCode}';
  } catch (error) {
    print("Ошибка при формировании списка контрагентов: $error");
  }

}

Future<bool> httpAvatarSend(String userId, List<ListAttach> listAttachedNetwork) async {
  bool _result=false;
  final _queryParameters = {
    'userId': Globals.anPhone
  };
  var _url=Uri(path: '${Globals.anPath}avatar/${userId}/', host: Globals.anServer, scheme: 'https', queryParameters: _queryParameters);
  var _headers = <String, String> {
    'Accept': 'application/json',
    'Authorization': Globals.anAuthorization
  };
  print(_url.path);
  try {
    var _body = <String, dynamic> {
      "userId": userId,
      "attachList": listAttachedNetwork!.map((v) => v.toJson()).toList()
    };
    print(jsonEncode(_body));
    var response = await http.post(_url, headers: _headers, body: jsonEncode(_body));
    print('Код ответа: ${response.statusCode} Тело ответа: ${response.body}');
    var data = json.decode(response.body);
    _result = data['Успешно'] ?? '';
    String _message = data['Сообщение'] ?? '';

    if (response.statusCode != 200 || _result==false) {
      print('Не удалось отправить avatar');
      _result = false;
      // final snackBar = SnackBar(content: Text('Не удалось отправить сообщение! $_message'), );
      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  } catch (error) {
    _result = false;
    print("Ошибка при отправке avatara: $error");
    // final snackBar = SnackBar(content: Text('$error'), );
    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  return _result ?? false;
}
