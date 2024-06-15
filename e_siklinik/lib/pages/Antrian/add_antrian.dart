import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class AddAntrian extends StatefulWidget {
  const AddAntrian({super.key});

  @override
  State<AddAntrian> createState() => _AddAntrianState();
}

class _AddAntrianState extends State<AddAntrian> {
  final TextEditingController pasienIdController = TextEditingController();
  final TextEditingController noAntrianController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  final String apiPostAntrian =
      "http://192.168.239.136:8000/api/antrian/create";
  final String apiGetAllPasien = "http://192.168.239.136:8000/api/pasien";

  List<dynamic> pasienList = [];
  List<dynamic> filteredPasienList = [];
  Map<String, dynamic>? selectedPasien;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _getAllPasien();
    searchFocusNode.addListener(() {
      setState(() {
        if (searchFocusNode.hasFocus) {
          filteredPasienList = pasienList;
        } else {
          filteredPasienList = [];
        }
      });
    });
  }

  Future<void> _getAllPasien() async {
    try {
      final response = await http.get(Uri.parse(apiGetAllPasien));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data['pasien'] != null) {
          setState(() {
            pasienList = data['pasien'];
          });
        } else {
          print("No data received from API");
        }
      } else {
        print("Failed to load pasien data");
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void _filterPasienList(String query) {
    if (query.isNotEmpty) {
      setState(() {
        filteredPasienList = pasienList.where((pasien) {
          final namaLower = pasien['nama'].toString().toLowerCase();
          final nrpLower = pasien['nrp'].toString().toLowerCase();
          final searchLower = query.toLowerCase();
          return namaLower.contains(searchLower) ||
              nrpLower.contains(searchLower);
        }).toList();
      });
    } else {
      setState(() {
        filteredPasienList = pasienList;
      });
    }
  }

  Future<void> addAntrian(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiPostAntrian));
      request.fields['pasien_id'] = selectedPasien?['id'].toString() ?? '';
      request.fields['no_antrian'] = noAntrianController.text;

      // Menambahkan tanggal saat ini ke request
      String currentDate = DateTime.now().toIso8601String();
      request.fields['tanggal'] = currentDate;

      var response = await request.send();

      if (response.statusCode == 200) {
        final antrian = json.decode(await response.stream.bytesToString());
        print('Antrian berhasil ditambahkan: $antrian');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Antrian berhasil ditambahkan')),
        );

        pasienIdController.clear();
        noAntrianController.clear();
        setState(() {
          selectedPasien = null;
        });
        Navigator.pop(context, true);
      } else {
        final errorData = json.decode(await response.stream.bytesToString());
        print('Gagal menambahkan antrian: ${errorData['message']}');
      }
    } catch (error) {
      print('Error: $error');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void handleCancel() {
    setState(() {
      selectedPasien = null;
      searchController.clear();
      filteredPasienList = [];
    });
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
          "Tambahkan Antrian",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFF234DF0), width: 2),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                        image: const DecorationImage(
                            image: AssetImage('assets/images/addantrian.png'),
                            fit: BoxFit.fill),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            offset: const Offset(-1, 2),
                            blurRadius: 3,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      width: double.infinity,
                      height: 180,
                    ),
                    if (selectedPasien == null) ...[
                      Container(
                        margin:
                            const EdgeInsets.only(top: 16, right: 16, left: 16),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        width: double.infinity,
                        height: 50,
                        decoration: const BoxDecoration(
                          color: Color(0xFFEFF0F3),
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        child: Row(
                          children: [
                            Flexible(
                              child: TextFormField(
                                controller: searchController,
                                focusNode: searchFocusNode,
                                onChanged: _filterPasienList,
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
                      const SizedBox(height: 10),
                      if (searchController.text.isNotEmpty ||
                          searchFocusNode.hasFocus)
                        ListView.builder(
                          itemCount: filteredPasienList.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            final pasien = filteredPasienList[index];
                            return Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedPasien = pasien;
                                      searchController.clear();
                                      filteredPasienList = [];
                                    });
                                    searchFocusNode.unfocus();
                                  },
                                  child: Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 24),
                                    padding: const EdgeInsets.all(15),
                                    width: double.infinity,
                                    // No fixed height to allow dynamic adjustment based on content
                                    decoration: BoxDecoration(
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
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const CircleAvatar(
                                          backgroundColor: Color(0xFFB7D1FF),
                                          radius: 25,
                                          child: Icon(
                                            Icons.person_outline,
                                            color: Color(0xFF234DF0),
                                            size: 40,
                                          ),
                                        ),
                                        const SizedBox(width: 15),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                pasien['nama'],
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 20,
                                                ),
                                                // Allow the name text to wrap to new lines
                                                softWrap: true,
                                              ),
                                              Text(
                                                pasien['nrp'],
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                              ],
                            );
                          },
                        ),
                    ] else ...[
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 8),
                        padding: const EdgeInsets.all(16),
                        width: double.infinity,
                        decoration: BoxDecoration(
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Informasi Pasien",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 18),
                            ),
                            const SizedBox(height: 15),
                            Container(
                              height: 180,
                              width: 180,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15)),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          'http://192.168.239.136:8000/storage/' +
                                              selectedPasien!['image']),
                                      fit: BoxFit.fill)),
                            ),
                            const SizedBox(height: 15),
                            setInfoPasien("Nama", "${selectedPasien!['nama']}"),
                            setInfoPasien("Prodi",
                                "${selectedPasien!['pasien_to_prodi']['nama']}"),
                            setInfoPasien(
                                "Gender", "${selectedPasien!['gender']}"),
                            setInfoPasien("Tanggal Lahir",
                                "${selectedPasien!['tanggal_lahir']}"),
                            setInfoPasien(
                                "Alamat", "${selectedPasien!['alamat']}"),
                            setInfoPasien(
                                "No Hp", "${selectedPasien!['nomor_hp']}"),
                            setInfoPasien(
                                "No Wali", "${selectedPasien!['nomor_wali']}"),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: handleCancel,
                            style: ElevatedButton.styleFrom(
                              side: const BorderSide(
                                  color: Color(0xFF234DF0), width: 2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.0),
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF234DF0)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed:
                                isLoading ? null : () => addAntrian(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF234DF0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.0),
                              child: Text(
                                'Submit',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFCFCFD)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}

Widget setInfoPasien(String label, String value) {
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
