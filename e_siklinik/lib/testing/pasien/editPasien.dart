import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditPasienPage extends StatefulWidget {
  final Map<String, dynamic> pasien;

  const EditPasienPage({Key? key, required this.pasien}) : super(key: key);

  @override
  _EditPasienPageState createState() => _EditPasienPageState();
}

class _EditPasienPageState extends State<EditPasienPage> {
  final String apiGetAllProdi = "http://192.168.239.136:8000/api/prodi";
  List<dynamic> prodiList = [];

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  late TextEditingController _nrpController;
  late TextEditingController _genderController;
  late TextEditingController _tanggalLahirController;
  late TextEditingController _alamatController;
  late TextEditingController _nomorHpController;
  late TextEditingController _nomorWaliController;
  String? _selectedProdiId;
  final TextEditingController imageController = TextEditingController();

  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.pasien['nama']);
    _nrpController = TextEditingController(text: widget.pasien['nrp']);
    _genderController = TextEditingController(text: widget.pasien['gender']);
    _tanggalLahirController =
        TextEditingController(text: widget.pasien['tanggal_lahir']);
    _alamatController = TextEditingController(text: widget.pasien['alamat']);
    _nomorHpController = TextEditingController(text: widget.pasien['nomor_hp']);
    _nomorWaliController =
        TextEditingController(text: widget.pasien['nomor_wali']);
    _selectedProdiId = widget.pasien['prodi_id'].toString();
    _imageFile = null;
    _getAllProdi();
  }

  @override
  void dispose() {
    _namaController.dispose();
    _nrpController.dispose();
    _genderController.dispose();
    _tanggalLahirController.dispose();
    _alamatController.dispose();
    _nomorHpController.dispose();
    _nomorWaliController.dispose();
    super.dispose();
  }

  Future<void> _updatePasien() async {
    final id = widget.pasien['id'];
    final url = Uri.parse('http://192.168.239.136:8000/api/pasien/update/$id');
    final request = http.MultipartRequest('POST', url);

    // Menambahkan data yang akan diperbarui
    request.fields['nama'] = _namaController.text;
    request.fields['nrp'] = _nrpController.text;
    request.fields['gender'] = _genderController.text;
    request.fields['tanggal_lahir'] = _tanggalLahirController.text;
    request.fields['alamat'] = _alamatController.text;
    request.fields['nomor_hp'] = _nomorHpController.text;
    request.fields['nomor_wali'] = _nomorWaliController.text;
    request.fields['prodi_id'] = _selectedProdiId!;

    // Menambahkan file gambar (jika ada)
    if (_imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          _imageFile!.path,
        ),
      );
    }

    final response = await request.send();

    if (response.statusCode == 200) {
      // Berhasil memperbarui data
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data pasien berhasil diperbarui'),
        ),
      );
    } else {
      // Gagal memperbarui data
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memperbarui data pasien'),
        ),
      );
    }
  }

  Future<void> _getAllProdi() async {
    try {
      final response = await http.get(Uri.parse(apiGetAllProdi));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data['prodi'] != null) {
          setState(() {
            prodiList = data['prodi'];
          });
        } else {
          print("No data received from API");
        }
      } else {
        print("Failed to load prodi");
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Data Pasien'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _namaController,
                decoration: InputDecoration(
                  labelText: 'Nama',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nrpController,
                decoration: InputDecoration(
                  labelText: 'NRP',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'NRP tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _genderController,
                decoration: InputDecoration(
                  labelText: 'Jenis Kelamin',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Jenis kelamin tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _tanggalLahirController,
                decoration: InputDecoration(
                  labelText: 'Tanggal Lahir',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Tanggal lahir tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _alamatController,
                decoration: InputDecoration(
                  labelText: 'Alamat',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Alamat tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nomorHpController,
                decoration: InputDecoration(
                  labelText: 'Nomor HP',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Nomor HP tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nomorWaliController,
                decoration: InputDecoration(
                  labelText: 'Nomor Wali',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Nomor Wali tidak boleh kosong';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedProdiId,
                decoration: InputDecoration(
                  labelText: 'Prodi',
                ),
                items: prodiList.map((prodi) {
                  return DropdownMenuItem<String>(
                    value: prodi['id'].toString(),
                    child: Text(prodi?['nama'] ?? ''),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedProdiId = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Prodi tidak boleh kosong';
                  }
                  return null;
                },
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
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _updatePasien();
                  }
                },
                child: Text('Simpan Perubahan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
