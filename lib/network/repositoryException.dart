import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_auth/model/ExceptionModel.dart';
import 'package:flutter_auth/network/api.dart';
import 'package:flutter_auth/screens/exception.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class RepositoryException {
  Network network = Network();
  String _baseUrl;

  RepositoryException() {
    _baseUrl = network.getUrl();
  }

  Future getData(id) async{
    try {
      final response = await http.get(Uri.parse(_baseUrl + 'exception_mobile/'+id.toString()));
      if(response.statusCode == 200){
        Iterable it = jsonDecode(response.body);
        List<ExceptionModel> jadwal = it.map((e) => ExceptionModel.fromJson(e)).toList();
        print(jadwal);
        return jadwal;
      }
    } catch (e) {
      print(e.toString());
    }
  }
  
  Future<void> deleteData(id) async {
    var response = await http.delete(Uri.parse(_baseUrl+ 'exception_mobile/'+id.toString()));

    if (response.statusCode == 200) {
      print('Data berhasil dihapus');
    } else {
      print('Gagal menghapus data. Status kode: ${response.statusCode}');
    }
  }

  Future<void> postDataException(String tanggal, String status, String alasan, int id_desa, int id, BuildContext context) async {
    var url = Uri.parse(_baseUrl + 'exception_mobile'); // Ganti dengan URL endpoint yang sesuai

    DateFormat formatLama = DateFormat('dd-MM-yyyy');
    DateFormat formatBaru = DateFormat('yyyy-MM-dd');

    if(tanggal == '' && status == '' && alasan == ''){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            padding: EdgeInsets.all(10),
            backgroundColor: Colors.red, // Warna latar belakang
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Text(
                    "Isikan Data Exception Dengan Lengkap",
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
            duration: Duration(seconds: 7), // Durasi tampilan snackbar
          ),
        );
    }else{

      DateTime dateTime = formatLama.parse(tanggal);
      String tanggalBaru = formatBaru.format(dateTime);
      var body = {
        'id': id,
        'tanggal': tanggalBaru,
        'alasan': alasan,
        'id_desa': id_desa
      };
      try {
        var response =
            await http.post(url, body: jsonEncode(body), headers: _setHeaders());
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = jsonDecode(response.body);
          String message = responseData['message'];

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              padding: EdgeInsets.all(10),
              backgroundColor: responseData['isError'] == true ? Colors.green : Colors.red, // Warna latar belakang
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Text(
                      message,
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


          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ExceptionPetugas(),
            ),
          );
        } else {
          print('Gagal melakukan POST request. Status code: ${response.statusCode}');
        }
      } catch (error) {
        print('Terjadi kesalahan saat melakukan POST request: $error');
      }
    }
  }

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
}
