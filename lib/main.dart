import 'package:flutter/material.dart';
import 'package:ppcmaintanance/screens/FirstScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PPC ERP"),
      ),
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(
                hintText: 'Enter email', border: OutlineInputBorder()),
            onChanged: (value) {
              email = value;
            },
          ),
          TextField(
            decoration: InputDecoration(
                hintText: 'Enter Password', border: OutlineInputBorder()),
            onChanged: (value) {
              password = value;
            },
          ),
          ElevatedButton(
              onPressed: () {
                if (email == "abc@ppc.com" && password == "1234") {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => FirstScreen()));
                } else {}
              },
              child: Text("Log In"))
        ],
      ),
    );
  }
}
