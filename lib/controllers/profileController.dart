import 'package:app/common/pretty_print.dart';
import 'package:app/const/url.dart';
import 'package:app/services/location_coordinates.dart';
import 'package:app/services/location_name.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  Map profile = {};
  Map location = {};

  Future<void> syncLocation() async {
    final locationCoord = await getLocation();
    final locationName = await getLocationName(
      lat: locationCoord!.latitude,
      long: locationCoord.longitude,
    );
    final _street = locationName[0].street.toString();
    final _locality = locationName[0].locality.toString();

    location = {
      "name": _street + ", " + _locality,
      "coordinates": {
        "latitude": locationCoord.latitude,
        "longitude": locationCoord.longitude,
      }
    };
  }

  Future<void> getProfile(String id) async {
    try {
      final _getProfileResponse = await Dio().get(baseUrl + "/profile/$id");
      profile = _getProfileResponse.data;

      final _accountType = _getProfileResponse.data["accountType"];
      prettyPrint("PROFILE", _getProfileResponse.data);

      // REDIRECT
      if (_accountType == "customer") {
        Get.toNamed("/customer");
      }
      if (_accountType == "station") {
        Get.toNamed("/station-customer-orders");
      }
    } on DioError catch (e) {
      Get.toNamed("/register-account-type");
      if (kDebugMode) {
        prettyPrint("getProfile()", e.response!.data);
      }
    }
  }

  Future<dynamic> getWaterRefillingStations() async {
    try {
      // SYNC USER LOCATION
      await syncLocation();

      // GET WATER REFILLIGN STATIONS NEARBY
      final getWaterRefillingStations = await Dio().get(
        baseUrl + "/profile",
        queryParameters: {
          "accountType": "station",
          "visibility": true,
          "latitude": location["coordinates"]["latitude"],
          "longitude": location["coordinates"]["longitude"],
        },
      );
      //prettyPrint("WATER REFILLING STATIONS", getWaterRefillingStations.data);
      return getWaterRefillingStations.data;
    } on DioError catch (e) {
      Get.back();
      if (kDebugMode) {
        prettyPrint("getProfile()", e.response!.data);
      }
    }
  }
}
