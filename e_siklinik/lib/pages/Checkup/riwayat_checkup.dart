import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'dart:typed_data';

class RiwayatCheckup extends StatefulWidget {
  final int checkupId;
  const RiwayatCheckup({super.key, required this.checkupId});

  @override
  State<RiwayatCheckup> createState() => _RiwayatCheckupState();
}

class _RiwayatCheckupState extends State<RiwayatCheckup> {
  Map<String, dynamic>? checkupDetail;

  @override
  void initState() {
    super.initState();
    _getCheckupDetail();
  }

  Future<void> _getCheckupDetail() async {
    try {
      final response = await http.get(
        Uri.parse(
            "http://192.168.239.136:8000/api/checkup-result/show/${widget.checkupId}"),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data['results'] != null) {
          setState(() {
            checkupDetail = data['results'];
            print(checkupDetail);
          });
        } else {
          print("No data received from API");
        }
      } else {
        print("Failed to load riwayat checkup");
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void _showImage(String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            child: checkupDetail!['url_file'] != null
                ? Image.network('http://192.168.239.136:8000/storage/' +
                    checkupDetail!['url_file'])
                : Container(
                    width: double.infinity,
                    height: 200,
                    color: Colors.grey[200],
                    child: const Icon(
                      Icons.image,
                      size: 100,
                      color: Colors.grey,
                    ),
                  ));
      },
    );
  }

  Future<void> _generatePdf() async {
    final pdf = pw.Document();

    // Fetch image if exists
    pw.Widget? imageWidget;
    if (checkupDetail!['url_file'] != null) {
      final imageUrl =
          'http://192.168.239.136:8000/storage/${checkupDetail!['url_file']}';
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final Uint8List imageData = response.bodyBytes;
        final image = pw.MemoryImage(imageData);
        imageWidget = pw.Image(image);
      }
    }

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                "Riwayat Check Up",
                style:
                    pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 20),
              pw.Text("Tanggal Check Up: ${checkupDetail!['created_at']}"),
              pw.SizedBox(height: 15),
              pw.Text("Informasi Pasien:"),
              _buildPatientInfo(),
              pw.SizedBox(height: 15),
              pw.Text(
                  "Informasi Dokter: ${checkupDetail!["nama_dokter, dokter.id"]}"),
              pw.SizedBox(height: 15),
              pw.Text("Hasil Check Up:"),
              pw.Text("${checkupDetail!['hasil_diagnosa']}"),
              if (imageWidget != null) ...[
                pw.SizedBox(height: 15),
                pw.Text("Lampiran:"),
                imageWidget,
              ],
              pw.SizedBox(height: 15),
              pw.Text("Resep Obat:"),
              ..._buildResepObatPdfList(),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }

  pw.Widget _buildPatientInfo() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text("NRP: ${checkupDetail!['pasien_nrp']}"),
        pw.Text("Nama: ${checkupDetail!['nama_pasien']}"),
        pw.Text("Program Studi: ${checkupDetail!['nama']}"),
        pw.Text("Gender: ${checkupDetail!['pasien_gender']}"),
        pw.Text("Tanggal Lahir: ${checkupDetail!['tanggal_lahir_pasien']}"),
        pw.Text("Alamat: ${checkupDetail!['pasien_address']}"),
        pw.Text("No Hp: ${checkupDetail!['pasien_phone_no']}"),
        pw.Text("No Wali: ${checkupDetail!['pasien_wali_no']}"),
      ],
    );
  }

  List<pw.Widget> _buildResepObatPdfList() {
    List<pw.Widget> resepObatWidgets = [];
    if (checkupDetail != null && checkupDetail!['detail_resep_obats'] != null) {
      int index = 1;
      for (var detail in checkupDetail!['detail_resep_obats']) {
        resepObatWidgets.add(
          pw.Text(
            "$index. ${detail['nama_obat']} - ${detail['detail_jumlah_pemakaian']}x${detail['detail_waktu_pemakaian']} Hari",
          ),
        );
        index++;
      }
    }
    return resepObatWidgets;
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
          icon: const Icon(Icons.arrow_back_ios),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.black,
        centerTitle: true,
        title: const Text(
          "Riwayat Check Up",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: _generatePdf,
          ),
        ],
      ),
      body: checkupDetail != null
          ? SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Column(
                children: [
                  buildContainer(
                    title: "Tanggal Check Up",
                    content: Text(
                      "${checkupDetail!['created_at']}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF62636C),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  buildContainer(
                    title: "Informasi Pasien",
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        setInfoPasien("NRP", "${checkupDetail!['pasien_nrp']}"),
                        setInfoPasien(
                            "Nama", "${checkupDetail!['nama_pasien']}"),
                        setInfoPasien(
                            "Program Studi", "${checkupDetail!['nama']}"),
                        setInfoPasien(
                            "Gender", "${checkupDetail!['pasien_gender']}"),
                        setInfoPasien("Tanggal Lahir",
                            "${checkupDetail!['tanggal_lahir_pasien']}"),
                        setInfoPasien(
                            "Alamat", "${checkupDetail!['pasien_address']}"),
                        setInfoPasien(
                            "No Hp", "${checkupDetail!['pasien_phone_no']}"),
                        setInfoPasien(
                            "No Wali", "${checkupDetail!['pasien_wali_no']}"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  buildContainer(
                    title: "Informasi Dokter",
                    content: Text(
                      "${checkupDetail!["nama_dokter, dokter.id"]}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF62636C),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  buildContainer(
                    title: "Hasil Check Up",
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${checkupDetail!['hasil_diagnosa']}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF62636C),
                          ),
                        ),
                        const SizedBox(height: 5),
                        ElevatedButton(
                          style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Color(0xFFEFF0F3))),
                          onPressed: () {
                            _showImage(checkupDetail!['url_file']);
                          },
                          child: const Text(
                            'Lihat Lampiran',
                            style: TextStyle(color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  buildContainer(
                    title: "Resep Obat",
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: buildResepObatList(),
                    ),
                  ),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget buildContainer({required String title, required Widget content}) {
    return Container(
      padding: const EdgeInsets.all(15),
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          content,
        ],
      ),
    );
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
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF62636C),
                ),
              ),
              const Text(
                ":",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF62636C),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Color(0xFF62636C),
            ),
          ),
        ),
      ],
    );
  }

  Widget setResepObat(String id, String nama, String ket) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(id),
        const SizedBox(width: 2),
        Text(nama),
        const SizedBox(width: 5),
        Text(
          ket,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  List<Widget> buildResepObatList() {
    List<Widget> resepObatWidgets = [];
    if (checkupDetail != null && checkupDetail!['detail_resep_obats'] != null) {
      int index = 1;
      for (var detail in checkupDetail!['detail_resep_obats']) {
        resepObatWidgets.add(
          setResepObat(
            "$index.",
            detail['nama_obat'],
            "${detail['detail_jumlah_pemakaian']}x${detail['detail_waktu_pemakaian']} Hari",
          ),
        );
        index++;
      }
    }
    return resepObatWidgets;
  }
}
