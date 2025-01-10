import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ppcmaintanance/screens/home_screen.dart';
import 'package:http/http.dart' as http;

import 'breakdown.dart';

class Maintanance extends StatelessWidget {
  const Maintanance({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Maintanance"),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back)),
        ),
        body: Center(
          child: Column(
            children: [
              Btn("All Machines", AllMaintainances()),
              Btn("BreakdownLogs", BreakdownPage()),
            ],
          ),
        ),
      ),
    );
  }
}


class AllMaintainances extends StatefulWidget {
  const AllMaintainances({super.key});

  @override
  _MachineListScreenState createState() => _MachineListScreenState();
}

class BreakdownLogs extends StatelessWidget {
  const BreakdownLogs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      );
  }
}



class _MachineListScreenState extends State<AllMaintainances> {
  late Future<List<dynamic>> futureMachines;

  @override
  void initState() {
    super.initState();
    futureMachines = fetchMachines(); // Initial fetch
  }

  // Method to refresh data
  Future<void> _refreshData() async {
    setState(() {
      futureMachines = fetchMachines(); // Refresh the data by calling the API again
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("All Machines"),
          actions: [IconButton(onPressed: _refreshData, icon: Icon(Icons.refresh))],
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
                return Center(child: Text("Something went wrong, Make sure this device have internet connection. \n\n\nError: \n\n${snapshot.error}"));
              } else if (snapshot.hasData) {
                List machines = snapshot.data!;
                return RefreshIndicator(onRefresh:_refreshData ,child: funListViewBuilder(machines: machines));
              }
              return Center(child: Text('No data available'));
            }),
      );//Scaffold


    }
  }

Future<List> fetchMachines() async {
  final url = Uri.parse(
      "https://machine-maintenance.onrender.com/api/maintenance/machines/");

  final response = await http.get(url);
  if (response.statusCode == 200) {
    print(response.body);
    final data = jsonDecode(response.body)["results"];
    print(data);
    return data;
  } else {
    throw  Exception("failed to load machine. Makesure you phone have stable internet connection");
  }
}

Widget funListViewBuilder({required List machines}) {
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

