import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BreakdownPage extends StatefulWidget {
  const BreakdownPage({super.key});

  @override
  State<BreakdownPage> createState() => _BreakdownPageState();
}

class _BreakdownPageState extends State<BreakdownPage> {
  List BreakdownList = [
    // {"value": "Default task", "isDone": false}
  ];
  String singlevalue = "";
  TextEditingController taskController = TextEditingController();

  addString(content) {
    setState(() {
      singlevalue = content;
    });
  }

  addList() {
    setState(() {
      if (singlevalue != "") {
        BreakdownList.add(singlevalue);
        taskController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Task should not be empty."),
            duration: Duration(seconds: 1)));
      }
    });
  }

  deleteItem(index) {
    setState(() {
      BreakdownList.removeAt(index);
    });
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Breakdown Logs",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        centerTitle: true,
        toolbarHeight: 75,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {Navigator.pop(context);},
        ),
        elevation: 0,
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              flex: 90,
              child: logsList(),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () async {
        final qrcodevalue =  await Navigator.push(context, MaterialPageRoute(builder: (context) => ScannerPage()));

        singlevalue = qrcodevalue??"";
        addList();

        }, child: Icon(Icons.add)),
    );
  }

  Widget logsList(){
    if(BreakdownList.isEmpty) {
      return Center(child: Column( mainAxisAlignment: MainAxisAlignment.center , children: [Text("No breakdown logs found.\nPress + to add Break down", style: TextStyle(color:Colors.grey),)],));
    } else {
      return ListView.builder(
          itemCount: BreakdownList.length,

          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () async{
                String status = await Navigator.push(context, MaterialPageRoute(builder: (context) => BreakdownDetails(logitem:BreakdownList[index].toString())));
                if (status!=""){
                  deleteItem(index);
                }
              },
                child: Card(

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              color: Colors.white,
              child: SizedBox(
                height: 50,
                width: double.infinity,
                child: Container(
                  margin: EdgeInsets.only(left: 10),
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(5),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 60,
                        child: Text(
                          "$index) " +
                              BreakdownList[index],
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // Expanded(
                      //   flex: 20,
                      //   child: TextButton(
                      //       onPressed: () {
                      //         deleteItem(index);
                      //       },
                      //       child: Text(
                      //         "X",
                      //         style: TextStyle(color: Colors.grey),
                      //       )),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
            );
          });
    }
  }
}




class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  _ScannerPageState createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage>{
  String? qrCodeValue;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(""),

          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back)),
          actions: [IconButton(onPressed: (){
            Navigator.pop(context,qrCodeValue);
            // Navigator.pushNamed(context, "breakdown", arguments: qrCodeValue);

          }, icon: Icon(Icons.add_circle))],
        ),


        body: Column(
          children: [
            Expanded(
              flex: 4,
              child: MobileScanner(
                onDetect: (BarcodeCapture capture){
                  if(capture.raw!=null){
                    setState(() {
                      qrCodeValue = capture.barcodes[0].rawValue;
                    });
                  }
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  qrCodeValue ?? 'Scan a QR Code',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}


class BreakdownDetails extends StatelessWidget {
  final String title = "Breakdown Log";
  final String logitem;
  const BreakdownDetails({required this.logitem, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context,"");
              },
              icon: Icon(Icons.arrow_back)),
        ),
        body: Center(
          child: addWidget(context),
        ),
      ),
    );
  }

  Widget addWidget(BuildContext context){
    return Column(children: [
      Text(logitem),
      ElevatedButton(onPressed: (){Navigator.pop(context,"solved");}, child: Text("Solved"))
    ],);
  }
}
