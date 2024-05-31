import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ShowDokterPage extends StatefulWidget {
  final int dokterId;
  const ShowDokterPage({Key? key, required this.dokterId});

  @override
  State<ShowDokterPage> createState() => _ShowDokterPageState();
}

class _ShowDokterPageState extends State<ShowDokterPage> {
  Map<String, dynamic>? dokterDetail;
  List<dynamic>? riwayatDokter;

  @override
  void initState() {
    super.initState();
    _getDokterDetail();
    _getRiwayatDokter();
  }

  Future<void> _getDokterDetail() async {
    try {
      final response = await http.get(
        Uri.parse(
            "http://10.0.2.2:8000/api/dokter/show/${widget.dokterId}"),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data['dokter'] != null) {
          setState(() {
            dokterDetail = data['dokter'];
          });
        } else {
          print("No data received from API");
        }
      } else {
        print("Failed to load dokter detail");
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _getRiwayatDokter() async {
    try {
      final response = await http.get(Uri.parse(
          "http://10.0.2.2:8000/api/riwayat-dokter/${widget.dokterId}"));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data['checkup'] != null) {
          setState(() {
            riwayatDokter = data['checkup'];
          });
        }
      } else {
        print("Failed to load riwayat checkup");
      }
    } catch (error) {
      print('Error : $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Dokter'),
      ),
      body: dokterDetail != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          'http://10.0.2.2:8000/storage/' +
                              dokterDetail!['image'],
                        ),
                      ),
                      Text('Nama: ${dokterDetail!['nama']}'),
                      Text('Gender: ${dokterDetail!['gender']}'),
                      Text('Tanggal Lahir: ${dokterDetail!['tanggal_lahir']}'),
                      Text('Alamat: ${dokterDetail!['alamat']}'),
                      Text('Nomor HP: ${dokterDetail!['nomor_hp']}'),
                      Text(
                          'Hari: ${dokterDetail!['dokter_to_jadwal'][0]['hari']}'),
                      Text(
                          'Jam Mulai: ${dokterDetail!['dokter_to_jadwal'][0]['jadwal_mulai_tugas']}'),
                      Text(
                          'Jam Selesai: ${dokterDetail!['dokter_to_jadwal'][0]['jadwal_selesai_tugas']}'),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Riwayat Checkup Dokter:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: riwayatDokter != null
                      ? ListView.builder(
                          itemCount: riwayatDokter!.length,
                          itemBuilder: (BuildContext context, int index) {
                            final riwayat = riwayatDokter![index];
                            return Card(
                              child: ListTile(
                                title:
                                    Text(riwayat['hasil_diagnosa'].toString()),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Checkup Id: ${riwayat['id']}'),
                                    Text(
                                        'Hasil Diagnosa: ${riwayat['hasil_diagnosa']}'),
                                    Text(
                                        'Assesmen Id: ${riwayat['assesmen_id']}'),
                                    // Tambahkan informasi lain yang diperlukan
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : Center(child: CircularProgressIndicator()),
                ),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}