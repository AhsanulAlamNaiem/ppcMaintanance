import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BreakdownPage extends StatefulWidget {
  const BreakdownPage({super.key});

  @override
  State<BreakdownPage> createState() => _BreakdownPageState();
}

class _BreakdownPageState extends State<BreakdownPage> {
  late Future<List<dynamic>> futureMachines;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Breakdown Logs"),
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


  Future<List> fetchMachines() async {
    final url = Uri.parse(
        "https://machine-maintenance.onrender.com/api/maintenance/breakdown-logs/");

    final response = await http.get(url);
    if (response.statusCode == 200) {
      print(response.body);
      final data = jsonDecode(response.body);
      print(data);
      return data;
    } else {
      throw  Exception("failed to load machine. Makesure you phone have stable internet connection");
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      futureMachines = fetchMachines(); // Refresh the data by calling the API again
    });
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
              height: 70,
              width: double.infinity,
              child: Container(
                margin: EdgeInsets.only(left: 10),
                alignment: Alignment.center,
                padding: EdgeInsets.all(5),
                child: Column(
                  children: [
                    Text(
                      "Id: ${machines[index]['id']}",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Breakdown Start: ${machines[index]['breakdown_start']}",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      "lost time: ${machines[index]['lost_time']}",
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



  }
