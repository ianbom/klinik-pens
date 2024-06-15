import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProdiListScreen extends StatefulWidget {
  @override
  _ProdiListScreenState createState() => _ProdiListScreenState();
}

class _ProdiListScreenState extends State<ProdiListScreen> {
  List<dynamic> prodiList = [];
  final String apiGetAllProdi = "http://192.168.239.136:8000/api/prodi";

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Prodi'),
      ),
      body: prodiList.isEmpty
          ? Center(
              child: Text(
                'Prodi Kosong',
                style: TextStyle(fontSize: 18.0),
              ),
            )
          : ListView.builder(
              itemCount: prodiList.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    title: Text(prodiList[index]['nama']),
                    subtitle: Text(prodiList[index]['created_at'].toString()),
                  ),
                );
              },
            ),
    );
  }
}
