import 'dart:convert';
import 'dart:io';

import 'package:bs_flutter/bs_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/network/RepositoryKunjungan.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';



class StoreKunjungan extends StatefulWidget {
  // final String imagePath;
  const StoreKunjungan({Key key}) : super(key: key);

  @override
  State<StoreKunjungan> createState() => _StoreKunjunganState();
}

class _StoreKunjunganState extends State<StoreKunjungan> {
  DateTime selectedDate;
  File image; 
  bool _isNIKDisabled = false; 
  TextEditingController _nikController = TextEditingController();
  TextEditingController _namaController = TextEditingController();
  TextEditingController _alamatController = TextEditingController();
  TextEditingController _no_hpController = TextEditingController();
  TextEditingController _tanggal_lahirController = TextEditingController();
  TextEditingController _jml_anggota_keluargaController = TextEditingController();
  TextEditingController _berat_badanController = TextEditingController();
  TextEditingController _tinggi_badanController = TextEditingController();
  TextEditingController _tekanan_darahController = TextEditingController();
  TextEditingController _diagnosaController = TextEditingController();
  TextEditingController _penyuluhanController = TextEditingController();

  BsSelectBoxController _select2 = BsSelectBoxController(options: [
    BsSelectBoxOption(value: 1, text: Text('punya')),
    BsSelectBoxOption(value: 0, text: Text('tidak')),
  ]);

  RepositoryKunjungan _repository = RepositoryKunjungan();

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    getKunjunganExisting();
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
        _tanggal_lahirController.text = '${picked.day}-${picked.month}-${picked.year}';
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
                    enabled: !_isNIKDisabled,
                    cursorColor: Colors.blue,
                    keyboardType: TextInputType.number,
                    controller: _nikController,
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
                    controller: _namaController,
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
                    controller: _alamatController,
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
                          controller: _no_hpController,
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
                  TextFormField(
                    cursorColor: Colors.blue,
                    keyboardType: TextInputType.number,
                    controller: _jml_anggota_keluargaController,
                    decoration: InputDecoration(
                      hintText: "Jumlah Anggota Keluarga",
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
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          cursorColor: Colors.blue,
                          keyboardType: TextInputType.number,
                          controller: _berat_badanController,
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
                          controller: _tinggi_badanController,
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
                          controller: _tekanan_darahController,
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
                        child: BsSelectBox(
                          hintTextLabel: 'BPJS',
                          controller: _select2,
                          // searchable: true,
                          autoClose: true,
                          dialogStyle: BsDialogBoxStyle(
                            borderRadius: BorderRadius.circular(20.0),
                          )
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  TextField(
                      cursorColor: Colors.blue,
                      keyboardType: TextInputType.multiline,
                      controller: _diagnosaController,
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
                      controller: _penyuluhanController,
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
                    onPressed: () async {
                      SharedPreferences localStorage = await SharedPreferences.getInstance();
                      var user = jsonDecode(localStorage.getString('user'));

                      String nik = _nikController.text;
                      String nama = _namaController.text;
                      String alamat = _alamatController.text;
                      String no_hp = _no_hpController.text;
                      String tanggal_lahir = _tanggal_lahirController.text;
                      String tekanan_darah = _tekanan_darahController.text;
                      String diagnosa = _diagnosaController.text;
                      String penyuluhan = _penyuluhanController.text;
                      int jml_anggota_keluarga = int.parse(_jml_anggota_keluargaController.text);
                      int tinggi_badan = int.parse(_tinggi_badanController.text);
                      int bpjs = int.parse(_select2.getSelectedAsString());
                      double berat_badan = double.parse(_berat_badanController.text);
                      String created_by = user['id'].toString();
                      File _image = image;

                      _repository.postDataKunjungan(
                          nik, nama, alamat, no_hp , tanggal_lahir , jml_anggota_keluarga,berat_badan , tinggi_badan , tekanan_darah , bpjs , diagnosa , penyuluhan, created_by, _image, context);
                    },
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

  void getKunjunganExisting() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user'));

    int _idDesa = int.parse(user['id_desa']);
    List<dynamic> data = await _repository.getKunjunganExisting(_idDesa);

    if (data.isNotEmpty) {
      setState(() {
        _nikController.text = data[0]['nik'].toString();
        _namaController.text = data[0]['nama'].toString();
        _alamatController.text = data[0]['alamat'].toString();
        _no_hpController.text = data[0]['no_hp'].toString();
        _jml_anggota_keluargaController.text = data[0]['jml_anggota_keluarga'].toString();
        _berat_badanController.text = data[0]['berat_badan'].toString();
        _tinggi_badanController.text = data[0]['tinggi_badan'].toString();
        _tekanan_darahController.text = data[0]['tekanan_darah'].toString();
        _diagnosaController.text = data[0]['diagnosa'].toString();
        _penyuluhanController.text = data[0]['penyuluhan'].toString();

        _isNIKDisabled = true;

      });
    }else{
        _isNIKDisabled = false; 
    }
    // _alamatController.text = "Alamat Default";
    // Assign nilai default ke variabel lain sesuai kebutuhan
  }
}

