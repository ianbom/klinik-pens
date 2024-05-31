import 'dart:convert';

import 'package:e_siklinik/components/box.dart';
import 'package:e_siklinik/pages/Antrian/list_antrian.dart';
import 'package:e_siklinik/pages/Assessment/assessment.dart';
import 'package:e_siklinik/pages/carousel_banner.dart';
import 'package:e_siklinik/pages/carousel_jadwal.dart';
import 'package:e_siklinik/testing/antrian/listAntrian.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'Jadwal/jadwal_dokter_model.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late List<JadwalDokter> todayDoctor = [];
  void _getJadwalToday() async {
  try {
    DateTime today = DateTime.now();
    String dayName = DateFormat('EEEE').format(today);
    switch (dayName) {
      case 'Monday':
        dayName = 'Senin';
        break;
      case 'Tuesday':
        dayName = 'Selasa';
        break;
      case 'Wednesday':
        dayName = 'Rabu';
        break;
      case 'Thursday':
        dayName = 'Kamis';
        break;
      case 'Friday':
        dayName = 'Jum\'at';
        break;
      case 'Saturday':
        dayName = 'Sabtu';
        break;
      case 'Sunday':
        dayName = 'Minggu';
        break;
      default:
        break;
    }

    Uri url = Uri.parse('http://10.0.2.2:8000/api/jadwal_dokter/today/$dayName');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      if (jsonData != null && jsonData['jadwal_dokter'] != null) {
        List<dynamic> jadwalList = jsonData['jadwal_dokter'];
        setState(() {
          todayDoctor = jadwalList.map((json) => JadwalDokter.fromJson(json)).toList();
        });
      } else {
        print('No schedule found for today');
        setState(() {
          todayDoctor = []; // Set an empty list if no schedule is found
        });
      }
    } else {
      print('Failed to load data');
    }
  } catch (error) {
    print('An error occurred: $error');
  }
}


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getJadwalToday();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FB),
      body: SafeArea(
          maintainBottomViewPadding: true,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 25),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  Center(
                    child: Container(
                      width: 1000,
                      height: 150,
                      child: CarouselBanner(),
                    ),
                  ),
                  Container(
                    child: CarouselJadwal(),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    width: double.infinity,
                    height: 160,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Jadwal Antrian",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                            TextButton(
                                onPressed: () {},
                                child: const Text(
                                  "Tampilkan Semua",
                                  style: TextStyle(color: Colors.grey),
                                ))
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.all(15),
                          width: double.infinity,
                          height: 100,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  offset: const Offset(-1, 2),
                                  blurRadius: 3,
                                  spreadRadius: 0,
                                ),
                              ],
                              image: const DecorationImage(
                                  image:
                                      AssetImage('assets/images/Schedule.png'),
                                  fit: BoxFit.fill)),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "John Doe",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "9732344524",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const Text(
                    "Utilities",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  Column(
                    children: [
                      Box(
                        title: 'Check Up',
                        desc: 'Tambahkan Hasil Check Up Pasien',
                        bgimage: 'assets/images/Utilities1.png',
                        icon: const Icon(
                          Icons.data_saver_on,
                          size: 25,
                          color: Color(0xFF234DF0),
                        ),
                        onTapBox: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AssesmentPage()));
                        },
                      ),
                      Box(
                        title: 'Jadwal Antrean',
                        desc: 'Mengatur Jadwal Antrean Pasien',
                        bgimage: 'assets/images/Utilities2.png',
                        icon: const Icon(Icons.people_alt,
                            size: 25, color: Color(0xFF234DF0)),
                        onTapBox: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ListAntrianNew()));
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 70,
                  )
                ],
              ),
            ),
          )),
    );
  }
}