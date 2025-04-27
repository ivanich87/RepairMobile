import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:repairmodule/components/SingleSelections.dart';
import 'package:repairmodule/models/ListWorks.dart';


class scrMaterialEditingScreen extends StatefulWidget {
  final Materials material;
  final num kolRemains;

  scrMaterialEditingScreen(this.material, this.kolRemains);

  @override
  State<scrMaterialEditingScreen> createState() => _scrMaterialEditingScreenState();
}

class _scrMaterialEditingScreenState extends State<scrMaterialEditingScreen> {


  @override
  Widget build(BuildContext context) {
    String _url='https://sun1-83.userapi.com/s/v1/ig2/7t9jiWE0Fldp0dmKRxMIAbxCOAYtCjAB2-SQo_yJ_xk8e8jxC8UiSXx8BKIj981EXnpFOmF5UyINu4alIhbyfLr8.jpg?size=400x400&quality=95&crop=40,0,447,447&ava=1';
    return Scaffold(
      appBar: AppBar(
        title: Text('Материал'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.menu))
        ],
      ),
        body: ListView(padding: EdgeInsets.only(top: 12, left: 8, right: 8),
          children: [
              Image.network(widget.material.avatar ?? _url),
              SizedBox(height: 10,),
              Text('${widget.material.materialName}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),),
              Divider(),
              titleHeader('Цены'),
              ListTile(
                title: Text('Цена клиента'),
                trailing: Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(widget.material.price), style: TextStyle(fontSize: 16)),
              ),
              ListTile(
                title: Text('Цена закупа'),
                trailing: Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(widget.material.priceSeb), style: TextStyle(fontSize: 16)),
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
                      widget.material.kol= (widget.material.consumption ?? 0) * widget.kolRemains;
                    });

                    }, icon: Row(mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${(widget.material.consumption ?? 0) * widget.kolRemains}', style: TextStyle(fontSize: 16)),
                      Icon(Icons.arrow_downward)
                    ],
                  ))
              ),
              ListTile(
                title: Text('Количество', style: TextStyle(fontSize: 18)),
                trailing: Text(widget.material.kol.toString(), style: TextStyle(fontSize: 18),),
                  onTap: () {
                    _tripEditKol(_tripKolEditWidgets());
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

    TextEditingController _kolController = TextEditingController(text: widget.material.kol.toString());


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
                    widget.material.kol=num.tryParse(_kolController.text.replaceAll(',', '.')) ?? 0;
                    widget.material.summa = widget.material.kol!*(widget.material.price ?? 0);
                    widget.material.summaSeb = widget.material.kol!*(widget.material.priceSeb ?? 0);
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


}

