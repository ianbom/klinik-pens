import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class AddDokter extends StatefulWidget {
  const AddDokter({super.key});

  @override
  State<AddDokter> createState() => _AddDokterState();
}

class _AddDokterState extends State<AddDokter> {
  final TextEditingController namaController = TextEditingController();
  final List<String> gender = ['Laki-Laki', 'Perempuan'];
  String genderController = '';
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController noHpController = TextEditingController();
  //final TextEditingController jadwalController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController tanggalLahirController = TextEditingController();

  final String apiPostDokter = "http://10.0.2.2:8000/api/dokter/create";
  final String apiGetAllJadwalDokter =
      "http://10.0.2.2:8000/api/jadwal_dokter";

  List<dynamic> dokterList = [];
  File? _imageFile;
  String? selectedGender;
  final List<String> genders = ["Laki-laki", "Perempuan"];

  @override
  void initState() {
    super.initState();
  }

  Future<void> addDokter(BuildContext context) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiPostDokter));
      request.fields['nama'] = namaController.text;
      request.fields['gender'] = genderController;
      request.fields['tanggal_lahir'] = tanggalLahirController.text;
      request.fields['alamat'] = alamatController.text;
      request.fields['nomor_hp'] = noHpController.text;

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
        final dokter =
            json.decode(await response.stream.bytesToString())['dokter'];
        print('Dokter berhasil ditambahkan: $dokter');
// Menampilkan snackbar untuk memberi tahu pengguna bahwa pasien berhasil ditambahkan
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dokter berhasil ditambahkan')),
        );
        namaController.clear();
        // genderController.clear();
        tanggalLahirController.clear();
        alamatController.clear();
        noHpController.clear();
        _imageFile = null;

        Navigator.pop(context,true);
      } else {
        print('Gagal menambahkan Dokter');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF9F9FB),
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
            "Data Dokter",
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
                              hintText: "Nama", border: InputBorder.none),
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
                                      color: Color(0xFFEFF0F3),
                                    ),
                                    child: DropdownButtonFormField(
                                      onChanged: (value) {
                                        setState(() {
                                          genderController = value;
                                        });
                                      },
                                      items:
                                          gender.map<DropdownMenuItem>((item) {
                                        return DropdownMenuItem(
                                          value: item,
                                          child: Text(item),
                                        );
                                      }).toList(),
                                      decoration: const InputDecoration(
                                          hintText: "Gender",
                                          border: InputBorder.none),
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
                        "Foto Dokter",
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
                            onPressed: () => addDokter(context),
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
              )),
        ));
  }
}