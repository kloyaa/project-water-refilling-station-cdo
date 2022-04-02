import 'package:app/const/colors.dart';
import 'package:app/screens/account/login/login.dart';
import 'package:app/screens/account/registration/account.dart';
import 'package:app/screens/account/registration/accountPicture.dart';
import 'package:app/screens/account/registration/accountProfile.dart';
import 'package:app/screens/account/registration/accountType.dart';
import 'package:app/screens/customer/main.dart';
import 'package:app/screens/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Water Refilling Station',
      theme: ThemeData(
        checkboxTheme: CheckboxThemeData(
          checkColor: MaterialStateProperty.all(kPrimary),
          fillColor: MaterialStateProperty.all(kLight),
        ),
        primarySwatch: Colors.grey,
      ),
      home: const Login(),
      getPages: [
        GetPage(
          name: "/loading",
          page: () => const Loading(),
        ),
        GetPage(
          name: "/login",
          page: () => const Login(),
        ),
        GetPage(
          name: "/customer",
          page: () => const NearbyWaterRefillingStations(),
        ),
        ...registration,
      ],
    );
  }
}

final List<GetPage<dynamic>> registration = [
  GetPage(
    name: "/register",
    page: () => const RegisterAccount(),
  ),
  GetPage(
    name: "/register-account-type",
    page: () => const RegisterAccountType(),
  ),
  GetPage(
    name: "/register-account-profile",
    page: () => const RegisterAccountProfile(),
  ),
  GetPage(
    name: "/register-account-picture",
    page: () => const RegisterAccountPicture(),
  )
];
