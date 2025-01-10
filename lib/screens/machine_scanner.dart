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

  Widget funcScannerBuilder() {
    return Column(
      children: [
        Expanded(
          flex: 4,
          child: MobileScanner(
            onDetect: (BarcodeCapture capture) {
              if(capture.raw!=null){
                Vibration.vibrate();
                setState(()  {
                  qrCodeValue = capture.barcodes[0].rawValue;
                   // Trigger a single vibration
                  isScanning = !isScanning;
                });

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
            return MachineDetailsPage(machineDetails:  snapshot.data!);
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
        body:  isScanning? funcScannerBuilder():funcMachineDetailsBuilder(model: qrCodeValue??"No Model Detected"),
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

    return
      FutureBuilder(future: getDesignation(), builder: (context, snapshot){
        if(snapshot.connectionState==ConnectionState.waiting){
          return CircularProgressIndicator();
        }
        else {
          final desigNation = snapshot.data??"Unknown";
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
          Text("Status: ${machine['status']}"),
          const Spacer(),
          Text("Your Rule is: $desigNation"),
          const Text("Do you want to change the machine status to Broken?"),
          const SizedBox(height: 16.0),
          isPatching
              ? const Center(child: CircularProgressIndicator())
              : ElevatedButton(
            onPressed: () async {
              setState(() {
                isPatching = true;
              });

              final url =
                  "https://machine-maintenance.onrender.com/api/maintenance/machines/${machine['id']}/";
              final body = {"status": "Broken"};

              try {
                await http.patch(
                  Uri.parse(url),
                  body: body,
                );
              } catch (e) {
                // Handle error
                print("Error: $e");
              }

              setState(() {
                isPatching = false;
              });
            },
            child: const Text("Yes"),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              // Implement the scan again functionality
            },
            child: const Text("Scan Again"),
          ),
        ],
      ),
    );}
      });
  }
}
