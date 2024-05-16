import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:repairmodule/components/SingleSelections.dart';
import 'package:repairmodule/screens/profileMan.dart';
import 'package:repairmodule/models/Lists.dart';
import 'package:repairmodule/screens/object_view.dart';
import 'package:repairmodule/screens/plat_edit.dart';

class scrPlatsViewScreen extends StatefulWidget {
  //final String id;
  final ListPlat plat;
  scrPlatsViewScreen({super.key, required this.plat});

  @override
  State<scrPlatsViewScreen> createState() => _scrPlatsViewScreenState();
}

class _scrPlatsViewScreenState extends State<scrPlatsViewScreen> {
  String address = 'no address';
  String name = 'no name';

  //String id = 'no id';
  String nameClient = 'no nameClient';
  String idClient = 'no idClient';
  String nameManager = 'no nameManager';
  String idManager = 'no idManager';
  String nameProrab = 'no nameProrab';
  String idProrab = 'no idProrab';
  String startDate = '20010101';
  String stopDate = '20010101';
  int summa = 0;
  int summaSeb = 0;
  int summaAkt = 0;
  int percent = 0;
  int payment = 0;
  int area = 0;


  Future httpGetInfoObject() async {
    var _url=Uri(path: '/a/centrremonta/hs/v1/0/', host: 's1.rntx.ru', scheme: 'https');
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': 'Basic YWNlOkF4V3lJdnJBS1prdzY2UzdTMEJP'
    };
    try {
      var response = await http.get(_url, headers: _headers);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        //id = data['id'] ?? 'no id';
        name = data['nameObject'] ?? 'no name';
        nameClient = data['nameClient'] ?? 'no nameClient';
        idClient = data['idClient'] ?? 'no idClient';
        nameManager = data['nameManager'] ?? 'no nameManager';
        idManager = data['idManager'] ?? 'no idManager';
        nameProrab = data['nameProrab'] ?? 'no nameProrab';
        idProrab = data['idProrab'] ?? 'no idProrab';
        address = data['address'] ?? 'no address';

        startDate = DateFormat('dd-MM-yyyy').format(DateTime.parse(data['StartDate']));
        stopDate = DateFormat('dd-MM-yyyy').format(DateTime.parse(data['StopDate']));

        final a = double.parse(data['area'].toString());
        area = a.toInt();

        final s = double.parse(data['СуммыДоговоров'].toString());
        summa = s.toInt();

        final s2 = double.parse(data['СуммаСебестоимость'].toString());
        summaSeb = s2.toInt();

        final s3 = double.parse(data['СуммаАктов'].toString());
        summaAkt = s3.toInt();

        final s4 = double.parse(data['ПроцентВыполнения'].toString());
        percent = s4.toInt();

        final s5 = double.parse(data['ПроцентВыполнения'].toString());
        payment = s5.toInt();
      };
    } catch (error) {
      print("Ошибка при формировании списка: $error");
    }
  }

  @override
  // void initState() {
  //   httpGetInfoObject().then((value) {
  //     setState(() {
  //     });
  //   });
  //   // TODO: implement initState
  //   super.initState();
  // }
  Widget build(BuildContext context) {
    print('Идентификатор платежа: ${widget.plat.id}');
    return Scaffold(
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
                        widget.plat.name,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '№ ${widget.plat.number} от ${DateFormat('dd.MM.yyyy').format(widget.plat.date)}',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Divider(),
                _payer(widget: widget,),
                Divider(),
                if (widget.plat.objectName!='')
                SingleSection(
                  title: 'Сведения об объекте',
                  children: [
                    _CustomListTile(
                        title: 'Договор № ${widget.plat.dogNumber} от ${DateFormat('dd.MM.yyyy').format(widget.plat.dogDate)}',
                        icon: Icons.paste_rounded,
                        id: '',
                        idType: ''),
                    _CustomListTile(
                        title: 'Объект: ${widget.plat.objectName}',
                        icon: Icons.location_on_outlined,
                        id: widget.plat.objectId,
                        idType: 'scrObjectsViewScreen'),
                  ],
                ),
                if (widget.plat.objectName!='')
                Divider(),
                _recipient(widget: widget,),
                Divider(),
                SingleSection(
                  title: 'Аналитика и комментарий',
                  children: [
                    if (widget.plat.platType!='Перемещение' && widget.plat.type!='Выдача денежных средств в подотчет')
                    _CustomListTile(
                        title: "${widget.plat.analyticName}",
                        icon: Icons.analytics,
                        id: '',
                        idType: ''),
                    _CustomListTile(
                        title: widget.plat.comment,
                        icon: Icons.comment_outlined,
                        id: '',
                        idType: ''),
                  ],
                ),
                Text('${widget.plat.summa} руб.', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: (widget.plat.summa>=0) ? Colors.green : Colors.red))
              ],
            )

          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async{
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => scrPlatEditScreen(plat2: widget.plat,)));
            setState(() {

            });
          },
          child: Icon(Icons.edit),
        )
      //backgroundColor: Colors.grey[900]),
    );
  }
}

class _CustomListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? trailing;
  final String id;
  final String idType;

  const _CustomListTile(
      {Key? key, required this.title, required this.icon, this.trailing, required this.id, required this.idType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title ?? 'ggg'),
      leading: Icon(icon),
      trailing: trailing,
      onTap: () {
        if (id != '') {
          print(id);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) {
                    if (idType=='scrProfileMan') {
                      return scrProfileMan(id: id,);
                    };
                    if (idType=='scrObjectsViewScreen') {
                      return scrObjectsViewScreen(id: id,);
                    };
                    return scrProfileMan(id: id,);
                  } ));
        }
      },
    );
  }

}

class _payer extends StatelessWidget {
  final widget;
  const _payer(
      {Key? key, this.widget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (widget.plat.platType!='Приход') {
      return SingleSection(
        title: 'Сведения о плательщике',
        children: [
          _CustomListTile(
              title: '${widget.plat.kassa}',
              icon: (widget.plat.kassaType == 1
                  ? Icons.account_balance_wallet
                  : Icons.credit_card),
              id: (widget.plat.kassaType == 1 ? widget.plat.kassaSotrId : ''),
              idType: 'scrProfileMan'),
          if (widget.plat.companyName!='')
          _CustomListTile(
              title: '${widget.plat.companyName}',
              icon: Icons.account_balance,
              id: '',
              idType: ''),
          ],
        );
      };
    return SingleSection(
          title: 'Сведения о плательщике',
          children: [
            _CustomListTile(
                title: (widget.plat.type=='Выдача денежных средств в подотчет') ? widget.plat.kassaSotrName : widget.plat.contractorName,
                icon: Icons.man,
                id: '',
                idType: '')
          ]
      );
  }

}

class _recipient extends StatelessWidget {
  final widget;
  const _recipient(
      {Key? key, this.widget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (widget.plat.platType=='Приход') {
      return SingleSection(
        title: 'Сведения о получателе',
        children: [
          _CustomListTile(
              title: '${widget.plat.kassaName}', //было widget.plat.kassa
              icon: (widget.plat.kassaType == 1
                  ? Icons.account_balance_wallet
                  : Icons.credit_card),
              id: (widget.plat.kassaType == 1 ? widget.plat.kassaSotrId : ''),
              idType: 'scrProfileMan'),
          if (widget.plat.companyName!='')
          _CustomListTile(
              title: '${widget.plat.companyName}',
              icon: Icons.account_balance,
              id: '',
              idType: ''),
        ],
      );
    }
    return SingleSection(
        title: 'Сведения о получателе',
        children: [
          _CustomListTile(
              title: (widget.plat.type=='Выдача денежных средств в подотчет') ? widget.plat.kassaSotrName : widget.plat.contractorName,
              icon: Icons.man,
              id: '',
              idType: '')
        ]
    );
  }

}

