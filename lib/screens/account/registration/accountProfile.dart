import 'package:app/common/destroy_textFocus.dart';
import 'package:app/common/pretty_print.dart';
import 'package:app/common/radius.dart';
import 'package:app/common/spacing.dart';
import 'package:app/const/colors.dart';
import 'package:app/controllers/globalController.dart';
import 'package:app/controllers/userController.dart';
import 'package:app/form/input.dart';
import 'package:app/services/location_coordinates.dart';
import 'package:app/services/location_name.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';

class RegisterAccountProfile extends StatefulWidget {
  const RegisterAccountProfile({Key? key}) : super(key: key);

  @override
  State<RegisterAccountProfile> createState() => _RegisterAccountProfileState();
}

class _RegisterAccountProfileState extends State<RegisterAccountProfile> {
  final _user = Get.put(UserController());
  final _global = Get.put(GlobalController());

  late TextEditingController _firstNameController;
  late FocusNode _firstNameFocus;

  late TextEditingController _lastNameController;
  late FocusNode _lastNameFocus;

  late TextEditingController _contactController;
  late FocusNode _contactFocus;

  late TextEditingController _addressController;
  late FocusNode _addressFocus;

  late TextEditingController _stationNameController;
  late FocusNode _stationNameFocus;

  String _openTime = "Select Open Time";
  String _closingTime = "Select Closing Time";

  Future<void> onProceed() async {
    final _firstName = _firstNameController.text.trim();
    final _lastName = _lastNameController.text.trim();
    final _address = _addressController.text.trim();
    final _stationName = _stationNameController.text.trim();

    final _contact = _contactController.text.trim().replaceAll(r' ', "");

    // VALIDATE
    if (_global.registrationProperties["accountType"] == "customer") {
      if (_firstName.isEmpty) {
        return _firstNameFocus.requestFocus();
      }
      if (_lastName.isEmpty) {
        return _lastNameFocus.requestFocus();
      }
    }
    if (_global.registrationProperties["accountType"] == "station") {
      if (_stationName.isEmpty) {
        return _stationNameFocus.requestFocus();
      }
      if (_openTime == "Select Open Time") {
        return selectServiceHrs("open");
      }
      if (_closingTime == "Select Closing Time") {
        return selectServiceHrs("close");
      }
    }

    if (_contact.isEmpty) {
      return _contactFocus.requestFocus();
    }
    if (_address.isEmpty) {
      return syncLocation();
    }

    // CONCAT SERVICE HRS
    final serviceHrs = _openTime + " to " + _closingTime;

    // ASSIGN VALUE TO GLOBAL STATE
    _global.registrationProperties.addAll(
      {
        "stationName": _stationName,
        "serviceHrs": serviceHrs,
        "name": {
          "first": _firstName,
          "last": _lastName,
        },
        "contact": {
          "number": _contact,
          "email": _global.registrationProperties["loginData"]["email"],
        },
        "address": {
          "coordinates": {
            "latitude": "8.4354216",
            "longitude": "124.6190972",
          },
          "name": _address
        },
      },
    );

    if (_global.registrationProperties["accountType"] == "station") {
      _global.registrationProperties.remove("name");
    }
    if (_global.registrationProperties["accountType"] == "customer") {
      _global.registrationProperties.remove("stationName");
      _global.registrationProperties.remove("serviceHrs");
    }

    // REDIRECT
    Get.toNamed("/register-account-picture");
  }

  Future<void> syncLocation() async {
    final locationCoord = await getLocation();
    final locationName = await getLocationName(
      lat: locationCoord!.latitude,
      long: locationCoord.longitude,
    );
    final _street = locationName[0].street.toString();
    final _locality = locationName[0].locality.toString();

    _addressController.text = _street + ", " + _locality;
  }

  void selectServiceHrs(type) {
    if (type == "open") {
      return BottomPicker.time(
        height: Get.height * 0.50,
        title: "Select Opening Time",
        buttonAlignement: MainAxisAlignment.end,
        buttonSingleColor: kPrimary,
        pickerTextStyle: GoogleFonts.chivo(
          fontSize: 13.0,
          fontWeight: FontWeight.w400,
          color: kPrimary,
        ),
        titleStyle: GoogleFonts.chivo(
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
          color: kPrimary,
        ),
        onSubmit: (date) {
          setState(() {
            _openTime = Jiffy(date).jm;
          });
        },
        onClose: () {
          print("Picker closed");
        },
        use24hFormat: false,
      ).show(context);
    }
    if (type == "close") {
      return BottomPicker.time(
        height: Get.height * 0.50,
        title: "Select Closing Time",
        buttonAlignement: MainAxisAlignment.end,
        buttonSingleColor: kPrimary,
        pickerTextStyle: GoogleFonts.chivo(
          fontSize: 13.0,
          fontWeight: FontWeight.w400,
          color: kPrimary,
        ),
        titleStyle: GoogleFonts.chivo(
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
          color: kPrimary,
        ),
        onSubmit: (date) {
          setState(() {
            _closingTime = Jiffy(date).jm;
          });
        },
        onClose: () {
          print("Picker closed");
        },
        bottomPickerTheme: BOTTOM_PICKER_THEME.orange,
        use24hFormat: false,
      ).show(context);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firstNameController = TextEditingController();
    _firstNameFocus = FocusNode();
    _lastNameController = TextEditingController();
    _lastNameFocus = FocusNode();
    _contactController = MaskedTextController(mask: '0000 000 0000');
    _contactFocus = FocusNode();
    _addressController = TextEditingController();
    _addressFocus = FocusNode();

    _stationNameController = TextEditingController();
    _stationNameFocus = FocusNode();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _firstNameController.dispose();
    _firstNameFocus.dispose();
    _lastNameController.dispose();
    _lastNameFocus.dispose();
    _contactController.dispose();
    _contactFocus.dispose();
    _addressController.dispose();
    _addressFocus.dispose();

    _stationNameController.dispose();
    _stationNameFocus.dispose();
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
          const Icon(
            Entypo.chevron_right,
            color: kLight,
            size: 15.0,
          ),
          Text(
            "Info",
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
      _global.registrationProperties["accountType"] == "customer"
          ? "Profile"
          : "Water Refilling Station",
      style: GoogleFonts.chivo(
        fontSize: 25.0,
        fontWeight: FontWeight.bold,
        color: kLight,
      ),
    );
    final _subTitle = Text(
      "Write basic details",
      style: GoogleFonts.roboto(
        fontSize: 16.0,
        fontWeight: FontWeight.w300,
        color: kLight,
      ),
    );

    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => destroyTextFieldFocus(context),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: kPrimary,
          appBar: AppBar(
            title: _breadCrumbs,
            backgroundColor: kPrimary,
            elevation: 0,
            leading: const SizedBox(),
            leadingWidth: 0.0,
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 15.0),
                child: IconButton(
                  onPressed: () => Get.back(),
                  splashRadius: 20.0,
                  icon: const Icon(
                    AntDesign.close,
                    color: kLight,
                  ),
                ),
              )
            ],
          ),
          body: Container(
            margin: kDefaultBodyPadding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _title,
                _subTitle,
                _global.registrationProperties["accountType"] == "customer"
                    ? Container(
                        margin: const EdgeInsets.only(top: 40.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: inputTextField(
                                controller: _firstNameController,
                                focusNode: _firstNameFocus,
                                color: kLight,
                                hasError: false,
                                labelText: "Firstname",
                                textFieldStyle: GoogleFonts.roboto(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                  color: kPrimary,
                                ),
                                hintStyleStyle: GoogleFonts.roboto(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                  color: kPrimary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: inputTextField(
                                controller: _lastNameController,
                                focusNode: _lastNameFocus,
                                hasError: false,
                                labelText: "Lastname",
                                color: kLight,
                                textFieldStyle: GoogleFonts.roboto(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                  color: kPrimary,
                                ),
                                hintStyleStyle: GoogleFonts.roboto(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                  color: kPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        margin: const EdgeInsets.only(top: 40.0),
                        width: double.infinity,
                        child: inputTextField(
                          controller: _stationNameController,
                          focusNode: _stationNameFocus,
                          // obscureText: true,
                          hasError: false,
                          labelText: "Water Refilling Station Name",
                          color: kLight,
                          textFieldStyle: GoogleFonts.roboto(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400,
                            color: kPrimary,
                          ),
                          hintStyleStyle: GoogleFonts.roboto(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400,
                            color: kPrimary,
                          ),
                        ),
                      ),
                _global.registrationProperties["accountType"] == "station"
                    ? Container(
                        margin: const EdgeInsets.only(top: 10.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () => selectServiceHrs("open"),
                                child: Text(
                                  _openTime,
                                  style: GoogleFonts.roboto(
                                    fontSize: 14.0,
                                    fontWeight: _openTime == "Select Open Time"
                                        ? FontWeight.w400
                                        : FontWeight.bold,
                                    color: kLight,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            _openTime != "Select Open Time"
                                ? Text(
                                    "to",
                                    style: GoogleFonts.roboto(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w400,
                                      color: kLight.withOpacity(0.5),
                                    ),
                                  )
                                : const SizedBox(),
                            Expanded(
                              child: TextButton(
                                onPressed: () => selectServiceHrs("close"),
                                child: Text(
                                  _closingTime,
                                  style: GoogleFonts.roboto(
                                    fontSize: 14.0,
                                    fontWeight:
                                        _closingTime == "Select Closing Time"
                                            ? FontWeight.w400
                                            : FontWeight.bold,
                                    color: kLight,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 10.0),
                  child: inputNumberTextField(
                    controller: _contactController,
                    focusNode: _contactFocus,
                    hasError: false,
                    labelText: "Contact Number",
                    color: kLight,
                    textFieldStyle: GoogleFonts.roboto(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: kPrimary,
                    ),
                    hintStyleStyle: GoogleFonts.roboto(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: kPrimary,
                    ),
                  ),
                ),
                IgnorePointer(
                  ignoring: true,
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 10.0),
                    child: inputTextArea(
                      controller: _addressController,
                      focusNode: _addressFocus,
                      // obscureText: true,
                      hasError: false,
                      labelText: "Delivery Address",
                      color: kLight,
                      textFieldStyle: GoogleFonts.roboto(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: kPrimary,
                      ),
                      hintStyleStyle: GoogleFonts.roboto(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: kPrimary,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => syncLocation(),
                      style: TextButton.styleFrom(),
                      child: Text(
                        "SYNC LOCATION",
                        style: GoogleFonts.roboto(
                          fontSize: 10.0,
                          fontWeight: FontWeight.w500,
                          color: kLight,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                const Spacer(flex: 2),
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
      ),
    );
  }
}
