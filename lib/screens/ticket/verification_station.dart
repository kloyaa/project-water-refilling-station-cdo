import 'dart:io';
import 'package:app/common/destroy_textFocus.dart';
import 'package:app/common/radius.dart';
import 'package:app/const/colors.dart';
import 'package:app/controllers/profileController.dart';
import 'package:app/controllers/userController.dart';
import 'package:app/controllers/verificationController.dart';
import 'package:app/form/input.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class VerificationStation extends StatefulWidget {
  const VerificationStation({Key? key}) : super(key: key);

  @override
  State<VerificationStation> createState() => _VerificationStationState();
}

class _VerificationStationState extends State<VerificationStation> {
  final _verificationController = Get.put(VerificationController());
  final _profile = Get.put(ProfileController());
  final _user = Get.put(UserController());

  final ImagePicker _picker = ImagePicker();

  String _img1Path = "";
  String _img1Name = "";

  late TextEditingController _addressController;
  late TextEditingController _contactNoController;
  late TextEditingController _fullNameController;

  late FocusNode _addressFocus;
  late FocusNode _fullNameFocus;

  late FocusNode _contactFocus;
  var path;

  Future<void> selectImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _img1Path = image.path;
        _img1Name = image.name;
      });
    }
  }

  void removeSelectedImage() async {
    setState(() {
      _img1Path = "";
      _img1Name = "";
    });
  }

  Future<void> submitTicket() async {
    final _contactNo = _contactNoController.text.trim();
    final _address = _addressController.text.trim();

    if (_img1Path.isEmpty) {
      return selectImage();
    }
    if (_address.isEmpty) {
      return _addressFocus.requestFocus();
    }
    if (_contactNo.isEmpty) {
      return _contactFocus.requestFocus();
    }
    Get.toNamed("/loading");
    await _verificationController.submitStationVerificationTicket(
      data: {
        "img": {
          "path": _img1Path,
          "name": _img1Name,
        },
      },
    );
    Get.toNamed("/station-customer-orders");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _addressController = TextEditingController();
    _contactNoController = MaskedTextController(mask: '0000 000 0000');
    _addressFocus = FocusNode();
    _contactFocus = FocusNode();
    // path = Get.arguments["path"];

    _fullNameController = TextEditingController();
    _fullNameFocus = FocusNode();

    _fullNameController.text = _profile.profile["stationName"];
    _addressController.text = _profile.profile["address"]["name"];
    _contactNoController.text = _profile.profile["contact"]["number"];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => destroyTextFieldFocus(context),
      child: WillPopScope(
        onWillPop: () async => true,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
              toolbarHeight: 60.0,
              backgroundColor: kPrimary,
              leading: IconButton(
                splashRadius: 20.0,
                onPressed: () => Get.back(),
                icon: const Icon(
                  AntDesign.arrowleft,
                  color: kLight,
                ),
              ),
              elevation: 0,
              shadowColor: Colors.white,
              // shape: Border(
              //   bottom: BorderSide(color: secondary.withOpacity(0.2), width: 0.5),
              // ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Business Verification",
                    style: GoogleFonts.chivo(
                      color: kLight,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                  ),
                  Text(
                    "UPLOAD BUSINESS PERMIT",
                    style: GoogleFonts.roboto(
                      color: kLight,
                      fontSize: 10.0,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
              actions: [
                IconButton(
                  padding: const EdgeInsets.all(0),
                  splashRadius: 20.0,
                  onPressed: () => _user.logout(),
                  icon: const Icon(
                    AntDesign.logout,
                    color: kLight,
                  ),
                ),
              ]),
          backgroundColor: kPrimary,
          body: Container(
            padding: const EdgeInsets.only(left: 30.0, right: 30.0),
            width: Get.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  child: _img1Path == ""
                      ? GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () async => await selectImage(),
                          child: DottedBorder(
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(15),
                            dashPattern: const [10, 10],
                            color: kLight,
                            strokeWidth: 1.5,
                            child: Stack(
                              children: [
                                SizedBox(
                                  height: Get.height * 0.30,
                                  width: Get.width,
                                ),
                                const Positioned.fill(
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
                      : DottedBorder(
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(15),
                          dashPattern: const [10, 10],
                          color: Colors.transparent,
                          strokeWidth: 1.5,
                          child: Stack(
                            children: [
                              Image.file(
                                File(_img1Path),
                                height: Get.height * 0.30,
                                width: Get.width,
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                top: 25,
                                right: 30,
                                child: IconButton(
                                  splashRadius: 20.0,
                                  onPressed: () => removeSelectedImage(),
                                  icon: const Icon(
                                    AntDesign.closecircle,
                                    color: Colors.white,
                                    size: 40.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
                const Spacer(),
                SizedBox(
                  width: Get.width,
                  child: IgnorePointer(
                    ignoring: true,
                    child: inputTextField(
                      controller: _fullNameController,
                      focusNode: _fullNameFocus,
                      labelText: "Business name",
                      hasError: false,
                      textFieldStyle: GoogleFonts.roboto(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.black54,
                      ),
                      hintStyleStyle: GoogleFonts.roboto(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w300,
                      ),
                      color: kLight,
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                SizedBox(
                  width: Get.width,
                  child: IgnorePointer(
                    ignoring: true,
                    child: inputTextField(
                      controller: _addressController,
                      focusNode: _addressFocus,
                      labelText: "Business Address",
                      hasError: false,
                      textFieldStyle: GoogleFonts.roboto(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.black54,
                      ),
                      hintStyleStyle: GoogleFonts.roboto(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w300,
                      ),
                      color: kLight,
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                SizedBox(
                  width: Get.width,
                  child: IgnorePointer(
                    ignoring: true,
                    child: inputNumberTextField(
                      color: kLight,
                      controller: _contactNoController,
                      focusNode: _contactFocus,
                      hasError: false,
                      labelText: "Business Contact Number",
                      textFieldStyle: GoogleFonts.roboto(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.black54,
                      ),
                      hintStyleStyle: GoogleFonts.roboto(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
                const Spacer(flex: 5),
                SizedBox(
                  width: double.infinity,
                  height: 62,
                  child: TextButton(
                    onPressed: () => submitTicket(),
                    style: TextButton.styleFrom(
                      //primary: kFadeWhite,
                      backgroundColor: kLight,
                      shape: const RoundedRectangleBorder(
                        borderRadius: kDefaultRadius,
                      ),
                    ),
                    child: Text(
                      "SUBMIT TICKET",
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
