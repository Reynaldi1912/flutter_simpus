import 'dart:convert';

import 'package:bs_flutter/bs_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/model/ExceptionModel.dart';
import 'package:flutter_auth/network/repositoryException.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExceptionPetugas extends StatefulWidget {
  const ExceptionPetugas({Key key}) : super(key: key);

  @override
  State<ExceptionPetugas> createState() => _ExceptionPetugasState();
}

class _ExceptionPetugasState extends State<ExceptionPetugas> {
  DateTime selectedDate;
  String alasan;
  TextEditingController _dateController = TextEditingController();
  TextEditingController _reasonController = TextEditingController();

  BsSelectBoxController _statusController = BsSelectBoxController(options: [
    BsSelectBoxOption(value: 'Reschedule', text: Text('Reschedule')),
    BsSelectBoxOption(value: 'Tidak Masuk', text: Text('Tidak Masuk')),
  ]);

  List<ExceptionModel> listException = [];
  RepositoryException re = RepositoryException();

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

  void _selectDateMethod(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null) {
      setState(() {
        _dateController.text =
            '${pickedDate.day}-${pickedDate.month}-${pickedDate.year}';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    _prepareData();
  }

  Future<void> _prepareData() async {
    await getData();
  }

  @override
  void dispose() {
    _dateController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    RepositoryException _repository = RepositoryException();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "SIMPUS",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 60, 170, 182)
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: [
                        Text("Riwayat Exception" , style: TextStyle(fontSize: 15 , fontWeight: FontWeight.bold),),
                        SizedBox(height: 10),
                        ListView.separated(
                          padding: const EdgeInsets.all(8),
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: listException.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 200,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(listException[index].status_appr == 0 ? 'Pending' : listException[index].status_appr == 1 ? 'Disetujui' : 'Ditolak' ,
                                          style: TextStyle(color: listException[index].status_appr == 0 ? Colors.amber : listException[index].status_appr == Colors.green ? 'Disetujui' : Colors.red)
                                        ),
                                        SizedBox(height: 5),
                                        Text("Jadwal : "+listException[index].tanggal_mulai , style: TextStyle(fontSize: 15 , fontWeight: FontWeight.bold)),
                                        Text("Alasan : "+listException[index].alasan , style: TextStyle(fontSize: 12)),
                                        SizedBox(height: 5),
                                        Text("diajukan "+listException[index].created_at , style: TextStyle(fontSize: 10 , color: Colors.grey))
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 40,
                                          child: InkWell(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text("Konfirmasi"),
                                                    content: Text("Apakah Anda yakin ingin menghapus exception ini?"),
                                                    actions: [
                                                      TextButton(
                                                        child: Text("Batal"),
                                                        onPressed: () {
                                                          Navigator.of(context).pop();
                                                        },
                                                      ),
                                                      TextButton(
                                                        child: Text("Hapus"),
                                                        onPressed: () async {
                                                          await re.deleteData(listException[index].id);
                                                          await getData();
                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                            SnackBar(
                                                              padding: EdgeInsets.all(5),
                                                              backgroundColor: Colors.green, // Warna latar belakang
                                                              content: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                children: [
                                                                  Expanded(
                                                                    child: Text(
                                                                      "Data Berhasil Dihapus",
                                                                      style: TextStyle(color: Colors.white), // Warna teks
                                                                    ),
                                                                  ),
                                                                  IconButton(
                                                                    color: Colors.white,
                                                                    icon: Icon(Icons.close),
                                                                    onPressed: () {
                                                                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                                                    }
                                                                  ),
                                                                ],
                                                              ),
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(10.0),
                                                              ),
                                                              behavior: SnackBarBehavior.floating,
                                                              elevation: 30,
                                                              duration: Duration(seconds: 5), // Durasi tampilan snackbar
                                                            ),
                                                          );
                                                          Navigator.of(context).pop();
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(3),
                                                color: Colors.red, 
                                              ),
                                              child: Icon(
                                                Icons.delete,
                                                size: 35,
                                                color: Colors.white, 
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Container(
                                        //   margin: EdgeInsets.only(left: 5),
                                        //   width: 40,
                                        //   child: InkWell(
                                        //     onTap: () {},
                                        //     child: Container(
                                        //       decoration: BoxDecoration(
                                        //         borderRadius: BorderRadius.circular(3),
                                        //         color: Colors.blue, 
                                        //       ),
                                        //       child: Icon(
                                        //         Icons.remove_red_eye,
                                        //         size: 35,
                                        //         color: Colors.white, 
                                        //       ),
                                        //     ),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                          separatorBuilder:
                              (BuildContext context, int index) =>
                                  const Divider(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Text("Exception Petugas"),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      _selectDateMethod(context);
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
                          Expanded(
                            child: TextField(
                              controller: _dateController,
                              enabled: false,
                              decoration: InputDecoration(
                                hintText: 'Select Date',
                              ),
                            ),
                          ),
                          Icon(Icons.calendar_today),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  // BsSelectBox(
                  //   hintTextLabel: 'Status',
                  //   controller: _statusController,
                  //   autoClose: true,
                  //   dialogStyle: BsDialogBoxStyle(
                  //     borderRadius: BorderRadius.circular(20.0),
                  //   ),
                  // ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _reasonController,
                    cursorColor: Colors.blue,
                    keyboardType: TextInputType.multiline,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: "Alasan",
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
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      SharedPreferences localStorage = await SharedPreferences.getInstance();
                      var user = jsonDecode(localStorage.getString('user'));

                      String tanggal = _dateController.text;
                      String status = _statusController.getSelectedAsString();
                      String alasan = _reasonController.text;
                      int id_desa = int.parse(user['id_desa']);
                      int id = user['id'];

                      _repository.postDataException(
                          tanggal, status, alasan, id_desa, id, context);
                    },
                    child: Text("Ajukan"),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user'));
    List<ExceptionModel> data = await re.getData(user['id']);
    print(data);
    setState(() {
      listException = data;
    });
  }
}
