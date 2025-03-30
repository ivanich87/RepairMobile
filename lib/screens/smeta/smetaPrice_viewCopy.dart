
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:repairmodule/models/ListWorks.dart';
import 'package:repairmodule/models/Lists.dart';




class scrSmetaPriceViewCopyScreen extends StatefulWidget {
  final List <Works> works;
  final String parentId;
  final String parentName;
  SmetaAllWork smetaAllWork;

  scrSmetaPriceViewCopyScreen(this.works, this.parentId, this.parentName, this.smetaAllWork);

  @override
  State<scrSmetaPriceViewCopyScreen> createState() => _scrSmetaPriceViewCopyScreenState();
}

class _scrSmetaPriceViewCopyScreenState extends State<scrSmetaPriceViewCopyScreen> {
  List <Works> filtered_works = [];

  @override
  void initState() {
    _findList(widget.parentId);
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
                        trailing: (filtered_works[index].isFolder!) ? Icon(Icons.navigate_next) : Text(NumberFormat.decimalPatternDigits(locale: 'ru-RU', decimalDigits: 2).format(filtered_works[index].summa), style: TextStyle(fontSize: 16)),
                        onTap: () async {
                          if (filtered_works[index].isFolder!) {
                            await Navigator.push(context, MaterialPageRoute(builder: (context) => scrSmetaPriceViewCopyScreen(widget.works, filtered_works[index].workId!, filtered_works[index].workName!, widget.smetaAllWork)));
                            _findList(widget.parentId);
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
              _findList(widget.parentId);
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

  void _findList(value) {
    setState(() {
      filtered_works = widget.works.where((element) => element.parentId!.toLowerCase().contains(value.toLowerCase()) && (element.kol ?? 0)>((widget.smetaAllWork.allPrice==true) ? -1 : 0)).toList();
    });
  }

}

