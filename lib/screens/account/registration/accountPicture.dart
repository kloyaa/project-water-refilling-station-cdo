import 'dart:io';

import 'package:app/common/radius.dart';
import 'package:app/common/spacing.dart';
import 'package:app/const/colors.dart';
import 'package:app/controllers/globalController.dart';
import 'package:app/controllers/userController.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class RegisterAccountPicture extends StatefulWidget {
  const RegisterAccountPicture({Key? key}) : super(key: key);

  @override
  State<RegisterAccountPicture> createState() => _RegisterAccountPictureState();
}

class _RegisterAccountPictureState extends State<RegisterAccountPicture> {
  final _user = Get.put(UserController());
  final _global = Get.put(GlobalController());

  final ImagePicker _picker = ImagePicker();
  String _img1Path = "";
  String _img1Name = "";

  void removeSelectedImage() async {
    setState(() {
      _img1Path = "";
      _img1Name = "";
    });
  }

  Future<void> selectImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _img1Path = image.path;
        _img1Name = image.name;
      });
    }
  }

  Future<void> onRegister() async {
    if (_img1Path.isEmpty) {
      return selectImage();
    }
    if (_img1Name.isEmpty) {
      return selectImage();
    }

    _global.registrationProperties.addAll(
      {
        "img": {
          "name": _img1Name,
          "path": _img1Path,
        },
      },
    );

    await _user.createProfile();
  }

  @override
  Widget build(BuildContext context) {
    final _breadCrumbs = Container(
      margin: kDefaultBodyPadding.copyWith(left: 15.0),
      child: Row(
        children: [
          Text(
            "Account",
            style: GoogleFonts.roboto(
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
            style: GoogleFonts.roboto(
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
            style: GoogleFonts.roboto(
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
            _global.registrationProperties["accountType"] == "customer"
                ? "Avatar"
                : "Banner",
            style: GoogleFonts.roboto(
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
          ? "Upload Avatar"
          : "Upload Banner",
      style: GoogleFonts.chivo(
        fontSize: 25.0,
        fontWeight: FontWeight.bold,
        color: kLight,
      ),
    );
    final _subTitle = Text(
      "We are almost done",
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
              const Spacer(flex: 2),
              _global.registrationProperties["accountType"] == "customer"
                  ? SizedBox(
                      width: double.infinity,
                      child: Center(
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(300)),
                          child: _img1Path == ""
                              ? GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () async => await selectImage(),
                                  child: DottedBorder(
                                    borderType: BorderType.Circle,
                                    dashPattern: const [10, 10],
                                    color: kLight,
                                    strokeWidth: 1.5,
                                    child: Stack(
                                      children: const [
                                        SizedBox(
                                          height: 200,
                                          width: 200,
                                        ),
                                        Positioned.fill(
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Icon(
                                              AntDesign.plus,
                                              color: kLight,
                                              size: 34.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () => selectImage(),
                                  child: Image.file(
                                    File(_img1Path),
                                    height: 200,
                                    width: 200,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                      ),
                    )
                  : SizedBox(
                      width: double.infinity,
                      child: Center(
                        child: ClipRRect(
                          // borderRadius:
                          //     const BorderRadius.all(Radius.circular(300)),
                          child: _img1Path == ""
                              ? GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () async => await selectImage(),
                                  child: DottedBorder(
                                    borderType: BorderType.Rect,
                                    dashPattern: const [10, 10],
                                    color: kLight,
                                    strokeWidth: 1.5,
                                    child: Stack(
                                      children: const [
                                        SizedBox(
                                          height: 200,
                                          width: double.infinity,
                                        ),
                                        Positioned.fill(
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Icon(
                                              AntDesign.plus,
                                              color: kLight,
                                              size: 34.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () => selectImage(),
                                  child: Image.file(
                                    File(_img1Path),
                                    height: 200,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                      ),
                    ),
              const Spacer(flex: 2),
              _global.registrationProperties["accountType"] == "customer"
                  ? SizedBox(
                      width: double.infinity,
                      child: Text(
                        "${_global.registrationProperties["name"]["first"]}, ${_global.registrationProperties["name"]["last"]}",
                        style: GoogleFonts.chivo(
                          fontSize: 26.0,
                          fontWeight: FontWeight.w400,
                          color: kLight,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : SizedBox(
                      width: double.infinity,
                      child: Text(
                        _global.registrationProperties["stationName"],
                        style: GoogleFonts.chivo(
                          fontSize: 26.0,
                          fontWeight: FontWeight.w400,
                          color: kLight,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
              _global.registrationProperties["accountType"] == "station"
                  ? Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Text(
                        "Service Hours ${_global.registrationProperties["serviceHrs"]}",
                        style: GoogleFonts.roboto(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w300,
                          color: kLight,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : const SizedBox(),
              Container(
                width: double.infinity,
                margin:
                    const EdgeInsets.only(left: 30.0, right: 30.0, top: 5.0),
                child: Text(
                  _global.registrationProperties["address"]["name"],
                  style: GoogleFonts.roboto(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w300,
                    color: kLight,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 40.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    _global.registrationProperties["contact"]["number"],
                    style: GoogleFonts.robotoMono(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w300,
                      color: kLight,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    _global.registrationProperties["contact"]["email"],
                    style: GoogleFonts.robotoMono(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w300,
                      color: kLight,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const Spacer(flex: 3),
              SizedBox(
                width: double.infinity,
                height: 62,
                child: TextButton(
                  onPressed: () => onRegister(),
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
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}
