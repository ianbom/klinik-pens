import 'package:e_siklinik/components/bottomsheet.dart';
import 'package:e_siklinik/components/box.dart';
import 'package:e_siklinik/components/delete_confirmation.dart';
import 'package:e_siklinik/pages/Dokter/add_dokter.dart';
import 'package:e_siklinik/pages/Dokter/edit_dokter.dart';
import 'package:e_siklinik/pages/Dokter/show_dokter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';

class DataDokter extends StatefulWidget {
  const DataDokter({super.key});

  @override
  State<DataDokter> createState() => _DataDokterState();
}

class _DataDokterState extends State<DataDokter> {
  final String apiGetAllDokter = "http://10.0.2.2:8000/api/dokter";

  List<dynamic> dokterList = [];
  List<dynamic> filteredDokterList = [];

  @override
  void initState() {
    super.initState();
    _getAllDokter();
    _refreshData();
  }

  Future<void> _getAllDokter() async {
    try {
      final response = await http.get(Uri.parse(apiGetAllDokter));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data['dokter'] != null) {
          setState(() {
            dokterList = data['dokter'];
            filteredDokterList = List.from(dokterList);
          });
          print(dokterList);
        } else {
          print("No data received from API");
        }
      } else {
        print("Failed to load Data");
      }
    } catch (error) {
      print('Error : $error');
    }
  }

  Future<void> _refreshData() async {
    await _getAllDokter();
  }

  void _filterDokterList(String searchText) {
    setState(() {
      filteredDokterList = dokterList
          .where((dokter) =>
              dokter['nama'].toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }

  Future<void> _disableDokter(int dokterId) async {
    try {
      final response = await http
          .put(Uri.parse("http://10.0.2.2:8000/api/dokter/disabled/$dokterId"));
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
          // Menunggu hasil dari halaman AddDokter
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddDokter()),
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
          "Database Dokter",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: dokterList.isEmpty
            ? const Center(
                child: Text(
                  'Tidak ada data Dokter',
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
                              onChanged: _filterDokterList,
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
                        itemCount: filteredDokterList.length,
                        itemBuilder: (BuildContext context, int index) {
                          final dokter = filteredDokterList[index];
                          final dokterId =
                              dokter['id']; // Dapatkan id dokter di sini
                          return BoxDokter(
                            onTapBox: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ShowDokter(dokterId: dokterId)));
                            },
                            icon: 'http://10.0.2.2:8000/storage/' +
                                dokter['image'],
                            nama: dokter['nama'] ?? '',
                            onTapPop: () {
                              showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (context) => BuildSheet(
                                        onTapEdit: () async {
                                          final result = await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditDokter(
                                                          dokter: dokter)));
                                          if (result == true) {
                                            Navigator.pop(
                                                context); // Menutup showModalBottomSheet
                                            _refreshData(); // Memuat ulang data jika perlu
                                          }
                                        },
                                        onTapDelete: () {
                                          showDeleteConfirmationDialog(context,
                                              () => _disableDokter(dokterId));
                                        },
                                      ));
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
