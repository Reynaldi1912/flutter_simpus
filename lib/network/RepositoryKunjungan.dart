import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_auth/model/HistoryKunjunganModel.dart';
import 'package:flutter_auth/network/api.dart';
import 'package:flutter_auth/screens/store-kunjungan.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class RepositoryKunjungan {
  Network network = Network();
  String _baseUrl;

  RepositoryKunjungan() {
    _baseUrl = network.getUrl();
  }

  Future<List<dynamic>> getKunjunganExisting(id) async {
      try {
        final response = await http.get(Uri.parse(_baseUrl + 'kunjungan-mobile/' + id.toString()+'/edit'));
        print(_baseUrl + 'kunjungan-mobile/' + id.toString()+'/edit');
        print(response.statusCode);
        if (response.statusCode == 200) {
          var jsonData = jsonDecode(response.body);
          return [jsonData]; // Mengembalikan data kunjungan dalam bentuk List<dynamic>
        }
      } catch (e) {
        print(e.toString());
      }
      return [];
    }
  Future<List<HistoryKunjunganModel>> getKunjungan(id) async {
    try {
      final response = await http.get(Uri.parse(_baseUrl + 'kunjungan-mobile/' + id.toString()));
      print(response.statusCode);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        print(jsonData);
        List<HistoryKunjunganModel> data = [];
        for (var item in jsonData) {
          data.add(HistoryKunjunganModel.fromJson(item));
        }
        return data;
      }
    } catch (e) {
      print(e.toString());
    }
    return [];
  }

Future<void> postDataKunjungan(
  String nik, String nama, String alamat, String no_hp, String tanggal_lahir,
  int jml_anggota_keluarga, double berat_badan, int tinggi_badan,
  String tekanan_darah, int bpjs, String diagnosa, String penyuluhan,
  String created_by, File image, BuildContext context) async {

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Mengirim data..."),
            ],
          ),
        );
      },
    );
  // Load gambar ke dalam image.Image
  final bytes = await image.readAsBytes();
  final imageBytes = img.decodeImage(bytes);

  // Konversi ukuran gambar
  final resizedImage = img.copyResize(imageBytes, width: 800);

  // Simpan gambar sementara ke dalam file dengan nama yang acak
  final tempDir = await getTemporaryDirectory();
  final uuid = Uuid().v4(); // Generate UUID
  final tempImagePath = '${tempDir.path}/$uuid.jpg';
  File(tempImagePath).writeAsBytesSync(img.encodeJpg(resizedImage, quality: 85));

  // Konversi File menjadi http.MultipartFile
  var imageFile = await http.MultipartFile.fromPath('image', tempImagePath);

  // Buat objek request multipart
  var request = http.MultipartRequest('POST', Uri.parse(_baseUrl + "kunjungan-mobile"));
  request.headers.addAll(_setHeaders());

  DateTime dateTime = DateFormat('dd-MM-yyyy').parse(tanggal_lahir);
  String tanggalBaru = DateFormat('yyyy-MM-dd').format(dateTime);
  // Tambahkan data dan gambar ke request multipart
  request.fields['nik'] = nik;
  request.fields['nama'] = nama;
  request.fields['alamat'] = alamat;
  request.fields['no_hp'] = no_hp;
  request.fields['tanggal_lahir'] = tanggalBaru;
  request.fields['umur'] = "30";
  request.fields['jml_anggota_keluarga'] = jml_anggota_keluarga.toString();
  request.fields['berat_badan'] = berat_badan.toString();
  request.fields['tinggi_badan'] = tinggi_badan.toString();
  request.fields['tekanan_darah'] = tekanan_darah;
  request.fields['bpjs'] = bpjs.toString();
  request.fields['diagnosa'] = diagnosa;
  request.fields['penyuluhan'] = penyuluhan;
  request.fields['created_by'] = created_by;
  request.files.add(imageFile);

  try {
    var response = await request.send();
    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      Map<String, dynamic> responseData = jsonDecode(responseBody);
      String message = responseData['message'];

      ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              padding: EdgeInsets.all(10),
              backgroundColor: responseData['isSuccess'] == true ? Colors.green : Colors.red, // Warna latar belakang
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Text(
                      message,
                      style: TextStyle(color: Colors.white), // Warna teks
                    ),
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


          Navigator.pop(
            context,
            MaterialPageRoute(
              builder: (context) => StoreKunjungan(),
            ),
          );
    } else {
      print('Gagal melakukan POST request. Status code: ${response.statusCode}');
      print('Response body: ${await response.stream.bytesToString()}');
    }
  } catch (error) {
    print('Terjadi kesalahan saat melakukan POST request: $error');
  }

  // Hapus file temporari setelah selesai
  File(tempImagePath).delete();

  // Navigator.of(context, rootNavigator: true).pop();

}



  _setHeaders() => {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

}