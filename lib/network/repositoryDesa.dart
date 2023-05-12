import 'dart:convert';

import 'package:http/http.dart' as http;

class RepositoryDesa {
  final _baseUrl = 'http://127.0.0.1:8000/api/';

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