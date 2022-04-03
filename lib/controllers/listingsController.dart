import 'package:app/common/pretty_print.dart';
import 'package:app/const/url.dart';
import 'package:app/controllers/globalController.dart';
import 'package:app/controllers/profileController.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class ListingsController extends GetxController {
  Future<dynamic> getListings() async {
    try {
      final _global = Get.put(GlobalController());
      final _listingsResponse = await Dio().get(
        baseUrl + "/station/listing",
        queryParameters: {
          "accountId": _global.selectedStation["accountId"],
          "availability": true,
        },
      );
      return _listingsResponse.data;
    } on DioError catch (e) {
      Get.back();
      if (kDebugMode) {
        prettyPrint("getListings()", e.response!.data);
      }
    }
  }

  Future<dynamic> getMyListings() async {
    try {
      final _profile = Get.put(ProfileController());
      final _listingsResponse = await Dio().get(
        baseUrl + "/station/listing",
        queryParameters: {
          "accountId": _profile.profile["accountId"],
          "availability": true,
        },
      );
      return _listingsResponse.data;
    } on DioError catch (e) {
      Get.back();
      if (kDebugMode) {
        prettyPrint("getListings()", e.response!.data);
      }
    }
  }

  Future<void> addListing({title, price}) async {
    try {
      final accountId = Get.put(ProfileController()).profile["accountId"];
      Get.toNamed("/loading");
      await Dio().post(
        baseUrl + "/station/listing",
        data: {
          "accountId": accountId,
          "title": title,
          "price": price,
          "availability": true
        },
      );
      Get.toNamed("/station-listings");
    } on DioError catch (e) {
      Get.back();
      if (kDebugMode) {
        prettyPrint("addListing()", e.response!.data);
      }
    }
  }

  Future<void> deleteListing(id) async {
    await Dio().delete(baseUrl + "/station/listing/$id");
  }
}
