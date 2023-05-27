import 'package:bs_flutter/bs_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ExceptionPetugas extends StatefulWidget {
  const ExceptionPetugas({Key key}) : super(key: key);

  @override
  State<ExceptionPetugas> createState() => _ExceptionPetugasState();
}

class _ExceptionPetugasState extends State<ExceptionPetugas> {
  DateTime selectedDate;

  BsSelectBoxController _select2 = BsSelectBoxController(options: [
    BsSelectBoxOption(value: 1, text: Text('Reschedule')),
    BsSelectBoxOption(value: 0, text: Text('Tidak Masuk')),
  ]);
  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("SIMPUS" , style: TextStyle(color: Colors.black),),
        
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      body:
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color.fromARGB(255, 255, 255, 255) , Color.fromARGB(255, 60, 170, 182)])
          ),
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:[
                Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10) , color: Colors.white),
                  height: height * 4/10,
                  width: double.infinity,
                  margin: EdgeInsets.only(left: 20 , right: 20),
                  padding: EdgeInsets.all(5),
                  child: Column(
                    children: [
                      Text("Riwayat Exception"),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10) , color :Colors.white),
                  height: height * 4/10,
                  margin: EdgeInsets.only(left: 20 , right: 20),
                  padding: EdgeInsets.all(10),
                  width: double.infinity,
                  child: Column(
                    children: [
                      Text("Exception Petugas"),
                       SizedBox(height: 10,),
                       Container(
                          child: InkWell(
                            onTap: () {
                              _selectDate(context);
                            },
                            child: InputDecorator(
                              decoration: InputDecoration(
                                hintText: 'Test',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.blue,
                                    width: 2,
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${selectedDate.day}-${selectedDate.month}-${selectedDate.year}',
                                  ),
                                  Icon(Icons.calendar_today),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Expanded(
                          child: BsSelectBox(
                            hintTextLabel: 'Status',
                            controller: _select2,
                            // searchable: true,
                            autoClose: true,
                            dialogStyle: BsDialogBoxStyle(
                              borderRadius: BorderRadius.circular(20.0),
                            )
                          ),
                        ),
                        TextField(
                        cursorColor: Colors.blue,
                        keyboardType: TextInputType.multiline,
                        maxLines: 4,
                        decoration: InputDecoration(
                        hintText: "Alasan",
                        filled: true, // membuat background terisi
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.blue,
                            width: 2,
                          ),
                        ),
                                          ),
                                        ),
                    SizedBox(height: 10),
                    ElevatedButton(onPressed: (){}, child: Text("Ajukan"))
                    ],
                  ),
                ),
            ],
          ),
        ),
    );
  }
}