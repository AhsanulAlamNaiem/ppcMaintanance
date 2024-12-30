import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ppcmaintanance/screens/HomeScreen.dart';
import 'package:http/http.dart' as http;

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Second Screen"),
          leading: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back)),
        ),
        body: Center(
          child: Column(
            children: [
              Btn("AllMaintainance", AllMaintainance()),
              Btn("BreakdownLogs", BreakdownLogs()),
            ],
          ),
        ),
      ),
    );
  }
}

class AllMaintainance extends StatelessWidget {
  const AllMaintainance({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("AllMaintainance"),
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.refresh))],
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back)),
        ),
        body: FutureBuilder<List>(
            future: fetchMachines(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Erros: ${snapshot.error}"));
              } else if (snapshot.hasData) {
                List machines = snapshot.data!;
                return lst(10, machines: machines);
              }
              return Center(child: Text('No data available'));
            }),
      ),
    );
  }
}

class BreakdownLogs extends StatelessWidget {
  const BreakdownLogs({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("BreakdownLogs"),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back)),
        ),
        body: Center(
          child: ElevatedButton(onPressed: () {}, child: Text("")),
        ),
      ),
    );
  }
}

Widget lst(int child, {required List machines}) {
  return ListView.builder(
      itemCount: machines.length,
      itemBuilder: (context, index) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          color: Colors.white,
          child: SizedBox(
            height: 50,
            width: double.infinity,
            child: Container(
              margin: EdgeInsets.only(left: 10),
              alignment: Alignment.center,
              padding: EdgeInsets.all(5),
              child: Column(
                children: [
                  Text(
                    "${machines[index]['machine_id']}",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${machines[index]['status']}",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
}

Future<List> fetchMachines() async {
  final url = Uri.parse(
      "https://fast-tracker-bo3s.onrender.com/api/maintenance/machines/?format=json");

  final response = await http.get(url);
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    return [];
  }
}

class Machine {
  String category;
  String type;
  String brand;
  String model_number;
  String serial_no;
  int floor_no;
  int line_no;
  String supplier;
  String purchase_date;
  String location;
  String last_breakdown_start;
  String status;

  Machine(
      this.category,
      this.type,
      this.brand,
      this.model_number,
      this.serial_no,
      this.floor_no,
      this.line_no,
      this.supplier,
      this.purchase_date,
      this.location,
      this.last_breakdown_start,
      this.status);
}
