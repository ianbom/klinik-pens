import 'package:e_siklinik/control.dart';
import 'package:e_siklinik/pages/login.dart';
import 'package:e_siklinik/testing/grafik/grafik_obat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
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
        debugShowCheckedModeBanner: false,
        home: 
        ControlPage());
        // haveCookie ? const ControlPage() : const LoginPage());
  }
}
