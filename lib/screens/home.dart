import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_auth/model/JadwalModel.dart';
import 'package:flutter_auth/network/current_location.dart';
import 'package:flutter_auth/network/repositoryDesa.dart';
import 'package:flutter_auth/network/repositoryJadwal.dart';
import 'package:flutter_auth/screens/drawerwidget.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import "package:latlong/latlong.dart" as latLng;
import 'package:pull_to_refresh/pull_to_refresh.dart' as pullToRefresh;
import 'package:shared_preferences/shared_preferences.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String id, 
        nama_lengkap , 
        nama_kegiatan = 'Tidak Ada Kegiatan' , 
        rincian_kegiatan = '-' , 
        nama_pelaksana1 = '-' , 
        nama_pelaksana2 = '-' , 
        nama_desa = '' ;

  double latitude = 0.0, 
        longitude = 0.0 , 
        latitude_desa = 0.0, 
        longitude_desa = 0.0 , 
        jarak =0.0 , 
        radius =0.0 ;

  bool _isLoading = false , 
      _isTimer = false;

  int id_jadwal = 0 ,
      id_desa;

  final pullToRefresh.RefreshController _refreshController =pullToRefresh.RefreshController();

  List<Jadwal> listJadwal = [];
  RepositoryJadwal repository = RepositoryJadwal();
  RepositoryDesa repositoryDesa = RepositoryDesa();
  Current_Location cl = Current_Location();

  Future<void> _onRefresh() async {
    setState(() {
      _isLoading = true;
    });

    Timer(Duration(seconds: 10), () {//Menampilkan Pop up Error Jika Data Yang Ditampilkan Gagal Diload selama 10 detik
      if (_isLoading) {
        setState(() {
          _isLoading = false;
        });
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('Error'),
            content: Text('Data Gagal Dimuat. Periksa Kembali Koneksi Internet Anda'),
            actions: [
              TextButton(
                child: Text('Refresh'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _onRefresh();
                },
              ),
            ],
          ),
        );
      }
    });

    nama_kegiatan = 'Tidak Ada Kegiatan';
    rincian_kegiatan = '-';
    nama_pelaksana1 = '-';
    nama_pelaksana2 = '-';
    id_jadwal = 0;
    await _loadUserData();
    await getPosition();
    await getData();

    setState(() {
      _isLoading = false;
    });
    _refreshController.refreshCompleted();
  }


  @override
  void initState(){
    super.initState();
    _prepareData();
  }

  Future<void> _prepareData() async {
    setState(() {
      _isLoading = true;
    });

    await _loadUserData();
    await getPosition();
    await getData();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("SIMPUS" , style: TextStyle(color: Colors.black),),
        
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      body: _isLoading ? Center(child: CircularProgressIndicator()) : 
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.fromARGB(255, 255, 255, 255) , Color.fromARGB(255, 60, 170, 182)])
        ),
        child: pullToRefresh.SmartRefresher(
          controller: _refreshController,
          onRefresh: _onRefresh,
      
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  margin:EdgeInsets.only(top: 20 , left: 10 , right: 10),
                  padding: EdgeInsets.only(top : 5),
                  height: height*2/10,
                  decoration: BoxDecoration(
                    color: id_jadwal != 0 ? Color.fromARGB(255, 24, 192, 18) :Colors.red,
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
                      Expanded(
                        child: Container(
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
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin:EdgeInsets.only( left: 10 , right: 10),
                  padding: EdgeInsets.only(top: 10 ),
                  decoration: BoxDecoration(
                    color: getJarak() == 0 ? Color.fromARGB(255, 115, 115, 115) : (getJarak() > radius ? Colors.red: Color.fromARGB(255, 24, 192, 18)),
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
                            Text(getJarak() == 0 ? 'Loading' : (getJarak() > radius ? '(- '+(getJarak() - radius).toStringAsFixed(2)+' KM)': 'Sudah Memasuki'),
                              style: TextStyle(
                                color: Colors.white
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        height: height*2/10,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 255, 255, 255)
                        ),
                        child: latitude == 0 || longitude == 0
                              ? MyMapLoadingWidget() 
                              : MyMapDisplayWidget(latitude: latitude, longitude: longitude , latitude_desa: latitude_desa , longitude_desa:longitude_desa , radius : radius), 
                      ),
                    ],
                  ),
                ),
                Container(
                  margin:EdgeInsets.only( bottom: 20 , left: 10 , right: 10),
                  padding: EdgeInsets.only(top : 20),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    height: height*3/10,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Center(
                                  child: Container(
                                    padding: EdgeInsets.only(bottom: 10),
                                    child: Text(
                                      "jadwal Kegiatan",
                                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          ListView.separated(
                            padding: const EdgeInsets.all(8),
                            physics: NeverScrollableScrollPhysics(),
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
                                      child: Text(
                                        listJadwal[index].kegiatan,
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    SizedBox(height: 2,),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        listJadwal[index].rincian_pelaksanaan,
                                        style: TextStyle(fontSize: 10, color: Color.fromARGB(255, 23, 23, 23)),
                                      ),
                                    ),
                                    SizedBox(height: 13,),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'pelaksana 1 : ' + listJadwal[index].nama_pelaksana1 + ' , pelaksana 2 : ' + listJadwal[index].nama_pelaksana2,
                                        style: TextStyle(fontSize: 10, color: Color.fromARGB(255, 173, 173, 173)),
                                      ),
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
      ),
      drawer : DrawerWidget(
        // id: id,
        // nama_lengkap: nama_lengkap,
        // jarak : getJarak(),
        // radius : radius,
        // id_jadwal : id_jadwal,
        // context: context,
      ),
    );
  }

  double getJarak(){
    return Geolocator.distanceBetween(latitude, longitude, latitude_desa, longitude_desa) / 1000;
  }
  
  void getPosition() async {
    try {
      Position position = await cl.getCurrentLocation();
      if (mounted) {
        setState(() {
          latitude = position.latitude;
          longitude = position.longitude;
        });
      }
    }catch(e){
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
  Future<void> getData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user'));

    int _idDesa = int.parse(user['id_desa']);

    List<Jadwal> data = await repository.getData(_idDesa);
    if(await repository.getJadwalNow(_idDesa) != null){
      Map<String, dynamic> jadwalData = await repository.getJadwalNow(_idDesa);

      id_jadwal = jadwalData['id'];
      nama_kegiatan = jadwalData['kegiatan'].toString();
      rincian_kegiatan = jadwalData['rincian_pelaksanaan'].toString();
      nama_pelaksana1 = jadwalData['nama_pelaksana1'].toString();
      nama_pelaksana2 = jadwalData['nama_pelaksana2'].toString(); 
    }
    
    if(_idDesa != 0){
      Map<String, dynamic> desaData = await repositoryDesa.getDesa(_idDesa);

      latitude_desa = double.parse(desaData['latitude']);
      longitude_desa = double.parse(desaData['longitude']);
      radius = double.parse(desaData['radius']);
      nama_desa = desaData['nama_desa'].toString();
    }
    
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
  final double latitude , longitude , longitude_desa , latitude_desa , radius;

  MyMapDisplayWidget({this.latitude, this.longitude , this.latitude_desa , this.longitude_desa , this.radius});

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
        CircleLayerOptions(
          circles: [
            CircleMarker(
              point: latLng.LatLng(latitude_desa, longitude_desa),
              radius: radius * 1000,
              color: Colors.red.withOpacity(0.3),
              borderColor: Colors.red,
              borderStrokeWidth: 1,
              useRadiusInMeter: true,
            ),
          ],
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