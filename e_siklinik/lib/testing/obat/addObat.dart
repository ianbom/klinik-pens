import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AddObatPage extends StatefulWidget {
  const AddObatPage({Key? key}) : super(key: key);

  @override
  State<AddObatPage> createState() => _AddObatPageState();
}

class _AddObatPageState extends State<AddObatPage> {
  final TextEditingController namaObatController = TextEditingController();
  final TextEditingController tanggalKadaluarsaController =
      TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController hargaController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController kategoriController = TextEditingController();

  final String apiPostObat = "http://10.0.2.2:8000/api/obat/insert";

  final String apiGetAllKategori = "http://10.0.2.2:8000/api/kategori-obat";

  List<dynamic> kategoriList = [];

  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _getAllKategori();
  }

  Future<void> _getAllKategori() async {
    try {
      final response = await http.get(Uri.parse(apiGetAllKategori));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data['kategori'] != null) {
          setState(() {
            kategoriList = data['kategori'];
          });
        } else {
          print("No data received from API");
        }
      } else {
        print("Failed to load kategori obat");
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> addObat(BuildContext context) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiPostObat));
      request.fields['nama_obat'] = namaObatController.text;
      request.fields['tanggal_kadaluarsa'] = tanggalKadaluarsaController.text;
      request.fields['stock'] = stockController.text;
      request.fields['harga'] = hargaController.text;
      request.fields['kategori_id'] = kategoriController.text;

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
        final obat =
            json.decode(await response.stream.bytesToString())['obats'];
        print('Obat berhasil ditambahkan: $obat');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Obat berhasil ditambahkan')),
        );

        // Clear input fields
        // namaObatController.clear();
        // tanggalKadaluarsaController.clear();
        // stockController.clear();
        // hargaController.clear();
        // imageController.clear();
        // kategoriController.clear();
        // _imageFile = null;
      } else {
        final errorData = json.decode(await response.stream.bytesToString());
        print('Gagal menambahkan obat: ${errorData['message']}');
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
          "Data Obat",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: namaObatController,
                decoration: const InputDecoration(
                  labelText: "Nama Obat",
                ),
              ),
              TextFormField(
                controller: tanggalKadaluarsaController,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      tanggalKadaluarsaController.text =
                          pickedDate.toString().split(' ')[0];
                    });
                  }
                },
                decoration: const InputDecoration(
                  labelText: "Tanggal Kadaluarsa",
                ),
              ),
              TextFormField(
                controller: stockController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Stock",
                ),
              ),
              TextFormField(
                controller: hargaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Harga",
                ),
              ),
              TextFormField(
                controller: imageController,
                decoration: const InputDecoration(
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
              DropdownButtonFormField(
                value: null,
                onChanged: (value) {
                  setState(() {
                    kategoriController.text = value.toString();
                  });
                },
                items: kategoriList.map<DropdownMenuItem>((kategori) {
                  return DropdownMenuItem(
                    value: kategori['id'],
                    child: Text(kategori['nama_kategori']),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: "Kategori Obat",
                ),
              ),
              ElevatedButton(
                onPressed: () => addObat(context),
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
