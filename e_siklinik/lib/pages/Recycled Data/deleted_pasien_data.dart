import 'package:flutter/material.dart';
import 'package:e_siklinik/components/bottomsheet.dart';
import 'package:e_siklinik/components/box.dart';
import 'package:e_siklinik/components/delete_confirmation.dart';
import 'package:e_siklinik/pages/Pasien/add_pasien.dart';
import 'package:e_siklinik/pages/Pasien/edit_pasien.dart';
import 'package:e_siklinik/pages/Pasien/show_pasien.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DeletedPasienData extends StatefulWidget {
  const DeletedPasienData({super.key});

  @override
  State<DeletedPasienData> createState() => _DeletedPasienDataState();
}

class _DeletedPasienDataState extends State<DeletedPasienData> {
  final String apiGetAllPasien =
      "http://192.168.239.136:8000/api/pasien/deleted-pasien";
  List<dynamic> pasienList = [];
  List<dynamic> filteredPasienList = [];
  bool isLoading = true; // flag to track loading state

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
        if (data != null && data['data'].length > 0) {
          setState(() {
            pasienList = data['data'];
            filteredPasienList = List.from(pasienList);
            isLoading = false; // set loading to false when data is fetched
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
    await _getAllPasien();
    setState(() {});
  }

  void _filterPasienList(String searchText) {
    setState(() {
      filteredPasienList = pasienList
          .where((pasien) =>
              pasien['nama'].toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }

  void _deleteItem(int id) async {
    Uri url = Uri.parse('http://192.168.239.136:8000/api/pasien/aktif/$id');
    final response = await http.put(url);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Berhasil restore data pasien!'),
        ),
      );
      Navigator.pop(context);
      _refreshData();
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal hapus data pasien!'),
        ),
      );
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
          "Database Pasien",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
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
                            margin: const EdgeInsets.only(
                                top: 16, right: 16, left: 16),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            width: double.infinity,
                            height: 50,
                            decoration: const BoxDecoration(
                                color: Color(0xFFEFF0F3),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
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
                                          pasien['pasien_to_prodi']['nama'] ??
                                              '',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w300),
                                        )
                                      : const Text("G ada prodi"),
                                  icon: 'http://192.168.239.136:8000/storage/' +
                                      pasien['image'],
                                  onTapPop: () {
                                    showModalBottomSheet(
                                      isScrollControlled: true,
                                      context: context,
                                      builder: (context) => BuildSheet(
                                        onTapDelete: () {
                                          showDeleteConfirmationDialog(context,
                                              () {
                                            _deleteItem(pasien['id']);
                                          }, 'restore');
                                          _refreshData();
                                        },
                                        deleteOrRestoreData: 'Restore Data',
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
