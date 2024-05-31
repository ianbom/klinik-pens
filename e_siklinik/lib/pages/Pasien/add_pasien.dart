import 'dart:convert';
import 'dart:io';
import 'package:e_siklinik/components/dropdown_search.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPasien extends StatefulWidget {
  const AddPasien({super.key});

  @override
  State<AddPasien> createState() => _AddPasienState();
}

class _AddPasienState extends State<AddPasien> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController nrpController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController noHpController = TextEditingController();
  final TextEditingController noWaliController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController prodiController = TextEditingController();
  final TextEditingController tanggalLahirController = TextEditingController();

  final String apiPostPasien = "http://10.0.2.2:8000/api/pasien/create";
  final String apiGetAllProdi = "http://10.0.2.2:8000/api/prodi";

  List<dynamic> prodiList = [];
  String? selectedGender;
  final List<String> genders = ["Laki-laki", "Perempuan"];
  File? _imageFile;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _getAllProdi();
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
      print('Error : $error');
    }
  }

  Future<void> addPasien(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiPostPasien));
      request.fields['nama'] = namaController.text;
      request.fields['nrp'] = nrpController.text;
      request.fields['gender'] = selectedGender ?? "";
      request.fields['tanggal_lahir'] = tanggalLahirController.text;
      request.fields['alamat'] = alamatController.text;
      request.fields['nomor_hp'] = noHpController.text;
      request.fields['nomor_wali'] = noWaliController.text;
      request.fields['prodi_id'] = prodiController.text;

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
        // Handle respon dari server
        final pasien =
            json.decode(await response.stream.bytesToString())['pasien'];
        print('Pasien berhasil ditambahkan: $pasien');

        // Menampilkan snackbar untuk memberi tahu pengguna bahwa pasien berhasil ditambahkan
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pasien berhasil ditambahkan')),
        );

        namaController.clear();
        nrpController.clear();
        selectedGender = null;
        tanggalLahirController.clear();
        alamatController.clear();
        noHpController.clear();
        noWaliController.clear();
        imageController.clear();
        prodiController.clear();
        _imageFile = null;
      } else {
        print('Gagal menambahkan pasien');
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
                  Navigator.pop(context, true);
                },
                icon: const Icon(Icons.arrow_back_ios)),
            backgroundColor: Colors.white,
            elevation: 2,
            shadowColor: Colors.black,
            centerTitle: true,
            title: const Text(
              "Data Pasien",
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
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: Color(0xFFEFF0F3)),
                        child: TextFormField(
                          controller: namaController,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Nama',
                              focusColor: Color(0xFFEBF2FF)),
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
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: Color(0xFFEFF0F3),
                        ),
                        child: AutocompleteTextField(
                          decoration: const InputDecoration(
                              hintText: 'Prodi', border: InputBorder.none),
                          validator: (val) {
                            if (prodiList.contains(val)) {
                              return null;
                            } else {
                              return 'Invalid Prodi';
                            }
                          },
                          items: prodiList
                              .map((prodi) => prodi['nama'] as String)
                              .toList(),
                          onItemSelect: (value) {
                            final selectedProdi = prodiList
                                .firstWhere((prodi) => prodi['nama'] == value);
                            setState(() {
                              prodiController.text =
                                  selectedProdi['id'].toString();
                            });
                          },
                        ),
                      ),
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
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: Color(0xFFEFF0F3)),
                        child: TextFormField(
                          controller: nrpController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              hintText: "NRP", border: InputBorder.none),
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
                                      onChanged: (newValue) {
                                        setState(() {
                                          selectedGender = newValue;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              )),
                          const SizedBox(width: 10),
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
                                      controller: tanggalLahirController,
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
                                            tanggalLahirController.text =
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
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: Color(0xFFEFF0F3)),
                        child: TextFormField(
                          maxLines: null,
                          controller: alamatController,
                          decoration: const InputDecoration(
                              hintText: "Alamat", border: InputBorder.none),
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
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: Color(0xFFEFF0F3)),
                        child: TextFormField(
                          controller: noHpController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                              hintText: "Nomor HP", border: InputBorder.none),
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
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: Color(0xFFEFF0F3)),
                        child: TextFormField(
                          controller: noWaliController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                              hintText: "Nomor Wali", border: InputBorder.none),
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
                            onPressed:
                                isLoading ? null : () => addPasien(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF234DF0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.0),
                              child: Text(
                                'Submit',
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
