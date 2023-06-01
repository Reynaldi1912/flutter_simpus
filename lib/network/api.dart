import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Network{
  final String _url = 'https://9187-36-73-182-249.ngrok-free.app/api/';
    // final String _url = 'https://6b88-117-103-68-176.ngrok-free.app/api/';
  // 192.168.1.2 is my IP, change with your IP address
  var token;

  String getUrl(){
    return _url;
  }
  _getToken() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    token = jsonDecode(localStorage.getString('token'))['token'];
  }

  auth(data, apiURL) async{
    var fullUrl = (_url +'v1') + apiURL;
    return await http.post(
      fullUrl,
      body: jsonEncode(data),
      headers: _setHeaders()
    );
  }

  getData(apiURL) async{
    var fullUrl = (_url +'v1') + apiURL;
    await _getToken();
    return await http.get(
      fullUrl,
      headers: _setHeaders(),
    );
  }

  _setHeaders() => {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  };
}