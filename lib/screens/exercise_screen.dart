import 'package:flutter/material.dart';
import 'package:orthoscan2/utils/exercise_type.dart';
import 'package:orthoscan2/widgets/exercise_item.dart';

class ExerciseScreen extends StatelessWidget {
  const ExerciseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Interactive Exercises"),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: const SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ExcerciseItem(
                  imageUrl: "assets/images/02_Jumping_jack_image.jpg",
                  exerciseName: "Jumping Jacks",
                  gifUrl: "assets/gifs/Jumping_jacks_animation.gif",
                  type: ExcerciseType.jumpingJacks,
                ),
                SizedBox(height: 20),
                ExcerciseItem(
                  imageUrl:
                      "assets/images/hip_Abductor_Strengthening_image.png",
                  exerciseName: "Hip Abductor Strengthening",
                  gifUrl:
                      "assets/gifs/hip_Abductor_Strengthening_animation.gif",
                  type: ExcerciseType.hipAbductorStrengthening,
                ),
                SizedBox(height: 20),
                ExcerciseItem(
                  imageUrl: "assets/images/Barbell_underhand_image.jpg",
                  exerciseName: "Barbell Underhand",
                  gifUrl: "assets/gifs/02_Barbell__underhand_animation.gif",
                  type: ExcerciseType.barbellUnderhand,
                ),
                SizedBox(height: 20),
                // ExcerciseItem(
                //   imageUrl: "assets/images/Jumping_jack_image.jpg",
                //   exerciseName: "Jumping Jacks",
                //   gifUrl: "assets/gifs/Jumping_jacks_animation.gif",
                // ),
                // SizedBox(height: 20),
              ],
            ),
          ),
        ));
  }
}
