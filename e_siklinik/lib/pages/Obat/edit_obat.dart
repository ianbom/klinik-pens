import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class EditObat extends StatefulWidget {
  final Map<String, dynamic> obat;

  const EditObat({Key? key, required this.obat}) : super(key: key);

  @override
  State<EditObat> createState() => _EditObatState();
}

class _EditObatState extends State<EditObat> {
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
        const SnackBar(
          content: Text('Data obat berhasil diperbarui'),
        ),
      );
      Navigator.pop(context, true);
    } else {
      // Gagal memperbarui data
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
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
            "Edit Obat",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        body: SingleChildScrollView(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Card(
              elevation: 10,
              child: Container(
                  width: MediaQuery.of(context).size.width / 1.1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                  ),
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Text(
                                      'Nama Obat',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    width:
                                        MediaQuery.of(context).size.width / 1.1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        color: const Color.fromARGB(
                                            200, 235, 242, 255),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 9, bottom: 9, left: 20),
                                        child: TextFormField(
                                          controller: _namaObatController,
                                          decoration: InputDecoration.collapsed(
                                            filled: true,
                                            fillColor: const Color.fromARGB(
                                                200, 235, 242, 255),
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            hintText: 'Nama Obat',
                                            hintStyle: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 15),
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Nama obat tidak boleh kosong';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Padding(
                                                padding:
                                                    EdgeInsets.only(left: 10),
                                                child: Text(
                                                  'Kategori Obat',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    fontFamily: 'Urbanist',
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                child: Card(
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2.5,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                      color:
                                                          const Color.fromARGB(
                                                              200,
                                                              235,
                                                              242,
                                                              255),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child:
                                                          DropdownButtonFormField<
                                                              String>(
                                                        isExpanded: true,
                                                        icon: const ImageIcon(
                                                            AssetImage(
                                                                "assets/images/Dropdown.png")),
                                                        decoration:
                                                            const InputDecoration
                                                                .collapsed(
                                                                hintText: ""),
                                                        hint: const Text(
                                                          "Pilih Kategori Obat",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Urbanist',
                                                            fontSize: 16,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        value:
                                                            _selectedKategori,
                                                        items: kategoriObatList.map<
                                                                DropdownMenuItem<
                                                                    String>>(
                                                            (kategori) {
                                                          return DropdownMenuItem<
                                                              String>(
                                                            value:
                                                                kategori['id']
                                                                    .toString(),
                                                            child: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              constraints:
                                                                  const BoxConstraints(
                                                                      minHeight:
                                                                          48.0),
                                                              child: Text(
                                                                kategori[
                                                                    'nama_kategori'],
                                                                style:
                                                                    const TextStyle(
                                                                  fontFamily:
                                                                      'Urbanist',
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        }).toList(),
                                                        onChanged: (value) {
                                                          setState(() {
                                                            _selectedKategori =
                                                                value;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              child: Text(
                                                'Tanggal Kadaluarsa',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              child: Card(
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2.5,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    color: const Color.fromARGB(
                                                        200, 235, 242, 255),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        height: 40,
                                                        child: TextFormField(
                                                          controller:
                                                              _tanggalKadaluarsaController,
                                                          decoration:
                                                              InputDecoration(
                                                            border:
                                                                OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide
                                                                      .none,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            contentPadding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        10,
                                                                    vertical:
                                                                        5),
                                                            suffixIcon:
                                                                const Icon(
                                                              Icons
                                                                  .calendar_today,
                                                              size: 20,
                                                            ), //icon of text field
                                                            labelText:
                                                                "DD/MM/YYYY",
                                                            labelStyle:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        10), //label text of field
                                                          ),
                                                          readOnly:
                                                              true, // when true user cannot edit text
                                                          onTap: () async {
                                                            DateTime?
                                                                pickedDate =
                                                                await showDatePicker(
                                                              context: context,
                                                              initialDate: DateTime
                                                                  .now(), //get today's date
                                                              firstDate:
                                                                  DateTime
                                                                      .now(),
                                                              lastDate:
                                                                  DateTime(
                                                                      2101),
                                                            );
                                                            if (pickedDate !=
                                                                null) {
                                                              print(pickedDate);
                                                              String
                                                                  formattedDate =
                                                                  DateFormat(
                                                                          'yyyy-MM-dd')
                                                                      .format(
                                                                          pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                                                              print(
                                                                  formattedDate);
                                                              setState(() {
                                                                _tanggalKadaluarsaController
                                                                        .text =
                                                                    formattedDate; //set foratted date to TextField value.
                                                              });
                                                            } else {
                                                              print(
                                                                  "Date is not selected");
                                                            }
                                                          },
                                                          validator: (value) {
                                                            if (value!
                                                                .isEmpty) {
                                                              return 'Tanggal kadaluarsa tidak boleh kosong';
                                                            }
                                                            return null;
                                                          },
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  'Stok Obat',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                width: MediaQuery.of(context).size.width / 1.1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: const Color.fromARGB(
                                        200, 235, 242, 255),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 9, bottom: 9, left: 20),
                                    child: TextFormField(
                                      controller: _stockController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration.collapsed(
                                        filled: true,
                                        fillColor: const Color.fromARGB(
                                            200, 235, 242, 255),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        hintText: 'Masukkan Stok Obat',
                                        hintStyle: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 15,
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Stock tidak boleh kosong';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  'Harga Obat',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                width: MediaQuery.of(context).size.width / 1.1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: const Color.fromARGB(
                                        200, 235, 242, 255),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 9, bottom: 9, left: 20),
                                    child: TextFormField(
                                      controller: _hargaController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration.collapsed(
                                        filled: true,
                                        fillColor: const Color.fromARGB(
                                            200, 235, 242, 255),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        hintText: 'Masukkan Harga Obat',
                                        hintStyle: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 15,
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Harga tidak boleh kosong';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  'Gambar Obat',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                width: MediaQuery.of(context).size.width / 1.1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: const Color.fromARGB(
                                        200, 235, 242, 255),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 9, bottom: 9, left: 20),
                                    child: TextField(
                                      controller: imageController,
                                      decoration: InputDecoration.collapsed(
                                        filled: true,
                                        fillColor: const Color.fromARGB(
                                            200, 235, 242, 255),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        hintText: 'Pilih Gambar',
                                        hintStyle: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 15,
                                        ),
                                      ),
                                      readOnly: true,
                                      onTap: () async {
                                        final picker = ImagePicker();
                                        final pickedFile =
                                            await picker.pickImage(
                                          source: ImageSource.gallery,
                                        );

                                        if (pickedFile != null) {
                                          setState(() {
                                            _imageFile = File(pickedFile.path);
                                            imageController.text = _imageFile!
                                                .path
                                                .split('/')
                                                .last;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            _updateObat();
                                          } // Panggil fungsi addObat saat tombol Submit ditekan
                                        },
                                        child: SizedBox(
                                          child: Card(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                border: Border.all(
                                                    width: 2,
                                                    color: Colors.blue),
                                                color: Colors.blue,
                                              ),
                                              child: const Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 10,
                                                            horizontal: 20),
                                                    child: Text(
                                                      'Update',
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ))
                            ]),
                      ))))
        ])));
  }
}
