import 'package:flutter/material.dart';
import 'package:ppcmaintanance/screens/breakdown.dart';
import 'package:ppcmaintanance/screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LogInPage(),
    );
  }
}

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage>{
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
                      MaterialPageRoute(builder: (context) => HomeScreen()));
                } else {}
              },
              child: Text("Log In"))
        ],
      ),
    );
  }
}



class SamplePage extends StatelessWidget {
  final String title;
  const SamplePage({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back)),
        ),
        body: Center(
          child: addWidget(),
        ),
      ),
    );
  }

  Widget addWidget(){
    return Text("this is a sample page, override to add more widgets");
  }
}


