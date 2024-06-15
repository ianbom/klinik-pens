import 'package:e_siklinik/components/box.dart';
import 'package:e_siklinik/pages/Checkup/riwayat_checkup.dart';
import 'package:e_siklinik/pages/data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ShowDokter extends StatefulWidget {
  final int dokterId;
  const ShowDokter({Key? key, required this.dokterId});
  @override
  State<ShowDokter> createState() => _ShowDokterState();
}

class _ShowDokterState extends State<ShowDokter> {
  Map<String, dynamic>? dokterDetail;
  List<dynamic>? allRiwayatDokter;
  List<dynamic>? filteredRiwayatDokter;
  bool isLoading = true;
  bool hasError = false;

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
            "http://192.168.239.136:8000/api/dokter/show/${widget.dokterId}"),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 30)); // Increased timeout duration

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data['dokter'] != null) {
          setState(() {
            dokterDetail = data['dokter'];
            isLoading = false;
          });
        } else {
          setState(() {
            hasError = true;
            isLoading = false;
          });
        }
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
        print("Failed to load dokter detail: ${response.statusCode}");
      }
    } catch (error) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
      print('Error: $error');
    }
  }

  Future<void> _getRiwayatDokter() async {
    try {
      final response = await http.get(Uri.parse(
          "http://192.168.239.136:8000/api/riwayat-dokter/${widget.dokterId}"));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data['checkup'] != null) {
          setState(() {
            allRiwayatDokter = data['checkup'];
            filteredRiwayatDokter = allRiwayatDokter;
          });
        }
      } else {
        print("Failed to load riwayat checkup");
      }
    } catch (error) {
      print('Error : $error');
    }
  }

  void _filterRiwayatDokter(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredRiwayatDokter = allRiwayatDokter;
      });
    } else {
      setState(() {
        filteredRiwayatDokter = allRiwayatDokter?.where((riwayat) {
          final namaPasien = riwayat['check_up_resul_to_assesmen']
                      ['assesmen_to_antrian']['antrian_to_pasien']['nama']
                  ?.toLowerCase() ??
              '';
          return namaPasien.contains(query.toLowerCase());
        }).toList();
      });
    }
  }

  String extractDate(String dateTime) {
    return dateTime.split('T')[0];
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
          icon: const Icon(Icons.arrow_back_ios),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.black,
        centerTitle: true,
        title: const Text(
          "Detail Dokter",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hasError
              ? const Center(child: Text('Failed to load data'))
              : NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverAppBar(
                        automaticallyImplyLeading: false,
                        expandedHeight: 300.0,
                        floating: false,
                        stretch: true,
                        flexibleSpace: FlexibleSpaceBar(
                          collapseMode: CollapseMode.parallax,
                          background: dokterDetail != null &&
                                  dokterDetail!['image'] != null
                              ? Image.network(
                                  'http://192.168.239.136:8000/storage/' +
                                      dokterDetail!['image'],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset('assets/images/pp.png',
                                        fit: BoxFit.cover);
                                  },
                                )
                              : Image.asset(
                                  'assets/images/pp.png',
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ];
                  },
                  body: dokterDetail != null
                      ? Padding(
                          padding: const EdgeInsets.all(24),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 244, 244, 244),
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
                                    children: [
                                      Container(
                                          padding:
                                              const EdgeInsets.only(bottom: 8),
                                          width: double.infinity,
                                          decoration: const BoxDecoration(
                                              border: BorderDirectional(
                                                  bottom: BorderSide(
                                                      color: Colors.black))),
                                          child: Text(
                                            dokterDetail!['nama'] ?? '',
                                            style: const TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w600),
                                          )),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      setInfoDokter('Gender',
                                          dokterDetail!['gender'] ?? ''),
                                      setInfoDokter('Tanggal Lahir',
                                          dokterDetail!['tanggal_lahir'] ?? ''),
                                      setInfoDokter('Alamat',
                                          dokterDetail!['alamat'] ?? ''),
                                      setInfoDokter('Nomor Hp',
                                          dokterDetail!['nomor_hp'] ?? ''),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const Text(
                                  "Pasien Terakhir",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  width: double.infinity,
                                  height: 50,
                                  decoration: const BoxDecoration(
                                      color: Color(0xFFEFF0F3),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30))),
                                  child: Row(
                                    children: [
                                      Flexible(
                                        child: TextFormField(
                                          onChanged: _filterRiwayatDokter,
                                          maxLines: null,
                                          decoration: const InputDecoration(
                                            hintText: 'Search Here',
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                      const Icon(Icons.search),
                                    ],
                                  ),
                                ),
                                Divider(),
                                const SizedBox(
                                  height: 10,
                                ),
                                filteredRiwayatDokter != null
                                    ? ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount:
                                            filteredRiwayatDokter!.length,
                                        itemBuilder: (context, index) {
                                          final riwayat =
                                              filteredRiwayatDokter![index];
                                          final checkupId = riwayat['id'];
                                          final namaPasien =
                                              riwayat['check_up_resul_to_assesmen']
                                                              [
                                                              'assesmen_to_antrian']
                                                          ['antrian_to_pasien']
                                                      ['nama'] ??
                                                  'Tidak ada nama';
                                          final nomorAntrian =
                                              riwayat['check_up_resul_to_assesmen']
                                                          [
                                                          'assesmen_to_antrian']
                                                      ['no_antrian'] ??
                                                  '';
                                          return BoxRiwayatDokter(
                                            onTapBox: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          RiwayatCheckup(
                                                              checkupId:
                                                                  checkupId)));
                                            },
                                            nama: "Nama Pasien : $namaPasien",
                                            nrp:
                                                "NRP : ${riwayat['check_up_resul_to_assesmen']['assesmen_to_antrian']['antrian_to_pasien']['nrp'] ?? ''}",
                                            icon: setIcon(Icons.person_outline,
                                                const Color(0xFF234DF0)),
                                            tanggal: Text(
                                              "Tanggal : ${riwayat['created_at'] != null ? extractDate(riwayat['created_at']) : 'N/A'}",
                                              style: TextStyle(fontSize: 13),
                                            ),
                                            no: '$nomorAntrian',
                                          );
                                          // Card(
                                          //   child: ListTile(
                                          //     title: Text('Hasil Diagnosa: ${riwayat['hasil_diagnosa']}'),
                                          //     subtitle: Column(
                                          //       crossAxisAlignment: CrossAxisAlignment.start,
                                          //       children: [
                                          //         Text('No Antrian: $nomorAntrian'),
                                          //         Text('Nama Pasien: $namaPasien'),
                                          //         Text('Tanggal: ${extractDate(riwayat['created_at'])}'),
                                          //       ],
                                          //     ),
                                          //     onTap: () {
                                          //       // Navigator.push(
                                          //       //   context,
                                          //       //   MaterialPageRoute(
                                          //       //     builder: (context) => RiwayatCheckup(checkupId: checkupId),
                                          //       //   ),
                                          //       // );
                                          //     },
                                          //   ),
                                          // );
                                        },
                                      )
                                    : const Center(
                                        child: CircularProgressIndicator()),
                              ],
                            ),
                          ),
                        )
                      : const Center(child: Text('No detail available')),
                ),
    );
  }
}

Widget setInfoDokter(String label, String value) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        width: 120,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF62636C),
                )),
            const Text(":",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF62636C),
                ))
          ],
        ),
      ),
      const SizedBox(
        width: 5,
      ),
      Expanded(
        child: Text(value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Color(0xFF62636C),
            )),
      )
    ],
  );
}
