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
        title: Text("SIMPUS"),
      ),
      body: Container(
        margin: EdgeInsets.all(MediaQuery.of(context).size.width * 1/10),
        decoration: BoxDecoration(
          color: Colors.red
        ),
        child: Center(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/location.png'),
                Align(alignment: Alignment.center, child: Text("Anda Belum Memasuki Radius Desa" , style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold , fontSize: 25),textAlign: TextAlign.center,)),
                SizedBox(height: 20),
                Text("Jarak Anda Kurang "+ (jarak - radius).toString() +" KM" , style: TextStyle(color: Colors.white , fontWeight: FontWeight.w200 , fontSize: 20 ),textAlign: TextAlign.center,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
