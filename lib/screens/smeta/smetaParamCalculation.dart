import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:repairmodule/components/Cards.dart';
import 'package:repairmodule/models/ListCalculationParam.dart';
import 'package:repairmodule/models/ListWorks.dart';
import 'package:repairmodule/models/Lists.dart';
import 'package:http/http.dart' as http;
import 'package:repairmodule/models/httpRest.dart';
import 'package:repairmodule/screens/smeta/smetaPrice_view.dart';



class scrSmetaParamCalculationScreen extends StatefulWidget {
  final String smeta_id;
  final String room_id;
  final String room_name;
  final List <ListSmetaParam> param;

  scrSmetaParamCalculationScreen(this.smeta_id, this.room_id, this.room_name, this.param);

  @override
  State<scrSmetaParamCalculationScreen> createState() => _scrSmetaParamCalculationScreenState();
}

class _scrSmetaParamCalculationScreenState extends State<scrSmetaParamCalculationScreen> {
  num slopeConst = 0.6;
  num hConst = 2.7;
  List <ListFloor> floor = [];
  List <ListPerimeter> perimeter = [];
  List <ListOpenings> openings = [];
  List <ListSlopeDoor> slopeDoor = [];
  List <ListSlopeWindow> slopeWindow = [];
  List <ListSlopeWall> slopeWall = [];

  @override
  void initState() {
    print('initState');

    httpGetSmetaParamCalculation(widget.smeta_id, widget.room_id, floor, perimeter, openings, slopeDoor, slopeWindow, slopeWall, slopeConst, hConst).then((value) {
      setState(() {
      });
    });
    // TODO: implement initState
    super.initState();
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Расчет параметров'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.menu))
        ],
      ),
        body: ListView(
          children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Divider(height: 3),
              ),
              ListTile(title: Text('ПЛОЩАДЬ ПОЛА', style: TextStyle(fontSize: 18),), leading: Icon(Icons.crop_free), ),
              _pageFloor(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton.icon(
                  icon: Icon(Icons.add, color: Colors.black),
                  label: Text('Добавить', style: TextStyle(color: Colors.black, fontSize: 15)),
                  onPressed: () {
                    ListFloor newParamFloor = ListFloor(a: 0, b: 0, typeid: '');
                    floor.add(newParamFloor);
                    _EditModalParameterSheet(_tripFloorEditWidgets(newParamFloor));
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0),),),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Divider(height: 3),
              ),
              ListTile(title: Text('ДЛИНЫ ВСЕХ СТЕН', style: TextStyle(fontSize: 18),), leading: Icon(Icons.crop_free), ),
              _pagePerimeter(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton.icon(
                  icon: Icon(Icons.add, color: Colors.black),
                  label: Text('Добавить', style: TextStyle(color: Colors.black, fontSize: 15)),
                  onPressed: () {
                    ListPerimeter newParam = ListPerimeter(a: 0);
                    perimeter.add(newParam);
                    _EditModalParameterSheet(_tripPerimeterEditWidgets(newParam));
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0),),),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Divider(height: 3),
              ),
              ListTile(title: Text('ПРОЁМЫ', style: TextStyle(fontSize: 18),), leading: Icon(Icons.crop_free), ),
              _pageOpening(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton.icon(
                  icon: Icon(Icons.add, color: Colors.black),
                  label: Text('Добавить', style: TextStyle(color: Colors.black, fontSize: 15)),
                  onPressed: () {
                    ListOpenings newParam = ListOpenings(a: 0, b: 0, isDoor: true);
                    openings.add(newParam);
                    _EditOpeningModalParameterSheet(newParam);
                    //_EditModalParameterSheet(_tripOpeningEditWidgets(newParam));
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0),),),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Divider(height: 3),
              ),
              ListTile(title: Text('ОТКОСЫ НА ДВЕРЯХ', style: TextStyle(fontSize: 18),), leading: Icon(Icons.crop_free), ),
              _pageSlopeDoor(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton.icon(
                  icon: Icon(Icons.add, color: Colors.black),
                  label: Text('Добавить', style: TextStyle(color: Colors.black, fontSize: 15)),
                  onPressed: () {
                    ListSlopeDoor newParam = ListSlopeDoor(a: 0, b: 0, c: 0);
                    slopeDoor.add(newParam);
                    _EditModalParameterSheet(_tripSlopeEditWidgets(newParam));
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0),),),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Divider(height: 3),
              ),
              ListTile(title: Text('ОТКОСЫ НА ОКНАХ', style: TextStyle(fontSize: 18),), leading: Icon(Icons.crop_free), ),
              _pageSlopeWindow(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton.icon(
                  icon: Icon(Icons.add, color: Colors.black),
                  label: Text('Добавить', style: TextStyle(color: Colors.black, fontSize: 15)),
                  onPressed: () {
                    ListSlopeWindow newParam = ListSlopeWindow(a: 0, b: 0, c: 0);
                    slopeWindow.add(newParam);
                    _EditModalParameterSheet(_tripSlopeEditWidgets(newParam));
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0),),),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Divider(height: 3),
              ),
              ListTile(title: Text('ОТКОСЫ НА СТЕНАХ', style: TextStyle(fontSize: 18),), leading: Icon(Icons.crop_free), ),
              _pageSlopeWall(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton.icon(
                  icon: Icon(Icons.add, color: Colors.black),
                  label: Text('Добавить', style: TextStyle(color: Colors.black, fontSize: 15)),
                  onPressed: () {
                    ListSlopeWall newParam = ListSlopeWall(a: 0, b: 0, isWall: true);
                    slopeWall.add(newParam);
                    _EditSlopeWallModalParameterSheet(newParam);
                    //_EditModalParameterSheet(_tripSlopeWallEditWidgets(newParam));
                    //EditModalParameterSheet(context, _tripSlopeWallEditWidgets(newParam));
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0),),),
                ),
              ),
            ],

          ),
    );
  }

  _pageFloor() {
    return ListView.builder(shrinkWrap: true,
      padding: EdgeInsets.all(10),
      physics: BouncingScrollPhysics(),
      reverse: false,
      itemCount: floor.length,
      itemBuilder: (_, index) {
        return Card(
          child: ListTile(
            title: Text('${floor[index].a} * ${floor[index].b}', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18)),
            trailing: Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(floor[index].a * floor[index].b), style: TextStyle(fontSize: 16)),
            onTap: () {
              _EditModalParameterSheet(_tripFloorEditWidgets(floor[index]));
            },
          ),
        );

      },
    );
  }

  _pagePerimeter() {
    return ListView.builder(shrinkWrap: true,
      padding: EdgeInsets.all(10),
      physics: BouncingScrollPhysics(),
      reverse: false,
      itemCount: perimeter.length,
      itemBuilder: (_, index) {
        return Card(
          child: ListTile(
            title: Text('Длинна стены ${index+1}', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18)),
            trailing: Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(perimeter[index].a), style: TextStyle(fontSize: 16)),
            onTap: () {
              _EditModalParameterSheet(_tripPerimeterEditWidgets(perimeter[index]));
            },
          ),
        );

      },
    );
  }

  _pageOpening() {
    return ListView.builder(shrinkWrap: true,
      padding: EdgeInsets.all(10),
      physics: BouncingScrollPhysics(),
      reverse: false,
      itemCount: openings.length,
      itemBuilder: (_, index) {
        return Card(
          child: ListTile(
            title: Text('${(openings[index].isDoor) ? 'Дверь (' : 'Окно ('}${openings[index].a} * ${openings[index].b})', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18)),
            trailing: Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(openings[index].a * openings[index].b), style: TextStyle(fontSize: 16)),
            onTap: () {
              _EditOpeningModalParameterSheet(openings[index]);
            },
          ),
        );

      },
    );
  }

  _pageSlopeDoor() {
    return ListView.builder(shrinkWrap: true,
      padding: EdgeInsets.all(10),
      physics: BouncingScrollPhysics(),
      reverse: false,
      itemCount: slopeDoor.length,
      itemBuilder: (_, index) {
        return Card(
          child: ListTile(
            title: Text('${slopeDoor[index].a} + ${slopeDoor[index].b} + ${slopeDoor[index].c}', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18)),
            trailing: Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(slopeDoor[index].a + slopeDoor[index].b + slopeDoor[index].c), style: TextStyle(fontSize: 16)),
            onTap: () {
              _EditModalParameterSheet(_tripSlopeEditWidgets(slopeDoor[index]));
            },
          ),
        );

      },
    );
  }

  _pageSlopeWindow() {
    return ListView.builder(shrinkWrap: true,
      padding: EdgeInsets.all(10),
      physics: BouncingScrollPhysics(),
      reverse: false,
      itemCount: slopeWindow.length,
      itemBuilder: (_, index) {
        return Card(
          child: ListTile(
            title: Text('${slopeWindow[index].a} + ${slopeWindow[index].b} + ${slopeWindow[index].c}', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18)),
            trailing: Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(slopeWindow[index].a + slopeWindow[index].b + slopeWindow[index].c), style: TextStyle(fontSize: 16)),
            onTap: () {
              _EditModalParameterSheet(_tripSlopeEditWidgets(slopeWindow[index]));
            },
          ),
        );

      },
    );
  }

  _pageSlopeWall() {
    return ListView.builder(shrinkWrap: true,
      padding: EdgeInsets.all(10),
      physics: BouncingScrollPhysics(),
      reverse: false,
      itemCount: slopeWall.length,
      itemBuilder: (_, index) {
        return Card(
          child: ListTile(
            title: Text('${slopeWall[index].a} * ${slopeWall[index].b}', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18)),
            subtitle: Text('Вычитать из площади стен: ${(slopeWall[index].isWall) ? 'Да' : 'Нет'}'),
            trailing: Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(slopeWall[index].a * slopeWall[index].b), style: TextStyle(fontSize: 16)),
            onTap: () {
              _EditSlopeWallModalParameterSheet(slopeWall[index]);
            },
          ),
        );

      },
    );
  }


  Widget _tripFloorEditWidgets(ListFloor paramEdit) {
    GlobalKey _formKey = new GlobalKey<FormState>();
    TextEditingController _paramAController = TextEditingController(text: paramEdit.a.toString());
    TextEditingController _paramBController = TextEditingController(text: paramEdit.b.toString());

    void _SaveSums() {
      setState(() {
        paramEdit.a = num.tryParse(_paramAController.text) ?? 0;
        paramEdit.b = num.tryParse(_paramBController.text) ?? 0;
      });
      Navigator.pop(context);
    }

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _textEdit(_paramAController, 'Сторона A'),
          SizedBox(height: 10),
          _textEdit(_paramBController, 'Сторона B'),
          SizedBox(height: 20),
          Container(alignment: Alignment.center,
              child: ElevatedButton(onPressed: _SaveSums,
                child: Text('Сохранить'),
                style: _styleButton(),)),
        ],
      ),
    );
  }

  Widget _tripPerimeterEditWidgets(ListPerimeter paramEdit) {
    GlobalKey _formKey = new GlobalKey<FormState>();
    TextEditingController _paramAController = TextEditingController(text: paramEdit.a.toString());

    void _SaveSums() {
      setState(() {
        paramEdit.a = num.tryParse(_paramAController.text) ?? 0;
      });
      Navigator.pop(context);
    }

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _textEdit(_paramAController, 'Длинна стены'),
          SizedBox(height: 20),
          Container(alignment: Alignment.center,
              child: ElevatedButton(onPressed: _SaveSums,
                child: Text('Сохранить'),
                style: _styleButton(),)),
        ],
      ),
    );
  }

  Widget _tripSlopeEditWidgets(var paramEdit) {
    GlobalKey _formKey = new GlobalKey<FormState>();
    TextEditingController _paramAController = TextEditingController(text: paramEdit.a.toString());
    TextEditingController _paramBController = TextEditingController(text: paramEdit.b.toString());
    TextEditingController _paramCController = TextEditingController(text: paramEdit.c.toString());

    void _SaveSums() {
      setState(() {
        paramEdit.a = num.tryParse(_paramAController.text) ?? 0;
        paramEdit.b = num.tryParse(_paramBController.text) ?? 0;
        paramEdit.c = num.tryParse(_paramCController.text) ?? 0;
      });
      Navigator.pop(context);
    }

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            TextFormField(
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.next,
              controller: _paramAController,
              decoration: InputDecoration(border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)), labelText: 'Сторона A'),
              onChanged: (value) {
                _paramCController.text=_paramAController.text;
              },
          ),
          SizedBox(height: 10),
          _textEdit(_paramBController, 'Сторона B'),
          SizedBox(height: 10),
          _textEdit(_paramCController, 'Сторона C'),
          SizedBox(height: 20),
          Container(alignment: Alignment.center,
              child: ElevatedButton(onPressed: _SaveSums,
                child: Text('Сохранить'),
                style: _styleButton(),)),
        ],
      ),
    );
  }

  _EditOpeningModalParameterSheet(paramEdit) {
    GlobalKey _formKey = new GlobalKey<FormState>();
    TextEditingController _paramAController = TextEditingController(text: paramEdit.a.toString());
    TextEditingController _paramBController = TextEditingController(text: paramEdit.b.toString());

    void _SaveSums() {
      setState(() {
        paramEdit.a = num.tryParse(_paramAController.text) ?? 0;
        paramEdit.b = num.tryParse(_paramBController.text) ?? 0;
      });
      Navigator.pop(context);
    }

    showModalBottomSheet(isScrollControlled: true, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        context: context, builder: (context) => StatefulBuilder(builder: (context, state) {
          return Container(
            height: 600,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _textEdit(_paramAController, 'Ширина'),
                    SizedBox(height: 10),
                    _textEdit(_paramBController, 'Высота'),
                    SizedBox(height: 10),
                    RadioListTile(title: Text('Дверь'), value: true, groupValue: paramEdit.isDoor, onChanged: (value){
                      paramEdit.isDoor = value!;
                      state(() {
                        paramEdit.isDoor = value;
                      });
                    }
                    ),
                    RadioListTile(title: Text('Окно'), value: false, groupValue: paramEdit.isDoor, onChanged: (value){
                      paramEdit.isDoor = value!;
                      state(() {
                        paramEdit.isDoor = value;
                      });
                    }
                    ),
                    SizedBox(height: 20),
                    Container(alignment: Alignment.center,
                        child: ElevatedButton(onPressed: _SaveSums,
                          child: Text('Сохранить'),
                          style: _styleButton(),)),
                  ],
                ),
              ),
            ),
          );

        }
        )
    );
  }

  _EditSlopeWallModalParameterSheet(paramEdit) {
    GlobalKey _formKey = new GlobalKey<FormState>();
    TextEditingController _paramAController = TextEditingController(text: paramEdit.a.toString());
    TextEditingController _paramBController = TextEditingController(text: paramEdit.b.toString());

    void _SaveSums() {
      setState(() {
        paramEdit.a = num.tryParse(_paramAController.text) ?? 0;
        paramEdit.b = num.tryParse(_paramBController.text) ?? 0;
        //paramEdit.isWall = paramBool;
      });
      Navigator.pop(context);
    }

    showModalBottomSheet(isScrollControlled: true, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        context: context, builder: (context) => StatefulBuilder(builder: (context, state) {
          return Container(
            height: 600,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _textEdit(_paramAController, 'Ширина'),
                    SizedBox(height: 10),
                    _textEdit(_paramBController, 'Высота'),
                    SizedBox(height: 10),
                    RadioListTile(title: Text('Вычитать из площади стен'), value: true, groupValue: paramEdit.isWall, onChanged: (value){
                      paramEdit.isWall = value!;
                      state(() {
                        paramEdit.isWall = value;
                        print(paramEdit.isWall);
                      });
                      print(paramEdit.isWall);
                    }
                    ),
                    RadioListTile(title: Text('Не вычитать из площади стен'), value: false, groupValue: paramEdit.isWall, onChanged: (value){
                      paramEdit.isWall = value!;
                      state(() {
                        paramEdit.isWall = value;
                        print(paramEdit.isWall);
                      });
                      print(paramEdit.isWall);
                    }
                    ),
                    SizedBox(height: 20),
                    Container(alignment: Alignment.center,
                        child: ElevatedButton(onPressed: _SaveSums,
                          child: Text('Сохранить'),
                          style: _styleButton(),)),
                  ],
                ),
              ),
            ),
          );

        }
        )
    );
  }

  _EditModalParameterSheet(Widget type) {
    showModalBottomSheet(isScrollControlled: true, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      context: context, builder: (context) => StatefulBuilder(builder: (context, state) {
          return Container(
            height: 600,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: type,
            ),
          );

      }
      )
    );
  }

  _textEdit(_paramController, _label) {
    return TextFormField(
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      textInputAction: TextInputAction.next,
      controller: _paramController,
      decoration: InputDecoration(border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10)), labelText: _label),
      onFieldSubmitted: (value) {},
    );
  }

  _styleButton() {
    return ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.grey),
        shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
        minimumSize: WidgetStateProperty.all(Size(250, 40))
    );
  }

}


