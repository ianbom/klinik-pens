import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class AddCheckupResult extends StatefulWidget {
  final int assesmentId;
  const AddCheckupResult({Key? key, required this.assesmentId});

  @override
  State<AddCheckupResult> createState() => _AddCheckupResultState();
}

class _AddCheckupResultState extends State<AddCheckupResult> {
  final TextEditingController hasilDiagnosaController = TextEditingController();
  final TextEditingController imageController = TextEditingController();

  final String apiPostCheckupResult =
      "http://192.168.239.136:8000/api/checkup-obat/insert";
  final String apiGetAllObat = "http://192.168.239.136:8000/api/obat";

  List<dynamic> obatList = [];
  Map<String, dynamic>? assesmentDetail;
  File? _imageFile;
  List<Map<String, dynamic>> resepObatList = [];

  @override
  void initState() {
    super.initState();
    _getAssesmentDetail();
    _getAllObat();
  }

  Future<void> _getAllObat() async {
    try {
      final response = await http.get(Uri.parse(apiGetAllObat));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data['obats'] != null) {
          setState(() {
            obatList = data['obats'];
          });
        } else {
          print("No data received from API");
        }
      } else {
        print("Failed to load Data Obat");
      }
    } catch (error) {
      print('Error : $error');
    }
  }

  Future<void> _getAssesmentDetail() async {
    try {
      final response = await http.get(
        Uri.parse(
            "http://192.168.239.136:8000/api/checkup-assesmen/show/${widget.assesmentId}"),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data['results'] != null) {
          setState(() {
            assesmentDetail = data['results'];
          });
        } else {
          print("No data received from API");
        }
      } else {
        print("Failed to load assesment detail");
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> addCheckupWithResepObat(BuildContext context) async {
    try {
      var request =
          http.MultipartRequest('POST', Uri.parse(apiPostCheckupResult));
      request.fields['hasil_diagnosa'] = hasilDiagnosaController.text;
      request.fields['assesmen_id'] = widget.assesmentId.toString();

      if (_imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            _imageFile!.path,
          ),
        );
      }

      request.fields['resep_obat'] = json.encode(resepObatList);

      var response = await request.send();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data berhasil ditambahkan')),
        );
      } else {
        final errorData = json.decode(await response.stream.bytesToString());
        print('Gagal menambahkan data: ${errorData['message']}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void addResepObat() {
    setState(() {
      resepObatList.add({
        'obat_id': null,
        'jumlah_pemakaian': '',
        'waktu_pemakaian': '',
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          "Add Checkup",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Nama Pasien: ${assesmentDetail?['nama_pasien']}'),
              Text('Nama Prodi: ${assesmentDetail?['nama_prodi']}'),
              Text('Nama Dokter: ${assesmentDetail?['nama_dokter']}'),
              Text('No Antrian: ${assesmentDetail?['no_antrian']}'),
              TextFormField(
                controller: hasilDiagnosaController,
                decoration: const InputDecoration(
                  labelText: "Deskripsi",
                ),
              ),
              TextFormField(
                controller: imageController,
                decoration: const InputDecoration(
                  labelText: "Image (Opsional)",
                ),
                readOnly: true,
                onTap: () async {
                  final picker = ImagePicker();
                  final pickedFile = await picker.pickImage(
                    source: ImageSource.gallery,
                  );

                  if (pickedFile != null) {
                    setState(() {
                      _imageFile = File(pickedFile.path);
                      imageController.text = _imageFile!.path.split('/').last;
                    });
                  }
                },
              ),
              ...resepObatList.map((resep) {
                int index = resepObatList.indexOf(resep);
                return Column(
                  children: [
                    DropdownButtonFormField<int>(
                      value: resep['obat_id'],
                      onChanged: (value) {
                        setState(() {
                          resepObatList[index]['obat_id'] = value;
                        });
                      },
                      items: obatList.map<DropdownMenuItem<int>>((obat) {
                        return DropdownMenuItem<int>(
                          value: obat['id'],
                          child: Text(obat['nama_obat']),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                        labelText: "Nama obat",
                      ),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Jumlah Pemakaian",
                      ),
                      onChanged: (value) {
                        setState(() {
                          resepObatList[index]['jumlah_pemakaian'] = value;
                        });
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Waktu Pemakaian",
                      ),
                      onChanged: (value) {
                        setState(() {
                          resepObatList[index]['waktu_pemakaian'] = value;
                        });
                      },
                    ),
                  ],
                );
              }).toList(),
              ElevatedButton(
                onPressed: addResepObat,
                child: const Text("Tambah Resep Obat"),
              ),
              ElevatedButton(
                onPressed: () => addCheckupWithResepObat(context),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    'Simpan',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.indigo,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
