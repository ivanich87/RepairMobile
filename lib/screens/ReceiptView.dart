import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:repairmodule/components/SingleSelections.dart';
import 'package:repairmodule/models/Lists.dart';
import 'package:repairmodule/screens/ReceiptEdit.dart';
import 'package:repairmodule/screens/profileMan.dart';

import '../components/Cards.dart';

class scrReceiptViewScreen extends StatefulWidget {
  final String id;
  late ListPlat event;
  scrReceiptViewScreen({super.key, required this.id, required this.event});

  @override
  State<scrReceiptViewScreen> createState() => _scrReceiptViewScreenState();
}

class _scrReceiptViewScreenState extends State<scrReceiptViewScreen> {
  Receipt recipientdata = Receipt('', '', DateTime.now(), true, false, false, '', '', '', '', true, '', '', DateTime.now(), 0, 0, 0, false, '', '', '', 'Расход', 0, '7fa144f2-14ca-11ed-80dd-00155d753c19', 'Покупка стройматериалов', '', '', '', '', 0, 'Покупка стройматериалов');
  bool userDataEdit = false;


  Future httpGetInfoObject() async {
    print(widget.id);
    if (widget.id=='')
      return;

    var _url=Uri(path: '/a/centrremonta/hs/v1/receipt/'+widget.id+'/', host: 's1.rntx.ru', scheme: 'https');

    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': 'Basic YWNlOkF4V3lJdnJBS1prdzY2UzdTMEJP'
    };
    try {
      var response = await http.get(_url, headers: _headers);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        recipientdata.id = widget.id;
        recipientdata.number = data['number'] ?? '';
        recipientdata.date = DateTime.parse(data['date']);
        recipientdata.accept = data['accept'] ?? false;
        recipientdata.del = data['del'] ?? false;
        recipientdata.acceptClient = data['acceptClient'] ?? false;
        recipientdata.clientId = data['clientId'] ?? '';
        recipientdata.clientNmame = data['clientNmame'] ?? '';
        recipientdata.objectId = data['objectId'] ?? '';
        recipientdata.objectName = data['objectName'] ?? '';
        recipientdata.dogId = data['dogId'] ?? '';
        recipientdata.dogNumber = data['dogNumber'];
        recipientdata.dogDate = DateTime.parse(data['dogDate']);
        recipientdata.summaClient = data['summaClient'] ?? 0;
        recipientdata.summaOrg = data['summaOrg'] ?? 0;
        recipientdata.summa = data['summa'] ?? 0;
        recipientdata.tovarUse = data['tovarUse'] ?? false;
        recipientdata.comment = data['comment'] ?? '';
        recipientdata.contractorId = data['contractorId'] ?? '';
        recipientdata.contractorName = data['contractorName'] ?? '';
        recipientdata.platType = data['platType'] ?? 'Расход';
        recipientdata.status = data['status'] ?? 0;
        recipientdata.analyticId = data['analyticId'] ?? '';
        recipientdata.analyticName = data['analyticName'] ?? '';
        recipientdata.kassaId = data['kassaId'] ?? '';
        recipientdata.kassaName = data['kassaName'] ?? '';
        recipientdata.kassaSotrId = data['kassaSotrId'] ?? '';
        recipientdata.kassaSotrName = data['kassaSotrName'] ?? '';
        recipientdata.kassaType = data['kassaType'] ?? 0;
        recipientdata.type = data['type'] ?? 'Покупка стройматериалов';
      }
      else {
        print('Код ответа сервера: ' + response.statusCode.toString());
      };
    } catch (error) {
      print("Ошибка при формировании списка: $error");
    }
  }

  @override
  void initState() {
    httpGetInfoObject().then((value) {
      setState(() {
      });
    });
    // TODO: implement initState
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Покупка стройматериалов'),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: <Widget>[_menuAppBar()],
        ),
        body: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              //crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Divider(),
                SingleSection(
                  title: 'Данные по объекту',
                  children: [
                    _CustomListTile(
                        title: recipientdata.clientNmame,
                        icon: Icons.man,
                        id: recipientdata.clientId),
                    _CustomListTile(
                        title: recipientdata.objectName,
                        icon: Icons.location_on_outlined,
                        id: ''),
                    _CustomListTile(
                        title: '№${recipientdata.dogNumber} от ${DateFormat('dd.MM.yyyy').format(recipientdata.dogDate)}',//InfoObject['address'],//ObjectData,  //infoObjectData['address'].toString()
                        icon: Icons.document_scanner,
                        id: ''),
                  ],
                ),
                Divider(),
                SingleSection(
                  title: 'Поставщик',
                  children: [
                    _CustomListTile(
                        title: recipientdata.contractorName,
                        icon: Icons.manage_accounts,
                        id: ''),
                  ],
                ),
                Divider(),
                SingleSection(
                  title: 'Аналитика и комментарий',
                  children: [
                    _CustomListTile(
                        title: recipientdata.analyticName,
                        icon: Icons.analytics,
                        id: ''),
                    _CustomListTile(
                        title: recipientdata.comment,
                        icon: Icons.comment_outlined,
                        id: ''),
                  ],
                ),
                Divider(),
                SingleSection(
                  title: 'Суммы',
                  children: [
                    _CustomListTile(
                        title: "Сумма за материалы",
                        trailing: Text(recipientdata.summaClient.toString(), style: MyTextStyle()),
                        icon: Icons.attach_money,
                        id: ''),
                    if (recipientdata.summaClient!=recipientdata.summaOrg)
                    _CustomListTile(
                        title: "Сумма факт",
                        trailing: Text(recipientdata.summaOrg.toString(), style: MyTextStyle()),
                        icon: Icons.attach_money,
                        id: ''),
                    if (recipientdata.summa!=recipientdata.summaOrg)
                    _CustomListTile(
                        title: "Списать деньги",
                        trailing: Text(recipientdata.summa.toString(), style: MyTextStyle()),
                        icon: Icons.attach_money,
                        id: ''),
                    _CustomListTile(
                        title: '${(recipientdata.kassaType==0) ? recipientdata.kassaName : (recipientdata.kassaType==1) ? recipientdata.kassaSotrName : 'Без списния'}',
                        icon: Icons.payment_outlined,
                        id: '')
                  ],
                )
              ],
            )

          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async{
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => scrReceiptEditScreen(receiptData: recipientdata,)));
            setState(() {
              widget.event.summaDown = recipientdata.summa;
              widget.event.summa = -recipientdata.summa;
              widget.event.comment = recipientdata.comment;
            });
          },
          child: Icon(Icons.edit),
        )
      //backgroundColor: Colors.grey[900]),
    );
  }

  PopupMenuButton<Menu> _menuAppBar() {
    return PopupMenuButton<Menu>(
        icon: const Icon(Icons.menu, ),
        offset: const Offset(0, 40),
        onSelected: (Menu item) async {
          if (item == Menu.itemEdit) {
            await Navigator.push(context, MaterialPageRoute(builder: (context) => scrReceiptEditScreen(receiptData: recipientdata,)));
            setState(() {

            });
          }
          if (item == Menu.itemDelete) {
            httpEventDelete(widget.id, recipientdata.del, context).then((value) {
              userDataEdit = value;
              print('userDataEdit = $value');
              if (userDataEdit==true) {
                recipientdata.del=!recipientdata.del;
                Navigator.pop(context);
              }
            });
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
          const PopupMenuItem<Menu>(
            value: Menu.itemEdit,
            child: Text('Редактировать'),
          ),
          const PopupMenuItem<Menu>(
            value: Menu.itemDelete,
            child: Text('Удалить'),
          ),
        ].toList());
  }

}

enum Menu { itemEdit, itemDelete }

MyTextStyle() {
  return TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.red);
}

class _CustomListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? trailing;
  final String id;

  const _CustomListTile(
      {Key? key, required this.title, required this.icon, this.trailing, required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title ?? 'ggg'),
      leading: Icon(icon),
      trailing: trailing,
      onTap: () {
        if (id != '') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => scrProfileMan(id: id,)));
        }
      },
    );
  }

}

