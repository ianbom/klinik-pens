import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart'; // Tambahkan baris ini
import 'dart:io';

class EditDokterPage extends StatefulWidget {
  final Map<String, dynamic> dokter;

  const EditDokterPage({Key? key, required this.dokter}) : super(key: key);

  @override
  _EditDokterPageState createState() => _EditDokterPageState();
}

class _EditDokterPageState extends State<EditDokterPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  late TextEditingController _genderController;
  late TextEditingController _tanggalLahirController;
  late TextEditingController _alamatController;
  late TextEditingController _nomorHpController;
  final TextEditingController imageController = TextEditingController();

  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.dokter['nama']);
    _genderController = TextEditingController(text: widget.dokter['gender']);
    _tanggalLahirController =
        TextEditingController(text: widget.dokter['tanggal_lahir']);
    _alamatController = TextEditingController(text: widget.dokter['alamat']);
    _nomorHpController = TextEditingController(text: widget.dokter['nomor_hp']);
    _imageFile = null;
  }

  @override
  void dispose() {
    _namaController.dispose();
    _genderController.dispose();
    _tanggalLahirController.dispose();
    _alamatController.dispose();
    _nomorHpController.dispose();
    super.dispose();
  }

  Future<void> _updateDokter() async {
    final id = widget.dokter['id'];
    final url = Uri.parse('http://192.168.239.136:8000/api/dokter/update/$id');
    final request = http.MultipartRequest('POST', url);

    // Menambahkan data yang akan diperbarui
    request.fields['nama'] = _namaController.text;
    request.fields['gender'] = _genderController.text;
    request.fields['tanggal_lahir'] = _tanggalLahirController.text;
    request.fields['alamat'] = _alamatController.text;
    request.fields['nomor_hp'] = _nomorHpController.text;

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
          content: Text('Data dokter berhasil diperbarui'),
        ),
      );
    } else {
      // Gagal memperbarui data
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memperbarui data dokter'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Data Dokter'),
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
                    _updateDokter();
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
