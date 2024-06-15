import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ShowPasienDetail extends StatefulWidget {
  final int pasienId;
  const ShowPasienDetail({Key? key, required this.pasienId});

  @override
  State<ShowPasienDetail> createState() => _ShowPasienDetailState();
}

class _ShowPasienDetailState extends State<ShowPasienDetail> {
  Map<String, dynamic>? pasienDetail;
  List<dynamic>? riwayat;

  @override
  void initState() {
    super.initState();
    _getPasienDetail();
    _getRiwayatCheckup();
  }

  Future<void> _getPasienDetail() async {
    try {
      final response = await http.get(Uri.parse(
          "http://192.168.239.136:8000/api/pasien/show/${widget.pasienId}"));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data['pasien'] != null) {
          setState(() {
            pasienDetail = data['pasien'];
          });
        }
      } else {
        print("Failed to load pasien detail");
      }
    } catch (error) {
      print('Error : $error');
    }
  }

  Future<void> _getRiwayatCheckup() async {
    try {
      final response = await http.get(Uri.parse(
          "http://192.168.239.136:8000/api/riwayat-pasien/${widget.pasienId}"));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data['checkup'] != null) {
          setState(() {
            riwayat = data['checkup'];
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
        title: Text('Detail Pasien'),
      ),
      body: pasienDetail != null && riwayat != null
          ? Column(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      'http://192.168.239.136:8000/storage/' +
                          pasienDetail!['image']),
                ),
                Text('Nama: ${pasienDetail!['nama']}'),
                Text('NRP: ${pasienDetail!['nrp']}'),
                Text('Gender: ${pasienDetail!['gender']}'),
                Text('Tanggal Lahir: ${pasienDetail!['tanggal_lahir']}'),
                Text('Alamat: ${pasienDetail!['alamat']}'),
                Text('Nomor HP: ${pasienDetail!['nomor_hp']}'),
                Text('Nomor Wali: ${pasienDetail!['nomor_wali']}'),
                Expanded(
                  child: ListView.builder(
                    itemCount: riwayat!.length,
                    itemBuilder: (BuildContext context, int index) {
                      final checkup = riwayat![index];
                      return Card(
                        child: ListTile(
                          title: Text(
                              'Hasil Diagnosa: ${checkup['hasil_diagnosa']}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Checkup Id: ${checkup['id']}'),
                              Text('Assesmen Id: ${checkup['assesmen_id']}'),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
