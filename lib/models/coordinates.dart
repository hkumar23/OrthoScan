/* 
// Example Usage
Map<String, dynamic> map = jsonDecode(<myJSONString>);
var myRootNode = Root.fromJson(map);
*/
class LeftAnkle {
  int? x;
  int? y;

  LeftAnkle({this.x, this.y});

  LeftAnkle.fromJson(Map<String, dynamic> json) {
    x = json['x'];
    y = json['y'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'x': x,
      'y': y,
    };
    return data;
  }
}

class LeftHip {
  int? x;
  int? y;

  LeftHip({this.x, this.y});

  LeftHip.fromJson(Map<String, dynamic> json) {
    x = json['x'];
    y = json['y'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'x': x,
      'y': y,
    };
    return data;
  }
}

class RightAnkle {
  int? x;
  int? y;

  RightAnkle({this.x, this.y});

  RightAnkle.fromJson(Map<String, dynamic> json) {
    x = json['x'];
    y = json['y'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'x': x,
      'y': y,
    };
    return data;
  }
}

class RightHip {
  int? x;
  int? y;

  RightHip({this.x, this.y});

  RightHip.fromJson(Map<String, dynamic> json) {
    x = json['x'];
    y = json['y'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'x': x,
      'y': y,
    };
    return data;
  }
}

class RightKnee {
  int? x;
  int? y;

  RightKnee({this.x, this.y});

  RightKnee.fromJson(Map<String, dynamic> json) {
    x = json['x'];
    y = json['y'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'x': x,
      'y': y,
    };
    return data;
  }
}

class Coordinates {
  LeftAnkle? leftankle;
  RightKnee? rightknee;
  RightAnkle? rightankle;
  LeftHip? lefthip;
  RightHip? righthip;

  Coordinates(
      {this.leftankle,
      this.rightknee,
      this.rightankle,
      this.lefthip,
      this.righthip});

  Coordinates.fromJson(Map<String, dynamic> json) {
    leftankle = json['left_ankle'] != null
        ? LeftAnkle?.fromJson(json['left_ankle'])
        : null;
    rightknee = json['right_knee'] != null
        ? RightKnee?.fromJson(json['right_knee'])
        : null;
    rightankle = json['right_ankle:'] != null
        ? RightAnkle?.fromJson(json['right_ankle:'])
        : null;
    lefthip =
        json['left_hip:'] != null ? LeftHip?.fromJson(json['left_hip:']) : null;
    righthip = json['right_hip:'] != null
        ? RightHip?.fromJson(json['right_hip:'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'left_ankle': leftankle!.toJson(),
      'right_knee': rightknee!.toJson(),
      'right_ankle:': rightankle!.toJson(),
      'left_hip:': lefthip!.toJson(),
      'right_hip:': righthip!.toJson(),
    };
    return data;
  }
}
