import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:image_picker/image_picker.dart';
import 'dart:io';


class StoreKunjungan extends StatefulWidget {
  // final String imagePath;
  const StoreKunjungan({Key key}) : super(key: key);

  @override
  State<StoreKunjungan> createState() => _StoreKunjunganState();
}

class _StoreKunjunganState extends State<StoreKunjungan> {
  DateTime selectedDate;
  File image; //for captured image

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
  }

  Future getImage() async {
    final File imagePicked = await ImagePicker.pickImage(source: ImageSource.camera);
    image = File(imagePicked.path);
    setState(() {});
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "SIMPUS",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 255, 255, 255),
                  Color.fromARGB(255, 60, 170, 182)
                ]),
          ),
          child: Container(
            margin: EdgeInsets.all(20),
            decoration:
                BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    "Input Kunjungan",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    cursorColor: Colors.blue,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: "NIK",
                      filled: true, // membuat background terisi
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 2,
                        ),
                      ), // memberikan warna putih pada background
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    cursorColor: Colors.blue,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: "NAMA",
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
                  TextFormField(
                    cursorColor: Colors.blue,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: "ALAMAT",
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
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          cursorColor: Colors.blue,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "NO HP",
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
                      ),
                      SizedBox(width: 5,),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            _selectDate(context);
                          },
                          child: InputDecorator(
                            decoration: InputDecoration(
                              hintText: 'Tanggal Lahir',
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
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          cursorColor: Colors.blue,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "Anggota Keluarga",
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
                      ),
                      SizedBox(width: 5,),
                      Expanded(
                        child: TextFormField(
                          cursorColor: Colors.blue,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "BB",
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
                      ),
                      SizedBox(width: 5,),
                      Expanded(
                        child: TextFormField(
                          cursorColor: Colors.blue,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "TB",
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
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          cursorColor: Colors.blue,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: "TD",
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
                      ),
                      SizedBox(width: 5,),
                      Expanded(
                        child: TextFormField(
                          cursorColor: Colors.blue,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "BPJS",
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
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  TextField(
                      cursorColor: Colors.blue,
                      keyboardType: TextInputType.multiline,
                      maxLines: 4,
                      decoration: InputDecoration(
                      hintText: "Diagnosa",
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
                  SizedBox(height: 5),
                  TextField(
                      cursorColor: Colors.blue,
                      keyboardType: TextInputType.multiline,
                      maxLines: 4,
                      decoration: InputDecoration(
                      hintText: "Konseling / Penyuluhan",
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
                  Container(
                    padding: EdgeInsets.all(30),
                    child: image != null
                        ? Image.file(image, height: 300)
                        : Text("No image captured"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await getImage();
                    },
                    child: Text('Buka Kamera'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {},
                    child: Text('Simpan'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

