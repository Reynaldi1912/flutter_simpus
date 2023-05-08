import 'package:flutter/material.dart';
import 'package:flutter_auth/network/api.dart';
import 'register.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';

class Login extends StatefulWidget{
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login>{
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  var name, password;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _secureText = true;

  showHide(){
    setState(() {
      _secureText = !_secureText;
    });
  }

  _showMsg(msg) {
    final snackBar = SnackBar(
      content: Text(msg),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context){
     return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color.fromARGB(255, 48, 189, 72), Color.fromARGB(255, 29, 62, 151)])),
       child: Scaffold(
        backgroundColor: Colors.transparent,
        key: _scaffoldKey,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 28, vertical: 72),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text("SIMPUS"),
                ),
                Container(
                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 1/8),
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Welcome to SIMPUS Kedungjajang",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // menambahkan properti color
                            ),
                          ),
                          SizedBox(height: 18),
                          TextFormField(
                            cursorColor: Colors.blue,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: "NIP",
                              filled: true, // membuat background terisi
                              fillColor: Colors.white, // memberikan warna putih pada background
                            ),
                            validator: (nameValue){
                              if(nameValue.isEmpty){
                                return 'Please enter your NIPP';
                              }
                              name = nameValue;
                              return null;
                            }
                          ),

                          SizedBox(height: 12),
                          TextFormField(
                            cursorColor: Colors.blue,
                            keyboardType: TextInputType.text,
                            obscureText: _secureText,
                            decoration: InputDecoration(
                              hintText: "Password",
                              filled: true, // membuat background terisi
                              fillColor: Colors.white, // memberikan warna putih pada background
                              suffixIcon: IconButton(
                                onPressed: showHide,
                                icon: Icon(_secureText
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                              ),
                            ),
                            validator: (passwordValue){
                              if(passwordValue.isEmpty){
                                return 'Please enter your password';
                              }
                              password = passwordValue;
                              return null;
                            }
                          ),

                          SizedBox(height: 12),
                          TextButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                              child: Text(
                                _isLoading? 'Proccessing..' : 'Login',
                                textDirection: TextDirection.ltr,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                _login();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
         ),
     );
  }

  void _login() async{
    setState(() {
      _isLoading = true;
    });
    var data = {
      'id' : name,
      'password' : password
    };

    var res = await Network().auth(data, '/login');
    var body = json.decode(res.body);
    print(body);
    if(body['success'] && body['role']){
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', json.encode(body['token']));
      localStorage.setString('user', json.encode(body['user']));
      Navigator.pushReplacement(
          context,
          new MaterialPageRoute(
              builder: (context) => Home()
          ),
      );
    }else{
      _showMsg(body['message']);
    }

    setState(() {
      _isLoading = false;
    });
  }
}