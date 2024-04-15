import 'dart:io';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:orthoscan2/models/coordinates.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

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

class Point {
  final double x;
  final double y;

  Point(this.x, this.y);
}

Future<String> percentOfKnockKnees({required List<Pose> poses}) async {
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
    "right_ankle:": {
      "x": poses[0].landmarks[PoseLandmarkType.rightAnkle]!.x,
      "y": poses[0].landmarks[PoseLandmarkType.rightAnkle]!.y,
    },
    "left_hip:": {
      "x": poses[0].landmarks[PoseLandmarkType.leftHip]!.x,
      "y": poses[0].landmarks[PoseLandmarkType.leftHip]!.y,
    },
    "right_hip:": {
      "x": poses[0].landmarks[PoseLandmarkType.rightHip]!.x,
      "y": poses[0].landmarks[PoseLandmarkType.rightHip]!.y,
    },
  };

  Point hip = Point(coordinatesMap["left_hip"]!["x"]!.toDouble(),
      coordinatesMap["left_hip"]!["y"]!.toDouble());
  Point knee = Point(coordinatesMap["left_knee"]!["x"]!.toDouble(),
      coordinatesMap["left_knee"]!["y"]!.toDouble());
  Point ankle = Point(coordinatesMap["left_ankle"]!["x"]!.toDouble(),
      coordinatesMap["left_ankle"]!["y"]!.toDouble());

  // LEFT ANGLE

  // Vector representations of the lines
  Point hipToKnee = Point(knee.x - hip.x, knee.y - hip.y);
  Point kneeToAnkle = Point(ankle.x - knee.x, ankle.y - knee.y);

  // Dot product of the vectors
  double dotProduct =
      (hipToKnee.x * kneeToAnkle.x) + (hipToKnee.y * kneeToAnkle.y);

  // Magnitudes of the vectors
  double hipToKneeMagnitude = sqrt(pow(hipToKnee.x, 2) + pow(hipToKnee.y, 2));
  double kneeToAnkleMagnitude =
      sqrt(pow(kneeToAnkle.x, 2) + pow(kneeToAnkle.y, 2));

  // Calculate the angle between the lines
  double cosAngle = dotProduct / (hipToKneeMagnitude * kneeToAnkleMagnitude);
  double angleInRadians = acos(cosAngle);

  // Convert radians to degrees
  double angleInDegreesLeft = angleInRadians * (180 / pi);

  // RIGHT ANGLE

  Point hip_ = Point(coordinatesMap["right_hip"]!["x"]!.toDouble(),
      coordinatesMap["right_hip"]!["y"]!.toDouble());
  Point knee_ = Point(coordinatesMap["right_knee"]!["x"]!.toDouble(),
      coordinatesMap["right_knee"]!["y"]!.toDouble());
  Point ankle_ = Point(coordinatesMap["right_ankle"]!["x"]!.toDouble(),
      coordinatesMap["right_ankle"]!["y"]!.toDouble());

  // Vector representations of the lines
  Point hipToKnee_ = Point(knee_.x - hip_.x, knee_.y - hip_.y);
  Point kneeToAnkle_ = Point(ankle_.x - knee_.x, ankle_.y - knee_.y);

  // Dot product of the vectors
  double dotProduct_ =
      (hipToKnee_.x * kneeToAnkle_.x) + (hipToKnee_.y * kneeToAnkle_.y);

  // Magnitudes of the vectors
  double hipToKneeMagnitude_ = sqrt(pow(hipToKnee.x, 2) + pow(hipToKnee.y, 2));
  double kneeToAnkleMagnitude_ =
      sqrt(pow(kneeToAnkle.x, 2) + pow(kneeToAnkle.y, 2));

  // Calculate the angle between the lines
  double cosAngle_ =
      dotProduct_ / (hipToKneeMagnitude_ * kneeToAnkleMagnitude_);
  double angleInRadians_ = acos(cosAngle_);

  // Convert radians to degrees

  double angleInDegreesRight = angleInRadians_ * (180 / pi);

  final avgAngle = (angleInDegreesLeft + angleInDegreesRight) / 2;
  final perc = max(100, avgAngle * 10);

  // if (knee.x <= hip.x) return "Knock Knees $perc%";
  // if (knee.x > hip.x) return "Bow Legs $perc%";

  return "45";
}

// Future<String> percentOfKnockKnees({required List<Pose> poses}) async {
//   // final coordinates = Coordinates.fromJson(coordinatesMap);

//   // Random random = Random();
//   // return random.nextInt(100);
//   return "90";
// }
