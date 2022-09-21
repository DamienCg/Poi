// Class Model for SQL query

import 'dart:math';

class Position {
  double lat = 0;
  double long = 0;

  Position(double lat, double long) {
    this.lat = lat;
    this.long = long;
  }

  @override
  String toString() {
    return "\"" + lat.toString() + "-" + long.toString() + "\"";
  }

  String Dummyupdate(String privacydetail) {
    int dummy = int.parse(privacydetail);
    Random r = new Random();
    List<Position> dummyPosition = new List.empty(growable: true);
    Position RealPosition = Position(this.lat, this.long);
    int RealPositionIndex = r.nextInt(dummy - 1);

    for (var i = 0; i < dummy; i++) {
      double randomLat =
          (lat - 0.015) + ((lat + 0.015) - (lat - 0.015)) * r.nextDouble();
      double randomLong =
          (long - 0.015) + ((long + 0.015) - (long - 0.015)) * r.nextDouble();
      Position randomValue = Position(randomLat, randomLong);
      if (i == RealPositionIndex)
        dummyPosition.add(RealPosition);
      else
        dummyPosition.add(randomValue);
    }

    return dummyPosition.toString();
  }

  String Perturbation(String privacydetail) {
    int digits = int.parse(privacydetail);
    double lat = this.lat;
    double long = this.long;
    int LatBeforePoint = int.parse(lat.toString().split(".")[0]);
    int LatAfterPoint = int.parse(lat.toString().split(".")[1]);
    int LongBeforePoint = int.parse(long.toString().split(".")[0]);
    int LongAfterPoint = int.parse(long.toString().split(".")[1]);
    Random r = new Random();
    double finalLong = 0;
    double finalLat = 0;

    finalLat = double.parse(LatBeforePoint.toString() +
        "." +
        (LatAfterPoint.toString()).substring(0, digits) +
        r.nextInt(9).toString() +
        LatAfterPoint.toString().substring(digits + 1));

    finalLong = double.parse(LongBeforePoint.toString() +
        "." +
        (LongAfterPoint.toString()).substring(0, digits) +
        r.nextInt(9).toString() +
        LongAfterPoint.toString().substring(digits + 1));

    return "[\"" + finalLat.toString() + "-" + finalLong.toString() + "\"]";
  }
}
