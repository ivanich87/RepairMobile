import 'dart:io';

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class scrLoadingScreen extends StatefulWidget {
  // final String id;
  scrLoadingScreen(); //this.id

  @override
  State<scrLoadingScreen> createState() => _scrLoadingScreenState();
}

class _scrLoadingScreenState extends State<scrLoadingScreen> {
  final connectivityResult = (Connectivity().checkConnectivity());
  bool isOnline = true;

  Future<bool> hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    hasNetwork().then((value) {
      print(value.toString());
      isOnline = value;
      setState(() {

      });
    });
    super.initState();
  }
@override
  @override
  Widget build(BuildContext context) {
    print(connectivityResult.toString());
    print('Связь через мобильные данные:');
    print(connectivityResult == ConnectivityResult.mobile);

    print('Связь через wifi:');
    print(connectivityResult == ConnectivityResult.wifi);

    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(transform: GradientRotation(BorderSide.strokeAlignCenter),
              begin: Alignment.topLeft,
              end: Alignment.bottomCenter,
              colors: <Color>[Color(0xFF1B5E20), Colors.black, Colors.black, Colors.black, Colors.black, Colors.black, Colors.black])),
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           //if (connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi)
          if (isOnline!=true)
             Text('Ошибка 404. Проверьте интернет на устройстве и перезапустите приложение', style: TextStyle(fontSize: 24, color: Colors.white, decorationThickness: 0), )
          else
             Image.asset('assets/images/logo_white.png', width: 250, ),
          //Text('Загрузка данных'),
        ],
      ),
    );
  }
}
