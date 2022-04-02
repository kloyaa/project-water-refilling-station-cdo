import 'package:latlong2/latlong.dart';

getDistanceBetween({type, location1, location2}) {
  const Distance distance = Distance();
  if (type == "meter") {
    final meter = distance(
      LatLng(location1[0], location1[1]),
      LatLng(location2[0], location2[1]),
    );

    return meter;
  }
  if (type == "kilometer") {
    final km = distance.as(
      LengthUnit.Kilometer,
      LatLng(location1[0], location1[1]),
      LatLng(location2[0], location2[1]),
    );

    return km;
  }
}
