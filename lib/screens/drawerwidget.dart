import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_auth/screens/errorPage/error-radius.dart';
import 'package:flutter_auth/screens/store-kunjungan.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_auth/network/api.dart';
import 'dart:convert';
import 'login.dart';

class DrawerWidget extends StatelessWidget {
  final String id;
  final String nama_lengkap;
  final double jarak , radius;
  final BuildContext context;

  DrawerWidget({this.id, this.nama_lengkap,this.jarak, this.radius, this.context});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.supervised_user_circle_outlined , size: 60,color: Colors.white,),
                    SizedBox(height: 5,),
                    Text("Petugas" , style: TextStyle(fontSize: 15 , fontWeight: FontWeight.w400 , color: Colors.white)),
                    SizedBox(height: 5,),
                    Text('$nama_lengkap' , style: TextStyle(fontSize: 15 , fontWeight: FontWeight.bold , color: Colors.white),),
                    Text('($id)' , style: TextStyle(fontSize: 15 , fontWeight: FontWeight.w400 , color: Colors.white),),
                  ],
                ),
              ),
              decoration: BoxDecoration(
                gradient: const LinearGradient( begin : Alignment.topLeft, end: Alignment.bottomRight, colors : [Color.fromARGB(255, 22, 164, 0) , Color.fromARGB(255, 160, 160, 160)]),
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Input Kunjungan"),
              onTap: () {
                if(jarak > radius && jarak < 5000){
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => ErrorRadius(
                          jarak: jarak,
                          radius : radius
                        )
                    ),
                  );
                }else if(jarak < radius){
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => StoreKunjungan()
                    ),
                );
                }
                
              },
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
              leading: Icon(Icons.cottage),
              title: Text("Setting"),
              onTap: () {},
            ),
            SizedBox(height: 30),
            Container(
              padding: EdgeInsets.only(left: 20 , right: 20),
              child: ElevatedButton(
                  onPressed: () {
                     _showMsg("Anda berhasil Logout");
                    logout();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Text('Logout')),
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
