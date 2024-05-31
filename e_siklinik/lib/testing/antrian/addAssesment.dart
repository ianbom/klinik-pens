import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AddAssesmentPage extends StatefulWidget {
  final int antrianId;
  const AddAssesmentPage({Key? key, required this.antrianId});

  @override
  State<AddAssesmentPage> createState() => _AddAssesmentPageState();
}

class _AddAssesmentPageState extends State<AddAssesmentPage> {
  final TextEditingController dokterIdController = TextEditingController();
  final TextEditingController antrianController = TextEditingController();

  final String apiPostAssesment =
      "http://10.0.2.2:8000/api/checkup-assesmen/insert";
  List<dynamic>? antrianDetail;

  final String apiGetAllDokter = "http://10.0.2.2:8000/api/dokter";
  List<dynamic> dokterList = [];
  File? _imageFile;

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
        Uri.parse("http://10.0.2.2:8000/api/antrian/show/${widget.antrianId}"),
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
          icon: const Icon(Icons.arrow_back_ios),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.black,
        centerTitle: true,
        title: const Text(
          "Add Assesment",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Nama: ${antrianDetail?[0]['nama']}'),
              DropdownButtonFormField(
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
                  labelText: "Nama Dokter",
                ),
              ),
              ElevatedButton(
                onPressed: () => addAssesment(context),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    'Simpan',
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade600),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.indigo,
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
