import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ppcmaintanance/screens/inventory.dart';
import 'package:ppcmaintanance/screens/production.dart';

import '../login_page.dart';
import 'maintainance.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final storage = FlutterSecureStorage();
  final securedKey = "credential";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(" Home "),
          actions: [TextButton(onPressed: () async {
            await storage.delete(key: securedKey);

            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context)=> LogInPage()));
            }, child: Text("Log out"))],),
        body: Center(
          child: Column(children: [
            Btn("Production", ProductionPage()),
            Btn("Maintanance", Maintanance()),
            Btn("Inventory", InventoryPage()),
            ElevatedButton(onPressed: () async {
              final value = await storage.read(key: securedKey);
              print("$securedKey : $value");
            }, child: Text("read Secure data"))
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
