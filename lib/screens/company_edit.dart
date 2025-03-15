import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:repairmodule/components/GeneralFunctions.dart';
import 'package:repairmodule/components/SingleSelections.dart';
import 'package:repairmodule/models/Lists.dart';
import 'package:repairmodule/models/httpRest.dart';
import 'package:repairmodule/screens/profileMan.dart';


class scrCompanyEditScreen extends StatefulWidget {

  scrCompanyEditScreen({super.key});

  @override
  State<scrCompanyEditScreen> createState() => _scrCompanyEditScreenState();
}

class _scrCompanyEditScreenState extends State<scrCompanyEditScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late ImagePicker imagePicker;
  List<ListAttach> listAttached = [];
  List<ListAttach> listAttachedNetwork = [];
  List<String> images = [];

  bool userDataEdit = false;


  TextEditingController _companyName=TextEditingController(text: '');
  TextEditingController _companyComment=TextEditingController(text: '');

  Future<bool> httpCompanyUpdate() async {
    bool _result=false;
    String _message = '';
    var _url=Uri(path: '${Globals.anPath}company/${Globals.anCompanyId}/', host: Globals.anServer, scheme: 'https');
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': Globals.anAuthorization
    };
    var _body = <String, String> {
      'companyId': Globals.anCompanyId,
      'companyName': _companyName.text,
      'companyComment': _companyComment.text,
    };
    try {
      print(json.encode(_body));
      var response = await http.post(_url, headers: _headers, body: json.encode(_body));
      print('Код ответа: ${response.statusCode} Тело ответа: ${response.body}');
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        _result = data['Успешно'] ?? '';
        String _message = data['Сообщение'] ?? '';

        print('Объект и договор созданы. Результат:  $_result. Сообщение:  $_message. ');
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
    imagePicker = ImagePicker();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (userDataEdit==false) {
      _companyName.text = Globals.anCompanyName;
      _companyComment.text = Globals.anCompanyComment;

      userDataEdit = true;
    }


    return Scaffold(
        appBar: AppBar(
          title: Text('Данные компании'),
          centerTitle: true,
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.menu))],
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            children: [
              Container(height: 200, child: TopPortion(enableUser: true, avatar: Globals.anCompanyAvatar)),
              if (Globals.anUserRoleId==3) ... [
                SizedBox(height: 2,),
                _AddMenuIcon(),
              ],
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(),
                  SingleSection(title: 'Данные компании',
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            textAlign: TextAlign.start,
                            controller: _companyName,
                            keyboardType: TextInputType.text,
                            style: TextStyle(fontSize: 18),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Название компании',
                            ),
                              textInputAction: TextInputAction.done,
                              validator: (value) {
                                if (value == null || value.isEmpty) {return 'Заполните название компании';}
                                return null;
                              }
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                              textAlign: TextAlign.start,
                              minLines: 3,
                              maxLines: 10,
                              controller: _companyComment,
                              keyboardType: TextInputType.text,
                              style: TextStyle(fontSize: 18),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Комментарий',
                              ),
                              textInputAction: TextInputAction.done,
                          ),
                        )
                      ])
                    ],
                  ),
                ],
          ),
        ),
        floatingActionButton: (Globals.anUserRoleId!=3) ? null : FloatingActionButton(
          onPressed: () {
            print('Данные введены правильно');
            httpCompanyUpdate().then((value) {
              if (value==true) {
                Globals.setCompanyName(_companyName.text);
                Globals.setCompanyComment(_companyComment.text);
                Navigator.pop(context);
              }
            });
            },
          child: Icon(Icons.save),
        )
      //backgroundColor: Colors.grey[900]),
    );
  }

  _AddMenuIcon() {
    return PopupMenuButton<MenuItemPhotoFile>(
        icon:
        Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_a_photo_outlined),
            SizedBox(width: 4,),
            Text('Изменить фото',  style: TextStyle(fontSize: 15),)
          ],),//const Icon(Icons.attach_file),
        //offset: const Offset(40, 0),
        offset: Offset(20, 10),
        onSelected: (MenuItemPhotoFile item) async {
          print(item.name);
          if (item.name=='file') {
            print('Прикрепляем файл с устройства');
            _addImage(2);
          }
          else {
            print('Делаем фото');
            _addImage(1);
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuItemPhotoFile>>[
          const PopupMenuItem<MenuItemPhotoFile>(
            value: MenuItemPhotoFile.photo,
            child: Text('Сделать фото'),
          ),
          const PopupMenuItem<MenuItemPhotoFile>(
            value: MenuItemPhotoFile.file,
            child: Text('Вложить файл'),
          ),
        ]);

  }


  _addImage(int source) async {
    String _addStatus = '';
    try {
      XFile? selectedImage = await imagePicker.pickImage(source: (source==1) ? ImageSource.camera : ImageSource.gallery, maxHeight: 800);
      if (selectedImage!=null) {
        String _namePhoto = '${DateFormat('ddMMyyyyHHmmss').format(DateTime.now())}';
        print('_namePhoto = $_namePhoto');
        listAttached.add(ListAttach(selectedImage.path, _namePhoto, selectedImage.path, 0));
        setState(() {

        });
        returnResult res = await httpUploadImage(_namePhoto, File(selectedImage.path));
        if (res.resultCode==0) {
          listAttachedNetwork.add(ListAttach(selectedImage.path, _namePhoto, res.resultText, 0));
          _addStatus = 'Файл ${_namePhoto} успешно загружен на сервер';
          await httpAvatarSend(Globals.anCompanyId, listAttachedNetwork);
          initState();
        }
        else {
          throw res.resultText;
        }

      }
    } catch (error) {
      _addStatus = error.toString();
    }
    final snackBar = SnackBar(content: Text('$_addStatus'),);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    num CashSummaAll=0;
    num CashSummaPO=0;
    num ObjectKol=0;
    num ApprovalKol=0;
    await httpGetInfo(CashSummaAll, CashSummaPO, ObjectKol, ApprovalKol);
    setState(() {

    });
  }
}



