import 'package:e_siklinik/components/bottomsheet.dart';
import 'package:e_siklinik/components/box.dart';
import 'package:e_siklinik/components/delete_confirmation.dart';
import 'package:e_siklinik/pages/Pasien/add_pasien.dart';
import 'package:e_siklinik/pages/Pasien/edit_pasien.dart';
import 'package:e_siklinik/pages/Pasien/show_pasien.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DataPasien extends StatefulWidget {
  const DataPasien({super.key});

  @override
  State<DataPasien> createState() => _DataPasienState();
}

class _DataPasienState extends State<DataPasien> {
  final String apiGetAllPasien = "http://10.0.2.2:8000/api/pasien";
  List<dynamic> pasienList = [];
  List<dynamic> filteredPasienList = [];

  @override
  void initState() {
    super.initState();
    _getAllPasien();
  }

  Future<void> _getAllPasien() async {
    try {
      final response = await http.get(Uri.parse(apiGetAllPasien));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data['pasien'] != null) {
          setState(() {
            pasienList = data['pasien'];
            filteredPasienList = List.from(pasienList);
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

  Future<void> _refreshData() async {
    await _getAllPasien();
  }

  void _filterPasienList(String searchText) {
    setState(() {
      filteredPasienList = pasienList
          .where((pasien) =>
              pasien['nama'].toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }

  // void _deleteItem(int id) async {
  //   Uri url = Uri.parse('http://10.0.2.2:8000/api/pasien/delete/$id');
  //   final response = await http.delete(url);
  //   print('ini id ${response.body}');
  //   if (response.statusCode == 200) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Berhasil hapus data pasien!'),
  //       ),
  //     );
  //     Navigator.pop(context);
  //     _refreshData();
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Gagal hapus data pasien!'),
  //       ),
  //     );
  //   }
  // }

  Future<void> _disablePasien(int pasienId) async {
    try {
      final response = await http
          .put(Uri.parse("http://10.0.2.2:8000/api/pasien/disabled/$pasienId"));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Success: ${data['message']}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Success: ${data['message']}')),
        );
        _refreshData();
      } else {
        final errorData = json.decode(response.body);
        print('Failed: ${errorData['message']}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: ${errorData['message']}')),
        );
      }
    } catch (error) {
      print('Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FB),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: const Color(0xFF234DF0),
        onPressed: () async {
          // Menunggu hasil dari halaman AddPasien
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPasien()),
          );
          // Jika result bernilai true, panggil _refreshData
          if (result == true) {
            _refreshData();
          }
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
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
          "Database Pasien",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: pasienList.isEmpty
            ? const Center(
                child: Text(
                  'Tidak ada data pasien',
                  style: TextStyle(fontSize: 18.0),
                ),
              )
            : SafeArea(
                child: Column(
                  children: [
                    Container(
                      margin:
                          const EdgeInsets.only(top: 16, right: 16, left: 16),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      width: double.infinity,
                      height: 50,
                      decoration: const BoxDecoration(
                          color: Color(0xFFEFF0F3),
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: Row(
                        children: [
                          Flexible(
                            child: TextFormField(
                              onChanged: _filterPasienList,
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
                    const SizedBox(
                      height: 10,
                    ),
                    Flexible(
                      child: ListView.builder(
                        itemCount: filteredPasienList.length,
                        itemBuilder: (BuildContext context, int index) {
                          final pasien = filteredPasienList[index];
                          final pasienId = pasien['id'];
                          return BoxPasien(
                            onTapBox: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ShowPasien(pasienId: pasienId),
                                ),
                              );
                            },
                            nama: pasien['nama'] ?? '',
                            nrp: pasien['nrp'] ?? '',
                            prodi: pasien['pasien_to_prodi'] != null
                                ? Text(
                                    pasien['pasien_to_prodi']['nama'] ?? '',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w300),
                                  )
                                : const Text("G ada prodi"),
                            icon: 'http://10.0.2.2:8000/storage/' +
                                pasien['image'],
                            onTapPop: () {
                              showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                builder: (context) => BuildSheet(
                                  onTapEdit: () async {
                                    // Menunggu hasil dari halaman EditPasien
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditPasien(pasien: pasien),
                                      ),
                                    );
                                    // Jika result bernilai true, tutup modal bottom sheet
                                    if (result == true) {
                                      Navigator.pop(
                                          context); // Menutup showModalBottomSheet
                                      _refreshData(); // Memuat ulang data jika perlu
                                    }
                                  },
                                  onTapDelete: () {
                                    showDeleteConfirmationDialog(
                                        context, () => _disablePasien(pasienId));
                                  },
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}