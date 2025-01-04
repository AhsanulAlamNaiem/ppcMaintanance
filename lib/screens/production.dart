import 'package:flutter/material.dart';


class ProductionPage extends StatefulWidget {
  const ProductionPage({super.key});

  @override
  _ProductionPageState createState() => _ProductionPageState();
}

class _ProductionPageState extends State<ProductionPage>{
  @override
  Widget build(BuildContext context) {
    return       Scaffold(
        appBar: AppBar(
          title: Text("Production"),

          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back)),
        ),
          body: Column(
            children: [
              Expanded(
                flex: 1,
                child: Center(
                  child: Text('Production Page',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
      );
  }

}
