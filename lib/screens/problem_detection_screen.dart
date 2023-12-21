import 'package:flutter/material.dart';
import 'package:orthoscan2/widgets/side_drawer.dart';

class ProblemDetectionScreen extends StatelessWidget {
  static const routeName = "/problem-detection";
  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments as String;
    // print(args);
    return Scaffold(
      drawer: SideDrawer(),
      appBar: AppBar(
        title: Text(args),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            Card(
              child: Container(
                height: 250,
                width: 250,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            if(args != "Interactive Exercises")
            Card(
              child: Container(
                height: 250,
                width: 250,
              ),
            )
          ]
        ),
      ),
    );
  }
}