import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

import 'package:orthoscan2/knock_knee_detection/vision_detector_views/utils.dart';
import 'detector_view.dart';
import 'painters/pose_painter.dart';

class PoseDetectorView extends StatefulWidget {
  const PoseDetectorView(
      {required this.title, required this.isExercise, super.key});
  final bool isExercise;
  final String title;
  @override
  State<StatefulWidget> createState() => _PoseDetectorViewState();
}

class _PoseDetectorViewState extends State<PoseDetectorView> {
  final PoseDetector _poseDetector =
      PoseDetector(options: PoseDetectorOptions());
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;
  var _cameraLensDirection = CameraLensDirection.back;
  String _percentText = "Loading..."; //BYME:
  // Random random = Random();

  @override
  void dispose() async {
    _canProcess = false;
    _poseDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DetectorView(
      title: widget.title,
      customPaint: _customPaint,
      text: _text,
      onImage: _processImage,
      initialCameraLensDirection: _cameraLensDirection,
      onCameraLensDirectionChanged: (value) => _cameraLensDirection = value,
      percentText: _percentText, //BYME:
      isExercise: widget.isExercise, //BYME:
    );
  }

  Future<void> _processImage(InputImage inputImage) async {
    // print("IMAGE METADATA: ${inputImage.metadata!}");
    // print("PROCESSING IMAGE...");
    bool isLiveDetection = inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null; //BYME
    if (!_canProcess) return;
    // print("IS BUSY: $_isBusy");
    if (isLiveDetection && _isBusy) return;
    _isBusy = true;
    // setState(() {
    //   _text = '';
    // });
    if (isLiveDetection) {
      final poses = await _poseDetector.processImage(inputImage);
      // print("MODEL OUTPUT: $_percentText :D:D");
      if (widget.isExercise) {
        _percentText = exerciseDetection(poses: poses); //BYME:
      } else {
        _percentText = percentOfKnockKnees(poses: poses); //BYME:
      }
      final painter = PosePainter(
        poses,
        inputImage.metadata!.size,
        inputImage.metadata!.rotation,
        _cameraLensDirection,
      );
      _customPaint = CustomPaint(painter: painter);
    } else {
      double avgPercent = 0.0;
      for (int i = 0; i < 20; ++i) {
        final poses = await _poseDetector.processImage(inputImage);
        String detection = percentOfKnockKnees(poses: poses);
        if (detection != "Loading...") {
          // print("DETECTION ${i + 1}: $detection");
          avgPercent += double.parse(detection);
        } else {
          // print("DETECTION ${i + 1}: $detection");
        }
      }
      _percentText = (avgPercent / 20).toStringAsFixed(2);
      // _text = 'Poses found: ${poses.length}\n\n';
      // TODO: set _customPaint to draw landmarks on top of image
      _customPaint = null;
    }
    _isBusy = false;
    // print("IS BUSY MARKED FALSE: $_isBusy");
    if (mounted) {
      setState(() {});
    }
  }
}
