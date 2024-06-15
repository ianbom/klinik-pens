import 'package:e_siklinik/components/box.dart';
import 'package:e_siklinik/pages/Checkup/riwayat_checkup.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ShowObat extends StatefulWidget {
  final int obatId;
  const ShowObat({Key? key, required this.obatId});

  @override
  State<ShowObat> createState() => _ShowObatState();
}

class _ShowObatState extends State<ShowObat> {
  Map<String, dynamic>? obatDetail;
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _getObatDetail();
  }

  Future<void> _getObatDetail() async {
    try {
      final response = await http.get(
        Uri.parse("http://192.168.239.136:8000/api/obat/${widget.obatId}/show"),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data['obats'] != null) {
          if (mounted) {
            setState(() {
              obatDetail = data['obats'];
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
        print("Failed to load obat detail: ${response.statusCode}");
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
          "Detail Obat",
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
                          background: obatDetail != null &&
                                  obatDetail!['image'] != null
                              ? Image.network(
                                  'http://192.168.239.136:8000/storage/' +
                                      obatDetail!['image'],
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
                  body: obatDetail != null
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
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Image(
                                            image: AssetImage(_getImage(
                                                obatDetail!['kategori_id'])),
                                            width: 15,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            'Obat ${obatDetail!['obat_to_kategori_obat']['nama_kategori']}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        '${obatDetail!['nama_obat']}',
                                        style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                          'Harga: Rp. ${obatDetail!['harga']}'),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                          'Tanggal Kadaluarsa: ${obatDetail!['tanggal_kadaluarsa']}'),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text('Stock: ${obatDetail!['stock']}'),
                                    ],
                                  ),
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
