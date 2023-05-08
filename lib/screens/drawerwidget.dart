import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_auth/network/api.dart';
import 'dart:convert';
import 'login.dart';

class DrawerWidget extends StatelessWidget {
  final String id;
  final String nama_lengkap;
  final BuildContext context;

  DrawerWidget({this.id, this.nama_lengkap, this.context});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: Image(
                image: NetworkImage(
                    "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png"),
              ),
              accountName: Text('$id'),
              accountEmail: Text('$nama_lengkap'),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      "https://cdn.pixabay.com/photo/2016/04/24/20/52/laundry-1350593_960_720.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Input Kunjungan"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text("History Kunjungan"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.money),
              title: Text("Input Kegiatan"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.emoji_emotions),
              title: Text("History Kegiatan"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text("Exception"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text("Setting"),
              onTap: () {},
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.info),
              title: Text("Logout"),
              onTap: () {
                _showMsg("Anda berhasil Logout");
                logout();
              },
            ),
          ],
        ),
      ),
    );
  }

  _showMsg(msg) {
    final snackBar = SnackBar(
      content: Text(msg),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void logout() async {
    var res = await Network().getData('/logout');
    var body = json.decode(res.body);
    if (body['success']) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.remove('user');
      localStorage.remove('token');
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login()));
    }
  }
}
