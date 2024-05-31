import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AddDokterPage extends StatefulWidget {
  const AddDokterPage({Key? key}) : super(key: key);

  @override
  State<AddDokterPage> createState() => _AddDokterPageState();
}

class _AddDokterPageState extends State<AddDokterPage> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController noHpController = TextEditingController();
  //final TextEditingController jadwalController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController tanggalLahirController = TextEditingController();

  final String apiPostDokter = "http://10.0.2.2:8000/api/dokter/create";
  final String apiGetAllJadwalDokter =
      "http://10.0.2.2:8000/api/jadwal_dokter";

  List<dynamic> dokterList = [];
  File? _imageFile;

  @override
  void initState() {
    super.initState();
  }

  Future<void> addDokter(BuildContext context) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiPostDokter));
      request.fields['nama'] = namaController.text;
      request.fields['gender'] = genderController.text;
      request.fields['tanggal_lahir'] = tanggalLahirController.text;
      request.fields['alamat'] = alamatController.text;
      request.fields['nomor_hp'] = noHpController.text;

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
        final dokter =
            json.decode(await response.stream.bytesToString())['dokter'];
        SnackBar(content: Text('Dokter berhasil ditambahkan'));
        print('Dokter berhasil ditambahkan: $dokter');
      } else {
        print('Gagal menambahkan Dokter');
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
              Navigator.pop((context));
            },
            icon: const Icon(Icons.arrow_back_ios)),
        backgroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.black,
        centerTitle: true,
        title: const Text(
          "Data Dokter",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: namaController,
                decoration: InputDecoration(
                  labelText: "Nama",
                ),
              ),
              TextFormField(
                controller: genderController,
                decoration: InputDecoration(
                  labelText: "Gender",
                ),
              ),
              TextFormField(
                controller: tanggalLahirController,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      tanggalLahirController.text =
                          pickedDate.toString().split(' ')[0];
                    });
                  }
                },
                decoration: InputDecoration(
                  labelText: "Tanggal Lahir",
                ),
              ),
              TextFormField(
                controller: alamatController,
                decoration: InputDecoration(
                  labelText: "Alamat",
                ),
              ),
              TextFormField(
                controller: noHpController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: "Nomor HP",
                ),
              ),
              TextFormField(
                controller: imageController,
                decoration: InputDecoration(
                  labelText: "Image",
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
              // DropdownButtonFormField(
              //   value: null,
              //   onChanged: (value) {
              //     setState(() {
              //       prodiController.text = value.toString();
              //     });
              //   },
              //   items: dokterList.map<DropdownMenuItem>((prodi) {
              //     return DropdownMenuItem(
              //       value: prodi['id'],
              //       child: Text(prodi['nama']),
              //     );
              //   }).toList(),
              //   decoration: InputDecoration(
              //     labelText: "Prodi",
              //   ),
              // ),
              ElevatedButton(
                onPressed: () => addDokter(context),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
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