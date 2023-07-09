import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_auth/model/JadwalModel.dart';
import 'package:flutter_auth/network/api.dart';
import 'package:flutter_auth/network/current_location.dart';
import 'package:flutter_auth/network/repositoryDesa.dart';
import 'package:flutter_auth/network/repositoryJadwal.dart';
import 'package:flutter_auth/screens/errorPage/error-jadwal.dart';
import 'package:flutter_auth/screens/errorPage/error-radius.dart';
import 'package:flutter_auth/screens/exception.dart';
import 'package:flutter_auth/screens/history.dart';
import 'package:flutter_auth/screens/store-kunjungan.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key key}) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {


  String id, nama_lengkap , nama_kegiatan = 'Tidak Ada Kegiatan' , rincian_kegiatan = '-' , nama_pelaksana1 = '-' , nama_pelaksana2 = '-' , nama_desa = '' ;
  double latitude = 0.0, longitude = 0.0 , latitude_desa = 0.0, longitude_desa = 0.0 , jarak =0.0 , radius =0.0 ;
  bool _isLoading = false;
  int id_jadwal = 0 , id_desa;
  List<Jadwal> listJadwal = [];
  RepositoryJadwal repository = RepositoryJadwal();
  RepositoryDesa repositoryDesa = RepositoryDesa();
  Current_Location cl = Current_Location();

  @override
  void initState(){
    super.initState();
    _prepareData();
  }

  Future<void> _prepareData() async {
    // Mengatur _isLoading sebagai true saat halaman dimuat
    setState(() {
      _isLoading = true;
    });

    // Panggil fungsi persiapan lainnya
    await _loadUserData();
    await getPosition();
    await getData();

    // Setelah semua persiapan selesai, atur _isLoading sebagai false
    setState(() {
      _isLoading = false;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Drawer(
        child:ListView(
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
              leading: Icon(Icons.assignment),
              title: Text('Input Kunjungan'),
              onTap: () {
                if (_isLoading) {
                  // Jika sedang loading, tidak melakukan apa-apa
                  return;
                }

                if (id_jadwal == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ErrorJadwal(id_jadwal: id_jadwal),
                    ),
                  );
                } else {
                  if (getJarak() > radius && getJarak() < 5000) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ErrorRadius(jarak: getJarak(), radius: radius),
                      ),
                    );
                  } else if (getJarak() < radius) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => StoreKunjungan()),
                    );
                  }
                }
              },
              trailing: _isLoading
                  ? SizedBox(
                    height: 10,
                    width: 10,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, // Atur lebar garis lingkaran
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue), // Atur warna
                      ),
                  )
                  : null, // Jika tidak loading, kosongkan trailing
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text("History Kunjungan"),
              onTap: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => HistoryKunjungan()
                  ),
                );
              },
            ),

            ListTile(
              leading: Icon(Icons.message),
              title: Text("Exception"),
              onTap: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => ExceptionPetugas()
                  ),
                );
              },
            ),
            // ListTile(
            //   leading: Icon(Icons.settings),
            //   title: Text("Setting"),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       new MaterialPageRoute(
            //           builder: (context) => Setting()
            //       ),
            //     );
            //   },
            // ),
            SizedBox(height: 30),
            Container(
              padding: EdgeInsets.only(left: 20 , right: 20),
              child: ElevatedButton(
                  onPressed: () async {
                     _showMsg("Anda berhasil Logout");
                    await logout(context);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    backgroundColor: Colors.red
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
  ScaffoldMessenger.of(context).removeCurrentSnackBar(); // Tambahkan baris ini
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}


 void logout(BuildContext context) async {
  var res = await Network().getData('/logout');
  var body = json.decode(res.body);
  if (body['message'] == 'Logout successfully' || body['message'] == 'Unauthenticated.') {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.remove('user');
    localStorage.remove('token');
    await localStorage.commit(); // Simpan perubahan ke localStorage

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
  } else {
    if (body['message'] == 'Unauthenticated.') {
      // Hapus data pengguna dan token
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.remove('user');
      localStorage.remove('token');
      await localStorage.commit();

      // Navigasi ke halaman login
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
    } else {
        _showMsg("Failed to logout");
    }
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
      // setState(() {
      //     listJadwal = data;
      // });
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
      // Tangani kesalahan yang mungkin terjadi
      print('Error: $e');
    }
  }
  }
