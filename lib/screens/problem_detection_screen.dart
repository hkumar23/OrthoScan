import 'package:flutter/material.dart';
import 'package:orthoscan2/widgets/side_drawer.dart';

//NOT USED
class ProblemDetectionScreen extends StatelessWidget {
  static const routeName = "/problem-detection";

  const ProblemDetectionScreen({super.key});
  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments as String;
    // print(args);
    return Scaffold(
      drawer: const SideDrawer(),
      appBar: AppBar(
        title: Text(args),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(15),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Card(
            child: SizedBox(
              height: 250,
              width: 250,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          if (args != "Interactive Exercises")
            const Card(
              child: SizedBox(
                height: 250,
                width: 250,
              ),
            )
        ]),
      ),
    );
  }
}
