import 'package:flutter/material.dart';
import 'package:orthoscan2/widgets/app_drawer.dart';

class HomeScreen extends StatelessWidget {
  static const routeName='/home-screen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(
            "OrthoScan",
            ),
        ),
        body: Container(
          padding:EdgeInsets.all(20),
          child: ListView(
            children: [
              Card(
                child: Column(children: [
                  ListTile(title: Text("Flat Feet"),)
                ]),
              ),
              Card(
                child: Column(children: [
                  ListTile(title: Text("Flat Feet"),)
                ]),
              )
            ],
          )
        ),
      );
  }
}