import 'package:e_siklinik/pages/Recycled%20Data/deleted_dokter_data.dart';
import 'package:e_siklinik/pages/Recycled%20Data/deleted_jadwal_data.dart';
import 'package:e_siklinik/pages/Recycled%20Data/deleted_obat_data.dart';
import "package:e_siklinik/pages/Recycled%20Data/deleted_pasien_data.dart";
import "package:flutter/material.dart";
import 'package:e_siklinik/components/box.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:fluttericon/rpg_awesome_icons.dart';
import 'package:fluttericon/entypo_icons.dart';

class RecycledDataMain extends StatefulWidget {
  const RecycledDataMain({super.key});

  @override
  State<RecycledDataMain> createState() => _RecycledDataMainState();
}

class _RecycledDataMainState extends State<RecycledDataMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios)),
        backgroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.black,
        centerTitle: true,
        title: const Text(
          "Data Terhapus",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
          maintainBottomViewPadding: true,
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            offset: const Offset(-1, 2),
                            blurRadius: 3,
                            spreadRadius: 0,
                          ),
                        ],
                        border: Border.all(
                            color: const Color(0xFF234DF0), width: 2),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                        image: const DecorationImage(
                            image: AssetImage('assets/images/BannerData.jpeg'),
                            fit: BoxFit.fill)),
                    width: double.infinity,
                    height: 150,
                    child: const Center(),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Database",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  Column(
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      Box(
                        title: "Pasien",
                        desc: "Restore Data Pasien",
                        bgimage: 'assets/images/bgpolos.png',
                        icon: setIcon(
                            Icons.person_outline, const Color(0xFF234DF0)),
                        onTapBox: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const DeletedPasienData()));
                        },
                      ),
                      Box(
                        title: "Dokter",
                        desc: "Restore Data Dokter",
                        bgimage: 'assets/images/bgpolos.png',
                        icon: setIcon(
                            FontAwesome.stethoscope, const Color(0xFF234DF0)),
                        onTapBox: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const DeletedDokterData()));
                        },
                      ),
                      Box(
                        title: "Obat",
                        desc: "Data Obat Terhapus",
                        bgimage: 'assets/images/bgpolos.png',
                        icon: setIcon(RpgAwesome.pill, const Color(0xFF234DF0)),
                        onTapBox: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const DeletedObatData()));
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 70,
                  )
                ],
              ),
            ),
          )),
    );
  }

  Widget setIcon(IconData iconData, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: ShapeDecoration(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          color: const Color(0xFFDDEAFF)),
      child: Icon(
        iconData,
        color: iconColor,
      ),
    );
  }
}
