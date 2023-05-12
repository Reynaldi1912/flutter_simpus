import 'package:flutter/material.dart';
import 'package:flutter_auth/model/JadwalModel.dart';
import 'package:flutter_auth/network/current_location.dart';
import 'package:flutter_auth/network/repositoryDesa.dart';
import 'package:flutter_auth/network/repositoryJadwal.dart';
import 'package:flutter_auth/screens/drawerwidget.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_auth/network/api.dart';
import 'dart:convert';
import 'login.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import "package:latlong/latlong.dart" as latLng;
import 'package:intl/intl.dart';
import 'dart:math';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String id, nama_lengkap , nama_kegiatan = 'Tidak Ada Kegiatan' , rincian_kegiatan = '-' , nama_pelaksana1 = '-' , nama_pelaksana2 = '-' , nama_desa = '' ;
  double latitude , longitude , latitude_desa , longitude_desa , jarak , radius;
  List<Jadwal> listJadwal = [];
  RepositoryJadwal repository = RepositoryJadwal();
  RepositoryDesa repositoryDesa = RepositoryDesa();
  Current_Location cl = Current_Location();
  
  @override
  void initState() {
    super.initState();
    _loadUserData();
    getData();
    getPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SIMPUS" , style: TextStyle(color: Colors.black),),
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
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
                margin:EdgeInsets.only(top: 20 , left: 50 , right: 50),
                padding: EdgeInsets.only(top : 5),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 24, 192, 18),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Jadwal Hari Ini' , 
                            style: TextStyle(
                              color: Colors.white
                            ),
                          ),
                          Text(DateFormat.yMMMMd('en_US').format(DateTime.now()),
                            style: TextStyle(
                              color: Colors.white
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255)
                      ),
                      child: Column(
                        children: [
                          Align(alignment: Alignment.centerLeft, child: Text(nama_kegiatan == null ? '' : nama_kegiatan , style: TextStyle(fontSize: 15 , fontWeight: FontWeight.bold),)),
                          Align(alignment: Alignment.centerLeft, child: Text(rincian_kegiatan == null ? '' : rincian_kegiatan , style: TextStyle(fontSize: 12),)) , 
                          SizedBox(height: 10),
                          Align(alignment: Alignment.centerLeft, child: Text('Nama Pelaksana 1 : ' + (nama_pelaksana1 == null ? '' : nama_pelaksana1) , style: TextStyle(fontSize: 10 , color: Color.fromARGB(255, 189, 189, 189)))) , 
                          Align(alignment: Alignment.centerLeft, child: Text('Nama Pelaksana 2 : ' + (nama_pelaksana2 == null ? '' : nama_pelaksana2), style: TextStyle(fontSize: 10 , color: Color.fromARGB(255, 189, 189, 189)))) , 
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin:EdgeInsets.only( left: 50 , right: 50),
                padding: EdgeInsets.only(top: 10 ),
                decoration: BoxDecoration(
                  color: jarak == null ? Color.fromARGB(255, 115, 115, 115) : (jarak > radius ? Colors.red: Color.fromARGB(255, 24, 192, 18)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Desa '+nama_desa,
                            style: TextStyle(
                              color: Colors.white
                            ),
                          ),
                          Text(jarak == null ? 'Loading' : (jarak > radius ? '(- '+(jarak - radius).toStringAsFixed(2)+' KM)': 'Sudah Memasuki'),
                            style: TextStyle(
                              color: Colors.white
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      width: double.infinity,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255)
                      ),
                      child: latitude == null || longitude == null
                            ? MyMapLoadingWidget() // Tampilkan loading widget jika latitude dan longitude masih null
                            : MyMapDisplayWidget(latitude: latitude, longitude: longitude), // Tampilkan peta jika sudah ada nilai latitude dan longitude
                    ),
                  ],
                ),
              ),
              Container(
                margin:EdgeInsets.only( bottom: 20 , left: 50 , right: 50),
                padding: EdgeInsets.only(top : 20),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  height: 250,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Center(
                                child: Container(padding: EdgeInsets.only(bottom: 10), child: Text("jadwal Kegiatan" , style: TextStyle(fontSize: 25 , fontWeight: FontWeight.bold),)),
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
                                      Text(DateFormat.yMMMMd('en_US').format(DateTime.parse(listJadwal[index].tanggal_mulai))),
                                      Text('target : 1'),
                                    ],
                                  ),
                                  SizedBox(height: 7),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(listJadwal[index].kegiatan , style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  SizedBox(height: 2,),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(listJadwal[index].rincian_pelaksanaan , style: TextStyle(fontSize: 10 , color: Color.fromARGB(255, 23, 23, 23)),)
                                  ),
                                  SizedBox(height: 13,),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('pelaksana 1 : '+listJadwal[index].nama_pelaksana1+' , pelaksana 2 : '+listJadwal[index].nama_pelaksana2 , style: TextStyle(
                                      fontSize: 10,
                                      color: Color.fromARGB(255, 173, 173, 173)
                                    ),)
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

  void getPosition() async {
    try {
      Position position = await cl.getCurrentLocation();
      if (mounted) {
        setState(() {
          latitude = position.latitude;
          longitude = position.longitude;
          jarak = Geolocator.distanceBetween(latitude, longitude, latitude_desa, longitude_desa) / 1000;
        });
      }
    }catch(e){
      // Tangani kesalahan yang mungkin terjadi
      print('Error: $e');
    }
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
    List<Jadwal> data = await repository.getData(1);
    if(await repository.getJadwalNow(1) != null){
      nama_kegiatan = (await repository.getJadwalNow(1))['kegiatan'].toString();
      rincian_kegiatan = (await repository.getJadwalNow(1))['rincian_pelaksanaan'].toString();
      nama_pelaksana1 = (await repository.getJadwalNow(1))['nama_pelaksana1'].toString();
      nama_pelaksana2 = (await repository.getJadwalNow(1))['nama_pelaksana2'].toString(); 
    }
    latitude_desa = double.parse((await repositoryDesa.getDesa(1))['latitude']);
    longitude_desa = double.parse((await repositoryDesa.getDesa(1))['longitude']);
    radius = double.parse((await repositoryDesa.getDesa(1))['radius']);
    nama_desa = (await repositoryDesa.getDesa(1))['nama_desa'];
    setState(() {
        listJadwal = data;
    });
  }

}


class MyMapLoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }
}

class MyMapDisplayWidget extends StatelessWidget {
  final double latitude;
  final double longitude;

  MyMapDisplayWidget({this.latitude, this.longitude});

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        center: latLng.LatLng(latitude, longitude),
        zoom: 14,
      ),
      layers: [
        TileLayerOptions(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: ['a', 'b', 'c'],
        ),
        MarkerLayerOptions(
          markers: [
            Marker(
              width: 40.0,
              height: 40.0,
              point: latLng.LatLng(latitude, longitude),
              builder: (ctx) => Container(
                child: Icon(Icons.location_on),
              ),
            ),
          ],
        ),
      ],
    );
  }
}