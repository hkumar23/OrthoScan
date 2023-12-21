import 'package:flutter/material.dart';

class UpperAuthScreen extends CustomClipper<Path>{
  @override
  Path getClip(Size size){
    Path path=Path();
    // path.moveTo(0,size.height*0.1);
    path.lineTo(0,size.height*0.1);
    path.quadraticBezierTo(size.width*0.4, size.height*0.4, size.width, size.height*0.17);
    path.lineTo(size.width, 0);
    path.moveTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class LowerAuthScreen extends CustomClipper<Path>{
  @override
  Path getClip(Size size){
    Path path=Path();
    path.moveTo(0,size.height*0.75);
    // path.lineTo(size.width, 0);
    path.quadraticBezierTo(size.width*0.25,size.height*0.91,size.width*0.6,size.height*0.85);
    path.quadraticBezierTo(size.width*0.85,size.height*0.8,size.width,size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}