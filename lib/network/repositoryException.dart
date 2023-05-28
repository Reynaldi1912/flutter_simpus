import 'dart:convert';

import 'package:flutter_auth/network/api.dart';
import 'package:http/http.dart' as http;


class RepositoryException{
  Network network = Network();
  String _baseUrl;

  RepositoryException() {
    _baseUrl = network.getUrl();
  }
  Future<void> postDataException(String tanggal, String status, String alasan  ,int id) async {
    var url = Uri.parse(_baseUrl+'exception_mobile'); // Ganti dengan URL endpoint yang sesuai
    
    var body = {
      'id' : id,
      'tanggal': tanggal,
      'status': status,
      'alasan': alasan,
    };

    try {
      print(body);
      var response = await http.post(url, body: jsonEncode(body));
      if (response.statusCode == 200) {
        print('Data berhasil dipost');
        // Lakukan tindakan sesuai kebutuhan setelah data berhasil dipost
      } else {
        print('Gagal melakukan POST request. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Terjadi kesalahan saat melakukan POST request: $error');
    }
  }
}