import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class scrProfileMan extends StatefulWidget {
  final String id;
  const scrProfileMan({Key? key, required this.id}) : super(key: key);

  @override
  State<scrProfileMan> createState() => _scrProfileManState();
}

class _scrProfileManState extends State<scrProfileMan> {
  String name = '';
  String phone = '';
  String mail = '';
  String role = '';
  int kol = 0;

  Future httpGetInfoMan() async {
    var _url=Uri(path: '/a/centrremonta/hs/v1/man/'+widget.id+'/', host: 's1.rntx.ru', scheme: 'https');
    var _headers = <String, String> {
      'Accept': 'application/json',
      'Authorization': 'Basic YWNlOkF4V3lJdnJBS1prdzY2UzdTMEJP'
    };
    try {
      var response = await http.get(_url, headers: _headers);
      print('Запрос к профилю человека ${widget.id}');
      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        name = data['name'] ?? 'no name';
        phone = data['phone'] ?? 'no phone';
        mail = data['mail'] ?? 'no mail';
        role = data['role'] ?? 'no role';


        final a = double.parse(data['kol'].toString());
        kol = a.toInt();

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
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Профиль'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.menu))
        ],
      ),
      body: Column(
        children: [
          const Expanded(flex: 2, child: _TopPortion()),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FloatingActionButton.extended(
                        onPressed: () => _makingPhoneCall(phone, 1),
                        heroTag: 'call',
                        elevation: 0,
                        backgroundColor: Colors.green,
                        label: const Text("Позвонить"),
                        icon: const Icon(Icons.phone),
                      ),
                      const SizedBox(width: 16.0),
                      FloatingActionButton.extended(
                        onPressed: () => _makingPhoneCall(phone, 2),
                        heroTag: 'mesage',
                        elevation: 0,
                        backgroundColor: Colors.blue,
                        label: const Text("Написать"),
                        icon: const Icon(Icons.message_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  //const _ProfileInfoRow(),
                  const SizedBox(height: 16),
                  Divider(),
                  ListTile(
                    title: Text('Телефон: ' + phone, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),),
                    trailing: IconButton(onPressed: ()=>_makingPhoneCall(phone, 1), icon: Icon(Icons.phone_enabled)) , //Icon(Icons.phone_enabled)
                    onTap: () {},
                    onLongPress: () async {
                      await Clipboard.setData(ClipboardData(text: phone));
                    },
                  ),
                  Divider(),
                  ListTile(
                    title: Text('E-mail: ' + mail, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),),
                    trailing: Icon(Icons.email),
                    onTap: () => _makingPhoneCall(mail, 3),
                    onLongPress: () async {
                      await Clipboard.setData(ClipboardData(text: mail));
                    },
                  ),
                  Divider(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
        style: Theme.of(context).textTheme.caption,
      )
    ],
  );
}

class ProfileInfoItem {
  final String title;
  final int value;
  const ProfileInfoItem(this.title, this.value);
}

class _TopPortion extends StatelessWidget {
  const _TopPortion({Key? key}) : super(key: key);

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
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage('https://img.acewear.ru/CleverWearImg/ManProfile.png')), //https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                          color: Colors.green, shape: BoxShape.circle),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

_makingPhoneCall(phone, tip) async {
  var url = Uri.parse("tel:$phone");

  if (tip==2) {
      url = Uri.parse("sms:$phone");
  };
  if (tip==3) {
    url = Uri.parse("mailto:$phone?subject=News&body=New%20plugin");
  };
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  };
}