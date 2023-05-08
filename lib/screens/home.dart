import 'package:flutter/material.dart';
import 'package:flutter_auth/model/JadwalModel.dart';
import 'package:flutter_auth/network/repositoryJadwal.dart';
import 'package:flutter_auth/screens/drawerwidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_auth/network/api.dart';
import 'dart:convert';
import 'login.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String id, nama_lengkap;

  List<Jadwal> listJadwal = [];
  RepositoryJadwal repository = RepositoryJadwal();

  
  @override
  void initState() {
    super.initState();
    _loadUserData();
    getData();
  }

  _loadUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user'));

    if (user != null) {
      setState(() {
        id = user['id'].toString();
        nama_lengkap = user['nama_lengkap'];
      });
    }
  }
  getData() async {
    List<Jadwal> data = await repository.getData();
      setState(() {
          listJadwal = data;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SIMPUS"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.fromARGB(255, 255, 255, 255) , Color.fromARGB(255, 60, 170, 182)])
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                margin:EdgeInsets.only(top: 20 , bottom: 20 , left: 50 , right: 50),
                padding: EdgeInsets.only(top : 20),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 8, 241, 0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Jadwal Hari Ini' , 
                          style: TextStyle(
                            color: Colors.white
                          ),
                        ),
                        Text('Selasa , 20 Desember 2022',
                          style: TextStyle(
                            color: Colors.white
                          ),
                        )
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(top: 20),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255)
                      ),
                      child: Column(
                        children: [
                          Text("Penanggulangan stunting")
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin:EdgeInsets.only(top: 20 , bottom: 20 , left: 50 , right: 50),
                padding: EdgeInsets.only(top : 20),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 8, 241, 0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Desa Krasak',
                          style: TextStyle(
                            color: Colors.white
                          ),
                        ),
                        Text('Sudah Memasuki',
                          style: TextStyle(
                            color: Colors.white
                          ),
                        )
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      height: 100,
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(top: 20),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255)
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin:EdgeInsets.only(top: 20 , bottom: 20 , left: 50 , right: 50),
                padding: EdgeInsets.only(top : 20),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  height: 200,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Center(
                                child: Container(child: Text("jadwal")),
                              ),
                            ),
                          ],
                        ),
                        ListView.separated(
                          padding: const EdgeInsets.all(8),
                          shrinkWrap: true,
                          itemCount: listJadwal.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              color: Colors.white,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(listJadwal[index].tanggal_mulai),
                                      Text('target : 1'),
                                    ],
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(listJadwal[index].kegiatan)
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(listJadwal[index].rincian_pelaksanaan)
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('nama pelaksana 1 : '+listJadwal[index].nama_pelaksana1+' , nama pelaksana 2 : '+listJadwal[index].nama_pelaksana2)
                                  ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) => const Divider(),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      drawer : DrawerWidget(
        id: id,
        nama_lengkap: nama_lengkap,
        context: context,
      ),
    );
  }
}
