import 'package:app/common/destroy_textFocus.dart';
import 'package:app/common/radius.dart';
import 'package:app/common/spacing.dart';
import 'package:app/const/colors.dart';
import 'package:app/controllers/listingsController.dart';
import 'package:app/form/input.dart';
import 'package:app/screens/stations/sub/created_listings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateListing extends StatefulWidget {
  const CreateListing({Key? key}) : super(key: key);

  @override
  State<CreateListing> createState() => _CreateListingState();
}

class _CreateListingState extends State<CreateListing> {
  final _listing = Get.put(ListingsController());
  late TextEditingController _titleController;
  late FocusNode _titleFocus;
  late TextEditingController _priceController;
  late FocusNode _priceFocus;

  Future<void> createListing() async {
    final _title = _titleController.text.trim();
    final _price = _priceController.text.trim();
    if (_title.isEmpty) {
      return _titleFocus.requestFocus();
    }
    if (_price.isEmpty) {
      return _priceFocus.requestFocus();
    }
    await _listing.addListing(
      title: _title,
      price: _price,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _priceController = TextEditingController();
    _priceFocus = FocusNode();
    _titleController = TextEditingController();
    _titleFocus = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => destroyTextFieldFocus(context),
        child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: kPrimary,
            leading: IconButton(
              onPressed: () => Get.back(),
              splashRadius: 20.0,
              icon: const Icon(
                AntDesign.arrowleft,
                color: Colors.white,
              ),
            ),
            title: Text(
              "Create Listing",
              style: GoogleFonts.chivo(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 15.0),
                child: IconButton(
                  onPressed: () => Get.to(const CreatedListings()),
                  splashRadius: 20.0,
                  icon: const Icon(
                    Feather.list,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
          body: Container(
            padding: kDefaultBodyPadding,
            child: Column(
              children: [
                const Spacer(),
                Container(
                  child: inputTextField(
                    labelText: "Name",
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
                    controller: _titleController,
                    focusNode: _titleFocus,
                    hasError: false,
                    color: kLight,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  child: inputNumberTextField(
                    labelText: "Price",
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
                    controller: _priceController,
                    focusNode: _priceFocus,
                    hasError: false,
                    color: kLight,
                  ),
                ),
                const Spacer(flex: 10),
                Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 62,
                    child: TextButton(
                      onPressed: () => createListing(),
                      style: TextButton.styleFrom(
                        //primary: kFadeWhite,
                        backgroundColor: kLight,
                        shape: const RoundedRectangleBorder(
                          borderRadius: kDefaultRadius,
                        ),
                      ),
                      child: Text(
                        "ADDD LISTING",
                        style: GoogleFonts.roboto(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: kPrimary,
                        ),
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
