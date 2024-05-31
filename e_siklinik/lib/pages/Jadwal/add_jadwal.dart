import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddJadwal extends StatefulWidget {
  const AddJadwal({super.key});

  @override
  State<AddJadwal> createState() => _AddJadwalState();
}

class _AddJadwalState extends State<AddJadwal> {
  final TextEditingController dokterIdController = TextEditingController();
  String hariController = '';
  final TextEditingController jamMulaiController = TextEditingController();
  final TextEditingController jamSelesaiController = TextEditingController();
  final List<String> days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jum\'at'];
  final List<String> gender = ['Laki-Laki', 'Perempuan'];

  final String apiPostJadwalDokter =
      "http://10.0.2.2:8000/api/jadwal_dokter/create";
  final String apiGetAllDokter = "http://10.0.2.2:8000/api/dokter";
  List<dynamic> dokterList = [];

  @override
  void initState() {
    super.initState();
    _getAllDokter();
  }

  Future<void> _getAllDokter() async {
    try {
      final response = await http.get(Uri.parse(apiGetAllDokter));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data['dokter'] != null) {
          setState(() {
            dokterList = data['dokter'];
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

  Future<void> addJadwalDokter(BuildContext context) async {
    try {
      var request =
          http.MultipartRequest('POST', Uri.parse(apiPostJadwalDokter));
      request.fields['dokter_id'] = dokterIdController.text;
      request.fields['hari'] = hariController;
      request.fields['jadwal_mulai_tugas'] = jamMulaiController.text;
      request.fields['jadwal_selesai_tugas'] = jamSelesaiController.text;

      var response = await request.send();

      if (response.statusCode == 200) {
        final jadwal = json.decode(
            await response.stream.bytesToString()); // ['obat] coba ga pake ini
        print('Antrian berhasil ditambahkan: $jadwal');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Jadwal Dokter berhasil ditambahkan')),
        );
        Navigator.pop(context, true);
      } else {
        final errorData = json.decode(await response.stream.bytesToString());
        print('Gagal menambahkan jadwal dokter: ${errorData['message']}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _selectTime(
      BuildContext context, TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final now = DateTime.now();
      final selectedTime =
          DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
      final formattedTime =
          "${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}";
      setState(() {
        controller.text = formattedTime;
      });
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
          "Tambahkan Jadwal",
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
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Informasi Dokter",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                  ),
                  Container(
                    height: 50,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: Color(0xFFEFF0F3),
                    ),
                    child: DropdownButtonFormField(
                      value: null,
                      onChanged: (value) {
                        setState(() {
                          dokterIdController.text = value.toString();
                        });
                      },
                      items: dokterList.map<DropdownMenuItem>((dokter) {
                        return DropdownMenuItem(
                          value: dokter['id'],
                          child: Text(dokter['nama']),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                          hintText: "Nama Dokter", border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Hari Tugas",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                  ),
                  Container(
                    height: 50,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: Color(0xFFEFF0F3),
                    ),
                    child: DropdownButtonFormField(
                      onChanged: (value) {
                        setState(() {
                          hariController = value;
                        });
                      },
                      items: days.map<DropdownMenuItem>((day) {
                        return DropdownMenuItem(
                          value: day,
                          child: Text(day),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                          hintText: "Hari Tugas", border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Jam Tugas",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 2),
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              color: Color(0xFFEFF0F3)),
                          child: TextFormField(
                            controller: jamMulaiController,
                            readOnly: true,
                            onTap: () =>
                                _selectTime(context, jamMulaiController),
                            decoration: const InputDecoration(
                                hintText: "Jam Mulai",
                                border: InputBorder.none),
                          ),
                        ),
                      ),
                      const Text(
                        " - ",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w500),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 2),
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              color: Color(0xFFEFF0F3)),
                          child: TextFormField(
                            controller: jamSelesaiController,
                            readOnly: true,
                            onTap: () =>
                                _selectTime(context, jamSelesaiController),
                            decoration: const InputDecoration(
                                hintText: "Jam Selesai",
                                border: InputBorder.none),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () => addJadwalDokter(context),
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
              )),
            ),
          ),
        ),
      ),
    );
  }
}
