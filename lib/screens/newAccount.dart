import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:repairmodule/models/Lists.dart';

import 'home.dart';


class scrAccountNewScreen extends StatefulWidget {
  final String phone;
  scrAccountNewScreen(this.phone);

  @override
  State<scrAccountNewScreen> createState() => _scrAccountNewScreenState();
}

class _scrAccountNewScreenState extends State<scrAccountNewScreen> {
  //var objectList = [];
  bool success = false;
  String logoPath = 'https://beletag.com/upload/CMax/35c/tw0i3dku7v12n29mwofzdnj5b90k9kn7/logo_aspro.png';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String header = '';

  bool _agreement = false;

  var resp;
  var items = [];

  int _companyType = 1;
  TextEditingController _companyName = TextEditingController(text: '');


  TextEditingController _nameController = TextEditingController(text: '');
  TextEditingController _last_nameController = TextEditingController(text: '');
  TextEditingController _second_nameController = TextEditingController(text: '');
  TextEditingController _emailController = TextEditingController(text: '');


  Future httpCreateCard() async {
    var _url=Uri(path: '/b/sanpro_api/hs/MyCallServices/createaccount/', host: 's1.rntx.ru', scheme: 'https');
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': Globals.anAuthorization
    };

    var _body = <String, String> {
      "name": _nameController.text,
      "last_name": _last_nameController.text,
      "second_name": _second_nameController.text,
      "phone": widget.phone,
      "email": _emailController.text,
      "companyName": _companyName.text,
      "companyType": _companyType.toString(),
    };
    try {
      print(jsonEncode(_body));
      var response = await http.post(_url, headers: _headers, body: jsonEncode(_body));
      print('Код ответа: ${response.statusCode} Тело ответа: ${json.decode(response.body)}');
      if (response.statusCode == 200 || response.statusCode == 400) {
        var notesJson = json.decode(response.body);
        success = notesJson['success'] ?? false;
        String _message = notesJson['message'] ?? '';
        print(_message);
        print(notesJson.toString());
        if (success==true) {

        }
        else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_message), backgroundColor: Colors.red,));
        }
      }
    } catch (error) {
      print("Ошибка при создании компании: $error");
    }
  }

  @override
  void initState() {

    // TODO: implement initState
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Регистрация'),
        centerTitle: true,
      ),
      body: ListView(
          children: [Column(
            //mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image(image: NetworkImage(logoPath)),
              Container(
                padding: EdgeInsets.only(left: 8, top: 8,right: 8, bottom: 26),
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(decoration: InputDecoration(label: Text(widget.phone), border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)), prefixIcon: Icon(Icons.phone)), enabled: false,),
                        Divider(),
                        SizedBox(height: 12,),
                        TextFormField(controller: _companyName, decoration: InputDecoration(label: Text('Название вашей компании'), border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)), prefixIcon: Icon(Icons.account_balance)),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Заполните название компании. Пример: Бригада 77';
                              }
                              return null;
                            }
                            ),
                        SizedBox(height: 12,),
                        // DropdownButton<String>(padding: EdgeInsets.all(8),
                        //   isExpanded: true,
                        //   items: <String>['Физ лицо', 'ИП', 'ООО'].map((String value) {
                        //     return DropdownMenuItem<String>(
                        //       value: value,
                        //       child: Text(value),
                        //     );
                        //   }).toList(),
                        //   onChanged: (_) {},
                        // ),
                        // Row(
                        //   children: [
                        //     Flexible(
                        //       child: RadioListTile(title: Text('Физ лицо'), value: 1, groupValue: _companyType, onChanged: (value){
                        //         setState(() {
                        //           _companyType = value!;
                        //         });
                        //       }
                        //       ),
                        //     ),
                        //     Flexible(
                        //       child: RadioListTile(title: Text('ИП'), value: 2, groupValue: _companyType, onChanged: (value) {
                        //         setState(() {
                        //           _companyType = value!;
                        //         });
                        //       }
                        //       ),
                        //     ),
                        //     Flexible(
                        //       child: RadioListTile(title: Text('ООО'), value: 3, groupValue: _companyType, onChanged: (value) {
                        //         setState(() {
                        //           _companyType = value!;
                        //         });
                        //       }
                        //       ),
                        //     )
                        //   ],
                        // ),
                        Divider(),
                        TextFormField(controller: _last_nameController,decoration: InputDecoration(label: Text('Фамилия'), border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)), prefixIcon: Icon(Icons.person)),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Фамилия не должна быть пустой';
                              }
                              return null;
                            }),
                        SizedBox(height: 8,),
                        TextFormField(controller: _nameController, decoration: InputDecoration(label: Text('Имя'), border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)), prefixIcon: Icon(Icons.person)),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Имя не должна быть пустым';
                              }
                              return null;
                            }),
                        SizedBox(height: 8,),
                        TextFormField(controller: _second_nameController,  decoration: InputDecoration(label: Text('Отчество'), border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)), prefixIcon: Icon(Icons.person)),),
                        SizedBox(height: 16,),
                        TextFormField(controller: _emailController, decoration: InputDecoration(label: Text('E-mail'), border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)), prefixIcon: Icon(Icons.person)),),
                        SizedBox(height: 8,),

                        new CheckboxListTile(
                            value: _agreement,
                            title: new Text('Даю согласие на обработку и хранение моих персональных данных.'),
                            onChanged: (value) {setState(() => _agreement = value!);}
                        ),
                        ElevatedButton(
                          child: Text('Создать компанию', style: TextStyle(fontSize: 20)),
                            style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.yellow)),
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                  if (_agreement == false)
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Нужно разрешение на обработку персональных данных'), backgroundColor: Colors.red,));
                                  else {
                                    //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Данные сохраняются'), backgroundColor: Colors.green,));
                                    print('Данные введены правильно');
                                    httpCreateCard().then((value) {
                                      if (success==true) {

                                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => scrHomeScreen()), (route) => false,);
                                      }
                                    });
                                  }

                              }
                            }
                        ),
                      ],
                    )
                ),
              )
            ],
          ),
          ]
      ),
    );
  }
}

