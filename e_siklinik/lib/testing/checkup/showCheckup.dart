import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ShowCheckupDetail extends StatefulWidget {
  final int checkupId;
  const ShowCheckupDetail({Key? key, required this.checkupId});

  @override
  State<ShowCheckupDetail> createState() => _ShowCheckupDetailState();
}

class _ShowCheckupDetailState extends State<ShowCheckupDetail> {
  Map<String, dynamic>? checkupDetail;

  @override
  void initState() {
    super.initState();
    _getCheckupDetail();
  }

  Future<void> _getCheckupDetail() async {
    try {
      final response = await http.get(Uri.parse(
          "http://10.0.2.2:8000/api/checkup-result/show/${widget.checkupId}"));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data['results'] != null) {
          setState(() {
            checkupDetail = data['results'];
            print(checkupDetail);
          });
        }
      } else {
        print("Failed to load pasien detail");
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
      body: checkupDetail != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('No Assesmen: ${checkupDetail!['assesmen_id']}'),
                  Text(
                      'Nama Dokter: ${checkupDetail!['nama_dokter, dokter.id']}'),
                  Text(
                      'Nama Pasien: ${checkupDetail!['nama_pasien, pasien.id']}'),
                  Text('Hasil Diagnosa : ${checkupDetail!['hasil_diagnosa']}'),
                  Text('Antrian Id: ${checkupDetail!['antrian_id']}'),
                  Text('Prodi: ${checkupDetail!['nama']}'),
                  Text('Gender: ${checkupDetail!['gender']}'),
                  Text('Tanggal Lahir: ${checkupDetail!['tanggal_lahir']}'),
                  Text('nomor_hp: ${checkupDetail!['nomor_hp']}'),
                  Text('Alamat: ${checkupDetail!['alamat']}'),
                  Text('Pasien Id: ${checkupDetail!['pasien_id']}'),
                  Text('No Antrian: ${checkupDetail!['no_antrian']}'),
                  Text('Nrp: ${checkupDetail!['nrp']}'),
                  Text('Nama Obat: ${checkupDetail!['nama_obat']}'),
                  Text('Kadaluarsa: ${checkupDetail!['tanggal_kadaluarsa']}'),
                ],
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
