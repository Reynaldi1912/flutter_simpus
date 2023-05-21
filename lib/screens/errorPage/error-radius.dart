import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';


class ErrorRadius extends StatelessWidget {

  final double jarak , radius;
  ErrorRadius({this.jarak,this.radius});

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
        margin: EdgeInsets.all(MediaQuery.of(context).size.width * 1/10),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(20)
        ),

        child: Center(
          child: Container(
            padding: EdgeInsets.only(right: 30 , left: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/location.png'),
                Align(alignment: Alignment.center, child: Text("Anda Belum Memasuki Radius Desa" , style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold , fontSize: 25),textAlign: TextAlign.center,)),
                SizedBox(height: 20),
                Text("Jarak Anda Kurang "+ (jarak - radius).toStringAsFixed(2) +" KM" , style: TextStyle(color: Colors.white , fontWeight: FontWeight.w200 , fontSize: 20 ),textAlign: TextAlign.center,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
