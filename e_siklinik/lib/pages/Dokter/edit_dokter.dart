import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditDokter extends StatefulWidget {
  final Map<String, dynamic> dokter;

  const EditDokter({Key? key, required this.dokter}) : super(key: key);

  @override
  _EditDokterState createState() => _EditDokterState();
}

class _EditDokterState extends State<EditDokter> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  late TextEditingController _tanggalLahirController;
  late TextEditingController _alamatController;
  late TextEditingController _nomorHpController;
  final TextEditingController imageController = TextEditingController();
  String? selectedGender;
  File? _imageFile;
  final List<String> genders = ["Laki-Laki", "Perempuan"];

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.dokter['nama']);
    selectedGender = widget.dokter['gender'];
    _tanggalLahirController =
        TextEditingController(text: widget.dokter['tanggal_lahir']);
    _alamatController = TextEditingController(text: widget.dokter['alamat']);
    _nomorHpController = TextEditingController(text: widget.dokter['nomor_hp']);
    _imageFile = null;
  }

  @override
  void dispose() {
    _namaController.dispose();
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
    request.fields['gender'] = selectedGender ?? '';
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
      Navigator.pop(context, true);
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
      backgroundColor: const Color(0xFFF9F9FB),
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
          "Edit Data Dokter",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    offset: const Offset(-1, 2),
                    blurRadius: 3,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Nama",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                    ),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 2),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: Color(0xFFEFF0F3)),
                      child: TextFormField(
                        controller: _namaController,
                        decoration: const InputDecoration(
                            hintText: "Nama", border: InputBorder.none),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Nama tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Gender",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17),
                                ),
                                Container(
                                  height: 50,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 2),
                                  decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                      color: Color(0xFFEFF0F3)),
                                  child: DropdownButtonFormField<String>(
                                    value: selectedGender,
                                    decoration: const InputDecoration(
                                      hintText: "Gender",
                                      border: InputBorder.none,
                                    ),
                                    items: genders.map((String gender) {
                                      return DropdownMenuItem<String>(
                                        value: gender,
                                        child: Text(gender),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedGender = newValue;
                                      });
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Jenis kelamin tidak boleh kosong';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Tanggal Lahir",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17),
                                ),
                                Container(
                                  height: 50,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 2),
                                  decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                      color: Color(0xFFEFF0F3)),
                                  child: TextFormField(
                                    controller: _tanggalLahirController,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Tanggal lahir tidak boleh kosong';
                                      }
                                      return null;
                                    },
                                    onTap: () async {
                                      DateTime? pickedDate =
                                          await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime.now(),
                                      );
                                      if (pickedDate != null) {
                                        setState(() {
                                          _tanggalLahirController.text =
                                              pickedDate
                                                  .toString()
                                                  .split(' ')[0];
                                        });
                                      }
                                    },
                                    decoration: const InputDecoration(
                                        hintText: "YYYY/MM/DD",
                                        border: InputBorder.none,
                                        suffixIcon: Icon(
                                            Icons.calendar_month_outlined)),
                                  ),
                                ),
                              ],
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Alamat",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                    ),
                    Container(
                      height: 100,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 2),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: Color(0xFFEFF0F3)),
                      child: TextFormField(
                        maxLines: null,
                        controller: _alamatController,
                        decoration: const InputDecoration(
                            hintText: "Alamat", border: InputBorder.none),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Alamat tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Nomor Handphone",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                    ),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 2),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: Color(0xFFEFF0F3)),
                      child: TextFormField(
                        controller: _nomorHpController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                            hintText: "Nomor HP", border: InputBorder.none),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Nomor HP tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Foto Dokter",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                    ),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 2),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: Color(0xFFEFF0F3)),
                      child: TextFormField(
                        controller: imageController,
                        decoration: const InputDecoration(
                            hintText: "Image", border: InputBorder.none),
                        readOnly: true,
                        onTap: () async {
                          final picker = ImagePicker();
                          final pickedFile = await picker.pickImage(
                            source: ImageSource.gallery,
                          );

                          if (pickedFile != null) {
                            setState(() {
                              _imageFile = File(pickedFile.path);
                              imageController.text =
                                  _imageFile!.path.split('/').last;
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _updateDokter();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF234DF0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                            child: Text(
                              'Update',
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
      ),
    );
  }
}
