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
  print("FUNCTION CALLED");
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
  final perc = min(100, avgAngle * 10);
  if (kneex <= hipx) return "$perc% Knock Knees";
  if (kneex > hipx) return "$perc% Bow Legs";

  return "69";
}

// String percentOfKnockKnees({required List<Pose> poses}) {
//   // final coordinates = Coordinates.fromJson(coordinatesMap);

//   // Random random = Random();
//   // return random.nextInt(100);
//   return "90";
// }
