import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ShowObatPage extends StatefulWidget {
  final int obatId;
  const ShowObatPage({Key? key, required this.obatId}) : super(key: key);

  @override
  State<ShowObatPage> createState() => _ShowObatPageState();
}

class _ShowObatPageState extends State<ShowObatPage> {
  Map<String, dynamic>? obatDetail;

  @override
  void initState() {
    super.initState();
    _getObatDetail();
  }

  Future<void> _getObatDetail() async {
    try {
      final response = await http.get(
        Uri.parse("http://10.0.2.2:8000/api/obat/${widget.obatId}/show"),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data['obats'] != null) {
          setState(() {
            obatDetail = data['obats'];
          });
        } else {
          print("No data received from API");
        }
      } else {
        print("Failed to load obat detail");
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Obat'),
      ),
      body: obatDetail != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      'http://10.0.2.2:8000/storage/' + obatDetail!['image'],
                    ),
                  ),
                  Text('Nama Obat: ${obatDetail!['nama_obat']}'),
                  Text(
                      'Kategori: ${obatDetail!['obat_to_kategori_obat']['nama_kategori']}'),
                  Text(
                      'Tanggal Kadaluarsa: ${obatDetail!['tanggal_kadaluarsa']}'),
                  Text('Stock: ${obatDetail!['stock']}'),
                  Text('Harga: Rp. ${obatDetail!['harga']}'),
                ],
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
