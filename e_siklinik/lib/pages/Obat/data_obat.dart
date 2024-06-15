import 'package:e_siklinik/pages/Obat/addObat.dart';
import 'package:e_siklinik/pages/Obat/edit_obat.dart';
import 'package:e_siklinik/pages/Obat/detail_obat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:e_siklinik/components/bottomsheet.dart';
import 'package:e_siklinik/components/delete_confirmation.dart';

class DataObat extends StatefulWidget {
  const DataObat({Key? key}) : super(key: key);

  @override
  State<DataObat> createState() => _DataObatState();
}

class _DataObatState extends State<DataObat> {
  final String apiGetAllObat = "http://192.168.239.136:8000/api/obat";

  List<dynamic> obatList = [];
  List<dynamic> searchObat = [];
  bool isLoading = true;

  TextEditingController _searchController = TextEditingController();

  Future<void> _getAllObat() async {
    try {
      final response = await http.get(Uri.parse(apiGetAllObat));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data['obats'] != null) {
          setState(() {
            obatList = data['obats'];
            searchObat = obatList;
          });
        } else {
          print("No data received from API");
        }
      } else {
        print("Failed to load obat");
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      isLoading = true;
    });
    await _getAllObat();
  }

  Future<void> _disableObat(int obatId) async {
    try {
      final response = await http.put(
          Uri.parse("http://192.168.239.136:8000/api/obat/disabled/$obatId"));

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
  void initState() {
    super.initState();
    _getAllObat();
    _searchController.addListener(() {
      _searchObat(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchObat(String query) {
    final searchResults = obatList.where((obat) {
      final namaObat = obat['nama_obat'].toLowerCase();
      final input = query.toLowerCase();
      return namaObat.contains(input);
    }).toList();

    setState(() {
      searchObat = searchResults;
    });
  }

  String _getImage(int kategoriObat) {
    switch (kategoriObat) {
      case 1:
        return 'assets/images/OB.png';
      case 2:
        return 'assets/images/OBT.png';
      case 3:
        return 'assets/images/OK.png';
      case 4:
        return 'assets/images/ON.png';
      case 5:
        return 'assets/images/OJ.png';
      case 6:
        return 'assets/images/OH.png';
      case 7:
        return 'assets/images/OF.png';
      default:
        return 'assets/images/OD.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          "Database Obat",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: obatList.isEmpty
            ? Center(
                child: Image.asset(
                  'assets/images/obat_kosong.png',
                  fit: BoxFit.cover,
                ),
              )
            : Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                        top: 16, right: 16, left: 16, bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    width: double.infinity,
                    height: 50,
                    decoration: const BoxDecoration(
                        color: Color(0xFFEFF0F3),
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: Row(
                      children: [
                        Flexible(
                          child: TextField(
                            controller: _searchController,
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
                  Expanded(
                    child: GridView.builder(
                      padding:
                          const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8.0,
                        crossAxisSpacing: 8.0,
                        childAspectRatio: MediaQuery.of(context).size.width /
                            (MediaQuery.of(context).size.height / 2.5),
                      ),
                      itemCount: searchObat.length,
                      itemBuilder: (BuildContext context, int index) {
                        final obat = searchObat[index];
                        final obatId = obat['id'];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => ShowObat(
                                        obatId: obatId,
                                      ))),
                            );
                          },
                          child: Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundColor: Colors.transparent,
                                          child: Image.asset(
                                            _getImage(obat['kategori_id']),
                                            width: 30,
                                            height: 30,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        Spacer(),
                                        GestureDetector(
                                          onTap: () {
                                            showModalBottomSheet(
                                              isScrollControlled: true,
                                              context: context,
                                              builder: (context) => BuildSheet(
                                                onTapEdit: () async {
                                                  final result =
                                                      await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditObat(obat: obat),
                                                    ),
                                                  );
                                                  if (result == true) {
                                                    Navigator.pop(context);
                                                    _refreshData();
                                                  }
                                                },
                                                onTapDelete: () {
                                                  showDeleteConfirmationDialog(
                                                      context,
                                                      () =>
                                                          _disableObat(obatId),
                                                      'delete');
                                                },
                                                deleteOrRestoreData:
                                                    'Delete Data',
                                              ),
                                            );
                                          },
                                          child: const Icon(Icons.more_vert),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Expanded(
                                      child: Text(
                                        obat['nama_obat'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                        maxLines: 1, // Limit the text to 1 line
                                        overflow: TextOverflow
                                            .ellipsis, // Handle overflow with ellipsis
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                        'EXP: ${obat['tanggal_kadaluarsa'] ?? '-'}'),
                                    Text('Stok: ${obat['stock'] ?? '-'}')
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF234DF0),
        shape: const CircleBorder(),
        foregroundColor: Colors.black,
        onPressed: () async {
          final result = await Navigator.push(context,
              MaterialPageRoute(builder: ((context) => const AddObatNew())));
          if (result == true) {
            _refreshData();
          }
        },
        child: const Icon(
          Icons.add,
          size: 35,
          color: Colors.white,
        ),
      ),
    );
  }

  Future<void> _deleteObat(int id) async {
    final String apiUrl = "http://192.168.239.136:8000/api/obat/$id";

    try {
      final response = await http.delete(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        print("Data obat dengan ID $id berhasil dihapus.");
        _getAllObat();
      } else {
        print(
            "Gagal menghapus data obat dengan ID $id. Status code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error: $error");
    }
  }
}
