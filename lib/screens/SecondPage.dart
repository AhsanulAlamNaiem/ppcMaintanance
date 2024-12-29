import 'package:flutter/material.dart';
import 'package:ppcmaintanance/screens/Maintanance.dart';
import 'package:ppcmaintanance/screens/HomeScreen.dart';

class Production extends StatelessWidget {
  const Production({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Production"),
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
              Btn("AllMaintainance", AllMaintainance()),
              Btn("BreakdownLogs", BreakdownLogs()),
            ],
          ),
        ),
      ),
    );
  }
}

class Inventory extends StatelessWidget {
  const Inventory({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Inventory"),
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
