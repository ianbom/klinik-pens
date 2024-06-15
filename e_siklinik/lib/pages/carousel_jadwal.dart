import 'dart:convert';

import 'package:e_siklinik/pages/Jadwal/jadwal_dokter_model.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class CarouselJadwal extends StatefulWidget {
  const CarouselJadwal({super.key});

  @override
  State<CarouselJadwal> createState() => _CarouselJadwalState();
}

class _CarouselJadwalState extends State<CarouselJadwal> {
  late List<JadwalDokter> todayDoctor = [];
  //  late List<dynamic> todayDoctor = [];
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

      Uri url = Uri.parse(
          'http://192.168.239.136:8000/api/jadwal_dokter/today/$dayName');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData != null && jsonData['jadwal_dokter'] != null) {
          List<dynamic> jadwalList = jsonData['jadwal_dokter'];
          setState(() {
            todayDoctor =
                jadwalList.map((json) => JadwalDokter.fromJson(json)).toList();
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

  // final String apiGetAllJadwalDokter = "http://192.168.239.136:8000/api/jadwal_dokter";
  // List<dynamic> jadwalList = [];

  // @override
  // void initState() {
  //   super.initState();
  //   _getAllJadwal();
  // }

  // Future<void> _getAllJadwal() async {
  //   try {
  //     final response = await http.get(Uri.parse(apiGetAllJadwalDokter));
  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);
  //       if (data != null && data['jadwal_dokter'] != null) {
  //         setState(() {
  //           jadwalList = data['jadwal_dokter'];
  //         });
  //       } else {
  //         print("No data received from API");
  //       }
  //     } else {
  //       print("Failed to load Data");
  //     }
  //   } catch (error) {
  //     print('Error : $error');
  //   }
  // }

  // Future<void> _refreshData() async {
  //   await _getAllJadwal();
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Jadwal Dokter",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          todayDoctor.isEmpty
              ? Container(
                  margin: EdgeInsets.all(4),
                  padding: const EdgeInsets.all(15),
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        offset: const Offset(-1, 2),
                        blurRadius: 3,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Text(
                            "Tidak ada dokter yang bertugas",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      )
                    ],
                  ))
              : CarouselSlider(
                  options: CarouselOptions(
                    autoPlay: true,
                    aspectRatio: 3.3,
                    viewportFraction: 1.0,
                    enlargeCenterPage: true,
                  ),
                  items: todayDoctor.map((jadwal) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          margin: EdgeInsets.all(4),
                          padding: const EdgeInsets.all(15),
                          width: double.infinity,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(16)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                offset: const Offset(-1, 2),
                                blurRadius: 3,
                                spreadRadius: 0,
                              ),
                            ],
                            image: const DecorationImage(
                              image: AssetImage('assets/images/Schedule2.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                jadwal.nama,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.timer_outlined,
                                    color: Color(0xFF234DF0),
                                    size: 18,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    '${jadwal.jadwalMulaiTugas.substring(0, 5)} - ${jadwal.jadwalSelesaiTugas.substring(0, 5)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
        ],
      ),
    );
  }
}
