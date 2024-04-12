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

Future<int> percentOfKnockKnees({required List<Pose> poses}) async {
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
  // final coordinates = Coordinates.fromJson(coordinatesMap);

  // Random random = Random();
  // return random.nextInt(100);
  return 90;
}
