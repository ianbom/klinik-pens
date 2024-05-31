import 'package:e_siklinik/components/box.dart';
import 'package:e_siklinik/pages/Dokter/data_dokter.dart';
import 'package:e_siklinik/pages/Jadwal/data_jadwal.dart';
import 'package:e_siklinik/pages/Obat/data_obat.dart';
import 'package:e_siklinik/pages/Pasien/data_pasien.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:fluttericon/rpg_awesome_icons.dart';
import 'package:fluttericon/entypo_icons.dart';

class Data extends StatefulWidget {
  const Data({super.key});

  @override
  State<Data> createState() => _DataState();
}

class _DataState extends State<Data> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FB),
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
                        desc: "Add, Edit, Delete Data\nPasien",
                        bgimage: '',
                        icon: setIcon(
                            Icons.person_outline, const Color(0xFF234DF0)),
                        onTapBox: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const DataPasien()));
                        },
                      ),
                      Box(
                        title: "Dokter",
                        desc: "Add, Edit, Delete Data\nDokter",
                        bgimage: '',
                        icon: setIcon(
                            FontAwesome.stethoscope, const Color(0xFF234DF0)),
                        onTapBox: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const DataDokter()));
                        },
                      ),
                      Box(
                        title: "Obat",
                        desc: "Add, Edit, Delete Data\nObat",
                        bgimage: '',
                        icon: setIcon(RpgAwesome.pill, const Color(0xFF234DF0)),
                        onTapBox: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const DataObat()));
                        },
                      ),
                      Box(
                          title: "Jadwal Dokter",
                          desc: "Add, Edit, Delete Data\nJadwal Dokter",
                          bgimage: '',
                          icon: setIcon(
                              Entypo.back_in_time, const Color(0xFF234DF0)),
                          onTapBox: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const DataJadwal()));
                          })
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
}

Widget setIcon(IconData iconData, Color iconColor) {
  return Container(
    padding: const EdgeInsets.all(5),
    decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: const Color(0xFFDDEAFF)),
    child: Icon(
      iconData,
      color: iconColor,
    ),
  );
}
