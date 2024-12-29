import 'package:flutter/material.dart';
import 'package:ppcmaintanance/screens/FirstScreen.dart';

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
        body: Center(
          child: ElevatedButton(onPressed: () {}, child: Text("")),
        ),
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
