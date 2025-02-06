import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:repairmodule/components/SingleSelections.dart';
import 'package:repairmodule/models/Lists.dart';
import 'package:repairmodule/screens/profileMan.dart';
import 'package:repairmodule/screens/plat_edit.dart';
import 'package:repairmodule/screens/sprList.dart';

import 'ReceiptSost.dart';
import 'object_view.dart';
import 'objectsListSelected.dart';

class scrReceiptEditScreen extends StatefulWidget {
  final Receipt receiptData;
  scrReceiptEditScreen({super.key, required this.receiptData});

  @override
  State<scrReceiptEditScreen> createState() => _scrReceiptEditScreenState();
}

class _scrReceiptEditScreenState extends State<scrReceiptEditScreen> {

  TextEditingController _commentController = TextEditingController(text: '');

  bool firstInit = true;
  bool userDataEdit = false;
  late Receipt receiptDataCopy;

  Future<bool> httpPlatUpdate(Receipt _body) async {
    bool _result=false;
    bool _accept = false;
    final _queryParameters = {'userId': Globals.anPhone};
    var _url=Uri(path: '${Globals.anPath}platUpdate/', host: Globals.anServer, scheme: 'https', queryParameters: _queryParameters); //тут нужно заменить функцию на новую
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': Globals.anAuthorization
    };
    try {
      print('Start export plat!!!!');
      print(json.encode(_body.toJson()));
      var response = await http.post(_url, headers: _headers, body: json.encode(_body.toJson()));
      print('Код ответа: ${response.statusCode} Тело ответа: ${response.body}');
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        String _id = data['Код'] ?? '';
        _result = data['Успешно'] ?? '';
        String _message = data['Сообщение'] ?? '';
        _accept = data['Проведен'] ?? false;
        widget.receiptData.accept = _accept;
        if (widget.receiptData.id=='')
          _body.id = _id;

        print('Платеж выгружен. Результат:  $_result. Сообщение:  $_message');
      }
      else {
        _result = false;
        final snackBar = SnackBar(
          content: Text('${response.body}'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (error) {
      _result = false;
      print("Ошибка при выгрузке платежа: $error");
      _result = false;
      final snackBar = SnackBar(
        content: Text('$error'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    return _result ?? false;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  Widget build(BuildContext context) {
    if (firstInit==true) {
      receiptDataCopy = widget.receiptData.copyWith();
      print('Скопировали бэкап');
      _commentController.text = widget.receiptData.comment;

      if (widget.receiptData.kassaName.length==0)
        widget.receiptData.kassaName='Выберите кассу или банк';
      if (widget.receiptData.kassaSotrName.length==0)
        widget.receiptData.kassaSotrName='Выберите сотрудника';

    }
    firstInit=false;
    return PopScope(
        canPop: true,
        onPopInvoked: (bool didPop) async {
      if (userDataEdit==false) {
        Receipt.fromTo(widget.receiptData, receiptDataCopy);
        print('Вернули данные из бэкапа');
      }
      return;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Покупка стройматериалов'),
          centerTitle: true,
        ),
        body: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              //crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Divider(),
                SingleSection(
                  title: 'Сведения об объекте',
                  children: [
                    CustomTitle(plat: widget.receiptData,
                        titles: widget.receiptData.clientNmame,
                        icon: Icons.man,
                        id: '',
                        idType: '', trailing: null, Enabled: false),
                    CustomTitle(plat: widget.receiptData,
                        titles: (widget.receiptData.dogNumber.length==0) ? 'Выверите договор' : 'Договор № ${widget.receiptData.dogNumber} от ${DateFormat('dd.MM.yyyy').format(widget.receiptData.dogDate)}',
                        icon: Icons.paste_rounded,
                        trailing: Icon(Icons.navigate_next),
                        id: '',
                        idType: 'objectsListSelected'),
                      CustomTitle(plat: widget.receiptData,
                          titles: (widget.receiptData.objectName.length==0) ? 'Выверите объект' : 'Объект: ${widget.receiptData.objectName}',
                          icon: Icons.location_on_outlined,
                          trailing: Icon(Icons.navigate_next),
                          id: '',
                          idType: 'objectsListSelected'),
                  ],
                ),
                Divider(),
                SingleSection(
                  title: 'Поставщик',
                  children: [
                    CustomTitle(plat: widget.receiptData,
                        titles: (widget.receiptData.contractorName.length==0) ? 'Поставщик не указан' : widget.receiptData.contractorName,
                        icon: Icons.manage_accounts,
                        trailing: Icon(Icons.navigate_next),
                        id: 'КонтрагентыДляФондов',
                        idType: 'sprContractorListSelected'),
                  ],
                ),
                Divider(),
                SingleSection(
                  title: 'Аналитика и комментарий',
                  children: [
                    CustomTitle(plat: widget.receiptData,
                        titles: widget.receiptData.analyticName,
                        icon: Icons.analytics,
                        trailing: Icon(Icons.navigate_next),
                        id: 'АналитикаДвиженийДС',
                        idType: 'sprAnalyticsListSelected'),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        controller: _commentController,
                        keyboardType: TextInputType.text,
                        minLines: 3,
                        maxLines: 6,
                        decoration: InputDecoration(
                          icon: Icon(Icons.comment_outlined),
                          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                          hintText: 'Комментарий к платежу',
                        ),
                        // onChanged: (value) {
                        //   widget.receiptData.comment = value;
                        // },
                      ),
                    ),
                    if (widget.receiptData.tovarUse)
                      Card(
                        child: ListTile(
                          title: Text('Посмотреть товары'),
                          leading: Icon(Icons.list_alt),
                          trailing: Icon(Icons.navigate_next),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => scrReceiptSostScreen(widget.receiptData.receiptSost!.toList())));
                          },
                        ),
                      ),
                  ],
                ),
                Divider(),
                SingleSection(
                  title: 'Суммы',
                  children: [
                    //_EditSumma(typeSumma: 1, summa: widget.receiptData.summaClient),
                    CustomTitle(plat: widget.receiptData,
                        titles: "Сумма за материалы",
                        trailing: Text(widget.receiptData.summaClient.toString(), style: MyTextStyle()),
                        icon: Icons.attach_money,
                        id: '',
                        idType: 'summaEdit'),
                    if (widget.receiptData.summaClient!=widget.receiptData.summaOrg)
                      CustomTitle(plat: widget.receiptData,
                        titles: "Сумма факт",
                        trailing: Text(widget.receiptData.summaOrg.toString(), style: MyTextStyle()),
                        icon: Icons.attach_money,
                        id: '',
                        idType: 'summaEdit'),
                    if (widget.receiptData.summa!=widget.receiptData.summaOrg)
                      CustomTitle(plat: widget.receiptData,
                        titles: "Списать деньги",
                        trailing: Text(widget.receiptData.summa.toString(), style: MyTextStyle()),
                        icon: Icons.attach_money,
                        id: '',
                        idType: 'summaEdit'),
                    RadioListTile(title: Text('Касса/Банк'), value: 0, groupValue: widget.receiptData.kassaType, onChanged: (value){
                      setState(() {
                        widget.receiptData.kassaType = value!;
                      });
                    }
                    ),
                    RadioListTile(title: Text('Подотчетные средства'), value: 1, groupValue: widget.receiptData.kassaType, onChanged: (value) {
                      setState(() {
                        widget.receiptData.kassaType = value!;
                      });
                    }
                    ),
                    CustomTitle(plat: widget.receiptData,
                        titles: '${(widget.receiptData.kassaType==2 || widget.receiptData.summa==0) ? 'Без списания' : (widget.receiptData.kassaType==0) ? widget.receiptData.kassaName : widget.receiptData.kassaSotrName}',
                        icon: Icons.payment_outlined,
                        trailing: Icon(Icons.navigate_next),
                        id: (widget.receiptData.kassaType==0) ? 'Кассы' : 'Сотрудники',
                        idType: (widget.receiptData.kassaType==0) ? 'sprKassaListSelected' : 'sprSotrListSelected')
                  ],
                ),
              ],
            )

          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            widget.receiptData.comment = _commentController.text;
            httpPlatUpdate(widget.receiptData).then((value) {
              userDataEdit = value;
              print('userDataEdit = $value');
              if (userDataEdit==true)
                Navigator.pop(context);
            });
          },
          child: Icon(Icons.save),
        )
      //backgroundColor: Colors.grey[900]),
    ),
    );
  }

  CustomTitle({required String titles, required IconData icon, required Widget? trailing, required String id, required String idType, required Receipt plat, bool Enabled = true}) {
    return ListTile(
      enabled: Enabled,
      title: Text(titles ?? 'ggg'),
      leading: Icon(icon),
      trailing: trailing,
      onTap: () async {
        if (idType=='summaEdit') {
          tripEditModalBottomSheet(context, _tripEditWidgets(plat));
        }
        else {
          var res = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) {
                    if (idType == 'scrProfileMan') {
                      return scrProfileMan(id: plat.id,);
                    };
                    if (idType == 'scrObjectsViewScreen') {
                      return scrObjectsViewScreen(id: plat.id,);
                    };
                    if (idType == 'objectsListSelected') {
                      return objectsListSelected();
                    };
                    if (idType == 'sprAnalyticsListSelected') {
                      return scrListScreen(sprName: id, onType: 'pop');
                    };
                    if (idType == 'sprKassaListSelected' ||
                        idType == 'sprKassaListSelected2') {
                      return scrListScreen(sprName: id, onType: 'pop');
                    };
                    if (idType == 'sprSotrListSelected' ||
                        idType == 'sprSotrListSelected2') {
                      return scrListScreen(sprName: id, onType: 'pop');
                    };
                    if (idType == 'sprContractorListSelected') {
                      return scrListScreen(sprName: id, onType: 'pop');
                    };
                    if (idType == 'summaEdit') {
                      tripEditModalBottomSheet(
                          context, _tripEditWidgets(plat));
                    };
                    return scrProfileMan(id: id,);
                  }));
          print(idType);
          if (idType == 'objectsListSelected') {
            setState(() {
              plat.dogId = res.dogId;
              plat.dogNumber = res.dogNumber;
              plat.dogDate = res.dogDate;
              plat.objectId = res.objectId;
              plat.objectName = res.objectName;
              plat.clientNmame = res.objectContractor;
              //plat.clientId=res.objectContractorId;
            });
          };
          if (idType == 'sprAnalyticsListSelected') {
            print(plat.analyticName);
            print(res.name);
            setState(() {
              plat.analyticId = res.id;
              plat.analyticName = res.name;
              print(plat.analyticName);
            });
          };
          if (idType == 'sprKassaListSelected') {
            setState(() {
              plat.kassaId = res.id;
              plat.kassaName = res.name;
            });
          };
          if (idType == 'sprSotrListSelected') {
            setState(() {
              plat.kassaSotrId = res.id;
              plat.kassaSotrName = res.name;
            });
          };
          if (idType == 'sprContractorListSelected') {
            setState(() {
              plat.contractorId = res.id;
              plat.contractorName = res.name;
            });
          }
        }
      },
    );

  }

  Widget _tripEditWidgets(Receipt plat) {
    GlobalKey _formKey = new GlobalKey<FormState>();
    TextEditingController _summaClientController = TextEditingController(
        text: plat.summaClient.toString());
    TextEditingController _summaOrgController = TextEditingController(
        text: plat.summaOrg.toString());
    TextEditingController _summaController = TextEditingController(
        text: plat.summa.toString());


    final _style = ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.grey),
        shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
        minimumSize: WidgetStateProperty.all(Size(250, 40))
    );

    void _SaveSums() {
      setState(() {
        plat.summaClient = num.tryParse(_summaClientController.text) ?? 0;
        plat.summaOrg = num.tryParse(_summaOrgController.text) ?? 0;
        plat.summa = num.tryParse(_summaController.text) ?? 0;
      });
      Navigator.pop(context);
    }

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
            textInputAction: TextInputAction.next,
            controller: _summaClientController,
            decoration: InputDecoration(border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10)), labelText: 'Сумма за материалы'),
            onFieldSubmitted: (value) {
              print('summaClient = ' + _summaClientController.text + '   /   ' + value);
              print('summaOrg = ' + _summaOrgController.text);
              print('summa = ' + _summaController.text);
              if (plat.summaClient==plat.summaOrg)
                _summaOrgController.text=value;
              if (plat.summaOrg==plat.summa)
                _summaController.text=value;
            },
          ),
          SizedBox(height: 10),
          TextFormField(
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.next,
            validator: (value) => valid(value),
            controller: _summaOrgController,
            decoration: InputDecoration(border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10)), labelText: 'Сумма факт'),
            onFieldSubmitted: (value) {
              if (plat.summaOrg==plat.summa)
                _summaController.text=value;
            },
          ),
          SizedBox(height: 10),
          TextFormField(
            keyboardType: TextInputType.numberWithOptions(decimal: true ),
            controller: _summaController,
            decoration: InputDecoration(border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10)),
                labelText: 'Списать'),
          ),
          SizedBox(height: 20),
          Container(alignment: Alignment.center,
              child: ElevatedButton(onPressed: _SaveSums,
                child: Text('Сохранить'),
                style: _style,)),
        ],
      ),
    );
  }

}

void tripEditModalBottomSheet(BuildContext context, Widget type) {
  showModalBottomSheet(isScrollControlled: true, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), context: context, builder: (BuildContext bc) {
    return Container(
      height: 600,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: type,
      ),
    );

  });
}



_EditSumma({required int typeSumma, required num summa}) {
  return TextField(
    textAlign: TextAlign.center,
    controller: TextEditingController(text: summa.toString()),
    keyboardType: TextInputType.number,
    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.red),
    onSubmitted: (value) {
        summa=num.tryParse(value) ?? 0;

      print('изменили сумму платежа на ${summa}');
    },
  );
}

MyTextStyle() {
  return TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.red);
}

valid(String? value) {
  return value
  !.trim()
      .length > 0 ? null : 'Имя пользователя не может быть пустым';
}


