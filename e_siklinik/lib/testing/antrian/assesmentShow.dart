import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AssesmentDetail extends StatefulWidget {
  final int assesmentId;
  const AssesmentDetail({Key? key, required this.assesmentId});

  @override
  State<AssesmentDetail> createState() => _AssesmentDetailState();
}

class _AssesmentDetailState extends State<AssesmentDetail> {
  Map<String, dynamic>? assesmentDetail;

  @override
  void initState() {
    super.initState();
    _getAssesment();
  }

  Future<void> _getAssesment() async {
    try {
      final response = await http.get(Uri.parse(
          "http://192.168.239.136:8000/api/checkup-assesmen/show/${widget.assesmentId}"));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data['results'] != null) {
          setState(() {
            assesmentDetail = data['results'];
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
      body: assesmentDetail != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Nama Dokter: ${assesmentDetail!['nama_dokter']}'),
                  Text(
                      '----------------------------------------------------------------'),
                  Text('Nama Pasien: ${assesmentDetail!['nama']}'),
                  Text('NRP : ${assesmentDetail!['nrp']}'),
                  Text('Gender: ${assesmentDetail!['gender']}'),
                  Text('Tanggal Lahir: ${assesmentDetail!['tanggal_lahir']}'),
                  Text('Alamat :: ${assesmentDetail!['alamat']}'),
                  Text('Nomor HP: ${assesmentDetail!['nomor_hp']}'),
                  Text('Prodi ID: ${assesmentDetail!['prodi_id']}'),
                ],
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
