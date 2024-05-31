import 'package:e_siklinik/pages/Obat/data_obat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AddObatNew extends StatefulWidget {
  const AddObatNew({super.key});

  @override
  State<AddObatNew> createState() => _AddObatNewState();
}

class _AddObatNewState extends State<AddObatNew> {
  final TextEditingController namaObatController = TextEditingController();
  final TextEditingController tanggalKadaluarsaController =
      TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController hargaController = TextEditingController();
  final TextEditingController imageController = TextEditingController();

  final String apiPostObat = "http://10.0.2.2:8000/api/obat/insert";

  final String apiGetAllKategori = "http://10.0.2.2:8000/api/kategori-obat";

  List<dynamic> kategoriList = [];
  String? _selectedKategori;

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
      request.fields['kategori_id'] = _selectedKategori.toString();

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
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const DataObat()));

        // Clear input fields
        // namaObatController.clear();
        // tanggalKadaluarsaController.clear();
        // stockController.clear();
        // hargaController.clear();
        // imageController.clear();
        // _selectedKategori = null;
        // _imageFile = null;
      } else {
        final errorData = json.decode(await response.stream.bytesToString());
        print('Gagal menambahkan obat: ${errorData['message']}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  String? _doctors;
  String? _selectedDate;

  List _mydoctor = [
    "Clara",
    "John",
    "Rizal",
    "Steve",
    "Laurel",
    "Bernard",
    "Miechel"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          title: const Text(
            "Data Obat",
            style: TextStyle(),
          ),
          titleTextStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: '',
              color: Colors.black),
          centerTitle: true,
          backgroundColor: Colors.white,
          toolbarHeight: 66,
          leading: Container(
            color: Colors.white,
            child: ButtonBar(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_left,
                    size: 50,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ],
            ),
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
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
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
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: const Color.fromARGB(
                                          200, 235, 242, 255),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 9, bottom: 9, left: 20),
                                      child: TextField(
                                        controller: namaObatController,
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
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
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
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
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
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2.5,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    color: Color.fromARGB(
                                                        200, 235, 242, 255),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child:
                                                        DropdownButtonFormField<
                                                            String>(
                                                      isExpanded: true,
                                                      icon: ImageIcon(AssetImage(
                                                          "assets/images/Dropdown.png")),
                                                      decoration:
                                                          InputDecoration
                                                              .collapsed(
                                                                  hintText: ""),
                                                      hint: Text(
                                                        "Pilih Kategori Obat",
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'Urbanist',
                                                          fontSize: 16,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      value: _selectedKategori,
                                                      items: kategoriList.map<
                                                              DropdownMenuItem<
                                                                  String>>(
                                                          (kategori) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            constraints:
                                                                BoxConstraints(
                                                                    minHeight:
                                                                        48.0),
                                                            child: Text(
                                                              kategori[
                                                                  'nama_kategori'],
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Urbanist',
                                                              ),
                                                            ),
                                                          ),
                                                          value: kategori['id']
                                                              .toString(),
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
                                          Padding(
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
                                                  color: Color.fromARGB(
                                                      200, 235, 242, 255),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      height: 40,
                                                      child: TextField(
                                                        controller:
                                                            tanggalKadaluarsaController,
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide.none,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          contentPadding:
                                                              EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          10,
                                                                      vertical:
                                                                          5),
                                                          suffixIcon: Icon(
                                                            Icons
                                                                .calendar_today,
                                                            size: 20,
                                                          ), //icon of text field
                                                          labelText:
                                                              "DD/MM/YYYY",
                                                          labelStyle: TextStyle(
                                                              fontSize:
                                                                  10), //label text of field
                                                        ),
                                                        readOnly:
                                                            true, // when true user cannot edit text
                                                        onTap: () async {
                                                          DateTime? pickedDate =
                                                              await showDatePicker(
                                                            context: context,
                                                            initialDate: DateTime
                                                                .now(), //get today's date
                                                            firstDate: DateTime(
                                                                2000), //DateTime.now() - not to allow to choose before today.
                                                            lastDate:
                                                                DateTime(2101),
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
                                                              tanggalKadaluarsaController
                                                                      .text =
                                                                  formattedDate; //set foratted date to TextField value.
                                                            });
                                                          } else {
                                                            print(
                                                                "Date is not selected");
                                                          }
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
                                  color:
                                      const Color.fromARGB(200, 235, 242, 255),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 9, bottom: 9, left: 20),
                                  child: TextField(
                                    controller: stockController,
                                    decoration: InputDecoration.collapsed(
                                      filled: true,
                                      fillColor: const Color.fromARGB(
                                          200, 235, 242, 255),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      hintText: 'Masukkan Stok Obat',
                                      hintStyle: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 15,
                                      ),
                                    ),
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
                                  color:
                                      const Color.fromARGB(200, 235, 242, 255),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 9, bottom: 9, left: 20),
                                  child: TextField(
                                    controller: hargaController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration.collapsed(
                                      filled: true,
                                      fillColor: const Color.fromARGB(
                                          200, 235, 242, 255),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      hintText: 'Masukkan Harga Obat',
                                      hintStyle: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 15,
                                      ),
                                    ),
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
                                  color:
                                      const Color.fromARGB(200, 235, 242, 255),
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
                                        borderRadius: BorderRadius.circular(10),
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
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        // Aksi ketika tombol Cancel ditekan
                                      },
                                      child: SizedBox(
                                        child: Card(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              border: Border.all(
                                                  width: 2, color: Colors.blue),
                                              color: Colors.white,
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 10,
                                                      horizontal: 20),
                                                  child: Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.blue,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        addObat(
                                            context); // Panggil fungsi addObat saat tombol Submit ditekan
                                      },
                                      child: SizedBox(
                                        child: Card(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              border: Border.all(
                                                  width: 2, color: Colors.blue),
                                              color: Colors.blue,
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 10,
                                                      horizontal: 20),
                                                  child: Text(
                                                    'Submit',
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
                          ]))))
        ])));
  }
}
