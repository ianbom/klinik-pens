import 'package:e_siklinik/components/header.dart';
import 'package:e_siklinik/pages/dashboard.dart';
import 'package:e_siklinik/pages/data.dart';
import 'package:e_siklinik/pages/search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:rolling_bottom_bar/rolling_bottom_bar.dart';
import 'package:rolling_bottom_bar/rolling_bottom_bar_item.dart';

class ControlPage extends StatefulWidget {
  const ControlPage({super.key});

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  final _controller = PageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const Header(),
        body:
        PageView(
          controller: _controller,
          children: const <Widget>[
          Dashboard(),
          Search(),
          Data()
        ],
        ),
        extendBody: true,
      bottomNavigationBar: RollingBottomBar(
        color: Color.fromARGB(255, 243, 243, 243),
        controller: _controller,
        useActiveColorByDefault: false,
        items: const [
          RollingBottomBarItem(Icons.dashboard_rounded, label: 'Beranda', activeColor: Color(0xFF234DF0)),
          RollingBottomBarItem(Icons.search, label: 'Cari', activeColor: Color(0xFF234DF0)),
          RollingBottomBarItem(FontAwesome.database, label: 'Data', activeColor: Color(0xFF234DF0)),
        ],
        enableIconRotation: true,
        onTap: (index) {
          _controller.animateToPage(
            index,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut,
          );
        },
      ),
      );
  }
}