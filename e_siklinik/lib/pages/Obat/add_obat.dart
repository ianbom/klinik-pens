import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import 'package:dropdown_search/dropdown_search.dart';
 // GA KEPAKE WES TAK PINDAH NDE addObat.dart
class AddObat extends StatefulWidget {
  const AddObat({super.key});

  @override
  State<AddObat> createState() => _AddObatState();
}

class _AddObatState extends State<AddObat> {
  TextEditingController dateController = TextEditingController();
  TextEditingController namaObatController = TextEditingController();
  TextEditingController stokObatController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dateController.text = "";
  }

  String? _doctors;
  String? _selectedDate;
  String? _kategoriObat;

  List<String> _mydoctor = [
    "Clara",
    "John",
    "Rizal",
    "Steve",
    "Laurel",
    "Bernard",
    "Miechel"
  ];

  // Function to validate the form
  bool _validateForm() {
    if (namaObatController.text.isEmpty) {
      _showSnackBar('Nama Obat tidak boleh kosong');
      return false;
    }
    if (_kategoriObat == null) {
      _showSnackBar('Kategori Obat harus dipilih');
      return false;
    }
    if (dateController.text.isEmpty) {
      _showSnackBar('Tanggal Kadaluarsa tidak boleh kosong');
      return false;
    }
    if (stokObatController.text.isEmpty) {
      _showSnackBar('Stok Obat tidak boleh kosong');
      return false;
    }
    return true;
  }

  // Function to show snackbar with a message
  void _showSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message),backgroundColor: Colors.red,);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: const Text("Data Obat", style: TextStyle()),
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
                child: const Icon(Icons.arrow_left, size: 50, color: Color.fromARGB(255, 0, 0, 0)),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                            child: Text('Nama Obat', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            width: MediaQuery.of(context).size.width / 1.1,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: const Color.fromARGB(200, 235, 242, 255),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 9, bottom: 9, left: 20),
                                child: TextField(
                                  controller: namaObatController,
                                  decoration: InputDecoration.collapsed(
                                    filled: true,
                                    fillColor: const Color.fromARGB(200, 235, 242, 255),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    hintText: 'Nama Obat',
                                    hintStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 15)
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
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Text('Kategori Obat', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Urbanist')),
                                      ),
                                      SizedBox(
                                        child: Card(
                                          child: Container(
                                            width: MediaQuery.of(context).size.width / 2.5,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10.0),
                                              color: const Color.fromARGB(200, 235, 242, 255),
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                DropdownSearch<String>(
                                                  popupProps: PopupProps.dialog(
                                                    showSearchBox: true,
                                                  ),
                                                  dropdownDecoratorProps: DropDownDecoratorProps(
                                                    dropdownSearchDecoration: InputDecoration(
                                                      hintText: "Pilih Nama",
                                                      hintStyle: TextStyle(fontSize: 12),
                                                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                                      border: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(10.0),
                                                          borderSide: BorderSide.none
                                                      ),
                                                    ),
                                                  ),
                                                  items: _mydoctor,
                                                  selectedItem: _doctors,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _kategoriObat = value;
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 10),
                                      child: Text('Tanggal Kadaluarsa', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                    ),
                                    SizedBox(
                                      child: Card(
                                        child: Container(
                                          width: MediaQuery.of(context).size.width / 2.5,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10.0),
                                            color: Color.fromARGB(200, 235, 242, 255),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                child: TextField(
                                                  controller: dateController,
                                                  decoration: InputDecoration(
                                                      border: OutlineInputBorder(
                                                          borderSide: BorderSide.none,
                                                          borderRadius: BorderRadius.circular(10)
                                                      ),
                                                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                      suffixIcon: Icon(Icons.calendar_today, size: 20),
                                                      labelText: "DD/MM/YYYY",
                                                      labelStyle: TextStyle(fontSize: 10)
                                                  ),
                                                  readOnly: true,
                                                  onTap: () async {
                                                    DateTime? pickedDate = await showDatePicker(
                                                      context: context,
                                                      initialDate: DateTime.now(),
                                                      firstDate: DateTime(2000),
                                                      lastDate: DateTime(2101),
                                                    );
                                                    if (pickedDate != null) {
                                                      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                                                      setState(() {
                                                        dateController.text = formattedDate;
                                                      });
                                                    } else {
                                                      print("Date is not selected");
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
                        child: Text('Stok Obat', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        width: MediaQuery.of(context).size.width / 1.1,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: const Color.fromARGB(200, 235, 242, 255),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 9, bottom: 9, left: 20),
                            child: TextField(
                              controller: stokObatController,
                              decoration: InputDecoration.collapsed(
                                  filled: true,
                                  fillColor: const Color.fromARGB(200, 235, 242, 255),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  hintText: 'Masukkan Stok Obat',
                                  hintStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 15)
                              ),
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
                                Navigator.pop(context);
                              },
                              child: SizedBox(
                                child: Card(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      border: Border.all(width: 2, color: Colors.blue),
                                      color: Colors.white,
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                          child: Text('Cancel', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue)),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (_validateForm()) {
                                  // Proceed with form submission
                                }
                              },
                              child: SizedBox(
                                child: Card(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      border: Border.all(width: 2, color: Colors.blue),
                                      color: Colors.blue,
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                          child: Text('Submit', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
