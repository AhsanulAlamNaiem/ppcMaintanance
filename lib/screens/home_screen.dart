
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ppcmaintanance/login_page.dart';
import 'package:ppcmaintanance/screens/inventory.dart';
import 'package:ppcmaintanance/screens/production.dart';
import 'machine_scanner.dart';
import 'maintainance.dart';

class HomeScreen extends StatefulWidget{
  Map user;
  HomeScreen({super.key, required this.user});

  @override
  _HomeScreenState createState() {
    return _HomeScreenState(user);
  }
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex=1;
  final Map user;
  _HomeScreenState(this.user);
  final storage = FlutterSecureStorage();
  final securedKey = "Token";

  Future<Map> falsefetchUser() async{
    return Future.delayed(Duration(seconds: 5),(){
      return {"user":"falseUser"};
    });

  }

  @override
  Widget build(BuildContext context) {
    // return Text("$user");
    return homeScreenBuilder(user);
  }


  Widget homeScreenBuilder(Map user){


    Widget funcHomeBuilder(){
      return Center(
        child: Column(children: [
          Btn("Production", ProductionPage()),
          Btn("Maintenance", Maintanance()),
          Btn("Inventory", InventoryPage()),
          ElevatedButton(onPressed: () async {
            final value = await storage.read(key: securedKey);
            print("$securedKey : $value");
          }, child: Text("read Secure data"))
        ]),
      );
    }


    final List<Widget> pages = [
      funcHomeBuilder(),
      funcHomeBuilder(),
      MachineScanner()
    ];


    return
     WillPopScope(
         onWillPop: () async {
          final shouldAllowPop = _currentIndex==1?true:false;
          setState(() {
            _currentIndex =1;
          });
          return shouldAllowPop;// Block back navigation
    },
    child: Scaffold(
      appBar: AppBar(
        leading: null,
        // leading: Text("what?"),
        title: Text(" Home "),
      ),
      bottomNavigationBar: BottomNavigationBar(
      currentIndex: _currentIndex,
        selectedItemColor: Colors.green,
        onTap: (index){
          setState(() {
            _currentIndex= index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.document_scanner), label: "Machine"),
        ],

      ),
      body:pages[_currentIndex],
      endDrawer: Drawer(
        child: SizedBox(
            width: 100,
            child: Column(

              children: [
                UserAccountsDrawerHeader(
                  accountName: Text("${user["name"]}"),
                  accountEmail: Text("${user["designation"]} - ${user["department"]}"),

                  currentAccountPicture: CircleAvatar(
                    backgroundImage: AssetImage("assets/images/user.png"),
                  ),
                  decoration: BoxDecoration(
                      color: Colors.green
                  ),
                ),

                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      // Handle sign out action
                      await storage.delete(key: securedKey);
                      Navigator.pop(context);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LogInPage()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout),
                        SizedBox(width: 8),
                        Text('Sign Out'),
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ),
    ));
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
