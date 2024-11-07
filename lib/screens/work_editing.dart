import 'dart:convert';

import 'package:flutter/material.dart';
//import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';
import 'package:intl/intl.dart';
import 'package:repairmodule/components/Cards.dart';
import 'package:repairmodule/components/SingleSelections.dart';
import 'package:repairmodule/models/ListWorks.dart';
import 'package:repairmodule/models/Lists.dart';
import 'package:http/http.dart' as http;
import 'package:repairmodule/screens/works_edit.dart';

import 'object_create.dart';
import 'object_view.dart';


class scrWorkEditingScreen extends StatefulWidget {
  final Works rabota;
  final bool additionalWork;

  scrWorkEditingScreen(this.rabota, this.additionalWork);

  @override
  State<scrWorkEditingScreen> createState() => _scrWorkEditingScreenState();
}

class _scrWorkEditingScreenState extends State<scrWorkEditingScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Работа'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.menu))
        ],
      ),
        body: ListView(padding: EdgeInsets.only(top: 12, left: 8, right: 8),
          children: [
              Text('${widget.rabota.workName}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),),
              Divider(),
              titleHeader('Количества'),
              ListTile(
                title: Text('По смете'),
                trailing: Text(widget.rabota.kolSmeta.toString(), style: TextStyle(fontSize: 16),),
              ),
              ListTile(
                title: Text('Выполнено ранее'),
                trailing: Text(widget.rabota.kolUsed.toString(), style: TextStyle(fontSize: 16)),
              ),
              ListTile(
                title: Text('Осталось'),
                trailing: Text(widget.rabota.kolRemains.toString(), style: TextStyle(fontSize: 16)),
              ),
              Divider(),
            titleHeader('Цены'),
              ListTile(
                title: Text('Цена клиента'),
                trailing: Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(widget.rabota.price), style: TextStyle(fontSize: 16)),
              ),
              ListTile(
                title: Text('Цена мастеров'),
                trailing: Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(widget.rabota.priceSub), style: TextStyle(fontSize: 16)),
              ),
              Divider(),
              ListTile(
                title: Text('Количество по акту:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),),
                trailing: Text(widget.rabota.kol.toString(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: (widget.rabota.kol!>widget.rabota.kolRemains!) ? Colors.red : Colors.black)),
                subtitle: (widget.rabota.kol!>widget.rabota.kolRemains!) ? Text('В том числе доп. работы: ${widget.rabota.kol!-widget.rabota.kolRemains!}', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.red),) : null,
                onTap: () {
                  _tripEditKol(_tripEditWidgets());
                },
              ),
              Divider(),
            ],
          ),


    );
  }

  void _tripEditKol(Widget type) {
    showModalBottomSheet(isScrollControlled: true, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), context: context, builder: (BuildContext bc) {
      return Container(
        height: 400,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: type,
        ),
      );

    });
  }

  Widget _tripEditWidgets() {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    TextEditingController _kolController = TextEditingController(text: widget.rabota.kol.toString());


    final _style = ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.grey),
        shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
        minimumSize: WidgetStateProperty.all(Size(250, 40))
    );

    return Form(
      key: _formKey,
      //autovalidateMode: true,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            autofocus: true,
            textInputAction: TextInputAction.done,
            controller: _kolController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Введите количество';
              }
              if (!widget.additionalWork && num.tryParse(value)!>widget.rabota.kolRemains!) {
                return 'Максимальное количество может быть ${widget.rabota.kolRemains}';
              }
              return null;
            },
            decoration: InputDecoration(border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10)), labelText: 'Количество'),
          ),
          SizedBox(height: 20),
          Container(alignment: Alignment.center,
              child: ElevatedButton(onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  setState(() {
                    widget.rabota.kol=num.tryParse(_kolController.text) ?? 0;
                    widget.rabota.summa = widget.rabota.kol!*widget.rabota.price!;
                    widget.rabota.summaSub = widget.rabota.kol!*widget.rabota.priceSub!;
                  });
                  Navigator.pop(context);
                }

              },
                child: Text('Сохранить'),
                style: _style,)),
        ],
      ),
    );
  }


}

