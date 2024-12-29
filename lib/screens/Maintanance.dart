import 'package:flutter/material.dart';
import 'package:ppcmaintanance/screens/HomeScreen.dart';

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
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back)),
        ),
        body: lst(10, machinelist: []),
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

Widget lst(int child, {required List<dynamic> machinelist}) {
  return ListView.builder(
      itemCount: 20,
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
                    "Machine $index",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "This is the description of machine $index",
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
