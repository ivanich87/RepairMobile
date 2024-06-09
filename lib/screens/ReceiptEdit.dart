import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:repairmodule/components/SingleSelections.dart';
import 'package:repairmodule/models/Lists.dart';
import 'package:repairmodule/screens/profileMan.dart';
import 'package:repairmodule/screens/plat_edit.dart';
import 'package:repairmodule/screens/sprList.dart';

import 'object_view.dart';
import 'objectsListSelected.dart';

class scrReceiptEditScreen extends StatefulWidget {
  final Receipt receiptData;
  scrReceiptEditScreen({super.key, required this.receiptData});

  @override
  State<scrReceiptEditScreen> createState() => _scrReceiptEditScreenState();
}

class _scrReceiptEditScreenState extends State<scrReceiptEditScreen> {
  bool firstInit = true;
  bool userDataEdit = false;
  late Receipt receiptDataCopy;

  Future<bool> httpPlatUpdate(Receipt _body) async {
    bool _result=false;
    var _url=Uri(path: '/a/centrremonta/hs/v1/platUpdate/', host: 's1.rntx.ru', scheme: 'https'); //тут нужно заменить функцию на новую
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': 'Basic YWNlOkF4V3lJdnJBS1prdzY2UzdTMEJP'
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
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.menu))],
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
                        titles: 'Договор № ${widget.receiptData.dogNumber} от ${DateFormat('dd.MM.yyyy').format(widget.receiptData.dogDate)}',
                        icon: Icons.paste_rounded,
                        trailing: Icon(Icons.label_important_sharp),
                        id: '',
                        idType: 'objectsListSelected'),
                      CustomTitle(plat: widget.receiptData,
                          titles: 'Объект: ${widget.receiptData.objectName}',
                          icon: Icons.location_on_outlined,
                          trailing: Icon(Icons.label_important_sharp),
                          id: '',
                          idType: 'objectsListSelected'),
                  ],
                ),
                Divider(),
                SingleSection(
                  title: 'Поставщик',
                  children: [
                    CustomTitle(plat: widget.receiptData,
                        titles: widget.receiptData.contractorName,
                        icon: Icons.manage_accounts,
                        id: 'КонтрагентыДляФондов',
                        idType: 'sprContractorListSelected', trailing: null),
                  ],
                ),
                Divider(),
                SingleSection(
                  title: 'Аналитика и комментарий',
                  children: [
                    CustomTitle(plat: widget.receiptData,
                        titles: widget.receiptData.analyticName,
                        icon: Icons.analytics,
                        id: 'АналитикаДвиженийДС',
                        idType: 'sprAnalyticsListSelected', trailing: null),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        controller: TextEditingController(text: widget.receiptData.comment),
                        keyboardType: TextInputType.text,
                        minLines: 3,
                        maxLines: 6,
                        decoration: InputDecoration(
                          icon: Icon(Icons.comment_outlined),
                          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                          hintText: 'Комментарий к платежу',
                        ),
                        onChanged: (value) {
                          widget.receiptData.comment = value;
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
                    CustomTitle(plat: widget.receiptData,
                        titles: '${(widget.receiptData.kassaType==2 || widget.receiptData.summa==0) ? 'Без списания' : (widget.receiptData.kassaType==0) ? widget.receiptData.kassaName : widget.receiptData.kassaSotrName}',
                        //titles: '${(widget.receiptData.kassaType==0) ? widget.receiptData.kassaName : (widget.receiptData.kassaType==1) ? widget.receiptData.kassaSotrName : 'Без списния'}',
                        icon: Icons.payment_outlined,
                        id: (widget.receiptData.kassaType==0) ? 'Кассы' : 'Сотрудники',
                        idType: (widget.receiptData.kassaType==0) ? 'sprKassaListSelected' : 'sprSotrListSelected', trailing: null)
                  ],
                )
              ],
            )

          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            httpPlatUpdate(widget.receiptData).then((value) {
              userDataEdit = value;
              print('userDataEdit = $value');
              if (userDataEdit==true)
                Navigator.pop(context);
            });
          },
          child: Icon(Icons.disc_full_rounded),
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
          _tripEditModalBottomSheet(context, _tripEditWidgets(plat));
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
                      return scrListScreen(sprName: id);
                    };
                    if (idType == 'sprKassaListSelected' ||
                        idType == 'sprKassaListSelected2') {
                      return scrListScreen(sprName: id);
                    };
                    if (idType == 'sprSotrListSelected' ||
                        idType == 'sprSotrListSelected2') {
                      return scrListScreen(sprName: id);
                    };
                    if (idType == 'sprContractorListSelected') {
                      return scrListScreen(sprName: id);
                    };
                    if (idType == 'summaEdit') {
                      _tripEditModalBottomSheet(
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

  void _tripEditModalBottomSheet(BuildContext context, Widget type) {
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

  Widget _tripEditWidgets(Receipt plat) {
    GlobalKey _formKey = new GlobalKey<FormState>();
    TextEditingController _summaClientController = TextEditingController(
        text: plat.summaClient.toString());
    TextEditingController _summaOrgController = TextEditingController(
        text: plat.summaOrg.toString());
    TextEditingController _summaController = TextEditingController(
        text: plat.summa.toString());


    final _style = ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.grey),
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
        minimumSize: MaterialStateProperty.all(Size(250, 40))
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
            keyboardType: TextInputType.number,
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
            keyboardType: TextInputType.number,
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
            keyboardType: TextInputType.number,
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


