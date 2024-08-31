
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:repairmodule/models/Lists.dart';




class scrReceiptSostScreen extends StatefulWidget {
  List<ReceiptSost> objectList;

  scrReceiptSostScreen(this.objectList);

  @override
  State<scrReceiptSostScreen> createState() => _scrReceiptSostScreenState();
}

class _scrReceiptSostScreenState extends State<scrReceiptSostScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Состав чека'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
        body: ListView.builder(
          padding: EdgeInsets.all(10),
          physics: BouncingScrollPhysics(),
          reverse: false,
          itemCount: widget.objectList.length,
          itemBuilder: (_, index) =>
              Card(
                child: ListTile(
                  title: Text(widget.objectList[index].name.toString(), style: TextStyle(fontWeight: FontWeight.w700),),
                  subtitle: Text('Количество: ${widget.objectList[index].kol}; Цена: ${NumberFormat.simpleCurrency(locale: 'ru-RU', decimalDigits: 2).format(widget.objectList[index].price)}', textAlign: TextAlign.start,),
                  trailing: Text(NumberFormat.simpleCurrency(locale: 'ru-RU', decimalDigits: 2).format(widget.objectList[index].summa), style: TextStyle(fontSize: 18, color: Colors.red),),
                ),
              ),
        ),
    );
  }
}

