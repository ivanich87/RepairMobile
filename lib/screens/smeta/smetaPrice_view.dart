
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
  final List <Materials> materials;
  final String parentId;
  final String parentName;
  final String roomId;
  final SmetaAllWork smetaAllWork;
  final bool additionalWork;
  final int type;


  scrSmetaPriceViewScreen(this.smetaId, this.works, this.priceWorkList, this.materials, this.parentId, this.parentName, this.roomId, this.smetaAllWork, this.additionalWork, this.type);

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
        body: (_isLoad==false) ? Center(child: CircularProgressIndicator()) :
        Column(
          children: [
            ElevatedButton.icon(
              icon: (widget.smetaAllWork.allPrice) ? Icon(Icons.done_all, color: Colors.black) : Icon(Icons.add, color: Colors.black),
              label: _filterLabelText(),
              onPressed: () async {
                widget.smetaAllWork.allPrice = !widget.smetaAllWork.allPrice;
                _findList(widget.parentId, widget.roomId, '');
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(10),
                physics: BouncingScrollPhysics(),
                reverse: false,
                itemCount: filtered_works.length,
                  itemBuilder: (_, index) {
                    return Card(
                      child: ListTile(
                        title: Text(filtered_works[index].workName ?? '00', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18)),
                        trailing: _workTrailing(filtered_works[index]), //(filtered_works[index].isFolder!) ? Icon(Icons.navigate_next) : Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(filtered_works[index].summa), style: TextStyle(fontSize: 16)),
                        subtitle: _workSubtitle(filtered_works[index]), //(filtered_works[index].isFolder!) ? null : Text('Кол-во: ${filtered_works[index].kol}; Сумма: ${NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format((widget.smetaAllWork.priceDefault==1) ? filtered_works[index].summa : filtered_works[index].summaSub)}', style: TextStyle(fontStyle: FontStyle.italic, color: _colors(filtered_works[index].kol)),),
                        onTap: () async {
                          if (filtered_works[index].isFolder!) {
                            var _CloseParam = await Navigator.push(context, MaterialPageRoute(builder: (context) => scrSmetaPriceViewScreen(widget.smetaId, widget.works, widget.priceWorkList, widget.materials, filtered_works[index].workId!, filtered_works[index].workName!, filtered_works[index].roomId!, widget.smetaAllWork, true, widget.type)));
                            if (_CloseParam.toString()=='CloseAll')
                              Navigator.pop(context, 'CloseAll');
                            else
                            _findList(widget.parentId, widget.roomId, '');
                          }
                          else {
                            if (widget.type==1){
                              await Navigator.push(context, MaterialPageRoute(builder: (context) => scrSmetaWorkEditingScreen(filtered_works[index], _filterMaterials(filtered_works[index].workId), widget.additionalWork)));
                              _parentAddRecursion(filtered_works[index].parentId);
                            }
                            else
                              await Navigator.push(context, MaterialPageRoute(builder: (context) => scrWorkEditingScreen(filtered_works[index], widget.additionalWork)));
                            setState(() {

                            });
                          }
                        },
                      ),
                    );

                  },
                ),
            ),
          ],
        ),
          floatingActionButton: (Globals.anCreateObject==false) ? null : FloatingActionButton(
            onPressed: () async {
              bool _res = await httpObjectUpdateWorks(widget.smetaAllWork, widget.smetaId, widget.type, widget.works, widget.materials);
              if (_res)
                Navigator.pop(context, 'CloseAll');
              else {
                final snackBar = SnackBar(
                  content: Text('Ошибка при сохранении работ'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
              //widget.smetaAllWork.allPrice = !widget.smetaAllWork.allPrice;
              //_findList(widget.parentId, widget.roomId, '');
            },
            child: Icon(Icons.save))
          //backgroundColor: Colors.grey[900]),
    );


  }

  void _findList(parentId, roomId, _filter) {
    if (_filter!='') {
      setState(() {
      filtered_works = widget.works.where((element) => element.workName!.toLowerCase().contains(_filter.toLowerCase())).toList();
      });
    }
    else {
      if (roomId == '00000000-0000-0000-0000-000000000000') {
        setState(() {
          filtered_works = widget.works.where((element) => element.parentId!.toLowerCase().contains(parentId.toLowerCase()) && ((widget.type==1) ? (element.kol ?? 0) : (element.kolRemains ?? 0)) > ((widget.smetaAllWork.allPrice == true) ? -1 : 0)).toList();
        });
      }
      else {
        setState(() {
          filtered_works = widget.works.where((element) => element.roomId!.toLowerCase().contains(roomId.toLowerCase()) && element.parentId!.toLowerCase().contains(parentId.toLowerCase()) && ((widget.type==1) ? (element.kol ?? 0) : (element.kolRemains ?? 0)) > ((widget.smetaAllWork.allPrice == true) ? -1 : 0)).toList();
        });
      }
    }
  }

  _filterMaterials(_workId) {
    return widget.materials.where((element) => element.workId!.toLowerCase().contains(_workId.toLowerCase())).toList();
  }

  _filterLabelText() {
    if (widget.type==1)
      return (widget.smetaAllWork.allPrice) ? Text('Оставить только выбранные') : Text('Показать весь прайс');
    else
      return (widget.smetaAllWork.allPrice) ? Text('Оставить только не выполненные') : Text('Показать все работы по смете');
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

        num _sumMaterial = 0;
        num _sebMaterial = 0;
        for (Materials str in _filterMaterials(_work.workId)) {
          str.kol = (_work.kol ?? 0) * (str.consumption ?? 0);
          str.summa = (str.price ?? 0) * (str.kol ?? 0);
          str.summaSeb = (str.priceSeb ?? 0) * (str.kol ?? 0);
          _sumMaterial = _sumMaterial + (str.summa ?? 0);
          _sebMaterial = _sebMaterial + (str.summaSeb ?? 0);
        }
        _work.materialSumma = _sumMaterial;
        _work.materialSummaSeb = _sebMaterial;
      });
    });
  }

  _workSubtitle(Works _work) {
    if (_isActive) {
      if (_work.isFolder ?? false) {
        if (widget.type==1)
          return Text(_work.parentName ?? '');
        else
          return Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [Text(_work.roomName ?? ''), Text(_work.parentName ?? '')],);
      }
      else {
        return Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.type!=1)
              Text(_work.roomName ?? ''),
            Text(_work.parentName ?? ''),
            Text('Кол-во: ${_work.kol}; Сумма: ${NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format((widget.smetaAllWork.priceDefault==1) ? _work.summa : _work.summaSub)}', style: TextStyle(fontStyle: FontStyle.italic, color: _colors(_work.kol)),),
            Text('Материалы cумма: ${NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format((widget.smetaAllWork.priceDefault==1) ? _work.materialSumma : _work.materialSummaSeb)}', style: TextStyle(fontStyle: FontStyle.italic, color: _colors(_work.kol)),)
          ],
        );
      }
    }
    else {
      return (_work.isFolder!) ? null :
        Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Кол-во: ${_work.kol}; Сумма: ${NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format((widget.smetaAllWork.priceDefault==1) ? _work.summa : _work.summaSub)}', style: TextStyle(fontStyle: FontStyle.italic, color: _colors(_work.kol)),),
            if ((_work.materialSumma ?? 0)>0)
              Text('Сумма материалов: ${NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format((widget.smetaAllWork.priceDefault==1) ? (_work.materialSumma ?? 0) : (_work.materialSummaSeb ?? 0))}', style: TextStyle(fontStyle: FontStyle.italic, color: _colors(_work.kol)),)
          ],
        );
    }
    return null;

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
              await httpGetSmetaRoomWorks(widget.smetaId, widget.roomId, widget.priceWorkList, widget.materials);
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

  _parentAddRecursion(_parentId) {
    List <Works> priceFilteredWorkList = [];
    print('Количество работ к добавлению1 ');
    priceFilteredWorkList = widget.works.where((element) => element.workId!.toLowerCase().contains(_parentId.toLowerCase())).toList();
    print('Количество работ к добавлению2 ${priceFilteredWorkList.length}');
    for (var noteJson3 in priceFilteredWorkList) {
      noteJson3.kol=1;
      noteJson3.kolRemains=1;
      _parentAddRecursion(noteJson3.parentId);
    }
  }

  _SearchBar() {
    return Row(
      children: [
        if (!_isActive)
          Expanded(flex: 5,  child: Text(widget.parentName, style: Theme.of(context).appBarTheme.titleTextStyle)),
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
                    color: Colors.white,
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