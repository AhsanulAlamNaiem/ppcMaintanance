import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ppcmaintanance/screens/home_screen.dart';
import 'package:ppcmaintanance/login_page.dart';
import 'dart:convert';

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
  final securedKey = "Token";
  final securedUserInfo = "UserInfo";
  final securedName = "name";
  final securedDesignation = "designation";
  final securedDepartment = "dept";
  final securedCompany = 'company';

  Future<Map?> loginControl() async {
    // final name =  "John Doe";
    // final designation = "admin";
    // final department = "Engineering";
    // final company = "Acme Corporation";

    // await storage.write(key: securedKey, value: "252534563456");
    // await storage.write(key: securedName, value: name);
    // await storage.write(key: securedDesignation, value: designation);
    // await storage.write(key: securedDepartment, value: department);
    // await storage.write(key: securedCompany, value: company);

    final token = await storage.read(key: securedKey);
    final namee = await storage.read(key: securedName)??"null";
    final designatione = await storage.read(key: securedDesignation)??"null";
    final departmente = await storage.read(key: securedDepartment)??"null";
    final companye = await storage.read(key: securedCompany)??"null";

    final userInfo = {
      "name": namee,
      "designation": designatione,
      "department": departmente,
      "company": companye
    };
    if(token!=null){
      return userInfo;
    }
    return null;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Welcome to PPC ERP"),),
        body: FutureBuilder(
          future: loginControl(),
          builder: (context, snapshot) {
            Future((){
                  if(snapshot.hasData) {
                    Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) => HomeScreen(user: snapshot.data!,)));
                  } else{
                    Navigator.pushReplacement (context, MaterialPageRoute(builder: (context)=>LogInPage()));
                  }
            });
            return Text("Nothing to do");
          },
        ));
  }
}

