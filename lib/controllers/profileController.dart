import 'package:app/common/pretty_print.dart';
import 'package:app/const/url.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  Map profile = {};

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
        print("STATION");
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
      final getWaterRefillingStations = await Dio().get(
        baseUrl + "/profile",
        queryParameters: {
          "accountType": "station",
          "visibility": true,
        },
      );
      prettyPrint("WATER REFILLING STATIONS", getWaterRefillingStations.data);
      return getWaterRefillingStations.data;
    } on DioError catch (e) {
      Get.back();
      if (kDebugMode) {
        prettyPrint("getProfile()", e.response!.data);
      }
    }
  }
}
