import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:repairmodule/components/Cards.dart';
import 'package:repairmodule/models/Lists.dart';
import 'package:http/http.dart' as http;
import 'package:repairmodule/screens/profileMan_edit.dart';
import 'package:repairmodule/screens/sprList_create.dart';


class scrAccessUserKassaSelectedScreen extends StatefulWidget {
  final String sprName;
  final String onType;
  final List<sprListSelected> selectedList;

  scrAccessUserKassaSelectedScreen({super.key, required this.sprName, required this.onType, required this.selectedList});

  @override
  State<scrAccessUserKassaSelectedScreen> createState() => _scrAccessUserKassaSelectedScreenState();
}

class _scrAccessUserKassaSelectedScreenState extends State<scrAccessUserKassaSelectedScreen> {
  List<sprListSelected> selectedListResult=[];
  bool _isActive = false;


  @override
  void initState() {
    selectedListResult = widget.selectedList;

    // TODO: implement initState
    super.initState();
  }
  Widget build(BuildContext context) {
    print(widget.sprName);
    return Scaffold(
        appBar: AppBar(
          title: Text('Выбор касс и счетов'),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.menu))
          ],
        ),
        body: Column(
          children: [
            if (widget.sprName=='Кассы')
            Card(
              child: ListTile(
                title: Text('Подотчетные средства', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),),
                subtitle: Text('У каждого сотрудника есть подотчетные средства', textAlign: TextAlign.start,),
                trailing: Switch.adaptive(
                  value: true,
                  onChanged: null,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(10),
                physics: BouncingScrollPhysics(),
                reverse: false,
                itemCount: selectedListResult.length,
                itemBuilder: (_, index) =>
                    Card(
                      child: ListTile(
                        title: Text(selectedListResult[index].name.toString(), style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),),
                        subtitle: Text('${selectedListResult[index].comment}', textAlign: TextAlign.start,),
                          trailing: Switch.adaptive(
                            value: selectedListResult[index].selected,
                            onChanged: (bool value) {
                              setState(() {
                                selectedListResult[index].selected = value;
                              });
                            },
                          ),
                      ),
                    ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async{
            //widget.selectedList = selectedListResult;
            Navigator.pop(context, selectedListResult);
          },
          child: Icon(Icons.save),)
      //backgroundColor: Colors.grey[900]),
    );
  }
  
}

