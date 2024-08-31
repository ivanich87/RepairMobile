import 'dart:convert';
import 'dart:io';
import '../models/Lists.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

Future httpUploadImage(String title, File file) async {
  String _path="";
  int _code = 0;

  final _queryParameters = {'userId': Globals.anPhone};

  var _url=Uri(path: '/GLService/hs/repo/attachupload/$title/', host: 'ut.acewear.ru', scheme: 'https', queryParameters: _queryParameters);
  print(_url.path);
  var _headers = <String, String> {
    'Accept': 'application/json',
    'Authorization': Globals.anAuthorization
  };
  try {
    var response = await http.post(_url, headers: _headers, body: (await file.readAsBytesSync()));
    print(response.statusCode.toString());
    if (response.statusCode == 200) {
      var notesJson = json.decode(response.body);
      _path = notesJson['path'];
    }
    else
      throw 'Код ответа: ${response.statusCode.toString()}. Ответ: ${response.body}';
  } catch (error) {
    print("Ошибка: $error");
    _code=1;
    _path=error.toString();
  }
  return returnResult(resultCode: _code, resultText: _path);
}

Future httpSetListAttached(objectId, title, path) async {
  int resultCode = 0;
  String resultText = 'Успешно';
  final _queryParameters = {'userId': Globals.anPhone};

  var _url=Uri(path: '${Globals.anPath}attached/$objectId', host: Globals.anServer, scheme: 'https', queryParameters: _queryParameters);
  print(_url.path);
  var _headers = <String, String> {
    'Accept': 'application/json',
    'Authorization': Globals.anAuthorization
  };
  try {
    var _body = <String, String> {
      "name": title,
      "path": path,
    };
    var response = await http.post(_url, headers: _headers, body: jsonEncode(_body));
    print(response.statusCode.toString());
    if (response.statusCode == 200) {
      print(response.body.toString());
      // var notesJson = json.decode(response.body);
      // for (var noteJson in notesJson) {
      //   objectList.add(ListAttach.fromJson(noteJson));
      // }
    }
    else
      throw 'Код ответа: ${response.statusCode.toString()}. Ответ: ${response.body}';
  } catch (error) {
    print("Ошибка при формировании списка: $error");
    resultText = error.toString();
    // final snackBar = SnackBar(content: Text('$error'),);
    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  return returnResult(resultCode: resultCode, resultText: resultText);
}
