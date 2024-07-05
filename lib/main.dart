import 'dart:convert';
import 'dart:io' as IO;
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:repairmodule/screens/home.dart';
import 'package:repairmodule/screens/objects.dart';
import 'package:repairmodule/screens/object_view.dart';
import 'package:repairmodule/screens/cashHome.dart';
import 'package:repairmodule/screens/cashCategories.dart';
import 'package:repairmodule/screens/testMenu.dart';
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
      _path = '/repair/hs/v1/';
      _themeIndex = 0;

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
    Globals.setPasswodr(_password);

    String _platform = '';
    if (IO.Platform.isAndroid)
      _platform = 'android';
    if (IO.Platform.isIOS)
      _platform = 'ios';

    Globals.setPlatform(_platform);

    var _url=Uri(path: '$_path/logon/', host: 's4.rntx.ru', scheme: 'https');
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': Globals.anAuthorization
    };
    var _body = <String, String> {
      "login": _login,
      "password": _password
    };

    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      _load = true;
      try {
        print('Выполняем запрос на авторизацию по данным из сохраненных настроек');
        // var response = await http.post(_url, headers: _headers, body: jsonEncode(_body));
        // if (response.statusCode == 200) {
        //   var notesJson = json.decode(response.body);
        //   success = notesJson['success'] ?? false;
        //   message = notesJson['message'] ?? '';
        //   logIn = notesJson['response'] ?? false;
        //   _load = true;
        //   print('Ответ авторизации: $logIn Текст ответа: $message');
        // }
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
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context, {arguments}) => scrHomeScreen(),
          '/objects': (context, {arguments}) => scrObjectsScreen(),
          '/objectsView': (context, {arguments}) => scrObjectsViewScreen(id: arguments),
          '/testMenu': (context, {arguments}) => ResponsiveNavBarPage(),
          '/cashHome': (context, {arguments}) => scrCashHomeScreen(),
          '/cashHomeCategories': (context, {arguments}) => scrCashCategoriesScreen(idCash: arguments, cashName: '',),
        }
    );
  }
}
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//
//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.
//
//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
//
//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter++;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // TRY THIS: Try changing the color here to a specific color (to
//         // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
//         // change color while the other colors stay the same.
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//           //
//           // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
//           // action in the IDE, or press "p" in the console), to see the
//           // wireframe for each widget.
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
