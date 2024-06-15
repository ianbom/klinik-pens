import 'package:e_siklinik/components/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditPasien extends StatefulWidget {
  final Map<String, dynamic> pasien;

  const EditPasien({Key? key, required this.pasien}) : super(key: key);

  @override
  _EditPasienState createState() => _EditPasienState();
}

class _EditPasienState extends State<EditPasien> {
  final String apiGetAllProdi = "http://192.168.239.136:8000/api/prodi";
  List<dynamic> prodiList = [];
  String? selectedGender;
  final List<String> genders = ["Laki-Laki", "Perempuan"];
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  late TextEditingController _nrpController;
  late TextEditingController _tanggalLahirController;
  late TextEditingController _alamatController;
  late TextEditingController _nomorHpController;
  late TextEditingController _nomorWaliController;
  late TextEditingController _prodiController;
  String? _selectedProdiId;
  final TextEditingController imageController = TextEditingController();

  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _prodiController = TextEditingController(text: widget.pasien['prodi']);
    _namaController = TextEditingController(text: widget.pasien['nama']);
    _nrpController = TextEditingController(text: widget.pasien['nrp']);
    selectedGender = widget.pasien['gender'];
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
    _prodiController.dispose();
    _namaController.dispose();
    _nrpController.dispose();
    _tanggalLahirController.dispose();
    _alamatController.dispose();
    _nomorHpController.dispose();
    _nomorWaliController.dispose();
    super.dispose();
  }

  Future<void> _updatePasien() async {
    setState(() {
      isLoading = true;
    });
    final id = widget.pasien['id'];
    final url = Uri.parse('http://192.168.239.136:8000/api/pasien/update/$id');
    final request = http.MultipartRequest('POST', url);

    // Menambahkan data yang akan diperbarui
    request.fields['nama'] = _namaController.text;
    request.fields['nrp'] = _nrpController.text;
    request.fields['gender'] = selectedGender ?? '';
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
        const SnackBar(
          content: Text('Data pasien berhasil diperbarui'),
        ),
      );
      Navigator.pop(context, true);
    } else {
      // Gagal memperbarui data
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
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
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
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
              "Edit Pasien",
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
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 17),
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
                            controller: _namaController,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Nama',
                                focusColor: Color(0xFFEBF2FF)),
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
                        const Text(
                          "Program Studi",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 17),
                        ),
                        Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 2),
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              color: Color(0xFFEFF0F3)),
                          child: AutocompleteTextField(
                            validator: (value) {
                              if (value == null) {
                                return 'Prodi tidak boleh kosong';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                hintText:
                                    '${widget.pasien['pasien_to_prodi']['nama']}',
                                border: InputBorder.none),
                            items: prodiList
                                .map((prodi) => prodi['nama'] as String)
                                .toList(),
                            onItemSelect: (value) {
                              final selectedProdi = prodiList.firstWhere(
                                  (prodi) => prodi['nama'] == value);
                              setState(() {
                                _selectedProdiId =
                                    selectedProdi['id'].toString();
                              });
                            },
                          ),
                        ),
                        // DropdownButtonFormField<String>(
                        //   value: _selectedProdiId,
                        //   decoration: const InputDecoration(
                        //     labelText: 'Prodi',
                        //   ),
                        //   items: prodiList.map((prodi) {
                        //     return DropdownMenuItem<String>(
                        //       value: prodi['id'].toString(),
                        //       child: Text(prodi?['nama'] ?? ''),
                        //     );
                        //   }).toList(),
                        //   onChanged: (value) {
                        //     setState(() {
                        //       _selectedProdiId = value;
                        //     });
                        //   },
                        //   validator: (value) {
                        //     if (value == null) {
                        //       return 'Prodi tidak boleh kosong';
                        //     }
                        //     return null;
                        //   },
                        // ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "NRP",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 17),
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
                            controller: _nrpController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                hintText: "NRP", border: InputBorder.none),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'NRP tidak boleh kosong';
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
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
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
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
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
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 17),
                        ),
                        Container(
                          height: 100,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 2),
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
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
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 17),
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
                          "Nomor Handphone Wali",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 17),
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
                            controller: _nomorWaliController,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                                hintText: "Nomor Wali",
                                border: InputBorder.none),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Nomor Wali tidak boleh kosong';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Foto Pasien",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 17),
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
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      if (_formKey.currentState!.validate()) {
                                        _updatePasien();
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
        ),
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}
