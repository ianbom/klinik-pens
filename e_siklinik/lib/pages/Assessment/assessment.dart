import 'package:e_siklinik/components/box.dart';
import 'package:e_siklinik/pages/Checkup/checkup.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AssesmentPage extends StatefulWidget {
  const AssesmentPage({Key? key}) : super(key: key);

  @override
  State<AssesmentPage> createState() => _AssesmentPageState();
}

class _AssesmentPageState extends State<AssesmentPage> {
  final String apiGetAllAssesment =
      "http://10.0.2.2:8000/api/checkup-assesmen";
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
          print(response.body);
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
        backgroundColor: const Color(0xFFF9F9FB),
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios)),
          backgroundColor: Colors.white,
          elevation: 2,
          shadowColor: Colors.black,
          centerTitle: true,
          title: const Text(
            "Assesment",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        body: assesmentList.isEmpty
            ? const Center(
                child: Text(
                  'Tidak ada data pasien',
                  style: TextStyle(fontSize: 18.0),
                ),
              )
            : SafeArea(
                child: Padding(
                padding: const EdgeInsets.all(16),
                child: ListView.builder(
                  itemCount: assesmentList.length,
                  itemBuilder: (BuildContext context, int index) {
                    final assesment = assesmentList[index];
                    final assesmentId = assesment['checkup_assesmen_id'];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AddCheckup(assesmentId: assesmentId),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
                        padding: const EdgeInsets.all(15),
                        width: double.infinity,
                        height: 100,
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                              image: AssetImage('assets/images/Utilities1.png'),
                              fit: BoxFit.fill),
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
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Nomor Antrean : ${assesment['no_antrian'] ?? ''}",
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              "Pasien : ${assesment['nama_pasien'] ?? ''}",
                              style: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "Dokter : ${assesment['nama_dokter'] ?? ''}",
                              style: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )));
  }
}