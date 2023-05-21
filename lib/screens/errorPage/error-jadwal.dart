import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';


class ErrorJadwal extends StatelessWidget {

  final int id_jadwal;
  ErrorJadwal({this.id_jadwal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SIMPUS"),
      ),
      body: Container(
        margin: EdgeInsets.all(MediaQuery.of(context).size.width * 1/10),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 147, 7),
          borderRadius: BorderRadius.circular(20)
        ),
        child: Center(
          child: Container(
            padding: EdgeInsets.only(right: 30 , left: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/jadwalIcon.png'),
                Align(alignment: Alignment.center, child: Text("Maaf , Kamu Hari Ini Tidak Ada Jadwal" , style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold , fontSize: 25),textAlign: TextAlign.center,)),
                SizedBox(height: 20),
                Text("Silahkan Cek Jadwal Kamu Kembali" , style: TextStyle(color: Colors.white , fontWeight: FontWeight.w200 , fontSize: 15 ),textAlign: TextAlign.center,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
