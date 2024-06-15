import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditObatPage extends StatefulWidget {
  final Map<String, dynamic> obat;

  const EditObatPage({Key? key, required this.obat}) : super(key: key);

  @override
  _EditObatPageState createState() => _EditObatPageState();
}

class _EditObatPageState extends State<EditObatPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaObatController;
  late TextEditingController _tanggalKadaluarsaController;
  late TextEditingController _stockController;
  late TextEditingController _hargaController;
  String? _selectedKategori;
  final TextEditingController imageController = TextEditingController();

  final String apiGetAllKategoriObat =
      "http://192.168.239.136:8000/api/kategori-obat";
  List<dynamic> kategoriObatList = [];
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _namaObatController = TextEditingController(text: widget.obat['nama_obat']);
    _tanggalKadaluarsaController =
        TextEditingController(text: widget.obat['tanggal_kadaluarsa']);
    _stockController =
        TextEditingController(text: widget.obat['stock'].toString());
    _hargaController =
        TextEditingController(text: widget.obat['harga'].toString());
    _selectedKategori = widget.obat['kategori_id'].toString();
    _imageFile = null;
    _getAllKategoriObat();
  }

  @override
  void dispose() {
    _namaObatController.dispose();
    _tanggalKadaluarsaController.dispose();
    _stockController.dispose();
    _hargaController.dispose();
    super.dispose();
  }

  Future<void> _updateObat() async {
    final id = widget.obat['id'];
    final url = Uri.parse('http://192.168.239.136:8000/api/obat/$id/update');
    final request = http.MultipartRequest('POST', url);

    // Menambahkan data yang akan diperbarui
    request.fields['nama_obat'] = _namaObatController.text;
    request.fields['tanggal_kadaluarsa'] = _tanggalKadaluarsaController.text;
    request.fields['stock'] = _stockController.text;
    request.fields['harga'] = _hargaController.text;
    request.fields['kategori_id'] = _selectedKategori!;

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
          content: Text('Data obat berhasil diperbarui'),
        ),
      );
    } else {
      // Gagal memperbarui data
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memperbarui data obat'),
        ),
      );
    }
  }

  Future<void> _getAllKategoriObat() async {
    try {
      final response = await http.get(Uri.parse(apiGetAllKategoriObat));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data['kategori'] != null) {
          setState(() {
            kategoriObatList = data['kategori'];
          });
        } else {
          print("No data received from API");
        }
      } else {
        print("Failed to load prodi");
      }
    } catch (error) {
      print('Error : $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Data Obat'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _namaObatController,
                decoration: InputDecoration(
                  labelText: 'Nama Obat',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Nama obat tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _tanggalKadaluarsaController,
                decoration: InputDecoration(
                  labelText: 'Tanggal Kadaluarsa',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Tanggal kadaluarsa tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _stockController,
                decoration: InputDecoration(
                  labelText: 'Stock',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Stock tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _hargaController,
                decoration: InputDecoration(
                  labelText: 'Harga',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Harga tidak boleh kosong';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedKategori,
                decoration: InputDecoration(labelText: 'Kategori Obat'),
                items: kategoriObatList.map((kategori) {
                  return DropdownMenuItem<String>(
                    value: kategori['id'].toString(),
                    child: Text(kategori?['nama_kategori'] ?? ''),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedKategori = value;
                  });
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
                    _updateObat();
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
