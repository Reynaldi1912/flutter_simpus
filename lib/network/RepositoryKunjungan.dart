import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_auth/model/HistoryKunjunganModel.dart';
import 'package:flutter_auth/network/api.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class RepositoryKunjungan {
  Network network = Network();
  String _baseUrl;

  RepositoryKunjungan() {
    _baseUrl = network.getUrl();
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

  // Konversi File menjadi http.MultipartFile
  http.MultipartFile imageFile = await http.MultipartFile.fromPath('image', image.path);
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
      print('Berhasil');
      // Berhasil melakukan POST request
      // Tambahkan kode yang diperlukan setelah berhasil menyimpan gambar
    } else {
      print('Gagal melakukan POST request. Status code: ${response.statusCode}');
      print('Response body: ${await response.stream.bytesToString()}');
    }
  } catch (error) {
    print('Terjadi kesalahan saat melakukan POST request: $error');
  }
}

  _setHeaders() => {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

}