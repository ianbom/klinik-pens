import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'assessment.dart';

class AddAssessment extends StatefulWidget {
  final int antrianId;
  const AddAssessment({Key? key, required this.antrianId});

  @override
  State<AddAssessment> createState() => _AddAssessmentState();
}

class _AddAssessmentState extends State<AddAssessment> {
  final TextEditingController dokterIdController = TextEditingController();
  final TextEditingController antrianController = TextEditingController();

  final String apiPostAssesment =
      "http://192.168.239.136:8000/api/checkup-assesmen/insert";
  List<dynamic>? antrianDetail;

  final String apiGetAllDokter = "http://192.168.239.136:8000/api/dokter";
  List<dynamic> dokterList = [];
  File? _imageFile;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _getAntrianDetail();
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

  Future<void> _getAntrianDetail() async {
    try {
      final response = await http.get(
        Uri.parse("http://192.168.239.136:8000/api/antrian/show/${widget.antrianId}"),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data['antrian'] != null) {
          setState(() {
            antrianDetail = data['antrian'];
          });
          print(antrianDetail);
        } else {
          print("No data received from API");
        }
      } else {
        print("Failed to load dokter detail");
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> addAssesment(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiPostAssesment));
      request.fields['dokter_id'] = dokterIdController.text;
      request.fields['antrian_id'] = widget.antrianId.toString();

      if (_imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            _imageFile!.path,
          ),
        );
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        final obat = json.decode(
            await response.stream.bytesToString()); // ['obat] coba ga pake ini
        print('Assesment berhasil ditambahkan: $obat');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Assesment berhasil ditambahkan')),
        );
        Navigator.pop(context);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const AssesmentPage()));

        // Clear input fields
        // dokterIdController.clear();
        // tanggalKadaluarsaController.clear();
        // stockController.clear();
        // hargaController.clear();
        // imageController.clear();
        // noAntrianController.clear();
        // _imageFile = null;
      } else {
        final errorData = json.decode(await response.stream.bytesToString());
        print('Gagal menambahkan Assesment: ${errorData['message']}');
      }
    } catch (error) {
      print('Error: $error');
    } finally {
      setState(() {
        isLoading = false;
      });
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
          "Assessment",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Form(
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(8),
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
                            if (antrianDetail != null &&
                                antrianDetail!.isNotEmpty)
                              Container(
                                height: 180,
                                width: 180,
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(15)),
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            'http://192.168.239.136:8000/storage/' +
                                                antrianDetail?[0]['image']),
                                        fit: BoxFit.fill)),
                              )
                            else
                              const SizedBox(),
                            const SizedBox(height: 15),
                            setInfoPasien("NRP", "${antrianDetail?[0]['nrp']}"),
                            setInfoPasien(
                                "Nama", "${antrianDetail?[0]['nama']}"),
                            // setInfoPasien("Program Studi",
                            //     "${antrianDetail?[0]['pasien_to_prodi']?['nama']}"),
                            setInfoPasien(
                                "Gender", "${antrianDetail?[0]['gender']}"),
                            setInfoPasien("Tanggal Lahir",
                                "${antrianDetail?[0]['tanggal_lahir']}"),
                            setInfoPasien(
                                "Alamat", "${antrianDetail?[0]['alamat']}"),
                            setInfoPasien(
                                "No Hp", "${antrianDetail?[0]['nomor_hp']}"),
                            setInfoPasien("No Wali",
                                "${antrianDetail?[0]['nomor_wali']}"),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
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
                        child: Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 2),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: Color(0xFFEFF0F3),
                          ),
                          child: DropdownButtonFormField(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                            value: null,
                            onChanged: (value) {
                              setState(() {
                                dokterIdController.text = value.toString();
                              });
                            },
                            items: dokterList.map<DropdownMenuItem>((dokter) {
                              return DropdownMenuItem(
                                value: dokter['id'],
                                child: Text(dokter['nama']),
                              );
                            }).toList(),
                            decoration: const InputDecoration(
                                hintText: "Nama Dokter",
                                border: InputBorder.none),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed:
                                isLoading ? null : () => addAssesment(context),
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
                  ),
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
