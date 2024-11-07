import 'dart:convert';

import 'package:flutter/material.dart';
//import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';
import 'package:intl/intl.dart';
import 'package:repairmodule/components/Cards.dart';
import 'package:repairmodule/components/SingleSelections.dart';
import 'package:repairmodule/models/ListWorks.dart';
import 'package:repairmodule/models/Lists.dart';
import 'package:http/http.dart' as http;
import 'package:repairmodule/screens/pdf2.dart';
import 'package:repairmodule/screens/works_edit.dart';


class scrAktViewScreen extends StatefulWidget {
  final Akt akt;

  scrAktViewScreen(this.akt);

  @override
  State<scrAktViewScreen> createState() => _scrAktViewScreenState();
}

class _scrAktViewScreenState extends State<scrAktViewScreen> {
  int priceDefault=1;
  List<Works> ListWorks = [];
  List<Works> filteredListWorks = [];
  List<Works> ListWorksTitle = [];
  var myObjects = [];

  Future httpGetInfoObject() async {
    final _queryParameters = {'userId': Globals.anPhone, 'dogId': widget.akt.dogId};

    var _url=Uri(path: '${Globals.anPath}aktinfo/${widget.akt.id}/', host: Globals.anServer, scheme: 'https', queryParameters: _queryParameters);
    print(_url.path);
    print(Globals.anAuthorization);
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': Globals.anAuthorization
    };
    try {
      var response = await http.get(_url, headers: _headers);
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        print(response.body.toString());
        //widget.akt = Akt.fromJson(json.decode(response.body));
        widget.akt.summa = json.decode(response.body)['summa'];
        widget.akt.seb = json.decode(response.body)['seb'];
        widget.akt.number = json.decode(response.body)['number'];
        //widget.akt.date = json.decode(response.body)['date'];

        var notesJson = json.decode(response.body)['sost'];
        for (var noteJson in notesJson) {
          ListWorks.add(Works.fromJson(noteJson));
          if (noteJson['parentId']==null)
            ListWorksTitle.add(Works.fromJson(noteJson));
        }
      }
      else
        throw 'Код ответа: ${response.statusCode.toString()}. Ответ: ${response.body}';
    } catch (error) {
      print("Ошибка при формировании списка: $error");
    }
  }

  @override
  void initState() {
    if (Globals.anUserRoleId!=3)
      priceDefault=2;

    print('initState');
    ListWorks.clear();
    ListWorksTitle.clear();

    httpGetInfoObject().then((value) {
      setState(() {
      });
    });
    // TODO: implement initState
    super.initState();
  }
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Акт'),
          bottom: TabBar(tabs: [
            Tab(icon: Row(children:[Icon(Icons.hardware_outlined), Text('Работы')]), iconMargin: EdgeInsets.zero),
            Tab(icon: Row(children:[Icon(Icons.format_list_bulleted), Text('Основное')]), iconMargin: EdgeInsets.zero),
          ], isScrollable: true,),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: <Widget>[_menuAppBar()],
        ),
          body: TabBarView(children: <Widget> [
            _pageWork(),
            _pageGeneral()
          ]),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              var _res = await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                  scrWorksEditScreen(widget.akt.id, 2, widget.akt.dogId,
                      widget.akt.additionalWork, priceDefault)));
              if (_res!=null) {
                widget.akt.id = _res;
                initState();
              }
            },
            child: Icon(Icons.edit),
        )

      ),
    );
  }

  List<Widget> _generateChildrens(event) {
    var widgetList = <Widget>[];

     var value = event.workId;

     var _filtered = ListWorks.where((element) => element.parentId!.toLowerCase()==(value.toLowerCase())).toList();

    for (var str in _filtered) {
      //print(str);
      if (str.isFolder != true)
        widgetList.add(
          ListTile(
            title: Text(str.workName ?? ''),
            trailing: Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 0).format((priceDefault==1) ? str.summa : str.summaSub), style: TextStyle(fontSize: 16, color: (priceDefault==1) ? Colors.green : Colors.red)),
            subtitle: Text('Цена: ${(priceDefault==1) ? str.price.toString() : str.priceSub.toString()}; Кол-во: ${str.kol}', style: TextStyle(fontStyle: FontStyle.italic),),
          )
        );
      else
        widgetList.add(ExpansionTile(
          title: Text(str.workName.toString()),
          //leading: Container(child: Text(str.workName ?? '', style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),), width: 200,),
          subtitle: Text('Сумма: ${NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 0).format((priceDefault==1) ? str.summa : str.summaSub)}', style: TextStyle(fontWeight: FontWeight.w700, fontStyle: FontStyle.italic)),
          children: _generateChildrens(str),
        ),
        );
    }

    return widgetList;
  }

  _pageGeneral(){
    return Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleHeader('Акт №${widget.akt.number} от ${DateFormat('dd.MM.yyyy').format(widget.akt.date)}'),
        Divider(),
        titleHeader('Суммы'),
        ListTile(minVerticalPadding: 1,
          title: Text('Сумма для клиента'),
          trailing: Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(widget.akt.summa), style: TextStyle(fontSize: 16)),
        ),
        ListTile(minVerticalPadding: 1,
          title: Text('Сумма мастерам'),
          trailing: Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(widget.akt.seb), style: TextStyle(fontSize: 16)),
        ),
        ListTile(minVerticalPadding: 1,
          title: Text('Разница'),
          trailing: Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(widget.akt.summa-widget.akt.seb), style: TextStyle(fontSize: 16)),
        ),
        Divider(),
        Card(
          child: ListTile(
            title: Text('Открыть акт в PDF'),
            leading: Icon(Icons.calculate),
            trailing: Icon(Icons.navigate_next),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => PDFViewerFromUrl(url: 'https://ace:AxWyIvrAKZkw66S7S0BO@${Globals.anServer}${Globals.anPath}print/${widget.akt.id}/3/',)));
            },
          ),
        )
      ],
    );
  }

  _pageWork() {
    return ListView.builder(
      padding: EdgeInsets.all(10),
      physics: BouncingScrollPhysics(),
      reverse: false,
      itemCount: ListWorksTitle.length,
      itemBuilder: (_, index) => Card(
        child:
        ExpansionTile(
          title: Text(ListWorksTitle[index].workName ?? 'dd'),
          children: //<Widget>[
          _generateChildrens(ListWorksTitle[index]),
        ),
      ),
    );
  }

  PopupMenuButton<MenuSelectPrice> _menuAppBar() {
    return PopupMenuButton<MenuSelectPrice>(
        icon: const Icon(Icons.menu, ),
        offset: const Offset(0, 40),
        onSelected: (MenuSelectPrice item) async {
          if (item == MenuSelectPrice.itemPriceOpt) {
            priceDefault = 2;
          }
          if (item == MenuSelectPrice.itemPriceRozn) {
            priceDefault = 1;
          }
          setState(() {

          });
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuSelectPrice>>[
           PopupMenuItem<MenuSelectPrice>(
            value: MenuSelectPrice.itemPriceRozn,
            child: Row(
              children: [
                if (priceDefault==1)
                  Icon(Icons.check)
                else
                  SizedBox(width: 24,),
                Text(' Цены клиента'),
              ],
            ),
          ),
           PopupMenuItem<MenuSelectPrice>(
            value: MenuSelectPrice.itemPriceOpt,
            child: Row(
              children: [
                if (priceDefault==2)
                  Icon(Icons.check)
                else
                  SizedBox(width: 24,),
                Text(' Цены мастеров'),
              ],
            ),
          ),
        ].toList());
  }

}

enum MenuSelectPrice { itemPriceRozn, itemPriceOpt }