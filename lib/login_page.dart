import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ppcmaintanance/screens/home_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage>{
  String email = "";
  String password = "";
  bool isLoading = false;
  final storage = FlutterSecureStorage();
  final securedKey = "Token";
  final securedUserInfo = "UserInfo";
  final securedName = "name";
  final securedDesignation = "designation";
  final securedDepartment = "dept";
  final securedCompany = 'company';

  Future<void> login() async{
    setState(() {
      isLoading = true;
    });
    final url = Uri.parse(
        "https://fast-tracker-bo3s.onrender.com/api/user_management/login/");
    //https://ppcinern.pythonanywhere.com/login
    final body = jsonEncode({
      "email": email,
      "password": password
    });

    final headers = {'Content-Type': 'application/json'};
    final response = await http.post(url, body: body, headers: headers);

    if(response.statusCode == 200){
      final data = jsonDecode(response.body);
      final token = data['token'];
      print("Response data: $token");
      final cookies = response.headers['set-cookie']!.split(";");
      final cookie = "${cookies[0]}; ${cookies[4].split(",")[1]}";


      if(token!=null) {
        final employeUrl = Uri.parse(
            "https://fast-tracker-bo3s.onrender.com/api/user_management/employee/");
        final headers = {"cookie":cookie,
          "Authorization": "Token $token"};

        print(headers);
        final response = await http.get(employeUrl, headers: headers);

        if(response.statusCode==200){
         Map employeeInfo = jsonDecode(response.body);

        await storage.write(key: securedUserInfo, value: employeeInfo.toString());
         await storage.write(key: securedKey, value: token);
         await storage.write(key: securedName, value: employeeInfo["name"]);
         await storage.write(key: securedDesignation, value: employeeInfo["designation"]);
         await storage.write(key: securedDepartment, value: employeeInfo["department"]);
         await storage.write(key: securedCompany, value: employeeInfo["company"]);


        showDialog(context: context, builder: (context)=>AlertDialog(
          title: Text("Login Successful"),
          content: Text("Welcome, ${data["name"]}"),
          actions: [
            TextButton(onPressed: (){Navigator.pop(context);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen(user: employeeInfo,)));}, child: Text("Ok"))
          ],
        )
        );
        } else {
          showError('Failed Fetching User Info\n\n ${response.body} ${response.statusCode}');
          print(response.body);
        }
      } else {
        showError('Failed to Login');
      }
    } else {
      showError("${response.body}}");
    }
    setState(() {
      isLoading = false;
    });
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
              ElevatedButton(onPressed: () async {
                final value = await storage.read(key: securedKey);
                print("$securedKey : $value");
              }, child: Text("read Secure data"))
            ],
          ),)
    );
  }
}

