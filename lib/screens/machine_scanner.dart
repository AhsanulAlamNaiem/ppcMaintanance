import 'dart:convert';
import 'package:vibration/vibration.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MachineScanner extends StatefulWidget {
  const MachineScanner({super.key});

  @override
  _MachineScannerPageState createState() => _MachineScannerPageState();
}

class _MachineScannerPageState extends State<MachineScanner>{
  String? qrCodeValue;
  bool isScanning = true;
  final storage = FlutterSecureStorage();
  final securedDesignation = "designation";
  bool isScanned = false;

  Widget funcScannerBuilder() {
    return Column(
      children: [
        Expanded(
          flex: 4,
          child: MobileScanner(

            onDetect: (BarcodeCapture capture) async {
              print(isScanned);
              if(capture.raw!=null){
                setState(()  {
                  qrCodeValue = capture.barcodes[0].rawValue;
                   // Trigger a single vibration
                  Vibration.vibrate();
                  isScanning = !isScanning;
                });

                // if(!isScanned){
                //
                //   Vibration.vibrate();
                //   bool? result = await showDialog(
                //     context: context,
                //     barrierDismissible: false,
                //     builder: (BuildContext context){
                //       return AlertDialog(
                //         title: Text("Model: ${capture.barcodes[0].rawValue}"),
                //         content: Text("Machine description is here"),
                //         actions: [
                //           ElevatedButton(onPressed: (){}, child: Text("Yes")),
                //           ElevatedButton(onPressed: (){
                //             Navigator.of(context).pop(false);
                //             }, child: Text("Cancel"))
                //         ],
                //       );
                //     }
                // );
                //   print(result);
                //   result!? isScanned =  false: isScanned =false;
                //
                // };

              }
            },

          ),
        ),
        Expanded(
          flex: 1,
          child: Center(
            child: Text(
              qrCodeValue??  'Scan a QR Code',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Future<Map?> funcFetchMachineDetails(String model) async{
    final url = Uri.parse(
        "https://machine-maintenance.onrender.com/api/maintenance/machines/?machine_id=$model");

    final headers = {'Content-Type': 'application/json'};
    final response = await http.get(url);
    final designatione = await storage.read(key: securedDesignation)??"Unknown";
    if(response.statusCode==200){
      return jsonDecode(response.body);
    }
    return null;
  }

  Widget funcMachineDetailsBuilder({required String model}){
    return FutureBuilder(
      future: funcFetchMachineDetails(model),
      builder: (context, snapshot) {
          if(snapshot.connectionState==ConnectionState.waiting){
            return Center(child: Column(children: [
              Text("Model: $model"),
              CircularProgressIndicator()
            ],));
          } else if(snapshot.hasData) {
            return MachineDetailsPage(machineDetails:  snapshot.data!,);
          } else{
            return Center(
              child: Column(
                children: [
                  Text("No data Available")
                ],
              ),
            );
          }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [ElevatedButton(
        onPressed: () {
          setState(() {
            isScanning= true;
          });
        },
        child: const Text("Scan Again"),
      )],),
        body:  isScanning? funcScannerBuilder():  funcMachineDetailsBuilder(model: qrCodeValue??"No Model Detected"),
      );
  }
}


class MachineDetailsPage extends StatefulWidget {
  final Map machineDetails;
  const MachineDetailsPage({super.key, required this.machineDetails});

  @override
  _MachineDetailsPageState createState() => _MachineDetailsPageState();
}

class _MachineDetailsPageState extends State<MachineDetailsPage> {
  bool isPatching = false;

  Future<String?> getDesignation() async {
    final storage = FlutterSecureStorage();
    final securedDesignation = "designation";
    final designation = await storage.read(key: securedDesignation);

    return designation;
  }


  @override
  Widget build(BuildContext context) {
    final machine = widget.machineDetails['results'][0];
    final statuses = ['active', 'inactive', 'maintenance', 'broken'];
    final designations = ['Mechanic', 'Supervisor', 'Operator', 'Admin Officer'];
    String lastProblem = "";

    return FutureBuilder(
      future: getDesignation(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          final designation = snapshot.data ?? "Unknown";
          final machineStatus = machine['status'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Machine ID: ${machine['machine_id']}"),
                Text("Model Number: ${machine['model_number']}"),
                Text("Serial No: ${machine['serial_no']}"),
                Text("Purchase Date: ${machine['purchase_date']}"),
                Text("Last Breakdown Start: ${machine['last_breakdown_start']}"),
                Text("Status: $machineStatus"),
                Spacer(),
                // SizedBox(height: 50),
                // Display based on conditions
                if(designation == 'Supervisor' && machineStatus == 'active') ...[ //stage active to broken  && machineStatus == 'active'
                  Text("Your Role: $designation"),
                  const Text("Is the machine broken?"),
                  SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                        hintText: '',
                        border: OutlineInputBorder(),
                        labelText: "Explain the problem:"
                    ),
                    onChanged: (value) {lastProblem = value;},
                  ),
                  SizedBox(height: 16),
                  isPatching? CircularProgressIndicator():ElevatedButton(

                    onPressed: () {
                      final currentTIme = DateTime.now().toUtc().toString().split('.').first;
                      Map body = {"status": "broken",
                      "last_breakdown_start":  currentTIme.split(" ")[0] + "T" + currentTIme.split(" ")[1] + "Z",
                        "last_problem":lastProblem
                      };

                      print(body);
                      updateMachineStatus(machineId:  machine['id'].toString(), body:  body);},
                    child: const Text("Set to Broken"),
                  ),
                ]
                else if (designation == 'Supervisor' && machineStatus == 'maintenance') ...[//&& machineStatus == 'maintenance'
                  Text("Your Role: $designation"),
                  const Text("Is the machine active now?"),
                  const SizedBox(height: 16.0),
                  isPatching? CircularProgressIndicator():ElevatedButton(
                    onPressed: () {
                      DateTime startTime = DateTime.parse("${machine['last_breakdown_start']}");
                      DateTime endTime = DateTime.parse(DateTime.now().toUtc().toString().split('.').first + 'Z');
                      String formattedDuration = endTime.difference(startTime).toString().split('.').first;

                      Map body = {"status": "active",
                      };

                      final breakdownBody = {
                        "breakdown_start": "$startTime",
                        "repairing_start": "${machine['last_repairing_start']??"2025-01-09T11:50:00Z"}",
                        "lost_time": formattedDuration,
                        "comments": "",
                        "machine": "${machine['id']}",
                        "mechanic": "",
                        "operator": "",
                        "problem_category": "1",
                        "location": "1"
                      };
                      print(breakdownBody);
                      updateMachineStatus(machineId:  machine['id'].toString(), body:  body, willUpdateBreakdown: true, breakdownBody: breakdownBody);

                      },
                    child: const Text("Set to Active"),
                  ),


                ]
                else if (designation == 'Mechanic' && machineStatus == 'broken') ...[//stage broken to maintenance
                  Text("Your Role: $designation"),
                  const Text("Do you want to set the machine status to Maintenance?"),
                  const SizedBox(height: 16.0),
                  isPatching? CircularProgressIndicator():ElevatedButton(
                    onPressed: (){
                      final currentTIme = DateTime.now().toUtc().toString().split('.').first;
                      Map body = {"status": "maintenance",
                      "last_repairing_start": currentTIme.split(" ")[0] + "T" + currentTIme.split(" ")[1] + "Z"
                      };
                      updateMachineStatus(machineId:  machine['id'].toString(), body: body);},
        child: const Text("Set to Maintenance"),
        ),

        ] else if (designation == 'Admin Officer') ...[
        Text("Your Role: $designation"),
        const Text("Change machine status to:"),
        const SizedBox(height: 16.0),
        DropdownButton<String>(
        value: machineStatus,
        items: statuses.map((status) {
        return DropdownMenuItem(
        value: status,
        child: Text(status),
        );
        }
        ).toList(),
                    onChanged: (newStatus) {
                      if (newStatus != null) {
                        updateMachineStatus( machineId:  machine['id'], body: {});
                      }
                    },
                  ),
                ],
              ],
            ),
          );
        }
      },
    );
  }

// Function to update the machine status
  Future<void> updateMachineStatus({required String machineId, required Map body, Map breakdownBody= const {}, bool willUpdateBreakdown = false}) async {
    final url = "https://machine-maintenance.onrender.com/api/maintenance/machines/$machineId/";
    final breakDownUrl = "https://machine-maintenance.onrender.com/api/maintenance/breakdown-logs/";

    setState(() {
      isPatching = true;
    });

    try {
      final response = await http.patch(
        Uri.parse(url),
        body: body,
      );
      print(response.body);
      print("Status updated to $body");

      if(willUpdateBreakdown){
        final patchResponse = await http.post(Uri.parse(breakDownUrl),body:breakdownBody);
        print(breakdownBody);
        print("Breakdown updated ${patchResponse.body}");

      } else {
        print("will not Update breaddwonLodg");
      }

    } catch (e) {
      print("Error: $e");
    } finally {
      setState(() {
        isPatching = false;
      });
    }



  }


}//stagefull widget
