import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CategoryChartPage extends StatefulWidget {
  @override
  _CategoryChartPageState createState() => _CategoryChartPageState();
}

class _CategoryChartPageState extends State<CategoryChartPage> {
  List<Antrian> _antrianList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAntrianData();
  }

  Future<void> _fetchAntrianData() async {
    final response = await http
        .get(Uri.parse('http://192.168.239.136:8000/api/antrianCount'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['antrian'];
      setState(() {
        _antrianList = data.map((json) => Antrian.fromJson(json)).toList();
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load antrian data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(
                  axisLabelFormatter: (AxisLabelRenderDetails details) {
                    final date = DateTime.parse(details.text);
                    final formattedDate = DateFormat('MMM d').format(date);
                    return ChartAxisLabel(formattedDate, details.textStyle);
                  },
                ),
                primaryYAxis: NumericAxis(
                  interval: 1, // Ensure only integers are shown
                  axisLabelFormatter: (AxisLabelRenderDetails details) {
                    final intValue = int.parse(details.text.split('.')[0]);
                    return ChartAxisLabel('$intValue', details.textStyle);
                  },
                ),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <CartesianSeries>[
                  LineSeries<Antrian, String>(
                    dataSource: _antrianList,
                    xValueMapper: (Antrian data, _) => data.tanggal,
                    yValueMapper: (Antrian data, _) => data.jumlahAntrian,
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                    enableTooltip: true,
                  ),
                ],
                zoomPanBehavior: ZoomPanBehavior(
                  enablePinching: true,
                  zoomMode: ZoomMode.x,
                  enableDoubleTapZooming: true,
                ),
              ),
            ),
    );
  }
}

class Antrian {
  final String tanggal;
  final int jumlahAntrian;

  Antrian({required this.tanggal, required this.jumlahAntrian});

  factory Antrian.fromJson(Map<String, dynamic> json) {
    return Antrian(
      tanggal: json['tanggal'],
      jumlahAntrian: json['jumlah_antrian'],
    );
  }
}
