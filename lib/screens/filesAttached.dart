import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:repairmodule/models/Lists.dart';
import 'package:http/http.dart' as http;
import 'package:repairmodule/screens/filesAttachedGallery.dart';

import '../components/GeneralFunctions.dart';




class scrAttachedScreen extends StatefulWidget {
  final String id;

  scrAttachedScreen(this.id);

  @override
  State<scrAttachedScreen> createState() => _scrAttachedScreenState();
}

class _scrAttachedScreenState extends State<scrAttachedScreen> {
  bool _isLoad = false;
  //File? image;
  String _namePhoto='';
  late ImagePicker imagePicker;
  
  List<ListAttach> objectList = [];
  List<String> images = [];

  Future httpGetListAttached() async {
    final _queryParameters = {'userId': Globals.anPhone};
    images.clear();

    var _url=Uri(path: '${Globals.anPath}attached/${widget.id}', host: Globals.anServer, scheme: 'https', queryParameters: _queryParameters);
    print(_url.path);
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': Globals.anAuthorization
    };
    try {
      var response = await http.get(_url, headers: _headers);
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        print(response.body.toString());
        var notesJson = json.decode(response.body);
        for (var noteJson in notesJson) {
          objectList.add(ListAttach.fromJson(noteJson));
          images.add(noteJson['path']);
        }
      }
      else
        throw 'Код ответа: ${response.statusCode.toString()}. Ответ: ${response.body}';
    } catch (error) {
      print("Ошибка при формировании списка: $error");
    }
  }


  addImage() async {
    try {
      setState(() {
        _isLoad = true;
      });
      XFile? selectedImage = await imagePicker.pickImage(source: ImageSource.camera, maxHeight: 800);
      if (selectedImage!=null) {
        _namePhoto = '${DateFormat('ddMMyyyyHHmmss').format(DateTime.now())}';
        print('_namePhoto = $_namePhoto');
        returnResult res = await httpUploadImage(_namePhoto, File(selectedImage.path));
        if (res.resultCode==0) {
          returnResult res2 = await httpSetListAttached(widget.id, _namePhoto, res.resultText);
          if (res2.resultCode==0)
            initState();
          else
            throw res2.resultText;
        }
        else {
          throw res.resultText;
        }
      }
    } catch (error) {
      final snackBar = SnackBar(content: Text('$error'),);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    setState(() {
      _isLoad=false;
    });
  }

  uploadImage(String title, File file) async {
    int _status = 404;
    bool _success = false;
    String _id = '';
    String _deletehash = '';
    String _link = '';

    //final _queryParameters = {'userId': Globals.anPhone};
   // var _url=Uri(path: '${Globals.anPath}attachupload/', host: Globals.anServer, scheme: 'https', queryParameters: _queryParameters);
    var request = http.MultipartRequest('POST', Uri.parse('https://api.imgur.com/3/image'));
    request.fields['title']=title;
    request.fields['Authorization'] = '489d9fa84e83361';
    //request.fields['Authorization'] = 'Basic YWNlOkF4V3lJdnJBS1prdzY2UzdTMEJP';
    var picture = http.MultipartFile.fromBytes('image', (await file.readAsBytesSync()), filename: title); //(await rootBundle.load('file')).buffer.asUint8List()

    request.files.add(picture);
    request.send().then((response) {
      print(response.statusCode.toString());
      //if (response.statusCode == 200) print("Uploaded!");
    });

    // print('started upload1');
    // var response = await request.send();
    // print('started upload2 ${response}');
    // var responseData = await response.stream.toBytes();
    // print('started upload3 ${responseData}');
    // var result = await String.fromCharCodes(responseData);
    // print('started upload4 ${result}');
    //
    // print(result.toString());

    print('exit');
    // var data = json.decode(result);
    // _status = data['status'] ?? 404;
    // _success = data['success'] ?? false;
    //
    // _id = data['data']['id'] ?? '';
    // _deletehash = data['data']['deletehash'] ?? '';
    // _link = data['data']['link'] ?? '';
    //
    // print('_status=$_status');
    // print('_id=$_id');
    // print('_deletehash=$_deletehash');
    // print('_link=$_link');
  }

  @override 
  void initState() {
    print('initState');
    objectList.clear();

    httpGetListAttached().then((value) {
      setState(() {
      });
    });
    // TODO: implement initState
    //super.initState();
    imagePicker = ImagePicker();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Вложенные файлы'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
        body: (objectList.length==0) ? Center(child: Text('Нет фото')) :

        Stack(
          children: [
            if (_isLoad)
              Center(child: CircularProgressIndicator()),
            ListView.builder(
              padding: EdgeInsets.all(10),
              physics: BouncingScrollPhysics(),
              reverse: false,
              itemCount: objectList.length,
                itemBuilder: (_, index) =>
                    ListTile(
                      title: Image.network(objectList[index].path, height: 150,alignment: Alignment.center,),
                      //subtitle: Text(objectList[index].name, textAlign: TextAlign.center,),
                      onTap: () {
                        //Navigator.push(context, MaterialPageRoute(builder: (context) => scrAttachPreviewScreen(objectList[index].path)));
                        Navigator.push(context, MaterialPageRoute(builder: (context) => scrFilesAttachedGallery(imageItems: images, defaultIndex: index)));
                      },
                    ),
              ),
          ],
        ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
               addImage();
              //uploadImage('testOnePhoto', image!);
              //image==null ? Icon(Icons.photo, size: 35.0,) : Image.file(image!),
            },
            child: Text('+'),)
          //backgroundColor: Colors.grey[900]),
    );
  }
}

