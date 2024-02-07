import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  int count = 0;
  List<dynamic> readings = [];

  @override
  void initState() {
    super.initState();
    fetchReadings();
  }

  Future<void> fetchReadings() async {
    final response = await http.get(Uri.parse('https://mluh3lswob5p22qqwg4v5cmrbe0cfvky.lambda-url.us-east-2.on.aws/'));

    if (response.statusCode == 200) {
      setState(() {
        readings = json.decode(response.body);
      });
    } else {
      // Si la llamada no fue exitosa, lanza un error.
      throw Exception('Failed to load readings');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: readings.length,
      itemBuilder: (context, index) {
        var reading = readings[index];
        return ListTile(
          title: Text('Temperature: ${reading['temperature']} ${reading['UnitTemperature']}'),
          subtitle: Text('Humidity: ${reading['humidity']} ${reading['UnitHumidity']} - ${reading['Notes']}'),
        );
      },
    );
  }
}