import 'package:flutter/material.dart';
import 'package:orthoscan2/knock_knee_detection/vision_detector_views/pose_detector_view.dart';
import 'package:orthoscan2/utils/exercise_type.dart';

class ExcerciseItem extends StatelessWidget {
  const ExcerciseItem({
    super.key,
    required this.imageUrl,
    required this.exerciseName,
    required this.gifUrl,
    required this.type,
  });
  final String imageUrl;
  final String exerciseName;
  final String gifUrl;
  final ExcerciseType type;
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        // print("once: $type");

        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(exerciseName),
                content: Image.asset(
                  gifUrl,
                  fit: BoxFit.contain,
                  height: deviceSize.height * 0.25,
                  width: deviceSize.height * 0.25,
                ),
                actions: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    // style: ButtonStyle(
                    //   backgroundColor: MaterialStateProperty.all(
                    //     Theme.of(context).colorScheme.onSurface,
                    //   ),
                    // ),
                    child: const Text("Close"),
                  ),
                  FilledButton(
                      onPressed: () {
                        // print("twice: $type");
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => PoseDetectorView(
                              title: exerciseName,
                              isExercise: true,
                              exerciseType: type,
                            ),
                          ),
                        );
                      },
                      child: const Text("Start Exercise")),
                ],
              );
            });
      },
      child: Container(
        // alignment: Alignment.bottomRight,
        height: deviceSize.height * 0.25,
        width: deviceSize.width * 0.80,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(17)),
          border: Border.all(
            // color: Theme.of(context).colorScheme.primary,
            color: const Color.fromARGB(255, 77, 237, 200),
            width: 2,
          ),
          image: DecorationImage(
            image: AssetImage(
              imageUrl,
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          alignment: Alignment.bottomLeft,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                // Theme.of(context).colorScheme.secondary.withOpacity(0.9),
                const Color.fromARGB(255, 50, 65, 57).withOpacity(0.85),
              ],
            ),
          ),
          child: Text(
            exerciseName,
            style: TextStyle(
              fontSize: deviceSize.width * 0.25 * 0.3,
              color: Colors.white,
              // Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
