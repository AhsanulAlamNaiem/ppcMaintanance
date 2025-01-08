import 'dart:convert';
import 'package:vibration/vibration.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;

class MachineScanner extends StatefulWidget {
  const MachineScanner({super.key});

  @override
  _MachineScannerPageState createState() => _MachineScannerPageState();
}

class _MachineScannerPageState extends State<MachineScanner>{
  String? qrCodeValue;
  bool isScanning = true;

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
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Model: $model\n\n"),
                  Text("Machine Id: ${snapshot.data!['results'][0]['machine_id']}"),
                  Text("Model Number: ${snapshot.data!['results'][0]['model_number']}"),
                  Text("Serial No: ${snapshot.data!['results'][0]['serial_no']}"),
                  Text("Purchase Date: ${snapshot.data!['results'][0]['purchase_date']}"),
                  Text("Last Breakdown Start: ${snapshot.data!['results'][0]['last_breakdown_start']}"),
                  Text("Status: ${snapshot.data!['results'][0]['status']}"),
                ],
              );
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
        appBar: AppBar(
          title: Text(""),

          actions: [Row(children: [
            IconButton(onPressed: (){
            setState(() {
              isScanning = !isScanning;
            });
            // Navigator.pushNamed(context, "breakdown", arguments: qrCodeValue);

          }, icon: Icon(Icons.repeat))])],
        ),


        body:  isScanning? funcScannerBuilder():funcMachineDetailsBuilder(model: qrCodeValue??"No Model Detected"),
      );
  }

}