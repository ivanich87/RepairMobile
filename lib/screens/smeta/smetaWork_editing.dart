import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:repairmodule/components/SingleSelections.dart';
import 'package:repairmodule/models/ListWorks.dart';
import 'package:repairmodule/screens/smeta/material_editing.dart';




class scrSmetaWorkEditingScreen extends StatefulWidget {
  final Works rabota;
  final List <Materials> materials;
  final bool additionalWork;

  scrSmetaWorkEditingScreen(this.rabota, this.materials, this.additionalWork);

  @override
  State<scrSmetaWorkEditingScreen> createState() => _scrSmetaWorkEditingScreenState();
}

class _scrSmetaWorkEditingScreenState extends State<scrSmetaWorkEditingScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Работа'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.menu))
        ],
      ),
        body: ListView(padding: EdgeInsets.only(top: 12, left: 8, right: 8),
          children: [
              Text('${widget.rabota.workName}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),),
              Divider(),
              titleHeader('Цены'),
              ListTile(
                title: Text('Цена клиента'),
                trailing: Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(widget.rabota.price), style: TextStyle(fontSize: 16)),
              ),
              ListTile(
                title: Text('Цена мастеров'),
                trailing: Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(widget.rabota.priceSub), style: TextStyle(fontSize: 16)),
                onTap: () {
                  //if (widget.additionalWork)
                  //  _tripEditKol(_tripPriceSubEditWidgets());
                },
              ),
              Divider(),
              titleHeader('Количества'),
              ListTile(
                title: Text('Количество расчетное'),
                subtitle: Text('Расчитано по формуле и параметрам'),
                  trailing: IconButton(onPressed: () {
                    setState(() {
                      widget.rabota.kol=widget.rabota.kolRemains ?? 0;
                      num _sumMaterial = 0;
                      num _sebMaterial = 0;
                      for (var str in widget.materials) {
                        if (str.def==true || (str.kol ?? 0)>0) {
                          str.kol = (widget.rabota.kol ?? 0) * (str.consumption ?? 0);
                          str.summa = (str.kol ?? 0) * (str.price ?? 0);
                          str.summaSeb = (str.kol ?? 0) * (str.priceSeb ?? 0);
                        }
                        _sumMaterial = _sumMaterial + (str.summa ?? 0);
                        _sebMaterial = _sebMaterial + (str.summaSeb ?? 0);
                      }
                      widget.rabota.materialSumma = _sumMaterial;
                      widget.rabota.materialSummaSeb = _sebMaterial;
                    });

                    }, icon: Row(mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${widget.rabota.kolRemains ?? 0}', style: TextStyle(fontSize: 16)),
                      Icon(Icons.arrow_downward)
                    ],
                  ))
                //trailing: Text((widget.rabota.kolSmeta ?? 0).toString(), style: TextStyle(fontSize: 16)),
              ),
              ListTile(
                title: Text('Количество', style: TextStyle(fontSize: 18)),
                trailing: Text(widget.rabota.kol.toString(), style: TextStyle(fontSize: 18),),
                  onTap: () {
                    _tripEditKol(_tripKolEditWidgets());
                  },
              ),
              Divider(),
              SizedBox(height: 10,),
              if (widget.materials.length>0)
                titleHeader('Материалы'),
              ListView.builder(shrinkWrap: true,
                padding: EdgeInsets.all(1),
                physics: BouncingScrollPhysics(),
                reverse: false,
                itemCount: widget.materials.length,
                itemBuilder: (_, index) {
                  return Card(
                    child: ListTile(
                      title: Text(widget.materials[index].materialName!, style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18)),
                      leading: _materialLending(widget.materials[index]),
                      trailing: _materialTrailing(widget.materials[index]), //Checkbox(value: false, onChanged: (bool? value) {  },),
                      subtitle: _materialSubtitle(widget.materials[index]),
                      onTap: () async {
                        await Navigator.push(context, MaterialPageRoute(builder: (context) => scrMaterialEditingScreen(widget.materials[index], widget.rabota.kol ?? 0)));
                        num _sumMaterial = 0;
                        num _sebMaterial = 0;
                        for (var str in widget.materials) {
                          _sumMaterial = _sumMaterial + (str.summa ?? 0);
                          _sebMaterial = _sebMaterial + (str.summaSeb ?? 0);
                        }
                        widget.rabota.materialSumma = _sumMaterial;
                        widget.rabota.materialSummaSeb = _sebMaterial;

                        setState(() {

                        });
                      },
                    ),
                  );

                },
              )

          ],
          ),


    );
  }

  void _tripEditKol(Widget type) {
    showModalBottomSheet(isScrollControlled: true, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), context: context, builder: (BuildContext bc) {
      return Container(
        height: 440,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: type,
        ),
      );

    });
  }

  Widget _tripKolEditWidgets() {
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
                    num _sumMaterial = 0;
                    num _sebMaterial = 0;
                    widget.rabota.kol=num.tryParse(_kolController.text.replaceAll(',', '.')) ?? 0;
                    widget.rabota.summa = widget.rabota.kol!*widget.rabota.price!;
                    widget.rabota.summaSub = widget.rabota.kol!*widget.rabota.priceSub!;
                    for (var str in widget.materials) {
                      if (str.def==true || (str.kol ?? 0)>0) {
                        str.kol = (widget.rabota.kol ?? 0) * (str.consumption ?? 0);
                        str.summa = (str.kol ?? 0) * (str.price ?? 0);
                        str.summaSeb = (str.kol ?? 0) * (str.priceSeb ?? 0);
                      }
                      _sumMaterial = _sumMaterial + (str.summa ?? 0);
                      _sebMaterial = _sebMaterial + (str.summaSeb ?? 0);
                    }
                    widget.rabota.materialSumma = _sumMaterial;
                    widget.rabota.materialSummaSeb = _sebMaterial;
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

  _materialLending(Materials _material) {
    String _url='https://sun1-83.userapi.com/s/v1/ig2/7t9jiWE0Fldp0dmKRxMIAbxCOAYtCjAB2-SQo_yJ_xk8e8jxC8UiSXx8BKIj981EXnpFOmF5UyINu4alIhbyfLr8.jpg?size=400x400&quality=95&crop=40,0,447,447&ava=1';
    return Image.network(_material.avatar ?? _url);
  }

  _materialTrailing(Materials _material) {
    return Checkbox(value: (_material.kol==0) ? false : true, onChanged: (value) {
      setState(() {
        if (value==true){
          _material.kol= (_material.consumption ?? 0) * (widget.rabota.kol ?? 0);
        }
        else {
          _material.kol=0;
        }
        _material.summa = _material.kol! * (_material.price ?? 0);
        _material.summaSeb = _material.kol! * (_material.priceSeb ?? 0);
      });
    });
  }

  _materialSubtitle(Materials _material) {
      return Text('Кол-во: ${_material.kol}; Сумма: ${NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(_material.summa)}', style: TextStyle(fontStyle: FontStyle.italic),);
  }

  // Widget _tripPriceSubEditWidgets() {
  //   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //
  //   TextEditingController _kolController = TextEditingController(text: widget.rabota.priceSub.toString());
  //
  //
  //   final _style = ButtonStyle(
  //       backgroundColor: WidgetStateProperty.all(Colors.grey),
  //       shape: WidgetStateProperty.all(
  //           RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
  //       minimumSize: WidgetStateProperty.all(Size(250, 40))
  //   );
  //
  //   return Form(
  //     key: _formKey,
  //     //autovalidateMode: true,
  //     child: Column(
  //       mainAxisSize: MainAxisSize.max,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         TextFormField(
  //           keyboardType: TextInputType.numberWithOptions(decimal: true),
  //           autofocus: true,
  //           textInputAction: TextInputAction.done,
  //           controller: _kolController,
  //           validator: (value) {
  //             if (value == null || value.isEmpty) {
  //               return 'Введите цену мастеров';
  //             }
  //             return null;
  //           },
  //           decoration: InputDecoration(border: OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(10)), labelText: 'Цена мастеров'),
  //         ),
  //         SizedBox(height: 20),
  //         Container(alignment: Alignment.center,
  //             child: ElevatedButton(onPressed: () {
  //               if (_formKey.currentState?.validate() ?? false) {
  //                 setState(() {
  //                   widget.rabota.priceSub=num.tryParse(_kolController.text.replaceAll(',', '.')) ?? 0;
  //                   widget.rabota.summaSub = widget.rabota.kol!*widget.rabota.priceSub!;
  //                 });
  //                 Navigator.pop(context);
  //               }
  //
  //             },
  //               child: Text('Сохранить'),
  //               style: _style,)),
  //       ],
  //     ),
  //   );
  // }

}

