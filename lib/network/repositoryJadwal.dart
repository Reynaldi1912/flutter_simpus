import 'dart:convert';

import 'package:flutter_auth/model/JadwalModel.dart';
import 'package:flutter_auth/network/api.dart';
import 'package:http/http.dart' as http;

class RepositoryJadwal {
  Network network = Network();
  String _baseUrl;

  RepositoryJadwal() {
    _baseUrl = network.getUrl();
  }

  Future getData(id) async{
    try {
      final response = await http.get(Uri.parse(_baseUrl + 'jadwal-mobile/' + id.toString()));
      if(response.statusCode == 200){
        Iterable it = jsonDecode(response.body);
        List<Jadwal> jadwal = it.map((e) => Jadwal.fromJson(e)).toList();
        return jadwal;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future getTimeNow() async {
    try {
        final current_time = await http.get(Uri.parse(_baseUrl + 'jadwal-mobile/create'));
        var responseJson = jsonDecode(current_time.body);
        String currentTime = responseJson['CURRENT_TIME'];

        DateTime currentDateTime = DateTime.parse(currentTime);
          if(current_time.statusCode == 200){
              return currentDateTime;
          }
        } catch (e) {
          print(e.toString());
        }
      }

  Future getJadwalNow(id) async{
    try {
    final response = await http.get(Uri.parse(_baseUrl + 'jadwal-mobile/' + id.toString()));
    final current_time = await http.get(Uri.parse(_baseUrl + 'jadwal-mobile/create'));
    var responseJson = jsonDecode(current_time.body);
    String currentTime = responseJson['CURRENT_TIME'];

    DateTime currentDateTime = DateTime.parse(currentTime);
      if(response.statusCode == 200){
        var it = jsonDecode(response.body);

        String year = currentDateTime.year.toString();
        String month = currentDateTime.month.toString().padLeft(2, '0');
        String day = currentDateTime.day.toString().padLeft(2, '0');

        var filteredObj = it.firstWhere((element) => element['tanggal_mulai'] == "$year-$month-$day" , orElse: () => null);
        if (filteredObj != null) {
          return filteredObj;
        } else {
          return null;
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }
}