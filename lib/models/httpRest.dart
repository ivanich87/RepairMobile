import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:repairmodule/models/Lists.dart';
import 'package:repairmodule/screens/task/taskLists.dart';

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
      print(response.body.toString());
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

  print(jsonEncode(queryParameters));
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
