import 'dart:convert';
import 'package:e_siklinik/pages/Antrian/add_antrian.dart';
import 'package:e_siklinik/pages/Assessment/add_assessment.dart';
import 'package:e_siklinik/testing/antrian/addAssesment.dart';
import 'package:e_siklinik/testing/antrian/assesmentList.dart';
import 'package:e_siklinik/testing/antrian/assesmentShow.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AntrianListPage extends StatefulWidget {
  @override
  _AntrianListPageState createState() => _AntrianListPageState();
}

class _AntrianListPageState extends State<AntrianListPage> {
  List<dynamic> antrianList = [];
  final String apiGetAntrian = "http://10.0.2.2:8000/api/antrian";

  @override
  void initState() {
    super.initState();
    _getAllAntrian();
  }

  Future<void> _getAllAntrian() async {
    try {
      final response = await http.get(Uri.parse(apiGetAntrian));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data['antrian'] != null) {
          setState(() {
            antrianList = data['antrian'];
          });
        } else {
          print("No data received from API");
        }
      } else {
        print("Failed to load prodi");
      }
    } catch (error) {
      print('Error : $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddAntrian(),
            ),
          );
        },
        child: Icon(Icons.add, size: 30, color: Colors.white),
        backgroundColor: Color(0xFF234DF0),
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      appBar: AppBar(
        title: Text('Daftar Antrian'),
      ),
      body: antrianList.isEmpty
          ? Center(
              child: Text(
                'Antrian Kosong',
                style: TextStyle(fontSize: 18.0),
              ),
            )
          : ListView.builder(
              itemCount: antrianList.length,
              itemBuilder: (BuildContext context, int index) {
                final antrian = antrianList[index];
                final antrianId = antrian['id'];
                return Card(
                  child: ListTile(
                    title: Text(antrian['no_antrian'].toString()),
                    subtitle: Text(antrian['antrian_to_pasien']['nama']),
                    leading: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddAssessment(
                              antrianId: antrianId,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
