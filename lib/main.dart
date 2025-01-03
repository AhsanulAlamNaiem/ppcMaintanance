import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ppcmaintanance/screens/home_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


import 'package:ppcmaintanance/login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget{
  const SplashScreen({super.key});

  @override
  _SPlashScreenState createState() {
    return _SPlashScreenState();
  }
}

class _SPlashScreenState extends State<SplashScreen>{
  final storage = FlutterSecureStorage();
  final securedKey = "credential";

  Future<bool> logincontrol() async {
    final  credentials = await storage.read(key: securedKey);
    if (credentials!=null){ return true;} else { return false;}
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(future: logincontrol(),
          builder: (context, snapshot) {
            final status = snapshot.data?? false;
            Future((){
              if(status){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
              } else {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>LogInPage()));
              }
            });


            return Text("");
          },
        ));
  }
}

