import 'dart:convert';
import 'package:e_siklinik/components/bottomsheet.dart';
import 'package:e_siklinik/components/box.dart';
import 'package:e_siklinik/components/delete_confirmation.dart';
import 'package:e_siklinik/pages/Dokter/show_dokter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class DeletedDokterData extends StatefulWidget {
  const DeletedDokterData({super.key});

  @override
  State<DeletedDokterData> createState() => _DeletedDokterDataState();
}

class _DeletedDokterDataState extends State<DeletedDokterData> {
  final String apiGetAllDokter =
      "http://192.168.239.136:8000/api/dokter/deleted-dokter";
  List<dynamic> dokterList = [];
  List<dynamic> filteredDokterList = [];
  bool isLoading = true; // flag to track loading state

  @override
  void initState() {
    super.initState();
    _getAllDokter();
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
            isLoading = false; // set loading to false when data is fetched
          });
          print(dokterList);
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
        print("Failed to load Data");
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

  Future<void> _enableDokter(int dokterId) async {
    try {
      final response = await http.put(
          Uri.parse("http://192.168.239.136:8000/api/dokter/aktif/$dokterId"));
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
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
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
                                            builder: (context) => ShowDokter(
                                                dokterId: dokterId)));
                                  },
                                  icon: 'http://192.168.239.136:8000/storage/' +
                                      dokter['image'],
                                  nama: dokter['nama'] ?? '',
                                  onTapPop: () {
                                    showModalBottomSheet(
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (context) => BuildSheet(
                                              onTapDelete: () {
                                                showDeleteConfirmationDialog(
                                                    context,
                                                    () =>
                                                        _enableDokter(dokterId),
                                                    'restore');
                                              },
                                              deleteOrRestoreData:
                                                  'Restore Data',
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
