import 'package:app/common/pretty_print.dart';
import 'package:app/common/radius.dart';
import 'package:app/common/spacing.dart';
import 'package:app/const/colors.dart';
import 'package:app/controllers/globalController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterAccountType extends StatefulWidget {
  const RegisterAccountType({Key? key}) : super(key: key);

  @override
  State<RegisterAccountType> createState() => _RegisterAccountTypeState();
}

class _RegisterAccountTypeState extends State<RegisterAccountType> {
  final _global = Get.put(GlobalController());

  String selectedRole = "customer";

  Future<void> onProceed() async {
    // ASSIGN VALUE TO GLOBAL STATE
    _global.registrationProperties.addAll(
      {
        "accountType": selectedRole,
      },
    );

    prettyPrint("RegisterAccountType", _global.registrationProperties);

    // REDIRECT TO NEXT STEP
    Get.toNamed("/register-account-profile");
  }

  @override
  Widget build(BuildContext context) {
    final _breadCrumbs = Container(
      margin: kDefaultBodyPadding.copyWith(left: 15.0),
      child: Row(
        children: [
          Text(
            "Account",
            style: GoogleFonts.chivo(
              fontSize: 12.0,
              fontWeight: FontWeight.w500,
              color: kLight,
              height: 1.5,
            ),
          ),
          const Icon(
            Entypo.chevron_right,
            color: kLight,
            size: 15.0,
          ),
          Text(
            "Type",
            style: GoogleFonts.chivo(
              fontSize: 12.0,
              fontWeight: FontWeight.w500,
              color: kLight,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
    final _title = Text(
      "Profile Type",
      style: GoogleFonts.chivo(
        fontSize: 25.0,
        fontWeight: FontWeight.bold,
        color: kLight,
      ),
    );
    final _subTitle = Text(
      "Tell us what do you want to do and we will set your profile for you",
      style: GoogleFonts.roboto(
        fontSize: 16.0,
        fontWeight: FontWeight.w300,
        color: kLight,
      ),
    );

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: kPrimary,
        appBar: AppBar(
          title: _breadCrumbs,
          backgroundColor: kPrimary,
          elevation: 0,
          leading: const SizedBox(),
          leadingWidth: 0.0,
        ),
        body: Container(
          margin: kDefaultBodyPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 4),
              Container(
                margin: const EdgeInsets.only(top: 10.0),
                child: CheckboxListTile(
                  value: selectedRole == "customer" ? true : false,
                  onChanged: (v) {
                    setState(() {
                      selectedRole = "customer";
                    });
                  },
                  title: Text(
                    "Customer",
                    style: GoogleFonts.roboto(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: kLight,
                    ),
                  ),
                  subtitle: Text(
                    "I'm looking for Water Refilling Stations nearby",
                    style: GoogleFonts.roboto(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w400,
                      color: kLight,
                    ),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10.0),
                child: CheckboxListTile(
                  value: selectedRole == "station" ? true : false,
                  onChanged: (v) {
                    setState(() {
                      selectedRole = "station";
                    });
                  },
                  title: Text(
                    "Water Refilling Station",
                    style: GoogleFonts.roboto(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: kLight,
                    ),
                  ),
                  subtitle: Text(
                    "I would like to offer my service as Water Refilling Station",
                    style: GoogleFonts.roboto(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w400,
                      color: kLight,
                    ),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 62,
                child: TextButton(
                  onPressed: () => onProceed(),
                  style: TextButton.styleFrom(
                    //primary: kFadeWhite,
                    backgroundColor: kLight,
                    shape: const RoundedRectangleBorder(
                      borderRadius: kDefaultRadius,
                    ),
                  ),
                  child: Text(
                    "PROCEED",
                    style: GoogleFonts.roboto(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: kPrimary,
                    ),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
