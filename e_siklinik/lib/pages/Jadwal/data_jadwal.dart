import 'dart:convert';
import 'package:e_siklinik/components/bottomsheet.dart';
import 'package:e_siklinik/components/box.dart';
import 'package:e_siklinik/components/delete_confirmation.dart';
import 'package:e_siklinik/pages/Jadwal/edit_jadwal.dart';
import 'package:http/http.dart' as http;
import 'package:e_siklinik/pages/Jadwal/add_jadwal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DataJadwal extends StatefulWidget {
  const DataJadwal({super.key});

  @override
  State<DataJadwal> createState() => _DataJadwalState();
}

class _DataJadwalState extends State<DataJadwal> {
  final String apiGetAllJadwalDokter = "http://10.0.2.2:8000/api/jadwal_dokter";
  List<dynamic> jadwalList = [];
  List<dynamic> filteredJadwalList = [];

  @override
  void initState() {
    super.initState();
    _getAllJadwal();
    _refreshData();
  }

  Future<void> _getAllJadwal() async {
    try {
      final response = await http.get(Uri.parse(apiGetAllJadwalDokter));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data['jadwal_dokter'] != null) {
          setState(() {
            jadwalList = data['jadwal_dokter'];
            filteredJadwalList = List.from(jadwalList);
          });
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
    await _getAllJadwal();
  }

  void _filterJadwalList(String searchText) {
    setState(() {
      filteredJadwalList = jadwalList
          .where((jadwal) =>
              jadwal['jadwal_to_dokter']['nama']
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              jadwal['hari'].toLowerCase().contains(searchText.toLowerCase()) ||
              jadwal['jadwal_mulai_tugas']
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              jadwal['jadwal_selesai_tugas']
                  .toLowerCase()
                  .contains(searchText.toLowerCase()))
          .toList();
    });
  }

  void _deleteItem(int id) async {
    Uri url = Uri.parse('http://10.0.2.2:8000/api/jadwal_dokter/delete/$id');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Berhasil hapus jadwal dokter!'),
        ),
      );
      Navigator.pop(context);
      _refreshData();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal hapus jadwal dokter!'),
        ),
      );
    }
  }

  String formatTime(String time) {
    if (time.length >= 5) {
      return time.substring(0, 5); // Mengambil hanya jam dan menit
    }
    return time;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FB),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: const Color(0xFF234DF0),
        onPressed: () async {
          // Menunggu hasil dari halaman AddJadwal
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddJadwal()),
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
          "Jadwal Dokter",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: jadwalList.isEmpty
            ? const Center(
                child: Text(
                  'Tidak ada data Jadwal Dokter',
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
                              onChanged: _filterJadwalList,
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
                        itemCount: filteredJadwalList.length,
                        itemBuilder: (BuildContext context, int index) {
                          final jadwal = filteredJadwalList[index];
                          final jamMulai =
                              formatTime(jadwal['jadwal_mulai_tugas']);
                          final jamSelesai =
                              formatTime(jadwal['jadwal_selesai_tugas']);

                          return BoxJadwal(
                            dokter: "${jadwal['jadwal_to_dokter']['nama']}",
                            jadwal:
                                "${jadwal['hari']}, $jamMulai - $jamSelesai",
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
                                            EditJadwal(jadwal: jadwal),
                                      ),
                                    );
                                    if (result == true) {
                                      Navigator.pop(context);
                                      _refreshData();
                                    }
                                  },
                                  onTapDelete: () {
                                    showDeleteConfirmationDialog(context,
                                        () => _deleteItem(jadwal['id']));
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
