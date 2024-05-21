import 'dart:io';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:orthoscan2/models/coordinates.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class Point {
  final double x;
  final double y;

  Point(this.x, this.y);
}

Future<String> getAssetPath(String asset) async {
  final path = await getLocalPath(asset);
  await Directory(dirname(path)).create(recursive: true);
  final file = File(path);
  if (!await file.exists()) {
    final byteData = await rootBundle.load(asset);
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  }
  return file.path;
}

Future<String> getLocalPath(String path) async {
  return '${(await getApplicationSupportDirectory()).path}/$path';
}

String percentOfKnockKnees({required List<Pose> poses}) {
  // print("FUNCTION CALLED");
  final coordinatesMap = {
    "left_knee": {
      "x": poses[0].landmarks[PoseLandmarkType.leftKnee]!.x,
      "y": poses[0].landmarks[PoseLandmarkType.leftKnee]!.y,
    },
    "left_ankle": {
      "x": poses[0].landmarks[PoseLandmarkType.leftAnkle]!.x,
      "y": poses[0].landmarks[PoseLandmarkType.leftAnkle]!.y,
    },
    "right_knee": {
      "x": poses[0].landmarks[PoseLandmarkType.rightKnee]!.x,
      "y": poses[0].landmarks[PoseLandmarkType.rightKnee]!.y,
    },
    "right_ankle": {
      "x": poses[0].landmarks[PoseLandmarkType.rightAnkle]!.x,
      "y": poses[0].landmarks[PoseLandmarkType.rightAnkle]!.y,
    },
    "left_hip": {
      "x": poses[0].landmarks[PoseLandmarkType.leftHip]!.x,
      "y": poses[0].landmarks[PoseLandmarkType.leftHip]!.y,
    },
    "right_hip": {
      "x": poses[0].landmarks[PoseLandmarkType.rightHip]!.x,
      "y": poses[0].landmarks[PoseLandmarkType.rightHip]!.y,
    },
  };

  // print(coordinatesMap);

  double hipx = coordinatesMap["left_hip"]?["x"]?.toDouble() ?? 0.0;
  double hipy = coordinatesMap["left_hip"]?["y"]?.toDouble() ?? 0.0;
  double kneex = coordinatesMap["left_knee"]?["x"]?.toDouble() ?? 0.0;
  double kneey = coordinatesMap["left_knee"]?["y"]?.toDouble() ?? 0.0;
  double anklex = coordinatesMap["left_ankle"]?["x"]?.toDouble() ?? 0.0;
  double ankley = coordinatesMap["left_ankle"]?["y"]?.toDouble() ?? 0.0;

  // LEFT ANGLE

  // Vector representations of the lines
  double hipToKneex = kneex - hipx;
  double hipToKneey = kneey - hipy;
  double kneeToAnklex = anklex - kneex;
  double kneeToAnkley = ankley - kneey;

  // Dot product of the vectors
  double dotProduct = (hipToKneex * kneeToAnklex) + (hipToKneey * kneeToAnkley);

  // Magnitudes of the vectors
  double hipToKneeMagnitude = sqrt(pow(hipToKneex, 2) + pow(hipToKneey, 2));
  double kneeToAnkleMagnitude =
      sqrt(pow(kneeToAnklex, 2) + pow(kneeToAnkley, 2));

  // Calculate the angle between the lines
  double cosAngle = dotProduct / (hipToKneeMagnitude * kneeToAnkleMagnitude);
  double angleInRadians = acos(cosAngle);

  // Convert radians to degrees
  double angleInDegreesLeft = angleInRadians * (180 / pi);

  // RIGHT ANGLE

  hipx = coordinatesMap["right_hip"]?["x"]?.toDouble() ?? 0.0;
  hipy = coordinatesMap["right_hip"]?["y"]?.toDouble() ?? 0.0;
  kneex = coordinatesMap["right_knee"]?["x"]?.toDouble() ?? 0.0;
  kneey = coordinatesMap["right_knee"]?["y"]?.toDouble() ?? 0.0;
  anklex = coordinatesMap["right_ankle"]?["x"]?.toDouble() ?? 0.0;
  ankley = coordinatesMap["right_ankle"]?["y"]?.toDouble() ?? 0.0;

  // Vector representations of the lines
  hipToKneex = kneex - hipx;
  hipToKneey = kneey - hipy;
  kneeToAnklex = anklex - kneex;
  kneeToAnkley = ankley - kneey;

  // Dot product of the vectors
  dotProduct = (hipToKneex * kneeToAnklex) + (hipToKneey * kneeToAnkley);

  // Magnitudes of the vectors
  hipToKneeMagnitude = sqrt(pow(hipToKneex, 2) + pow(hipToKneey, 2));
  kneeToAnkleMagnitude = sqrt(pow(kneeToAnklex, 2) + pow(kneeToAnkley, 2));

  // Calculate the angle between the lines
  cosAngle = dotProduct / (hipToKneeMagnitude * kneeToAnkleMagnitude);
  angleInRadians = acos(cosAngle);

  // Convert radians to degrees
  final angleInDegreesRight = angleInRadians * (180 / pi);

  final avgAngle = (angleInDegreesLeft + angleInDegreesRight) / 2;
  final perc = min(100, avgAngle * 5).toStringAsFixed(1);
  if (kneex > anklex) return perc; // Knock knees
  if (kneex <= anklex) return "-$perc"; // Bow legs
  return "Loading...";
}

String jumpingJacks({required List<Pose> poses}) {
  if (poses.isEmpty) {
    return "No poses detected";
  }
  Pose pose = poses[0];
  //Calculate Distances
  double shouldersDistance = (pose.landmarks[PoseLandmarkType.leftShoulder]!.x -
          pose.landmarks[PoseLandmarkType.rightShoulder]!.x)
      .abs();
  double legsDistance = (pose.landmarks[PoseLandmarkType.leftAnkle]!.x -
          pose.landmarks[PoseLandmarkType.rightAnkle]!.x)
      .abs();
  double hipsWidth = (pose.landmarks[PoseLandmarkType.leftHip]!.x -
          pose.landmarks[PoseLandmarkType.rightHip]!.x)
      .abs();
  //Calculate Angles
  double leftArmAngle = calculateAngle(
      pose.landmarks[PoseLandmarkType.leftShoulder]!,
      pose.landmarks[PoseLandmarkType.leftElbow]!,
      pose.landmarks[PoseLandmarkType.leftWrist]!);
  double rightArmAngle = calculateAngle(
      pose.landmarks[PoseLandmarkType.rightShoulder]!,
      pose.landmarks[PoseLandmarkType.rightElbow]!,
      pose.landmarks[PoseLandmarkType.rightWrist]!);
  double leftArmpitAngle = calculateAngle(
      pose.landmarks[PoseLandmarkType.leftElbow]!,
      pose.landmarks[PoseLandmarkType.leftShoulder]!,
      pose.landmarks[PoseLandmarkType.leftHip]!);
  double rightArmpitAngle = calculateAngle(
      pose.landmarks[PoseLandmarkType.rightElbow]!,
      pose.landmarks[PoseLandmarkType.rightShoulder]!,
      pose.landmarks[PoseLandmarkType.rightHip]!);

  // Check if arms are extended outwards and upwards
  bool armsExtended = (leftArmAngle > 120) && (rightArmAngle > 120);
  bool armsNotDown = (leftArmpitAngle > 20) && (rightArmpitAngle > 20);

  // Check if legs are spread apart
  bool legsSpread = legsDistance >= 0.4 * shouldersDistance;

  if (!armsExtended) {
    return "Posture: Incorrect - Arms not extended";
  }
  if (!armsNotDown) {
    return "Posture: Incorrect - Arms not in correct position";
  }
  if (!legsSpread) {
    return "Posture: Incorrect - Legs not spread apart";
  }

  return "Posture: Correct";
}

// String cablePushdown({required List<Pose> poses}) {
//   double leftElbowAngle = calculateAngle(
//       poses[0].landmarks[PoseLandmarkType.leftShoulder]!,
//       poses[0].landmarks[PoseLandmarkType.leftElbow]!,
//       poses[0].landmarks[PoseLandmarkType.leftWrist]!);
//   double rightElbowAngle = calculateAngle(
//       poses[0].landmarks[PoseLandmarkType.rightShoulder]!,
//       poses[0].landmarks[PoseLandmarkType.rightElbow]!,
//       poses[0].landmarks[PoseLandmarkType.rightWrist]!);
//   bool elbowsAligned = (leftElbowAngle - rightElbowAngle).abs() <
//       10; // Assuming a threshold for alignment

//   // Check if wrists are higher than elbows
//   bool leftWristAboveElbow = poses[0].landmarks[PoseLandmarkType.leftWrist]!.y <
//       poses[0].landmarks[PoseLandmarkType.leftElbow]!.y;
//   bool rightWristAboveElbow =
//       poses[0].landmarks[PoseLandmarkType.rightWrist]!.y <
//           poses[0].landmarks[PoseLandmarkType.rightElbow]!.y;

//   return elbowsAligned && leftWristAboveElbow && rightWristAboveElbow
//       ? "Posture: Correct"
//       : "Posture: Incorrect";
// }

String hipAbductorStrengthening({required List<Pose> poses}) {
  if (poses.isEmpty) {
    return "No poses detected";
  }

  Pose pose = poses[0];
  //Calculate Distances
  double rightLegAbductionDistance =
      (pose.landmarks[PoseLandmarkType.rightHip]!.y -
              pose.landmarks[PoseLandmarkType.rightAnkle]!.x)
          .abs();
  double leftLegAbductionDistance =
      (pose.landmarks[PoseLandmarkType.rightHip]!.y -
              pose.landmarks[PoseLandmarkType.rightAnkle]!.x)
          .abs();
  // Calculate Angles
  double leftKneeAngle = calculateAngle(
    pose.landmarks[PoseLandmarkType.leftHip]!,
    pose.landmarks[PoseLandmarkType.leftKnee]!,
    pose.landmarks[PoseLandmarkType.leftAnkle]!,
  );
  double rightKneeAngle = calculateAngle(
    pose.landmarks[PoseLandmarkType.rightHip]!,
    pose.landmarks[PoseLandmarkType.rightKnee]!,
    pose.landmarks[PoseLandmarkType.rightAnkle]!,
  );
  double upperBodyAngle = calculateAngle(
    pose.landmarks[PoseLandmarkType.leftElbow]!,
    pose.landmarks[PoseLandmarkType.leftShoulder]!,
    pose.landmarks[PoseLandmarkType.leftHip]!,
  );
  // Check supporting leg stability
  bool supportingLegStable = (leftKneeAngle > 160 && leftKneeAngle <= 180);

  // Check active leg position (straight at start)
  bool activeLegStraight = (rightKneeAngle > 170 && rightKneeAngle < 180);

  // Check leg abduction
  bool legAbducted =
      rightLegAbductionDistance > 0.85 * leftLegAbductionDistance;

  // Check hip height (hips remain level)
  double leftHipY = pose.landmarks[PoseLandmarkType.leftHip]!.y;
  double leftKneeY = pose.landmarks[PoseLandmarkType.leftKnee]!.y;
  // double rightHipY = pose.landmarks[PoseLandmarkType.rightHip]!.y;
  bool hipsLevel =
      (leftHipY - leftKneeY).abs() <= 20; // Adjust threshold as needed

  // Check back straight
  // double backAngle = calculateAngle(
  //   pose.landmarks[PoseLandmarkType.leftShoulder]!,
  //   pose.landmarks[PoseLandmarkType.leftHip]!,
  //   pose.landmarks[PoseLandmarkType.leftKnee]!,
  // );
  // bool backStraight = (backAngle - 180).abs() < 10.0;

  // Check upper body stability (not swaying)
  bool upperBodyStable = upperBodyAngle < 65;

  if (!supportingLegStable) {
    return "Posture: Incorrect - Supporting leg is not stable";
  }

  if (!activeLegStraight) {
    return "Posture: Incorrect - Active leg is not straight";
  }

  if (!legAbducted) {
    return "Posture: Incorrect - Leg is not abducted correctly";
  }

  if (!hipsLevel) {
    return "Posture: Incorrect - Hips are not level";
  }

  // if (!backStraight) {
  //   return "Posture: Incorrect - Back is not straight";
  // }

  if (!upperBodyStable) {
    return "Posture: Incorrect - Upper body is not stable";
  }

  return "Posture: Correct";
}

// String barbellUnderhand({required List<Pose> poses}) {
//   bool handsBelowShoulders = poses[0].landmarks[PoseLandmarkType.leftWrist]!.y >
//           poses[0].landmarks[PoseLandmarkType.leftShoulder]!.y &&
//       poses[0].landmarks[PoseLandmarkType.rightWrist]!.y >
//           poses[0].landmarks[PoseLandmarkType.rightShoulder]!.y;

//   // Check if hands are at a certain distance apart
//   double handsDistance = (poses[0].landmarks[PoseLandmarkType.leftWrist]!.x -
//           poses[0].landmarks[PoseLandmarkType.rightWrist]!.x)
//       .abs();
//   bool correctHandsDistance = (0.6 < handsDistance) &&
//       (handsDistance < 0.9); // Assuming a range for hand distance

//   return handsBelowShoulders && correctHandsDistance
//       ? "Posture: Correct"
//       : "Posture: Incorrect";

//   // print("Barbell Underhand");
//   // return "You are doing Barbell Underhand right!";
// }

String barbellUnderhand({
  required List<Pose> poses,
}) {
  if (poses.isEmpty) {
    return "No poses detected";
  }

  Pose pose = poses[0];

  // Calculate distances
  double feetsDistance = (pose.landmarks[PoseLandmarkType.leftAnkle]!.x -
          pose.landmarks[PoseLandmarkType.rightAnkle]!.x)
      .abs();
  double shouldersDistance = (pose.landmarks[PoseLandmarkType.leftShoulder]!.x -
          pose.landmarks[PoseLandmarkType.rightShoulder]!.x)
      .abs();
  double handsDistance = (pose.landmarks[PoseLandmarkType.leftWrist]!.x -
          pose.landmarks[PoseLandmarkType.rightWrist]!.x)
      .abs();

  // Calculate angles
  double leftBackAngle = calculateAngle(
    pose.landmarks[PoseLandmarkType.leftShoulder]!,
    pose.landmarks[PoseLandmarkType.leftHip]!,
    pose.landmarks[PoseLandmarkType.leftKnee]!,
  );

  double rightBackAngle = calculateAngle(
    pose.landmarks[PoseLandmarkType.rightShoulder]!,
    pose.landmarks[PoseLandmarkType.rightHip]!,
    pose.landmarks[PoseLandmarkType.rightKnee]!,
  );

// Check if hands are below shoulders
  bool handsBelowShoulders = pose.landmarks[PoseLandmarkType.leftWrist]!.y >
          pose.landmarks[PoseLandmarkType.leftShoulder]!.y &&
      pose.landmarks[PoseLandmarkType.rightWrist]!.y >
          pose.landmarks[PoseLandmarkType.rightShoulder]!.y;

// Compare handsDistance with shouldersDistance
  bool correctHandsDistance = shouldersDistance <= handsDistance &&
      shouldersDistance >= 0.6 * handsDistance;

// Check back angle
  bool backBent = leftBackAngle < 160 || rightBackAngle < 160;

// Check feet placement
  bool feetShoulderWidth =
      (feetsDistance - shouldersDistance).abs() <= 0.2 * shouldersDistance;
  if (!handsBelowShoulders) {
    return "Posture: Incorrect - Hands are not below shoulders";
  }

  if (!correctHandsDistance) {
    return "Posture: Incorrect - Hands are not at the correct distance apart";
  }

  if (!backBent) {
    return "Posture: Incorrect - Back is not bent Correctly";
  }

  if (!feetShoulderWidth) {
    return "Posture: Incorrect - Feet are not shoulder-width apart";
  }

  return "Posture: Correct";
}

double calculateAngle(
    PoseLandmark point1, PoseLandmark point2, PoseLandmark point3) {
  // Finds the acute angle bw three points

  // Calculate vectors
  double ux = point1.x - point2.x;
  double uy = point1.y - point2.y;
  double vx = point3.x - point2.x;
  double vy = point3.y - point2.y;

  // Calculate dot product and magnitudes
  double dotProduct = ux * vx + uy * vy;
  double magnitudeU = sqrt(ux * ux + uy * uy);
  double magnitudeV = sqrt(vx * vx + vy * vy);

  // Calculate cosine of the angle
  double cosineTheta = dotProduct / (magnitudeU * magnitudeV);

  // Calculate and return the angle in degrees
  return acos(cosineTheta) * (180 / pi);
}
