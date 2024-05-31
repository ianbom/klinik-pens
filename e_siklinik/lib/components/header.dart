import 'package:e_siklinik/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/web_symbols_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({super.key});
  Future<bool> destroy() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.clear();
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        elevation: 2,
        shadowColor: Colors.black,
        title: const Text(
          "Hi, Admin",
          style: TextStyle(fontSize: 20),
        ),
        leading: Container(
          padding: const EdgeInsets.only(left: 10.0), // Add padding to the left
          child: const CircleAvatar(
            backgroundColor: Color(0xFFB7D1FF),
            radius: 18,
            child: Icon(
              Icons.person_outline,
              color: Color(0xFF234DF0),
            ),
          ),
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              padding: const EdgeInsets.only(right: 10),
              icon: const Icon(WebSymbols.logout),
              onPressed: () {
                destroy();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              },
            ),
          ),
        ],
      ),
    );
  }
}
