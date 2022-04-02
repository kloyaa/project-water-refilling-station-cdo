import 'package:app/common/pretty_print.dart';
import 'package:app/const/url.dart';
import 'package:app/controllers/globalController.dart';
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
  Map userAvatarData = {};

  Future<void> login({email, password}) async {
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

      // ASSIGN
      final _global = Get.put(GlobalController());
      _global.registrationProperties.addAll(
        {
          "loginData": {
            "accountId": _loginResponse.data["accountId"],
            "email": email,
            "password": password,
          },
        },
      );
      prettyPrint("LOGIN", _loginResponse.data);

      // GET PROFILE TYPE
      await _profile.getProfile(userLoginData["accountId"]);
    } on DioError catch (e) {
      loginFailed.value = true;
      Get.back();
      if (kDebugMode) {
        print("login() ${e.response!.data}");
      }
    }
  }

  Future<void> register({email, password}) async {
    try {
      final _global = Get.put(GlobalController());

      registerFailed.value = false;

      Get.toNamed("/loading");
      final _registerResponse = await Dio().post(
        baseUrl + "/user/register",
        data: {
          "email": email,
          "password": password,
        },
      );

      // ASSIGN VALUE TO GLOBAL STATE
      _global.registrationProperties.addAll(
        {
          "loginData": {
            "accountId": _registerResponse.data["accountId"],
            "email": email,
            "password": password,
          },
        },
      );
      registerFailed.value = false;

      // REDIRECT TO NEXT STEP
      Get.toNamed("/register-account-type");

      prettyPrint("REGISTER", _registerResponse.data);
    } on DioError catch (e) {
      registerFailed.value = true;
      Get.back();
      if (kDebugMode) {
        prettyPrint("register()", e.response!.data);
      }
    }
  }

  void logout() {
    final _global = Get.put(GlobalController());
    userLoginData.clear();
    _global.registrationProperties.clear();
    Get.toNamed("/login");
  }

  Future<void> createProfile() async {
    try {
      Get.toNamed("/loading");
      final _global = Get.put(GlobalController());
      final accountId =
          _global.registrationProperties["loginData"]["accountId"];
      final payload = http.FormData.fromMap({
        "accountId": accountId,
        'img': await http.MultipartFile.fromFile(
          _global.registrationProperties["img"]["path"],
          filename: _global.registrationProperties["img"]["name"],
          contentType: MediaType("image", "jpeg"), //important
        ),
      });

      // REMOVE IMG DATA
      _global.registrationProperties.remove("img");
      prettyPrint("onCreateProfile()", _global.registrationProperties);

      // ASSIGN VALUE OF ACCOUNT ID
      // CEATE PROFILE
      _global.registrationProperties["accountId"] = accountId;
      await Dio().post(
        baseUrl + "/profile",
        data: {
          ..._global.registrationProperties,
          "visibility": true,
          "verified": false,
        },
      );

      await Dio().put(baseUrl + "/profile/img", data: payload);

      // lOGIN AUTOMATICALLY AFTER REGISTRATION
      await login(
        email: _global.registrationProperties["loginData"]["email"],
        password: _global.registrationProperties["loginData"]["password"],
      );
      // // UPDATE PROFILE

      // // UPDATE PROFILE ADDRESS
      // await Dio().put(baseUrl + "/address/profile/$accountId", data: {
      //   "name": userRegistrationProfileData["address"],
      //   "lat": "0",
      //   "long": "0"
      // });

      // // UPDATE PROFILE CONTACT
      // await Dio().put(baseUrl + "/contact/profile/$accountId", data: {
      //   "number": userRegistrationProfileData["contact"],
      //   "email": userLoginData["email"],
      // });

    } on DioError catch (e) {
      Get.back();
      if (kDebugMode) {
        prettyPrint("createProfile()", e.response!.data);
      }
    }
  }
}
