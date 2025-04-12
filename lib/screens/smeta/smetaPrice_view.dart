
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:repairmodule/models/ListWorks.dart';
import 'package:repairmodule/models/Lists.dart';
import 'package:repairmodule/models/httpRest.dart';
import 'package:repairmodule/screens/smeta/smetaWork_editing.dart';
import 'package:repairmodule/screens/work_editing.dart';




class scrSmetaPriceViewScreen extends StatefulWidget {
  final String smetaId;
  final List <Works> works;
  final List <Works> priceWorkList;
  final String parentId;
  final String parentName;
  final String roomId;
  final SmetaAllWork smetaAllWork;
  final bool additionalWork;
  final int type;


  scrSmetaPriceViewScreen(this.smetaId, this.works, this.priceWorkList, this.parentId, this.parentName, this.roomId, this.smetaAllWork, this.additionalWork, this.type);

  @override
  State<scrSmetaPriceViewScreen> createState() => _scrSmetaPriceViewScreenState();
}

class _scrSmetaPriceViewScreenState extends State<scrSmetaPriceViewScreen> {
  List <Works> filtered_works = [];
  bool _isLoad = true;
  bool _isActive=false;


  @override
  void initState() {
    _findList(widget.parentId, widget.roomId, '');
    // TODO: implement initState
    super.initState();
  }
  Widget build(BuildContext context) {
    print(widget.parentId);
    print(widget.parentName);
    return Scaffold(
      appBar: AppBar(
        title: _SearchBar(), //Text('${widget.parentName}'),
        centerTitle: true,
        actions:     (widget.type==1 || widget.parentId=='00000000-0000-0000-0000-000000000000') ? null : <Widget>[_menuAppBar()],
      ),
        body: (_isLoad==false) ? Center(child: CircularProgressIndicator()) : ListView.builder(
          padding: EdgeInsets.all(10),
          physics: BouncingScrollPhysics(),
          reverse: false,
          itemCount: filtered_works.length,
            itemBuilder: (_, index) {
              return Card(
                child: ListTile(
                  title: Text(filtered_works[index].workName ?? '00', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18)),
                  trailing: _workTrailing(filtered_works[index]), //(filtered_works[index].isFolder!) ? Icon(Icons.navigate_next) : Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(filtered_works[index].summa), style: TextStyle(fontSize: 16)),
                  subtitle: (filtered_works[index].isFolder!) ? null : Text('Кол-во: ${filtered_works[index].kol}; Сумма: ${NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format((widget.smetaAllWork.priceDefault==1) ? filtered_works[index].summa : filtered_works[index].summaSub)}', style: TextStyle(fontStyle: FontStyle.italic, color: _colors(filtered_works[index].kol)),),
                  onTap: () async {
                    if (filtered_works[index].isFolder!) {
                      await Navigator.push(context, MaterialPageRoute(builder: (context) => scrSmetaPriceViewScreen(widget.smetaId, widget.works, widget.priceWorkList, filtered_works[index].workId!, filtered_works[index].workName!, filtered_works[index].roomId!, widget.smetaAllWork, true, widget.type)));
                      _findList(widget.parentId, widget.roomId, '');
                    }
                    else {
                      await Navigator.push(context, MaterialPageRoute(builder: (context) => scrWorkEditingScreen(filtered_works[index], widget.additionalWork)));
                      setState(() {

                      });
                    }
                  },
                ),
              );

            },
          ),
          floatingActionButton: (Globals.anCreateObject==false) ? null : FloatingActionButton(
            onPressed: () async {
              widget.smetaAllWork.allPrice = !widget.smetaAllWork.allPrice;
              _findList(widget.parentId, widget.roomId, '');
            },
            child: (widget.smetaAllWork.allPrice) ? Text('-') : Text('+'),)
          //backgroundColor: Colors.grey[900]),
    );


  }

  void _findList(parentId, roomId, _filter) {
    if (roomId=='00000000-0000-0000-0000-000000000000') {
      setState(() {
        filtered_works = widget.works.where((element) => element.parentId!.toLowerCase().contains(parentId.toLowerCase()) && (element.kol ?? 0)>((widget.smetaAllWork.allPrice==true) ? -1 : 0)).toList();
      });
    }
    else {
      setState(() {
        filtered_works = widget.works.where((element) => element.roomId!.toLowerCase().contains(roomId.toLowerCase()) && element.parentId!.toLowerCase().contains(parentId.toLowerCase()) && (element.kol ?? 0)>((widget.smetaAllWork.allPrice==true) ? -1 : 0)).toList();
      });
    }
    if (_filter!='') {
      List <Works> filtered_works2=[];
      filtered_works2 = filtered_works.where((element) => element.workName!.toLowerCase().contains(_filter.toLowerCase())).toList();
      filtered_works = filtered_works2;
    }
  }

  _workTrailing(Works _work) {
    return (_work.isFolder!) ? Icon(Icons.navigate_next) :
    Checkbox(value: (_work.kol==0) ? false : true, onChanged: (value) {
      setState(() {
        if (value==true){
          _work.kol=_work.kolRemains;
        }
        else {
          _work.kol=0;
        }
        _work.summa = _work.kol! * (_work.price ?? 0);
        _work.summaSub = _work.kol! * (_work.priceSub ?? 0);
      });
    });
  }

  _colors(kol) {

    if (kol==0)
      return Colors.blueGrey;
    if (widget.smetaAllWork.priceDefault==1)
      return Colors.green.shade800;
    else
      return Colors.red.shade800;
  }

  PopupMenuButton<MenuEditWorks> _menuAppBar() {
    return PopupMenuButton<MenuEditWorks>(
        icon: const Icon(Icons.menu, ),
        offset: const Offset(0, 40),
        onSelected: (MenuEditWorks item) async {
          if (item == MenuEditWorks.itemWorkAdd) {
            setState(() {
              _isLoad = false;
            });

            print('smetaId=${widget.smetaId}');
            print('roomId=${widget.roomId}');
            print('parentId=${widget.parentId}');

            if (widget.priceWorkList.length==0) {
              await httpGetSmetaRoomWorks(widget.smetaId, widget.roomId, widget.priceWorkList);
            }
            setState(() {
              _isLoad = true;
            });

            await _workAddRecursion(widget.priceWorkList, widget.parentId);
            _findList(widget.parentId, widget.roomId, '');

          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuEditWorks>>[
          const PopupMenuItem<MenuEditWorks>(
            value: MenuEditWorks.itemWorkAdd,
            child: Text('Добавить доп работу'),
          ),
        ].toList());
  }

  _workAddRecursion(_priceWorkList, _parentId) {
    List <Works> priceFilteredWorkList = [];
    print('Количество работ к добавлению1 ${_priceWorkList.length}');
    priceFilteredWorkList = _priceWorkList.where((element) => element.roomId!.toLowerCase().contains(widget.roomId.toLowerCase()) && element.parentId!.toLowerCase().contains(_parentId.toLowerCase()) && (element.kolSmeta ?? 0)==0  && (element.kol ?? 0)==0).toList();
    print('Количество работ к добавлению2 ${priceFilteredWorkList.length}');
    for (var noteJson3 in priceFilteredWorkList) {
      var _uniqueWork = widget.works.where((element) => element.workId!.toLowerCase().contains(noteJson3.workId!.toLowerCase()));
      if (_uniqueWork.length==0) {
        widget.works.add(noteJson3);
        filtered_works.add(noteJson3);
        if (noteJson3.isFolder!)
          _workAddRecursion(_priceWorkList, noteJson3.workId);
      }
    }
    widget.smetaAllWork.allPrice=true;

  }

  _SearchBar() {
    return Row(
      children: [
        if (!_isActive)
          Text(widget.parentName, style: Theme.of(context).appBarTheme.titleTextStyle),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: AnimatedSize(
              duration: const Duration(milliseconds: 250),
              child: (_isActive==true)
                  ? Container(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.white30,
                    borderRadius: BorderRadius.circular(4.0)),
                child: TextField(autofocus: true,
                  decoration: InputDecoration(
                      hintText: 'Введите строку для поиска',

                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isActive = false;
                              _findList(widget.parentId, widget.roomId, '');
                              print('Сбросили фильтр');
                            });
                          },
                          icon: const Icon(Icons.close))),
                  onChanged: (value) {
                    _findList(widget.parentId, widget.roomId, value);
                  },
                ),
              )
                  : IconButton(
                  onPressed: () {
                    setState(() {
                      _isActive = true;
                    });
                  },
                  icon: const Icon(Icons.search)),
            ),
          ),
        ),
      ],
    );
  }

}

enum MenuEditWorks { itemWorkAdd }