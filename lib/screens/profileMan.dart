import 'dart:convert';
import 'dart:io';
import 'package:avatar_brick/avatar_brick.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:repairmodule/components/GeneralFunctions.dart';
import 'package:repairmodule/models/Lists.dart';
import 'package:repairmodule/models/httpRest.dart';
import 'package:repairmodule/screens/profileMan_edit.dart';
import 'package:repairmodule/screens/settings/accessUser.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/Cards.dart';

class scrProfileMan extends StatefulWidget {
  final String id;
  const scrProfileMan({Key? key, required this.id}) : super(key: key);

  @override
  State<scrProfileMan> createState() => _scrProfileManState();
}

class _scrProfileManState extends State<scrProfileMan> {
  late ImagePicker imagePicker;
  List<ListAttach> listAttached = [];
  List<ListAttach> listAttachedNetwork = [];
  List<String> images = [];

  bool access = false;
  bool accessEnable = false;
  String name = '';
  String phone = '';
  String mail = '';
  String role = '';
  String avatarPhoto = '';

  int type = 1;
  int kol = 0;
  bool del = false;

  bool userDataEdit = false;

  Future httpGetInfoMan() async {
    final _queryParameters = {'userId': Globals.anPhone};
    var _url=Uri(path: '${Globals.anPath}man/'+widget.id+'/', host: Globals.anServer, scheme: 'https', queryParameters: _queryParameters);
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': Globals.anAuthorization
    };
    try {
      print(_url.path);
      var response = await http.get(_url, headers: _headers);
      print('Запрос к профилю человека ${widget.id}');
      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        name = data['name'] ?? 'no name';
        phone = data['phone'] ?? 'no phone';
        mail = data['mail'] ?? 'no mail';
        role = data['role'] ?? 'no role';
        avatarPhoto = data['avatar'] ?? '';
        type = data['type'] ?? 1;
        del = data['del'] ?? false;
        access = data['access'] ?? false;
      }
      else
        throw response.body;
    } catch (error) {
      print("Ошибка при формировании списка: $error");
    }
  }


  @override
  void initState() {
    httpGetInfoMan().then((value) {
      setState(() {
      });
    });
    imagePicker = ImagePicker();
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    print('anUserRoleId: ' + Globals.anUserRoleId.toString());
    if (Globals.anUserRoleId==3)
      accessEnable = true;

    return Scaffold(
      appBar: AppBar(
        title: Text('Профиль'),
        centerTitle: true,
        actions: (Globals.anUserRoleId!=3) ? null : <Widget>[_menuAppBar()],
      ),
      body: Column(
        children: [
          Expanded(flex: 2, child: TopPortion(enableUser: true, avatar: avatarPhoto)),
          if (Globals.anPhone==phone || Globals.anUserRoleId==3) ... [
          SizedBox(height: 2,),
          _AddMenuIcon(),
          ],
          SizedBox( height: 10,),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, decoration: textDelete(del))),
                  const SizedBox(height: 16),
                  Container(height: 50,
                    child: ListView(scrollDirection: Axis.horizontal,
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FloatingActionButton.extended(
                          onPressed: () => makingPhoneCall(phone, 1),
                          heroTag: 'call',
                          elevation: 0,
                          backgroundColor: Colors.green,
                          label: const Text("Позвонить"),
                          icon: const Icon(Icons.phone),
                        ),
                        const SizedBox(width: 16.0),
                        FloatingActionButton.extended(
                          onPressed: () => makingPhoneCall(phone, 2),
                          heroTag: 'mesage',
                          elevation: 0,
                          backgroundColor: Colors.grey,
                          label: const Icon(Icons.message_rounded),
                          //icon: const Icon(Icons.message_rounded),
                        ),
                        const SizedBox(width: 16.0),
                        FloatingActionButton.extended(
                          onPressed: () async {
                            makingPhoneCall(phone, 4);
                          },
                          heroTag: 'whatsapp',
                          elevation: 0,
                          backgroundColor: Colors.green,
                          label: const FaIcon(FontAwesomeIcons.whatsapp),
                          // icon: const FaIcon(FontAwesomeIcons.whatsapp), //Icon(Icons.navigation),
                        ),
                        const SizedBox(width: 16.0),
                        FloatingActionButton.extended(
                          onPressed: () async {
                            makingPhoneCall(phone, 5);
                          },
                          heroTag: 'telegram',
                          elevation: 0,
                          backgroundColor: Colors.blue,
                          label: const FaIcon(FontAwesomeIcons.telegram),
                          //icon: const Icon(Icons.telegram),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  //const _ProfileInfoRow(),
                  const SizedBox(height: 16),
                  Divider(),
                  ListTile(
                    title: Text('Телефон: ' + phone, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),),
                    trailing: IconButton(onPressed: ()=>makingPhoneCall(phone, 1), icon: Icon(Icons.phone_enabled)) , //Icon(Icons.phone_enabled)
                    onTap: () {},
                    onLongPress: () async {
                      await Clipboard.setData(ClipboardData(text: phone));
                    },
                  ),
                  Divider(),
                  ListTile(
                    title: Text('E-mail: ' + mail, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),),
                    trailing: Icon(Icons.email),
                    onTap: () => makingPhoneCall(mail, 3),
                    onLongPress: () async {
                      await Clipboard.setData(ClipboardData(text: mail));
                    },
                  ),
                  Divider(),
                  ListTile(
                    title: Text('Доступ в приложение:', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),),
                    subtitle: Text(role),
                    trailing: Switch.adaptive(
                      value: access,
                      onChanged: !accessEnable
                          ? null
                          : (bool value) async {
                        Map<String, dynamic> _result = await Navigator.push(context, MaterialPageRoute(builder: (context) => scrAccessUserScreen(widget.id, name, access, role),));
                        setState(() {
                          access=_result['access'];
                          role=_result['role'];
                        });
                      },
                    ),
                    onTap: () async {
                      if (accessEnable) {
                        Map<String, dynamic> _result = await Navigator.push(context, MaterialPageRoute(builder: (context) => scrAccessUserScreen(widget.id, name, access, role),));
                        setState(() {
                          access=_result['access'];
                          role=_result['role'];
                        });
                      }
                    },
                  ),
                  Divider(),
                ],
              ),
            ),
          ),
        ],
      ),
        floatingActionButton: (Globals.anUserRoleId!=3) ? null : FloatingActionButton(
          onPressed: () async {
            print('старая почта ' + mail);
            Map<String, dynamic> _result = await Navigator.push(context, MaterialPageRoute(builder: (context) => scrProfileManEditScreen(id: widget.id, name: name, email: mail, phone: phone, type: type),));
            mail=_result['mail'];
            phone=_result['phone'];
            name=_result['name'];
            setState(() {

            });
            //initState();
          },
          child: Icon(Icons.edit),
        )
    );
  }

  PopupMenuButton<Menu> _menuAppBar() {
    return PopupMenuButton<Menu>(
        icon: const Icon(Icons.menu, ),
        offset: const Offset(0, 40),
        onSelected: (Menu item) async {
          if (item == Menu.itemEdit) {
            await Navigator.push(context, MaterialPageRoute(builder: (context) => scrProfileManEditScreen(id: widget.id, name: name, email: mail, phone: phone, type: type)));
            setState(() {

            });
          }
          if (item == Menu.itemDelete) {
            httpEventDelete(widget.id, del, context).then((value) {
              userDataEdit = value;
              print('userDataEdit = $value');
              if (userDataEdit==true) {
                del=!del;
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
          await httpAvatarSend(widget.id, listAttachedNetwork);
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
  }

}

enum Menu { itemEdit, itemDelete }

class _ProfileInfoRow extends StatelessWidget {
  const _ProfileInfoRow({Key? key}) : super(key: key);

  final List<ProfileInfoItem> _items = const [
    ProfileInfoItem("Объектов", 6),
    ProfileInfoItem("Followers", 120),
    ProfileInfoItem("Following", 200),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      constraints: const BoxConstraints(maxWidth: 400),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _items
            .map((item) => Expanded(
            child: Row(
              children: [
                if (_items.indexOf(item) != 0) const VerticalDivider(),
                Expanded(child: _singleItem(context, item)),
              ],
            )))
            .toList(),
      ),
    );
  }

  Widget _singleItem(BuildContext context, ProfileInfoItem item) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          item.value.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      Text(
        item.title,
        //style: Theme.of(context).textTheme.caption,
      )
    ],
  );
}

class ProfileInfoItem {
  final String title;
  final int value;
  const ProfileInfoItem(this.title, this.value);
}

class TopPortion extends StatelessWidget {
  final bool enableUser;
  final String avatar;
  TopPortion({Key? key, required this.enableUser, required this.avatar, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 50),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.topCenter,
                  colors: [Color(0xff0043ba), Color(0xff006df1)]),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              )),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 150,
            height: 150,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (avatar=='')
                    AvatarBrick(
                    backgroundColor: Colors.black26,
                    icon: Icon(
                      Icons.person_rounded,
                      size: 48,
                      color: Colors.white,
                    ),
                  )
                else
                AvatarBrick(backgroundColor: Colors.black,
                    image: Image.network(
                      avatar,
                      // fit: BoxFit.cover,
                      // height: double.maxFinite,
                      // width: double.maxFinite,
                    )
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

makingPhoneCall(phone, tip) async {
  var url = Uri.parse("tel:$phone");

  if (tip==2) {
      url = Uri.parse("sms:$phone");
  };
  if (tip==3) {
    url = Uri.parse("mailto:$phone?subject=News&body=New%20plugin");
  };
  if (tip==4) {
    url = Uri.parse("whatsapp://send?phone=$phone");
    if (Platform.isIOS) {
      url = Uri.parse("https://wa.me/$phone");
    }
  };
  if (tip==5) {
    url = Uri.parse("https://t.me/$phone");
  };
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  };
}

enum MenuItemPhotoFile {photo, file}