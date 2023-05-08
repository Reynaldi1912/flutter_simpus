import 'dart:convert';

import 'package:flutter_auth/model/JadwalModel.dart';
import 'package:http/http.dart' as http;

class RepositoryJadwal {
  final _baseUrl = 'http://127.0.0.1:8000/api/';

  Future getData() async{
    try {
      final response = await http.get(Uri.parse(_baseUrl + 'jadwal-mobile/1'));
      if(response.statusCode == 200){
        Iterable it = jsonDecode(response.body);
        List<Jadwal> jadwal = it.map((e) => Jadwal.fromJson(e)).toList();
        return jadwal;
      }
    } catch (e) {
      print(e.toString());
    }
  }
}