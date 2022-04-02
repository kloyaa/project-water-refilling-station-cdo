import 'package:app/common/pretty_print.dart';
import 'package:app/const/url.dart';
import 'package:app/controllers/profileController.dart';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as http;

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';

class UserController extends GetxController {
  RxBool registerFailed = false.obs;
  RxBool loginFailed = false.obs;
  Map userLoginData = {};
  Map userRegistrationProfileData = {};
  Map userAvatarData = {};

  Future<void> onLogin({email, password}) async {
    try {
      final _profile = Get.put(ProfileController());

      loginFailed.value = false;
      Get.toNamed("/loading");

      final _loginResponse = await Dio().post(
        baseUrl + "/user/login",
        data: {
          "email": email,
          "password": password,
        },
      );

      userLoginData = _loginResponse.data;
      loginFailed.value = false;

      prettyPrint("DATA_LOGIN", _loginResponse.data);

      // GET PROFILE TYPE
      await _profile.getProfile(userLoginData["accountId"]);
      final _accountType = _profile.profile["accountType"];
      if (_accountType == "customer") {
        Get.toNamed("/customer");
      }
      if (_accountType == "laundry") {
        Get.toNamed("/laundry");
      }
    } on DioError catch (e) {
      loginFailed.value = true;
      Get.back();
      if (kDebugMode) {
        print("onLogin() ${e.response!.data}");
      }
    }
  }

  Future<void> onRegister({email, password}) async {
    try {
      registerFailed.value = false;
      Get.toNamed("/loading");

      final _registerResponse = await Dio().post(
        baseUrl + "/user/register",
        data: {
          "email": email,
          "password": password,
        },
      );

      registerFailed.value = false;
      userLoginData = _registerResponse.data;

      // ASSIGN FOR LOGIN
      userRegistrationProfileData["email"] = email;
      userRegistrationProfileData["password"] = password;

      Get.toNamed("/register-2");
      prettyPrint("_registerResponse", _registerResponse.data);
    } on DioError catch (e) {
      registerFailed.value = true;
      Get.back();
      if (kDebugMode) {
        prettyPrint("_loginResponse", e.response!.data);
      }
    }
  }

  void onLogout() {
    userLoginData.clear();
    userRegistrationProfileData.clear();
    Get.toNamed("/login");
  }

  Future<void> onCreateProfile() async {
    try {
      Get.toNamed("/loading");
      final accountId = userLoginData["accountId"];
      final payload = http.FormData.fromMap({
        "accountId": accountId,
        'img': await http.MultipartFile.fromFile(
          userAvatarData["path"],
          filename: userAvatarData["name"],
          contentType: MediaType("image", "jpeg"), //important
        ),
      });

      // CREATE PROFILE
      await Dio().post(baseUrl + "/profile", data: {
        "accountId": accountId,
        "accountType": userRegistrationProfileData["accoutType"],
        "firstName": userRegistrationProfileData["firstName"],
        "lastName": userRegistrationProfileData["lastName"],
        "verified": false
      });

      // UPDATE PROFILE
      await Dio().post(baseUrl + "/a/profile", data: payload);

      // UPDATE PROFILE ADDRESS
      await Dio().put(baseUrl + "/address/profile/$accountId", data: {
        "name": userRegistrationProfileData["address"],
        "lat": "0",
        "long": "0"
      });

      // UPDATE PROFILE CONTACT
      await Dio().put(baseUrl + "/contact/profile/$accountId", data: {
        "number": userRegistrationProfileData["contact"],
        "email": userLoginData["email"],
      });

      // lOGIN AUTOMATICALLY AFTER REGISTRATION
      await onLogin(
        email: userRegistrationProfileData["email"],
        password: userRegistrationProfileData["password"],
      );
    } on DioError catch (e) {
      Get.back();
      if (kDebugMode) {
        prettyPrint("onCreateProfile()", e.response!.data);
      }
    }
  }
}
