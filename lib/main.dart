import 'dart:convert';
import 'dart:io' as IO;
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:repairmodule/screens/home.dart';
import 'package:repairmodule/screens/inputSaredFiles.dart';
import 'package:repairmodule/screens/loading.dart';
import 'package:repairmodule/screens/logon.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/Lists.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const userInfoKey = 'userInfoKey';

  bool _load = false;
  String _login = '';
  String _password = '';
  String _phone = '';
  String _server = '';
  String _path = '';
  String _companyId='';
  String _companyName='';
  int _themeIndex = 0;

  bool success = false;
  String message = '';
  bool logIn = false;


  Future httpGetUserData() async {
    _load = false;
    var prefs = await SharedPreferences.getInstance();

    //prefs.remove(userInfoKey);
    final String? Inf = prefs.getString(userInfoKey);
    if (Inf == null) {
      _login = 'Руководитель';
      _password = '123';
      _server = 'ut.acewear.ru';
      _path = '/repair/hs/v2/';
      _themeIndex = 0;
      _companyId='';
      _companyName='Моя компания';

      print('не нашли данных по ключу $userInfoKey');
    } else {
      var str = json.decode(Inf);
      UserInfo dt = UserInfo.fromJson(str);
      _login = dt.login;
      _password = dt.password;
      _phone = dt.phone;
      _server = dt.server;
      _path = dt.path;
      _themeIndex = dt.themeIndex;
      _companyId = dt.companyId;
      _companyName=dt.companyName;
      print('Нашли данные по ключу $userInfoKey Логин: $_login Пароль: $_password');
    }

    print('logon......');
    print('Логин: $_login');
    print('Пароль: $_password');
    print('Тема: $_themeIndex');

    if (_themeIndex==null)
      _themeIndex = 0;

    //зачем обращаться к модели Globals, если есть модель UserInfo
    Globals.setThemeIndex(_themeIndex);
    Globals.setLogin(_login);
    Globals.setPhone(_phone);
    Globals.setServer(_server);
    Globals.setPath(_path);
    Globals.setCompanyId(_companyId);
    Globals.setCompanyName(_companyName);
    Globals.setPasswodr(_password);

    String _platform = '';
    if (IO.Platform.isAndroid)
      _platform = 'android';
    if (IO.Platform.isIOS)
      _platform = 'ios';

    Globals.setPlatform(_platform);

    var _url=Uri(path: '/b/sanpro_api/hs/MyCallServices/logon/', host: 's1.rntx.ru', scheme: 'https');
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': Globals.anAuthorization
    };
    var _body = <String, String> {
      "login": _login,
      "password": _password
    };
    print(jsonEncode(_body));
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      try {
        print('Выполняем запрос на авторизацию по данным из сохраненных настроек');
        print(_url.path);
         var response = await http.post(_url, headers: _headers, body: jsonEncode(_body));
         if (response.statusCode == 200) {
           var notesJson = json.decode(response.body);
           success = notesJson['success'] ?? false;
           message = notesJson['message'] ?? '';
           logIn = notesJson['response'] ?? false;
           _load = true;
           print('Ответ авторизации: $logIn Текст ответа: $message');
         }
         else
           print('Ошибка авторизации. Код ответа: ${response.statusCode.toString()}, тело ответа: ${response.body}');
      } catch (error) {
        print("Ошибка при формировании списка: $error");
        _load = false;
        //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Ошибка подключения к серверу: $error"), backgroundColor: Colors.red,));
      }
    }
    else {
      print('Нет инета');
      _load = false;
      //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Нет подключения к интернету"), backgroundColor: Colors.red,));
    }
  }

  @override
  void initState() {
    print('Запукаем чтение параметров');
    httpGetUserData().then((value) {
      setState(() {

      });
    });
    // TODO: implement initState
    super.initState();
    //initPlatformState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'РемонтКвартир',
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('en', ''),  //code
          Locale('ru', ''), // arabic, no country code
        ],
        theme: ThemeData.light().copyWith(appBarTheme: AppBarTheme(backgroundColor: Colors.black, foregroundColor: Colors.grey), floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: Colors.grey[600])),  //textTheme: Typography().black.apply(fontFamily: 'Montserrat')
        darkTheme: ThemeData.dark().copyWith(appBarTheme: AppBarTheme(backgroundColor: Colors.grey[900]), floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: Colors.grey[600])),

        // theme: ThemeData(),
        // darkTheme: ThemeData.dark(), // standard dark theme
        themeMode: ThemeMode.system, // device controls theme
        // theme: ThemeData(
        //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        //   useMaterial3: true,
        // ),
        home: (logIn == true) ? scrHomeScreen() : (_load == true) ? scrLogonScreen() : scrLoadingScreen(),
        // initialRoute: '/',
        // routes: {
        //   '/': (context, {arguments}) => scrHomeScreen(),
        //   '/objects': (context, {arguments}) => scrObjectsScreen(),
        //   '/objectsView': (context, {arguments}) => scrObjectsViewScreen(id: arguments),
        //   '/testMenu': (context, {arguments}) => ResponsiveNavBarPage(),
        //   '/cashHome': (context, {arguments}) => scrCashHomeScreen(),
        //   '/cashHomeCategories': (context, {arguments}) => scrCashCategoriesScreen(idCash: arguments, cashName: '',),
        // }
    );
  }
}

