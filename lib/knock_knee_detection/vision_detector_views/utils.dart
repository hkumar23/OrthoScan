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
  // Check if arms are extended outwards and upwards
  double leftArmAngle = calculateAngle(
      poses[0].landmarks[PoseLandmarkType.leftShoulder]!,
      poses[0].landmarks[PoseLandmarkType.leftElbow]!,
      poses[0].landmarks[PoseLandmarkType.leftWrist]!);
  double rightArmAngle = calculateAngle(
      poses[0].landmarks[PoseLandmarkType.rightShoulder]!,
      poses[0].landmarks[PoseLandmarkType.rightElbow]!,
      poses[0].landmarks[PoseLandmarkType.rightWrist]!);
  bool armsExtended = (leftArmAngle > 150) && (rightArmAngle > 150);

  double leftArmpitAngle = calculateAngle(
      poses[0].landmarks[PoseLandmarkType.leftElbow]!,
      poses[0].landmarks[PoseLandmarkType.leftShoulder]!,
      poses[0].landmarks[PoseLandmarkType.leftHip]!);
  double rightArmpitAngle = calculateAngle(
      poses[0].landmarks[PoseLandmarkType.rightElbow]!,
      poses[0].landmarks[PoseLandmarkType.rightShoulder]!,
      poses[0].landmarks[PoseLandmarkType.rightHip]!);
  bool armsNotDown = (leftArmpitAngle > 60) && (rightArmpitAngle > 60);

  // Check if legs are spread apart
  double legsDistance = (poses[0].landmarks[PoseLandmarkType.leftHip]!.y -
          poses[0].landmarks[PoseLandmarkType.rightHip]!.y)
      .abs();
  bool legsSpread = legsDistance > 0.2; // Assuming a threshold for leg spread

  return armsExtended && legsSpread && armsNotDown
      ? "Posture: Correct"
      : "Posture: Incorrect";

  // print("Jumping Jacks");
  // return "You are doing Jumping Jacks right!";
}

String cablePushdown({required List<Pose> poses}) {
  double leftElbowAngle = calculateAngle(
      poses[0].landmarks[PoseLandmarkType.leftShoulder]!,
      poses[0].landmarks[PoseLandmarkType.leftElbow]!,
      poses[0].landmarks[PoseLandmarkType.leftWrist]!);
  double rightElbowAngle = calculateAngle(
      poses[0].landmarks[PoseLandmarkType.rightShoulder]!,
      poses[0].landmarks[PoseLandmarkType.rightElbow]!,
      poses[0].landmarks[PoseLandmarkType.rightWrist]!);
  bool elbowsAligned = (leftElbowAngle - rightElbowAngle).abs() <
      10; // Assuming a threshold for alignment

  // Check if wrists are higher than elbows
  bool leftWristAboveElbow = poses[0].landmarks[PoseLandmarkType.leftWrist]!.y <
      poses[0].landmarks[PoseLandmarkType.leftElbow]!.y;
  bool rightWristAboveElbow =
      poses[0].landmarks[PoseLandmarkType.rightWrist]!.y <
          poses[0].landmarks[PoseLandmarkType.rightElbow]!.y;

  return elbowsAligned && leftWristAboveElbow && rightWristAboveElbow
      ? "Posture: Correct"
      : "Posture: Incorrect";
  // print("Cable Pushdown");
  // return "You are doing Cable Pushdown right!";
}

String barbellUnderhand({required List<Pose> poses}) {
  bool handsBelowShoulders = poses[0].landmarks[PoseLandmarkType.leftWrist]!.y >
          poses[0].landmarks[PoseLandmarkType.leftShoulder]!.y &&
      poses[0].landmarks[PoseLandmarkType.rightWrist]!.y >
          poses[0].landmarks[PoseLandmarkType.rightShoulder]!.y;

  // Check if hands are at a certain distance apart
  double handsDistance = (poses[0].landmarks[PoseLandmarkType.leftWrist]!.x -
          poses[0].landmarks[PoseLandmarkType.rightWrist]!.x)
      .abs();
  bool correctHandsDistance = (0.6 < handsDistance) &&
      (handsDistance < 0.9); // Assuming a range for hand distance

  return handsBelowShoulders && correctHandsDistance
      ? "Posture: Correct"
      : "Posture: Incorrect";

  // print("Barbell Underhand");
  // return "You are doing Barbell Underhand right!";
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
