import 'package:flutter/material.dart';
import 'package:ppcmaintanance/screens/production.dart';

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text(" Home ")),
        body: Center(
          child: Column(children: [
            Btn("Production", Production()),
            Btn("Maintanance", Maintanance()),
            Btn("Inventory", Inventory()),
          ]),
        ),
      ),
    );
  }
}

class Btn extends StatelessWidget {
  String title;
  Widget screen;
  Btn(this.title, this.screen);

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
