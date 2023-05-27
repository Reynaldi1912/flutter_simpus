import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class HistoryKunjungan extends StatefulWidget {
  const HistoryKunjungan({Key key}) : super(key: key);

  @override
  State<HistoryKunjungan> createState() => _HistoryKunjunganState();
}

class _HistoryKunjunganState extends State<HistoryKunjungan> {
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
        child: Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Text("History Kunjungan"),
              SizedBox(height: 20,),
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(20),
                  height: MediaQuery.of(context).size.height * 6/8,
                  child: ListView.separated(
                    physics: AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder:(BuildContext context, int index) {
                      return Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text("19 Desember 2022"),
                                Text("Kegiatan : Sosialisasi Ibu Hamil"),
                              ],
                            ),
                            ElevatedButton(onPressed: (){}, child: Icon(Icons.remove_red_eye))
                          ],
                        ),
                      );
                    }
                  , separatorBuilder: (BuildContext context, int index) => const Divider(), itemCount: 30),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}