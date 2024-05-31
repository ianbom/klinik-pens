import 'dart:convert';
import 'package:e_siklinik/testing/antrian/addAssesment.dart';
import 'package:e_siklinik/testing/antrian/assesmentList.dart';
import 'package:e_siklinik/testing/antrian/assesmentShow.dart';
import 'package:e_siklinik/testing/checkup/showCheckup.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CheckupListPage extends StatefulWidget {
  const CheckupListPage({Key? key}) : super(key: key);

  @override
  _CheckupListPageState createState() => _CheckupListPageState();
}

class _CheckupListPageState extends State<CheckupListPage> {
  List<dynamic> checkupList = [];
  final String apiGetCheckup = "http://10.0.2.2:8000/api/checkup-result";

  @override
  void initState() {
    super.initState();
    _getAllCheckup();
  }

  Future<void> _getAllCheckup() async {
    try {
      final response = await http.get(Uri.parse(apiGetCheckup));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data['checkup'] != null) {
          setState(() {
            checkupList = data['checkup'];
          });
          print(checkupList);
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
          title: Text('Daftar Checkup'),
        ),
        body: checkupList.isEmpty
            ? Center(
                child: Text(
                  'Checkup Kosong',
                  style: TextStyle(fontSize: 18.0),
                ),
              )
            : ListView.builder(
                itemCount: checkupList.length,
                itemBuilder: (BuildContext context, int index) {
                  final checkup = checkupList[index];
                  final checkupId = checkup['id'];
                  return Card(
                    child: ListTile(
                      title: Text(checkup['hasil_diagnosa'].toString()),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(checkup['check_up_resul_to_assesmen']
                                  ['assesmen_to_antrian']['antrian_to_pasien']
                              ['nama']),
                          Text(checkup['check_up_resul_to_assesmen']
                                  ['assesmen_to_antrian']['antrian_to_pasien']
                              ['pasien_to_prodi']['nama']),
                          Text(checkup['check_up_resul_to_assesmen']
                              ['assesmen_to_dokter']['nama']),
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ShowCheckupDetail(checkupId: checkupId),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      trailing: SizedBox(
                        width: 100,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount:
                              checkup['check_up_result_to_detail_resep'].length,
                          itemBuilder: (BuildContext context, int resepIndex) {
                            final resep =
                                checkup['check_up_result_to_detail_resep']
                                    [resepIndex];
                            return Text(
                                resep['detail_resep_to_obat']['nama_obat']);
                          },
                        ),
                      ),
                    ),
                  );
                },
              ));
  }
}
