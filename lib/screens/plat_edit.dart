import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:repairmodule/components/SingleSelections.dart';
import 'package:repairmodule/screens/profileMan.dart';
import 'package:repairmodule/models/Lists.dart';
import 'package:repairmodule/screens/object_view.dart';
import 'package:repairmodule/screens/sprList.dart';

import 'objects.dart';
import 'objectsListSelected.dart';

class scrPlatEditScreen extends StatefulWidget {
  final ListPlat plat2;
  //final String id;

  scrPlatEditScreen({super.key, required this.plat2});

  @override
  State<scrPlatEditScreen> createState() => _scrPlatEditScreenState();
}

class _scrPlatEditScreenState extends State<scrPlatEditScreen> {
  bool firstInit = true;
  bool userDataEdit = false;
  late ListPlat plat4;

  @override
  Widget build(BuildContext context) {
    ListPlat plat3 = widget.plat2;
    if (firstInit==true) {
      plat4 = widget.plat2.copyWith();
      print('Скопировали бэкап');
    }
    firstInit=false;

    return PopScope(
        canPop: true,
        onPopInvoked: (bool didPop) async {
      if (userDataEdit==false) {
        ListPlat.fromTo(plat3, plat4);
      }
      return;
    },
    child: Scaffold(
        appBar: AppBar(
          title: Text('Платеж'),
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        'Оплата от клиента за работы',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '№ ${plat3.number} от ${DateFormat('dd.MM.yyyy').format(plat3.date)}',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Divider(),
                //_payer(widget: widget,),
                Divider(),
                SingleSection(
                  title: 'Сведения об объекте',
                  children: [
                    widgetDogovor(plat3)
                  ],
                ),
                Divider(),
                //_recipient(widget: widget,),
                Divider(),
                SingleSection(
                  title: 'Аналитика и комментарий',
                  children: [
                    CustomTitle(plat: plat3,
                        titles: plat3.analyticName,
                        icon: Icons.analytics,
                        id: 'АналитикаДвиженийДС',
                        idType: 'sprAnalyticsListSelected', trailing: null),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        controller: TextEditingController(text: plat3.comment),
                        keyboardType: TextInputType.multiline,
                        minLines: 3,
                        maxLines: 6,
                        decoration: InputDecoration(
                          icon: Icon(Icons.comment_outlined),
                          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                          hintText: 'Комментарий к платежу',
                        ),
                      ),
                    ),
                  ],
                ),
                //],
                Divider(),
                SingleSection(
                  title: (plat3.platType=='Расход') ? 'Списать деньги с' : 'Зачислить деньги на',
                  children: [
                    Column(
                      children: [

                        RadioListTile(title: Text('Касса/Банк'), value: 0, groupValue: plat3.kassaType, onChanged: (value){
                            setState(() {
                              plat3.kassaType = value!;
                            });
                          }
                        ),
                        RadioListTile(title: Text('Подотчетные средства'), value: 1, groupValue: plat3.kassaType, onChanged: (value) {
                            setState(() {
                              plat3.kassaType = value!;
                            });
                          }
                          ),
                        ],
                      ),
                    CustomTitle(plat: plat3,
                        titles: (plat3.kassaType==0) ? plat3.kassaName : plat3.kassaSotrName,
                        icon: Icons.payment_outlined,
                        id: (plat3.kassaType==0) ? 'Кассы' : 'Сотрудники',
                        idType: (plat3.kassaType==0) ? 'sprKassaListSelected' : 'sprSotrListSelected', trailing: null),
                ],
              ),
                Divider(),
                SingleSection(
                  title: (plat3.platType=='Расход') ? 'Сведения о получателе' : 'Сведения о плательщике',
                  children: [
                    if (plat3.type=='Движение денежных средтв')
                      ListTile(title: Text('Учитывать в движениях по контрагенту'), trailing: CupertinoSwitch(value: plat3.contractorUse, onChanged: (bool val) => setState(() => plat3.contractorUse = val))),
                    CustomTitle(plat: plat3,
                        titles: plat3.contractorName,
                        icon: Icons.man,
                        id: 'Контрагенты',
                        idType: 'sprContractorListSelected', trailing: null, Enabled: (plat3.dogUse==true) ? false : true)
                  ],
                ),
                Divider(),
                SingleSection(title: 'Сумма',
                    children: [
                      TextField(
                        textAlign: TextAlign.center,
                        controller: TextEditingController(text: (plat3.platType=='Расход') ? plat3.summaDown.toString() : plat3.summaUp.toString()),
                        keyboardType: TextInputType.number,
                        style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: (plat3.summa>=0) ? Colors.green : Colors.red),
                      )
                    ]),
          ],
        ),
      ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            userDataEdit = true;
            Navigator.pop(context);
            //widget.plat2.copyWith(plat.id, plat.name, plat.date, plat.del, plat.number, plat.accept, plat.comment, plat.contractorId, plat.contractorName, plat.analyticId, plat.analyticName, plat.summaUp, plat.summaDown, plat.summa, plat.objectId, plat.objectName, plat.dogId, plat.dogNumber, plat.dogDate, plat.kassaId, plat.kassaName, plat.kassaSotrId, plat.kassaSotrName, plat.kassaType, plat.kassa, plat.companyId, plat.companyName, plat.platType);
          },
          child: Icon(Icons.save),
        )
      //backgroundColor: Colors.grey[900]),
    )
    );
  }

  widgetDogovor(ListPlat plat) {
    return Column(
      children: [
        if (plat.type=='Движение денежных средтв')
          ListTile(title: Text('Учитывать в договоре'), trailing: CupertinoSwitch(value: plat.dogUse, onChanged: (bool val) => setState(() => plat.dogUse = val))),
        if (plat.dogUse==true)
        CustomTitle(plat: plat,
            titles: 'Договор № ${plat.dogNumber} от ${DateFormat('dd.MM.yyyy').format(plat.dogDate)}',
            icon: Icons.paste_rounded,
            trailing: Icon(Icons.label_important_sharp),
            id: '',
            idType: 'objectsListSelected'),
        if (plat.dogUse==true)
        CustomTitle(plat: plat,
            titles: 'Объект: ${plat.objectName}',
            icon: Icons.location_on_outlined,
            trailing: Icon(Icons.label_important_sharp),
            id: '',
            idType: 'objectsListSelected'),
      ],
    );
  }


  CustomTitle({required String titles, required IconData icon, required Widget? trailing, required String id, required String idType, required ListPlat plat, bool Enabled = true}) {
    return ListTile(
      enabled: Enabled,
      title: Text(titles ?? 'ggg'),
      leading: Icon(icon),
      trailing: trailing,
      onTap: () async {
        var res = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) {
                    if (idType=='scrProfileMan') {
                      return scrProfileMan(id: plat.id,);
                    };
                    if (idType=='scrObjectsViewScreen') {
                      return scrObjectsViewScreen(id: plat.id,);
                    };
                    if (idType=='objectsListSelected') {
                      return objectsListSelected();
                    };
                    if (idType=='sprAnalyticsListSelected') {
                      return scrListScreen(sprName: id);
                    };
                    if (idType=='sprKassaListSelected') {
                      return scrListScreen(sprName: id);
                    };
                    if (idType=='sprSotrListSelected') {
                      return scrListScreen(sprName: id);
                    };
                    if (idType=='sprContractorListSelected') {
                      return scrListScreen(sprName: id);
                    };
                    return scrProfileMan(id: id,);
                  } ));
          if (idType=='objectsListSelected'){
            setState(() {
              plat.dogId = res.dogId;
              plat.dogNumber = res.dogNumber;
              plat.dogDate = res.dogDate;
              plat.objectId = res.objectId;
              plat.objectName = res.objectName;
            });
          };
          if (idType=='sprAnalyticsListSelected'){
            print(plat.analyticName);
            print(res.name);
          setState(() {
            plat.analyticId = res.id;
            plat.analyticName = res.name;
            print(plat.analyticName);
          });
        };
        if (idType=='sprKassaListSelected'){
          setState(() {
            plat.kassaId = res.id;
            plat.kassaName = res.name;
          });
        };
        if (idType=='sprSotrListSelected'){
          setState(() {
            plat.kassaSotrId = res.id;
            plat.kassaSotrName = res.name;
          });
        };
        if (idType=='sprContractorListSelected'){
          setState(() {
            plat.contractorId = res.id;
            plat.contractorName = res.name;
          });
        }
      },
    );

  }
}



