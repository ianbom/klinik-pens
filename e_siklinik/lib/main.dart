import 'package:e_siklinik/control.dart';
import 'package:e_siklinik/pages/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool haveCookie = false;
  void getCookie() async {
    SharedPreferences cookie = await SharedPreferences.getInstance();
    if (cookie.getString('token') != null) {
      setState(() {
        haveCookie = true;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getCookie();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: 
        ControlPage());
        // haveCookie ? const ControlPage() : const LoginPage());
  }
}
