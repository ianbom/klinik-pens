import 'dart:convert';
import 'dart:io';
import 'package:e_siklinik/components/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class AddCheckup extends StatefulWidget {
  final int assesmentId;
  const AddCheckup({Key? key, required this.assesmentId});

  @override
  State<AddCheckup> createState() => _AddCheckupState();
}

class _AddCheckupState extends State<AddCheckup> {
  final TextEditingController hasilDiagnosaController = TextEditingController();
  final TextEditingController jumlahPemakaianController =
      TextEditingController();
  final TextEditingController waktuPemakaianController =
      TextEditingController();
  final TextEditingController imageController = TextEditingController();

  final String apiPostCheckupResult =
      "http://10.0.2.2:8000/api/checkup-obat/insert";
  final String apiGetAllObat = "http://10.0.2.2:8000/api/obat";

  List<dynamic> obatList = [];
  Map<String, dynamic>? assesmentDetail;
  File? _imageFile;
  List<Map<String, dynamic>> resepObatList = [];
  int? selectedObatId;

  @override
  void initState() {
    super.initState();
    _getAssesmentDetail();
    _getAllObat();
  }

  Future<void> _getAllObat() async {
    try {
      final response = await http.get(Uri.parse(apiGetAllObat));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data['obats'] != null) {
          setState(() {
            obatList = List<Map<String, dynamic>>.from(data['obats']);
          });
        } else {
          print("No data received from API");
        }
      } else {
        print("Failed to load Data Obat");
      }
    } catch (error) {
      print('Error : $error');
    }
  }

  Future<void> _getAssesmentDetail() async {
    try {
      final response = await http.get(
        Uri.parse(
            "http://10.0.2.2:8000/api/checkup-assesmen/show/${widget.assesmentId}"),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data['results'] != null) {
          setState(() {
            assesmentDetail = data['results'];
          });
        } else {
          print("No data received from API");
        }
      } else {
        print("Failed to load assesment detail");
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> addCheckupWithResepObat(BuildContext context) async {
    try {
      var request =
          http.MultipartRequest('POST', Uri.parse(apiPostCheckupResult));
      request.fields['hasil_diagnosa'] = hasilDiagnosaController.text;
      request.fields['assesmen_id'] = widget.assesmentId.toString();

      if (_imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            _imageFile!.path,
          ),
        );
      }

      request.fields['resep_obat'] = json.encode(resepObatList);

      var response = await request.send();
      print(request.fields['hasil']);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data berhasil ditambahkan')),
        );
        Navigator.pop(context);
      } else {
        final errorData = json.decode(await response.stream.bytesToString());
        print('Gagal menambahkan data: ${errorData['message']}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void addResepObat() {
    if (selectedObatId != null &&
        jumlahPemakaianController.text.isNotEmpty &&
        waktuPemakaianController.text.isNotEmpty) {
      setState(() {
        resepObatList.add({
          'obat_id': selectedObatId,
          'jumlah_pemakaian': jumlahPemakaianController.text,
          'waktu_pemakaian': waktuPemakaianController.text,
        });
        selectedObatId = null;
        jumlahPemakaianController.clear();
        waktuPemakaianController.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap isi semua kolom resep obat')),
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
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios)),
        backgroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.black,
        centerTitle: true,
        title: const Text(
          "Checkup",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 8),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Informasi Pasien",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                          Text("No Antrian: ${assesmentDetail?['no_antrian']}")
                        ],
                      ),
                      const SizedBox(height: 15),
                      if (assesmentDetail != null &&
                          assesmentDetail!.isNotEmpty)
                        Container(
                          height: 180,
                          width: 180,
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15)),
                              image: DecorationImage(
                                  image: NetworkImage(
                                      'http://10.0.2.2:8000/storage/' +
                                          assesmentDetail?['image']),
                                  fit: BoxFit.fill)),
                        )
                      else
                        const SizedBox(),
                      const SizedBox(height: 15),
                      setInfoPasien("NRP", "${assesmentDetail?['nrp']}"),
                      setInfoPasien(
                          "Nama", "${assesmentDetail?['nama_pasien']}"),
                      setInfoPasien(
                          "Program Studi", "${assesmentDetail?['nama_prodi']}"),
                      setInfoPasien("Gender", "${assesmentDetail?['gender']}"),
                      setInfoPasien("Tanggal Lahir",
                          "${assesmentDetail?['tanggal_lahir']}"),
                      setInfoPasien("Alamat", "${assesmentDetail?['alamat']}"),
                      setInfoPasien("No Hp", "${assesmentDetail?['nomor_hp']}"),
                      setInfoPasien(
                          "No Wali", "${assesmentDetail?['nomor_wali']}"),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8),
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
                        "Nama Dokter",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "${assesmentDetail?['nama_dokter']}",
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8),
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
                        "Hasil Checkup",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                      Container(
                        height: 100,
                        margin: const EdgeInsets.only(top: 5),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 2),
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: Color(0xFFEFF0F3)),
                        child: TextFormField(
                          maxLines: null,
                          controller: hasilDiagnosaController,
                          decoration: const InputDecoration(
                              hintText: "Deskripsi", border: InputBorder.none),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Lampiran",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                      Container(
                        height: 50,
                        margin: const EdgeInsets.only(top: 5),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 2),
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: Color(0xFFEFF0F3)),
                        child: TextFormField(
                          controller: imageController,
                          decoration: const InputDecoration(
                              hintText: "Image (Opsional)",
                              border: InputBorder.none),
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
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(top: 8),
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
                        "Tambah Resep Obat",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                                height: 50,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    color: Color(0xFFEFF0F3)),
                                child: AutocompleteTextField(
                                  decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Nama Obat"),
                                  items: obatList
                                      .map(
                                          (obat) => obat['nama_obat'] as String)
                                      .toList(),
                                  onItemSelect: (value) {
                                    final selectedObat = obatList.firstWhere(
                                        (obat) => obat['nama_obat'] == value);
                                    setState(() {
                                      selectedObatId = selectedObat['id'];
                                    });
                                  },
                                )),
                          ),
                          const SizedBox(width: 5),
                          GestureDetector(
                            onTap: addResepObat,
                            child: Container(
                              width: 45,
                              height: 50,
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  color: Color(0xFFEFF0F3)),
                              child: const Center(child: const Icon(Icons.add)),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 50,
                              margin: const EdgeInsets.only(top: 5),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  color: Color(0xFFEFF0F3)),
                              child: TextFormField(
                                textAlignVertical: TextAlignVertical.center,
                                controller: jumlahPemakaianController,
                                decoration: const InputDecoration(
                                    hintText: "Jumlah Pemakaian",
                                    hintStyle: TextStyle(fontSize: 12),
                                    border: InputBorder.none),
                              ),
                            ),
                          ),
                          const Text(
                            " X ",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w700),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 50,
                              margin: const EdgeInsets.only(top: 5),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  color: Color(0xFFEFF0F3)),
                              child: TextFormField(
                                textAlignVertical: TextAlignVertical.center,
                                controller: waktuPemakaianController,
                                decoration: const InputDecoration(
                                    hintText: "Waktu Pemakaian",
                                    hintStyle: TextStyle(fontSize: 12),
                                    border: InputBorder.none),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 50,
                          )
                        ],
                      ),
                      const SizedBox(height: 15),
                      ...resepObatList.map((resep) {
                        final obat = obatList.firstWhere(
                            (obat) => obat['id'] == resep['obat_id'],
                            orElse: () => {'nama_obat': 'Unknown'});
                        return Text(
                            '- ${obat['nama_obat']}  ${resep['jumlah_pemakaian']} x ${resep['waktu_pemakaian']} Hari');
                      }).toList(),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () => addCheckupWithResepObat(context),
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
    );
  }
}

Widget setInfoPasien(String label, String value) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        width: 120,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF62636C),
                )),
            const Text(":",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF62636C),
                ))
          ],
        ),
      ),
      const SizedBox(
        width: 5,
      ),
      Expanded(
        child: Text(value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Color(0xFF62636C),
            )),
      )
    ],
  );
}
