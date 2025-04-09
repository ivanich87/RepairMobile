
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:repairmodule/models/ListWorks.dart';
import 'package:repairmodule/models/Lists.dart';
import 'package:repairmodule/screens/smeta/smetaWork_editing.dart';




class scrSmetaPriceViewScreen extends StatefulWidget {
  final List <Works> works;
  final String parentId;
  final String parentName;
  final String roomId;
  final SmetaAllWork smetaAllWork;

  scrSmetaPriceViewScreen(this.works, this.parentId, this.parentName, this.roomId, this.smetaAllWork);

  @override
  State<scrSmetaPriceViewScreen> createState() => _scrSmetaPriceViewScreenState();
}

class _scrSmetaPriceViewScreenState extends State<scrSmetaPriceViewScreen> {
  List <Works> filtered_works = [];

  @override
  void initState() {
    _findList(widget.parentId, widget.roomId);
    // TODO: implement initState
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.parentName}'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.menu))
        ],
      ),
        body: Column(
          children: [
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
                        onTap: () async {
                          if (filtered_works[index].isFolder!) {
                            await Navigator.push(context, MaterialPageRoute(builder: (context) => scrSmetaPriceViewScreen(widget.works, filtered_works[index].workId!, filtered_works[index].workName!, filtered_works[index].roomId!, widget.smetaAllWork)));
                            _findList(widget.parentId, widget.roomId);
                          }
                          else {
                            await Navigator.push(context, MaterialPageRoute(builder: (context) => scrSmetaWorkEditingScreen(filtered_works[index], true)));
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
              widget.smetaAllWork.allPrice = !widget.smetaAllWork.allPrice;
              _findList(widget.parentId, widget.roomId);
              // final newObjectId = await Navigator.push(context, MaterialPageRoute(builder: (context) => scrObjectCreateScreen(),)) ?? '';
              // if (newObjectId!='') {
              //   Navigator.push(context, MaterialPageRoute( builder: (context) => scrObjectsViewScreen(id: newObjectId)));
              //   initState();
              // }
            },
            child: (widget.smetaAllWork.allPrice) ? Text('-') : Text('+'),)
          //backgroundColor: Colors.grey[900]),
    );


  }

  void _findList(parentId, roomId) {
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

  }

}

_workTrailing(Works _work) {
    return (_work.isFolder!) ? Icon(Icons.navigate_next) :
    (_work.kol==0) ? Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(_work.summa), style: TextStyle(fontSize: 16)) :
    Column(mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(_work.summa), style: TextStyle(fontSize: 16)),
        Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(_work.kol), style: TextStyle(fontSize: 14)),
      ],
    );
}

