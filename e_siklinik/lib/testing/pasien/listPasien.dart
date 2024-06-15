import 'package:e_siklinik/testing/pasien/editPasien.dart';
import 'package:e_siklinik/testing/pasien/showPasien.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListPasienPage extends StatefulWidget {
  const ListPasienPage({Key? key}) : super(key: key);

  @override
  State<ListPasienPage> createState() => _ListPasienPageState();
}

class _ListPasienPageState extends State<ListPasienPage> {
  final String apiGetAllPasien = "http://192.168.239.136:8000/api/pasien";
  List<dynamic> pasienList = [];

  @override
  void initState() {
    super.initState();
    _getAllPasien();
  }

  Future<void> _getAllPasien() async {
    try {
      final response = await http.get(Uri.parse(apiGetAllPasien));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data['pasien'] != null) {
          setState(() {
            pasienList = data['pasien'];
          });
        } else {
          print("No data received from API");
        }
      } else {
        print("Failed to load pasien");
      }
    } catch (error) {
      print('Error : $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Pasien'),
      ),
      body: pasienList.isEmpty
          ? Center(
              child: Text(
                'Tidak ada data pasien',
                style: TextStyle(fontSize: 18.0),
              ),
            )
          : ListView.builder(
              itemCount: pasienList.length,
              itemBuilder: (BuildContext context, int index) {
                final pasien = pasienList[index];
                final pasienId = pasien['id'];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ShowPasienDetail(pasienId: pasienId),
                      ),
                    );
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        'http://192.168.239.136:8000/storage/' +
                            pasien['image'],
                      ),
                    ),
                    title: Text(pasien['nama'] ?? ''),
                    subtitle: Text(pasien['nrp'] ?? ''),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        pasien['pasien_to_prodi'] != null
                            ? Text(pasien['pasien_to_prodi']['nama'] ?? '')
                            : Text("G ada prodi"),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditPasienPage(pasien: pasien),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
