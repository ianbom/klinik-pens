import 'package:e_siklinik/components/box.dart';
import 'package:e_siklinik/pages/Checkup/riwayat_checkup.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ShowPasien extends StatefulWidget {
  final int pasienId;
  const ShowPasien({Key? key, required this.pasienId});

  @override
  State<ShowPasien> createState() => _ShowPasienState();
}

class _ShowPasienState extends State<ShowPasien> {
  Map<String, dynamic>? pasienDetail;
  bool isLoading = true;
  bool hasError = false;
  List<dynamic>? riwayat;

  @override
  void initState() {
    super.initState();
    _getPasienDetail();
    _getRiwayatCheckup();
  }

  Future<void> _getPasienDetail() async {
    try {
      final response = await http.get(
        Uri.parse(
            "http://192.168.239.136:8000/api/pasien/show/${widget.pasienId}"),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data['pasien'] != null) {
          if (mounted) {
            setState(() {
              pasienDetail = data['pasien'];
              isLoading = false;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              hasError = true;
              isLoading = false;
            });
          }
        }
      } else {
        if (mounted) {
          setState(() {
            hasError = true;
            isLoading = false;
          });
        }
        print("Failed to load pasien detail: ${response.statusCode}");
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
      print('Error: $error');
    }
  }

  Future<void> _getRiwayatCheckup() async {
    try {
      final response = await http.get(Uri.parse(
          "http://192.168.239.136:8000/api/riwayat-pasien/${widget.pasienId}"));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data['checkup'] != null) {
          if (mounted) {
            setState(() {
              riwayat = data['checkup'];
              if (riwayat == null) {
                print('Data kosong akwoakwo');
              } else {
                print(riwayat);
              }
            });
          }
        }
      } else {
        print("Failed to load riwayat checkup");
      }
    } catch (error) {
      print('Error : $error');
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
          "Detail Pasien",
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
                          background: pasienDetail != null &&
                                  pasienDetail!['image'] != null
                              ? Image.network(
                                  'http://192.168.239.136:8000/storage/' +
                                      pasienDetail!['image'],
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
                  body: pasienDetail != null && riwayat != null
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
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${pasienDetail!['nama']}',
                                                style: const TextStyle(
                                                    fontSize: 24,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Text(
                                                  '${pasienDetail!['pasien_to_prodi']['nama']}'),
                                              Text('${pasienDetail!['nrp']}')
                                            ],
                                          )),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      setInfoDokter('Gender',
                                          '${pasienDetail!['gender']}'),
                                      setInfoDokter('Tanggal Lahir',
                                          '${pasienDetail!['tanggal_lahir']}'),
                                      setInfoDokter('Alamat',
                                          '${pasienDetail!['alamat']}'),
                                      setInfoDokter('Nomor Hp',
                                          '${pasienDetail!['nomor_hp']}'),
                                      setInfoDokter('Nomor Wali',
                                          '${pasienDetail!['nomor_wali']}'),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const Text(
                                  "Riwayat Checkup",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20),
                                ),
                                Divider(),
                                const SizedBox(
                                  height: 10,
                                ),
                                ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: riwayat!.length,
                                  itemBuilder: (context, index) {
                                    final checkup = riwayat![index];
                                    final nomorAntrian =
                                        checkup['check_up_resul_to_assesmen']
                                                    ['assesmen_to_antrian']
                                                ?['no_antrian'] ??
                                            '';
                                    final checkupId = checkup['id'];

                                    final namaDokter =
                                        checkup['check_up_resul_to_assesmen']
                                                    ['assesmen_to_dokter']
                                                ?['nama'] ??
                                            '';
                                    return BoxRiwayat(
                                      onTapBox: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    RiwayatCheckup(
                                                        checkupId: checkupId)));
                                      },
                                      tanggal: checkup['created_at'] != null
                                          ? extractDate(checkup['created_at'])
                                          : 'N/A',
                                      nama: 'Nama Dokter: $namaDokter',
                                      no: '$nomorAntrian',
                                    );
                                    // Card(
                                    //   child: ListTile(
                                    //     title: Text(
                                    //       'Hasil Diagnosa: ${checkup['hasil_diagnosa']}',
                                    //     ),
                                    //     subtitle: Column(
                                    //       crossAxisAlignment:
                                    //           CrossAxisAlignment.start,
                                    //       children: [
                                    //         Text(
                                    //           'No Antrian: $nomorAntrian',
                                    //         ),
                                    //         Text(
                                    //           'Nama Dokter: $namaDokter',
                                    //         ),
                                    //         Text(
                                    //           'Tanggal: ${extractDate(checkup?['created_at'] ?? "N/A")}',
                                    //         ),
                                    //       ],
                                    //     ),
                                    //   ),
                                    // );
                                  },
                                ),
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
