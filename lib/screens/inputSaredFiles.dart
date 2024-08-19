import 'dart:async';

import 'package:flutter/material.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';


class scrInputSharedFilesScreen extends StatefulWidget {
  List<SharedMediaFile> _sharedFiles;

  scrInputSharedFilesScreen(this._sharedFiles);

  @override
  State<scrInputSharedFilesScreen> createState() => _scrInputSharedFilesScreenState();
}

class _scrInputSharedFilesScreenState extends State<scrInputSharedFilesScreen> {
  //late StreamSubscription _intentSub;
  //final _sharedFiles = <SharedMediaFile>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // // Listen to media sharing coming from outside the app while the app is in the memory.
    // _intentSub = ReceiveSharingIntent.instance.getMediaStream().listen((value) {
    //   setState(() {
    //     _sharedFiles.clear();
    //     _sharedFiles.addAll(value);
    //
    //     print('Пришел файл из вне 1');
    //     print(_sharedFiles.map((f) => f.toMap()));
    //   });
    // }, onError: (err) {
    //   print("getIntentDataStream error: $err");
    // });

    // // Get the media sharing coming from outside the app while the app is closed.
    // ReceiveSharingIntent.instance.getInitialMedia().then((value) {
    //   setState(() {
    //     _sharedFiles.clear();
    //     _sharedFiles.addAll(value);
    //
    //     print('Пришел файл из вне 2');
    //     print(_sharedFiles.map((f) => f.toMap()));
    //
    //     // Tell the library that we are done processing the intent.
    //     ReceiveSharingIntent.instance.reset();
    //   });
    // });

  }

  @override
  void dispose() {
    //_intentSub.cancel();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Объекты в работе'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.menu))
        ],
      ),
        body:               Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                child: ListTile(
                  title: Text(
                    'Это покупка стройматериалов',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                  subtitle: Text('Создать документ покупки'),
                  leading: Icon(Icons.account_balance_sharp),
                  onTap: () async {

                  },
                ),
              ),
              Card(
                child: ListTile(
                  title: Text(
                    'Это списание денег',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                  subtitle: Text('Создать документ'),
                  leading: Icon(Icons.currency_ruble_rounded),
                  onTap: () async {

                  },
                ),
              ),
              Text(widget._sharedFiles
                  .map((f) => f.toMap())
                  .join(",\n****************\n")),
            ],
          ),
        )//backgroundColor: Colors.grey[900]),
    );
  }
}

