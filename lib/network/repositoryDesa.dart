import 'dart:convert';

import 'package:flutter_auth/network/api.dart';
import 'package:http/http.dart' as http;

class RepositoryDesa {
  Network network = Network();
  String _baseUrl;

  RepositoryDesa() {
    _baseUrl = network.getUrl();
  }

  Future getDesa(id) async{
    try {
      final response = await http.get(Uri.parse(_baseUrl + 'get-desa/' + id.toString()));
      if(response.statusCode == 200){
        var it = jsonDecode(response.body);
        return it[0];
      }
    } catch (e) {
      print(e.toString());
    }
  }
}