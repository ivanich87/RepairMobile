
import 'package:flutter/material.dart';
import 'package:repairmodule/models/Lists.dart';
import 'package:repairmodule/screens/ReceiptEdit.dart';
import 'package:repairmodule/screens/sprList.dart';



class scrCashListFindScreen extends StatefulWidget {

  filtered filter;

  scrCashListFindScreen({required this.filter});

  @override
  State<scrCashListFindScreen> createState() => _scrCashListFindScreenState();
}

class _scrCashListFindScreenState extends State<scrCashListFindScreen> {
  String _selectedItem='';
  String idType = '';
  String id = '';
  final List<String> _countries = [
    'Приход',
    'Расход'
  ];

  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text('Фильтры'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            // ListTile(
            //   leading: Icon(Icons.dynamic_feed),
            //   title: Text(widget.filter.platType), //'Расход', 'Приход', 'Перемещение'
            //   trailing: Icon(Icons.navigate_next),
            //   onTap: () {
            //     _tripEditModalBottomSheet(_tripEditWidgetsPlatType(widget.filter));
            //   },
            // ),
            ListTile(
              leading: Icon(Icons.man),
              title: Text(widget.filter.kassaSortName),
              trailing: Icon(Icons.navigate_next),
              onTap: () async {
                print(Globals.anUserRoleId);
                if (Globals.anUserRoleId==3) {
                  idType = 'sprSotrListSelected';
                  id = 'КассыСотрудники';
                  _selectFiltered(id, idType);
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.credit_card),
              title: Text(widget.filter.cashName),
              trailing: Icon(Icons.navigate_next),
              onTap: () {
                idType = 'sprKassaListSelected';
                id = 'Кассы';
                _selectFiltered(id, idType);
              },
            ),
            ListTile(
              leading: Icon(Icons.analytics),
              title: Text(widget.filter.analyticName),
              trailing: Icon(Icons.navigate_next),
              onTap: () {
                idType = 'sprAnalyticsListSelected';
                id = 'АналитикаДвиженийДС';
                _selectFiltered(id, idType);
              },
            ),
            ListTile(
              leading: Icon(Icons.location_on_outlined),
              title: Text(widget.filter.objectName),
              trailing: Icon(Icons.navigate_next),
              onTap: () {
                idType = 'objectsListSelected';
                id = 'Объекты';
                _selectFiltered(id, idType);
              },
            ),
            Divider(),
            SizedBox(height: 30,),
            Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.check, color: Colors.black),
                  label: Text('Применить', style: TextStyle(color: Colors.black, fontSize: 14)),
                  onPressed: () {Navigator.pop(context);},
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton.icon(
                    icon: const Icon(Icons.clear, color: Colors.black),
                    label: const Text("Сбросить", style: TextStyle(color: Colors.black, fontSize: 14)),
                    onPressed: () async {
                      widget.filter.platType='';
                      widget.filter.kassaContractorId='';
                      widget.filter.kassaContractorName='Выберите контрагента';
                      widget.filter.objectName='Выберите объект';
                      widget.filter.objectId='';
                      widget.filter.analyticName='Выберите аналитику';
                      widget.filter.analytic='';
                      widget.filter.idCash='0';
                      widget.filter.cashName='Выберите кассу или банк';
                      if (Globals.anUserRoleId==3) {
                        widget.filter.kassaSortName='Выберите подотчетное лицо';
                        widget.filter.kassaSotrId='';
                      }
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  )

              ],
            )
          ],
        ),
    );

  }

  void _tripEditModalBottomSheet(Widget type) {
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

  _tripEditWidgetsPlatType(filtered filter) {
    GlobalKey _formKey = new GlobalKey<FormState>();

    final _style = ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.grey),
        shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
        minimumSize: WidgetStateProperty.all(Size(250, 40))
    );
    return Form(
      key: _formKey,
      //autovalidateMode: true,
      child:
      Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RadioListTile(title: Text('Приход'), value: 'Приход', groupValue: filter.platType, onChanged: (value){
          setState(() {
            filter.platType = value!;
          });
        }
        ),
        RadioListTile(title: Text('Расход'), value: 'Расход', groupValue: filter.platType, onChanged: (value) {
          setState(() {
            filter.platType = value!;
          });
        }
        ),
        RadioListTile(title: Text('Перемещение'), value: 'Перемещение', groupValue: filter.platType, onChanged: (value) {
          setState(() {
            filter.platType = value!;
          });

        }
        ),
        SizedBox(height: 20),
        Container(alignment: Alignment.center,
            child: ElevatedButton(onPressed: () {Navigator.pop(context);},
              child: Text('Сохранить'),
              style: _style,)),
      ],
    ),
    );
  }

  _selectFiltered(id, idType) async {
    var res = await Navigator.push(context, MaterialPageRoute(builder: (context) {return scrListScreen(sprName: id, onType: 'pop');} ));
    if (idType=='sprSotrListSelected'){
      setState(() {
        widget.filter.kassaSotrId = res.id;
        widget.filter.kassaSortName = res.name;
      });
    };
    if (idType=='sprKassaListSelected'){
      setState(() {
        widget.filter.idCash = res.id;
        widget.filter.cashName = res.name;
      });
    };
    if (idType=='sprAnalyticsListSelected'){
      setState(() {
        widget.filter.analytic = res.id;
        widget.filter.analyticName = res.name;
      });
    };
    if (idType=='objectsListSelected'){
      setState(() {
        widget.filter.objectId = res.id;
        widget.filter.objectName = res.name;
      });
    };
  }
}






class AutocompleteTextField extends StatefulWidget {
  final List<String> items;
  final Function(String) onItemSelect;
  final InputDecoration? decoration;
  final String? Function(String?)? validator;
  const AutocompleteTextField(
      {Key? key,
        required this.items,
        required this.onItemSelect,
        this.decoration,
        this.validator})
      : super(key: key);

  @override
  State<AutocompleteTextField> createState() => _AutocompleteTextFieldState();
}

class _AutocompleteTextFieldState extends State<AutocompleteTextField> {
  final FocusNode _focusNode = FocusNode();
  late OverlayEntry _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  late List<String> _filteredItems;

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _overlayEntry = _createOverlayEntry();
        Overlay.of(context)?.insert(_overlayEntry);
      } else {
        _overlayEntry.remove();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextFormField(
        controller: _controller,
        focusNode: _focusNode,
        onChanged: _onFieldChange,
        decoration: widget.decoration,
        validator: widget.validator,
      ),
    );
  }

  void _onFieldChange(String val) {
    setState(() {
      if (val == '') {
        _filteredItems = widget.items;
      } else {
        _filteredItems = widget.items
            .where(
                (element) => element.toLowerCase().contains(val.toLowerCase()))
            .toList();
      }
    });
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    return OverlayEntry(
        builder: (context) => Positioned(
          width: size.width,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(0.0, size.height + 5.0),
            child: Material(
              elevation: 4.0,
              child: Container(
                constraints: const BoxConstraints(maxHeight: 200),
                child: ListView.builder(
                  itemCount: _filteredItems.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = _filteredItems[index];
                    return ListTile(
                      title: Text(item),
                      onTap: () {
                        _controller.text = item;
                        _focusNode.unfocus();
                        widget.onItemSelect(item);
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ));
  }
}

