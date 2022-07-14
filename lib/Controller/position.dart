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
    return "Point(Lat: $lat, Long: $long)";
  }

  void printPosition() {
    print("Lat: " + this.lat.toString());
    print("Long: " + this.long.toString());
  }

  Position Dummyupdate(Position realPosition) {
    int dummy = 3; // TODO Recupero Dummy da settings
    Random r = new Random();
    List<Position> dummyPosition = new List.empty(growable: true);
    Position RealPosition = Position(lat, long);
    int RealPositionIndex = r.nextInt(dummy - 1);

    for (var i = 0; i < dummy; i++) {
      double randomLat =
          (lat - 0.3) + ((lat + 0.3) - (lat - 0.3)) * r.nextDouble();
      double randomLong =
          (long - 0.3) + ((long + 0.3) - (long - 0.3)) * r.nextDouble();
      Position randomValue = Position(randomLat, randomLong);
      if (i == RealPositionIndex)
        dummyPosition.add(RealPosition);
      else
        dummyPosition.add(randomValue);
    }

    //TODO invio dummyPosition per risposta query spaziali
    // mi prendo solo il risultato della risposta reale
    print("All position: ");
    print(dummyPosition);
    print("Real position: ");
    print(dummyPosition.elementAt(RealPositionIndex).lat.toString() +
        " " +
        dummyPosition.elementAt(RealPositionIndex).long.toString());

    return realPosition;
  }

/*
pertubation:
non invio il dato reale ma faccio camuffaggio, non invio un dato reale ma faccio trocamento
invece di inviare un dato con 10 cifre dopo la virgola invio un dato con 3 cifre dopo la virgola
oppure faccio sostituzione casuale di alcune cifre.
*/
  Position Perturbation(Position realPosition) {
    int digits = 3;
    double lat = 11.3726;
    double long = 44.2657;
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

    print(finalLat);
    print(finalLong);
    return new Position(finalLat, finalLong);
  }
}
