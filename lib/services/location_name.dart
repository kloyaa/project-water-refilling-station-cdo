import 'package:geocoding/geocoding.dart';

Future<List<Placemark>> getLocationName({lat, long}) async {
  List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
  return placemarks;
}
