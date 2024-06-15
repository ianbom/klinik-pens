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
      "http://192.168.239.136:8000/api/checkup-assesmen";
  List<dynamic> assesmentList = [];
  bool isLoading = true; // flag to track loading state

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
          // Filter hasil yang sudah selesai atau sudah diisi
          final filteredResults = data['results'].where((result) {
            return result['status'] !=
                'Selesai'; // Ubah kondisi sesuai dengan kebutuhan Anda
          }).toList();

          setState(() {
            assesmentList = filteredResults;
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
          print("No data received from API");
        }
      } else {
        setState(() {
          isLoading = false;
        });
        print("Failed to load pasien");
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print('Error : $error');
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      isLoading = true;
    });
    await _getAllAssesment();
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
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: _refreshData,
                child: assesmentList.isEmpty
                    ? Center(
                        child: Image.asset(
                          'assets/images/kosong.png',
                          fit: BoxFit.cover,
                        ),
                      )
                    : SafeArea(
                        child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: ListView.builder(
                          itemCount: assesmentList.length,
                          itemBuilder: (BuildContext context, int index) {
                            final assesment = assesmentList[index];
                            final assesmentId =
                                assesment['checkup_assesmen_id'];
                            return GestureDetector(
                              onTap: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AddCheckup(assesmentId: assesmentId),
                                  ),
                                );
                                if (result == true) {
                                  _refreshData(); // Memuat ulang data jika perlu
                                }
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 5),
                                padding: const EdgeInsets.only(
                                    top: 15, bottom: 15, left: 15, right: 45),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  image: const DecorationImage(
                                    image: AssetImage(
                                        'assets/images/Utilities1.png'),
                                    fit: BoxFit.fill,
                                  ),
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15)),
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
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      "Dokter : ${assesment['nama_dokter'] ?? ''}",
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )),
              ));
  }
}
