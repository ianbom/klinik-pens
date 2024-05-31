import 'dart:convert';
import 'package:e_siklinik/components/box.dart';
import 'package:e_siklinik/pages/Checkup/riwayat_checkup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<dynamic> checkupList = [];
  List<dynamic> filteredCheckupList = [];
  final String apiGetCheckup = "http://10.0.2.2:8000/api/checkup-result";
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getAllCheckup();
  }

  Future<void> _getAllCheckup() async {
    try {
      final response = await http.get(Uri.parse(apiGetCheckup));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data); // Cetak data untuk memverifikasi hasil respons API
        if (data != null && data['checkup'] != null) {
          setState(() {
            checkupList = data['checkup'];
            // Sort checkupList by created_at in descending order
            checkupList.sort((a, b) => DateTime.parse(b['created_at'])
                .compareTo(DateTime.parse(a['created_at'])));
            filteredCheckupList =
                checkupList; // Inisialisasi daftar hasil pencarian
          });
        } else {
          print("No data received from API");
        }
      } else {
        print("Failed to load checkup data");
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void _filterCheckupList(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredCheckupList = checkupList;
      });
    } else {
      setState(() {
        filteredCheckupList = checkupList.where((checkup) {
          final patientName = checkup['check_up_resul_to_assesmen']
                  ['assesmen_to_antrian']['antrian_to_pasien']['nama']
              .toLowerCase();
          return patientName.contains(query.toLowerCase());
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FB),
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                _buildHeader(),
                const SizedBox(height: 10),
                _buildSearchField(),
                const SizedBox(height: 10),
                const Text(
                  "Terakhir Checkup",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                _buildCheckupList(),
                const SizedBox(
                  height: 70,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF234DF0), width: 2),
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        image: const DecorationImage(
            image: AssetImage('assets/images/Search.jpeg'), fit: BoxFit.fill),
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
      height: 150,
    );
  }

  Widget _buildSearchField() {
    return Container(
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
              maxLines: null,
              onChanged: _filterCheckupList,
              decoration: const InputDecoration(
                hintText: 'Search Here',
                border: InputBorder.none,
              ),
            ),
          ),
          const Icon(Icons.search),
        ],
      ),
    );
  }

  Widget setIcon(IconData iconData, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: const Color(0xFFDDEAFF),
      ),
      child: Icon(
        iconData,
        color: iconColor,
      ),
    );
  }

  Widget _buildCheckupList() {
    // Limit the list to 5 items
    List<dynamic> limitedCheckupList = filteredCheckupList.take(5).toList();

    return limitedCheckupList.isEmpty
        ? const Center(
            child: Text(
              'Checkup Kosong',
              style: TextStyle(fontSize: 18.0),
            ),
          )
        : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: limitedCheckupList.length,
            itemBuilder: (BuildContext context, int index) {
              final checkup = limitedCheckupList[index];
              final checkupId = checkup['id'];
              return BoxSearchPage(
                onTapBox: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              RiwayatCheckup(checkupId: checkupId)));
                },
                nama: checkup['check_up_resul_to_assesmen']
                    ['assesmen_to_antrian']['antrian_to_pasien']['nama'],
                nrp: checkup['check_up_resul_to_assesmen']
                    ['assesmen_to_antrian']['antrian_to_pasien']['nrp'],
                icon: setIcon(Icons.person_outline, const Color(0xFF234DF0)),
                prodi: Text(
                  checkup['check_up_resul_to_assesmen']['assesmen_to_antrian']
                      ['antrian_to_pasien']['pasien_to_prodi']['nama'],
                ),
              );
            },
          );
  }
}
