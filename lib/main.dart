import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/home.dart';
import 'screens/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        splash: Transform.scale(
          scale: 4.0,
          child: Image.asset('assets/SIMPUS.png'),
        ),
        nextScreen: CheckAuth(),
        splashTransition: SplashTransition.slideTransition,
        duration: 3000,
        backgroundColor: Colors.blue,
      ),
      darkTheme: ThemeData(brightness: Brightness.light, accentColor: Colors.blueAccent),
      themeMode: ThemeMode.light,
      routes: {
        '/home': (context) => Home(),
      },
    );
  }
}

class CheckAuth extends StatefulWidget{
  @override
  _CheckAuthState createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth>{
  bool isAuth = false;

  @override
  void initState(){
    super.initState();
    _checkIfLoggedIn();
  }

  void _checkIfLoggedIn() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    if(token != null){
      if(mounted){
        setState(() {
          isAuth = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context){
    Widget child;
    print(isAuth);
    if(isAuth){
      print("Berhasil");
      child = Home();
    } else{
      print("Gagal");
      child = Login();
    }

  
    return Scaffold(
      body: child,
    );
  }
}
