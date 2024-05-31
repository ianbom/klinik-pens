import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;

class CarouselJadwal extends StatefulWidget {
  const CarouselJadwal({super.key});

  @override
  State<CarouselJadwal> createState() => _CarouselJadwalState();
}

class _CarouselJadwalState extends State<CarouselJadwal> {
  final String apiGetAllJadwalDokter = "http://10.0.2.2:8000/api/jadwal_dokter";
  List<dynamic> jadwalList = [];

  @override
  void initState() {
    super.initState();
    _getAllJadwal();
  }

  Future<void> _getAllJadwal() async {
    try {
      final response = await http.get(Uri.parse(apiGetAllJadwalDokter));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data['jadwal_dokter'] != null) {
          setState(() {
            jadwalList = data['jadwal_dokter'];
          });
        } else {
          print("No data received from API");
        }
      } else {
        print("Failed to load Data");
      }
    } catch (error) {
      print('Error : $error');
    }
  }

  Future<void> _refreshData() async {
    await _getAllJadwal();
  }

  final List<Map<String, dynamic>> doctorSchedules = [
    {
      'name': 'Andru Falah Arifin',
      'time': '13.00 - 13.30',
    },
    {
      'name': 'Jessica Wilson',
      'time': '14.00 - 14.30',
    },
    {
      'name': 'Michael Thompson',
      'time': '15.00 - 15.30',
    },
    // Add more schedules here
  ];

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
          CarouselSlider(
            options: CarouselOptions(
              autoPlay: true,
              aspectRatio: 3.3,
              viewportFraction: 1.0,
              enlargeCenterPage: true,
            ),
            items: jadwalList.map((jadwal) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
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
                          jadwal['jadwal_to_dokter']['nama'],
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
                              '${jadwal['jadwal_mulai_tugas'].substring(0, 5)} - ${jadwal['jadwal_selesai_tugas'].substring(0, 5)}',
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
