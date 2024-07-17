import 'dart:convert';


import 'package:phone_form_field/phone_form_field.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:repairmodule/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/Lists.dart';
import 'newAccount.dart';

class scrLogonScreen extends StatelessWidget {
  const scrLogonScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
        body: Center(
            child: isSmallScreen
                ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                  _Logo(),
                  _FormContent(),
              ],
            )
                : Container(
                  padding: const EdgeInsets.all(32.0),
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Row(
                    children: const [
                    Expanded(child: _Logo()),
                    Expanded(
                      child: Center(child: _FormContent()),
                  ),
                ],
              ),
            )));
  }
}

class _Logo extends StatelessWidget {
  const _Logo({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;
    //const String logoPath = 'https://beletag.com/upload/CMax/35c/tw0i3dku7v12n29mwofzdnj5b90k9kn7/logo_aspro.png';
    const String logoPath = 'https://img.acewear.ru/CleverWearImg/repo/logo.png';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        //FlutterLogo(size: isSmallScreen ? 100 : 200),
        Image(image: NetworkImage(logoPath)),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "Авторизация по номеру телефона",
            textAlign: TextAlign.center,
            style: isSmallScreen
                ? Theme.of(context).textTheme.headline6
                : Theme.of(context)
                .textTheme
                .headline5
                ?.copyWith(color: Colors.black),
          ),
        ),
      ],
    );
  }
}

class _FormContent extends StatefulWidget {
  const _FormContent({Key? key}) : super(key: key);

  @override
  State<_FormContent> createState() => __FormContentState();
}

class __FormContentState extends State<_FormContent> {
  static const userInfoKey = 'userInfoKey';
  String login = '';
  String password = '';
  bool accountNew = false;
  String companyName = '';
  String companyId = '';
  bool companyMulti = false;
  String server = '';
  String path = '';

  bool _isPasswordVisible = false;
  String _smskod = '1111';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future _setUserInfo() async {
    int themeIndex = Globals.anThemeIndex;

    //сохраняем в глобальные переменные логин и пароль
    print('Сохраняе данные переменных: login: $login password: $password сервер: $server путь: $path companyId: $companyId companyName: $companyName');
    Globals.setLogin(login);
    Globals.setPasswodr(password);
    Globals.setServer(server);
    Globals.setPath(path);
    Globals.setCompanyId(companyId);
    Globals.setCompanyName(companyName);

    //сохраняем в локальную БД параметры
    var prefs = await SharedPreferences.getInstance();
    final _userInfo = UserInfo(login: login, password: password, themeIndex: themeIndex, phone: login, server: server, path: path, companyId: companyId, companyName: companyName);
    prefs.setString(userInfoKey, json.encode(_userInfo));

    print('Сохранили в ключ $userInfoKey строку: ${json.encode(_userInfo)}');
  }

  Future httpGetPhoneValidate() async {
    print('Запустилась процедура отправки смс на $login');
    var resp;
    bool success = false;
    bool result = false;
    String message = '';
    var _url=Uri(path: '/b/sanpro_api/hs/MyCallServices/phonevalidate/${login}/', host: 's1.rntx.ru', scheme: 'https');
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': Globals.anAuthorization
    };
    try {
      var response = await http.get(_url, headers: _headers);
      if (response.statusCode == 200) {
        var notesJson = json.decode(response.body);
        success = notesJson['success'] ?? false;
        message = notesJson['message'] ?? '';
        if (success==true) {
          resp = notesJson['response'] ?? '';
          result = resp['result'];
          _smskod = resp['code'];
          accountNew = resp['new'];
          companyMulti = resp['companyMulti'];
          server = resp['server'];
          path = resp['path'];
          companyId = resp['companyId'];
          companyName = resp['companyName'];
          if (result == false)
            print('Ошибка отправки смс: $message');
        }
        else
          print('Ошибка отправки смс $message');
        print('Присвоен проверочный код $_smskod');
        print('Присвоен данные переменным: accountNew: $accountNew companyId: $companyId companyName: $companyName');
      }
    } catch (error) {
      print("Ошибка при получении смс кода: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PhoneFormField(
              key: Key('phone-field'),
              defaultCountry: IsoCode.RU,
              validator: PhoneValidator.validMobile(),
              enabled: !_isPasswordVisible,
              autofocus: !_isPasswordVisible,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Телефон',
                hintText: 'Введите ваш номер телефона',
                //prefixIcon: Icon(Icons.phone),
                icon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.done,
              onSubmitted: (_tel_value) {
                print('Введено значение телефона : ${_tel_value}');
                _isPasswordVisible = true;
                login = '7${_tel_value.replaceAll(' ', '').replaceAll('-', '').replaceAll('+7', '8')}';
                print(login);
                httpGetPhoneValidate().then((value) {
                  setState(() {
                  });
                });
              },
            ),
            _gap(),
            if (_isPasswordVisible == true)
                TextFormField(
                  autofocus: _isPasswordVisible,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    if (login != '79991111111') {
                      if (value != _smskod) {
                        return 'Не совпадает код из смс';
                      }
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                  labelText: 'Код',
                  hintText: 'Введите код из смс',
                  prefixIcon: const Icon(Icons.sms_failed_outlined),
                  border: const OutlineInputBorder(),
                  ),
                    onFieldSubmitted: (_value_kod) {
                      print('Введено код из смс : ${_value_kod}');
                      if (_formKey.currentState?.validate() ?? false) {
                        password = _value_kod;
                        _setUserInfo();
                        print('Аутентификация пройдена успешно');
                        if (accountNew==true)
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => scrAccountNewScreen(login)), (route) => false,);
                        else
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => scrHomeScreen()), (route) => false,);
                      }
                    },
                  ),
            _gap(),
            InkWell(autofocus: false, child:
                RichText(text: TextSpan(
                    children: [
                      TextSpan(text: 'Зайти в ', style: TextStyle(color: Colors.black, fontSize: 16)),
                      TextSpan(text: 'Демо-базу', style: TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.bold),)
                    ]
                )), onTap: () {
              Globals.setLogin('71111111111');
              Globals.setPhone('71111111111');
              Globals.setPasswodr('1111');
              Globals.setServer('ut.acewear.ru');
              Globals.setPath('/repair/hs/v1/');
              Globals.setCompanyId('50eb5b33-387f-11ef-a769-00155d02d23d');
              Globals.setCompanyName('РосРемонт');
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => scrHomeScreen()), (route) => false,);
            },

            )
          ],
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
}
