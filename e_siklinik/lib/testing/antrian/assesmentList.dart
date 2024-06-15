import 'package:e_siklinik/testing/checkup/addCheckup.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AssesmentList extends StatefulWidget {
  const AssesmentList({Key? key}) : super(key: key);

  @override
  State<AssesmentList> createState() => _AssesmentListState();
}

class _AssesmentListState extends State<AssesmentList> {
  final String apiGetAllAssesment =
      "http://192.168.239.136:8000/api/checkup-assesmen";
  List<dynamic> assesmentList = [];

  @override
  void initState() {
    super.initState();
    _getAllAssesment();
  }

  Future<void> _getAllAssesment() async {
    try {
      final response = await http.get(Uri.parse(apiGetAllAssesment));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data['results'] != null) {
          setState(() {
            assesmentList = data['results'];
          });
        } else {
          print("No data received from API");
        }
      } else {
        print("Failed to load pasien");
      }
    } catch (error) {
      print('Error : $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Assesment'),
      ),
      body: assesmentList.isEmpty
          ? Center(
              child: Text(
                'Tidak ada data pasien',
                style: TextStyle(fontSize: 18.0),
              ),
            )
          : ListView.builder(
              itemCount: assesmentList.length,
              itemBuilder: (BuildContext context, int index) {
                final assesment = assesmentList[index];
                final assesmentId = assesment['id'];

                return GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) =>
                    //         ShowPasienDetail(pasienId: assesmentId),
                    //   ),
                    // );
                  },
                  child: ListTile(
                    title: Text(assesment['nama_pasien'] ?? ''),
                    subtitle: Text(assesment['nama_dokter'] ?? ''),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(assesment['nama_prodi']),
                        Text(assesment['nrp']),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AddCheckupResult(assesmentId: assesmentId),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
