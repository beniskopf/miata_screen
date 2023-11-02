import 'dart:math';

class CompassCalc{
  static double radians(double degrees) {
    return degrees * (pi / 180.0);
  }
  static double calculateBearing(double lat1, double lon1, double lat2, double lon2) {
    final lat1Rad = lat1 * pi / 180;
    final lat2Rad = lat2 * pi / 180;
    final deltaLon = (lon2 - lon1) * pi / 180;

    final y = sin(deltaLon) * cos(lat2Rad);
    final x = cos(lat1Rad) * sin(lat2Rad) - sin(lat1Rad) * cos(lat2Rad) * cos(deltaLon);

    final initialBearing = atan2(y, x);

    // Convert to degrees
    final bearingDegrees = (initialBearing * 180 / pi + 360) % 360;

    return bearingDegrees;
  }
}
