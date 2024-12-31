import 'package:flutter/material.dart';
import 'package:ppcmaintanance/screens/inventory.dart';
import 'package:ppcmaintanance/screens/production.dart';

import 'maintainance.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text(" Home ")),
        body: Center(
          child: Column(children: [
            Btn("Production", ProductionPage()),
            Btn("Maintanance", Maintanance()),
            Btn("Inventory", InventoryPage()),
          ]),
        ),
      ),
    );
  }
}

class Btn extends StatelessWidget {
  final String title;
  final Widget screen;
  const Btn(this.title, this.screen, {super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => screen));
        },
        child: Text(title));
  }
}
