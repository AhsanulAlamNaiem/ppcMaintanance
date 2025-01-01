import 'package:flutter/material.dart';
import 'package:ppcmaintanance/screens/home_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:ppcmaintanance/signup.dart';

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
  bool isLoading = false;

  Future<void> login() async{
    setState(() {
      isLoading = true;
    });
    final url = Uri.parse(
        "https://ppcinern.pythonanywhere.com/login");
    final body = jsonEncode({
      "username": email,
      "password": password
    });

    final headers = {'Content-Type': 'application/json'};
    final response = await http.post(url, body: body, headers: headers);

    setState(() {
      isLoading = false;
    });

    if(response.statusCode == 200){
      final data = jsonDecode(response.body);
      if(data['success']) {
        showDialog(context: context, builder: (context)=>AlertDialog(
          title: Text("Login Successful"),
          content: Text("Welcome, ${data["name"]}"),
          actions: [
            TextButton(onPressed: (){Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));}, child: Text("Ok"))
          ],
        )
        );
      } else {
        showError('Invalid credential.');
      }
      } else {
      showError("${response.body}}");
    }
  }

  void showError(String message){
    showDialog(context: context, builder: (contex) => AlertDialog(
      title: Text('Error'),
      content: Text(message),
      actions: [
        TextButton(onPressed: ()=>Navigator.pop(context), child: Text("Ok"))
      ],

    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PPC ERP"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:  Column(
        children: [
          TextField(
            decoration: InputDecoration(
                hintText: '',
                border: OutlineInputBorder(),
                labelText: "Username:"
            ),
            onChanged: (value) {email = value;},
          ),
          SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(
                hintText: '',
                border: OutlineInputBorder(),
                labelText: "Password"
            ),
            onChanged: (value) {password = value;},
          ),
          SizedBox(height: 20),
          isLoading? CircularProgressIndicator() : ElevatedButton(onPressed: (){
            login();
          }, child: Text("Login")),
          TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>SignupPage())),
              child: Text("Don\'t have an account? Sign Up"))
        ],
      ),)
    );
  }
}

