import 'dart:convert';

import 'package:bs_flutter/bs_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/network/repositoryException.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExceptionPetugas extends StatefulWidget {
  const ExceptionPetugas({Key key}) : super(key: key);

  @override
  State<ExceptionPetugas> createState() => _ExceptionPetugasState();
}

class _ExceptionPetugasState extends State<ExceptionPetugas> {
  DateTime selectedDate;

  TextEditingController _dateController = TextEditingController();
  TextEditingController _reasonController = TextEditingController();

  BsSelectBoxController _statusController = BsSelectBoxController(options: [
    BsSelectBoxOption(value: 'reschedule', text: Text('Reschedule')),
    BsSelectBoxOption(value: 'tidak masuk', text: Text('Tidak Masuk')),
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
            ])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white),
              height: height * 6 / 16,
              width: double.infinity,
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Text("Riwayat Exception"),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white),
              height: height * 7 / 16,
              margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
              padding: EdgeInsets.all(10),
              width: double.infinity,
              child: Column(
                children: [
                  Text("Exception Petugas"),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: GestureDetector(
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
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                  child: BsSelectBox(
                    hintTextLabel: 'Status',
                    controller: _statusController,
                    // searchable: true,
                    autoClose: true,
                    dialogStyle: BsDialogBoxStyle(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),

                  TextField(
                    controller: _reasonController,
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
                  ElevatedButton(
                    onPressed: () async {
                      SharedPreferences localStorage = await SharedPreferences.getInstance();
                      var user = jsonDecode(localStorage.getString('user'));

                      String tanggal = _dateController.text;
                      String status = _statusController.getSelectedAsString();
                      String alasan = _reasonController.text;
                      int id = user['id'];

                      _repository.postDataException(tanggal, status, alasan , id);
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
}
