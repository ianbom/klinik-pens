import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class KategoriObatPage extends StatefulWidget {
  @override
  _KategoriObatPageState createState() => _KategoriObatPageState();
}

class _KategoriObatPageState extends State<KategoriObatPage> {
  List<dynamic> kategoriObatList = [];
  final String apiGetAllKategoriObat = "http://10.0.2.2:8000/api/kategori-obat";

  @override
  void initState() {
    super.initState();
    _getAllKategoriObat();
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
        title: Text('Daftar Prodi'),
      ),
      body: kategoriObatList.isEmpty
          ? Center(
              child: Text(
                'Ketegori Kosong',
                style: TextStyle(fontSize: 18.0),
              ),
            )
          : ListView.builder(
              itemCount: kategoriObatList.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    title: Text(kategoriObatList[index]['nama_kategori']),
                    subtitle:
                        Text(kategoriObatList[index]['created_at'].toString()),
                  ),
                );
              },
            ),
    );
  }
}
