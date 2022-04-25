import 'package:app/common/destroy_textFocus.dart';
import 'package:app/common/radius.dart';
import 'package:app/const/colors.dart';
import 'package:app/controllers/globalController.dart';
import 'package:app/controllers/listingsController.dart';
import 'package:app/controllers/orderController.dart';
import 'package:app/controllers/profileController.dart';
import 'package:app/widget/snapshot.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';

class PreviewStation extends StatefulWidget {
  const PreviewStation({Key? key}) : super(key: key);

  @override
  State<PreviewStation> createState() => _PreviewStationState();
}

class _PreviewStationState extends State<PreviewStation> {
  final _profile = Get.put(ProfileController());
  final _global = Get.put(GlobalController());
  final _listings = Get.put(ListingsController());
  final _order = Get.put(OrderController());

  late Future<dynamic> _stationListings;
  Map selectedItem = {};
  String selectedItemId = "";
  int selectedItemQty = 1;
  int total = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // INITIALIZE VARIABLES
    _stationListings = _listings.getListings();
  }

  Future<void> refresh() async {
    setState(() {
      _stationListings = _listings.getListings();
    });
  }

  Future<void> callNumber(number) async {
    try {
      await FlutterPhoneDirectCaller.callNumber(number);
    } catch (e) {
      print(e);
    }
  }

  Future<void> placeOrder() async {
    if (selectedItem.isNotEmpty) {
      int total = int.parse(selectedItem["price"] ?? 0) * selectedItemQty;
      if (selectedItemQty >= 11) {
        total -= int.parse(selectedItem["price"]);
      }
      return BottomPicker.dateTime(
        height: Get.height * 0.50,
        title: "Select Delivery Date and Time",
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
        minDateTime: DateTime.now(),
        displayButtonIcon: false,
        buttonText: "CONFIRM ORDER",
        buttonTextStyle: GoogleFonts.roboto(color: kLight),
        onSubmit: (date) {
          _order.createOrder({
            "header": {
              "customer": {
                "accountId": _profile.profile["accountId"],
                "firstName": _profile.profile["name"]["first"],
                "lastName": _profile.profile["name"]["last"],
                "contactNo": _profile.profile["contact"]["number"],
                "address": _profile.profile["address"]["name"],
                "img": _profile.profile["img"],
                "deliveryDateAndTime": Jiffy(date).yMMMdjm,
              },
              "station": {
                "accountId": _global.selectedStation["accountId"],
                "name": _global.selectedStation["stationName"],
                "contactNo": _global.selectedStation["contact"]["number"],
                "address": _global.selectedStation["address"]["name"],
                "img": _global.selectedStation["img"]
              }
            },
            "content": {
              "item": selectedItem["title"],
              "total": total,
              "qty": selectedItemQty >= 10
                  ? selectedItemQty += 1
                  : selectedItemQty,
            },
            "status": "pending",
          });
        },
        onClose: () {
          print("Picker closed");
        },
        use24hFormat: false,
      ).show(context);
    }
  }

  void changeStickiness() {}

  void changeQty(type) {
    if (type == "add") {
      setState(() {
        selectedItemQty += 1;
      });
    }
    if (selectedItemQty > 1) {
      if (type == "minus") {
        setState(() {
          selectedItemQty -= 1;
        });
      }
    }
  }

  void onSelect(data) {
    if (selectedItemId != data["_id"]) {
      setState(() {
        selectedItemQty = 1;
        selectedItemId = data["_id"];
        selectedItem = data;
      });
    }
  }

  int _total() {
    int total = int.parse(selectedItem["price"] ?? "0") * selectedItemQty;
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => destroyTextFieldFocus(context),
        child: Scaffold(
          backgroundColor: kLight,
          resizeToAvoidBottomInset: false,
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                stretch: true,
                backgroundColor: kPrimary,
                pinned: true,
                leading: IconButton(
                  onPressed: () => Get.back(),
                  splashRadius: 20.0,
                  icon: const Icon(
                    AntDesign.arrowleft,
                    color: Colors.white,
                  ),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _global.selectedStation["stationName"],
                      style: GoogleFonts.chivo(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Open ${_global.selectedStation["serviceHrs"]}",
                      style: GoogleFonts.chivo(
                        color: Colors.white,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: _global.selectedStation["accountId"],
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            _global.selectedStation["img"],
                          ),
                          colorFilter: ColorFilter.mode(
                            kPrimary.withOpacity(0.9),
                            BlendMode.overlay,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  stretchModes: const [
                    StretchMode.blurBackground,
                    StretchMode.zoomBackground,
                    StretchMode.fadeTitle,
                  ],
                ),
                actions: [
                  IconButton(
                    onPressed: () => callNumber(
                      _global.selectedStation["contact"]["number"],
                    ),
                    splashRadius: 20,
                    icon: const Icon(
                      FontAwesome.phone_square,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SliverFillRemaining(
                child: FutureBuilder(
                    future: _stationListings,
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.none) {
                        return snapshotSpinner();
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return snapshotSpinner();
                      }
                      if (snapshot.data == null) {
                        return snapshotSpinner();
                      }
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.data.length == 0) {
                          return snapshotEmptyMessage(
                            "There are no listings available",
                          );
                        }
                      }

                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final _isSelected =
                              selectedItemId == snapshot.data[index]["_id"];

                          return Container(
                            margin: const EdgeInsets.only(
                              top: 10.0,
                              left: 20.0,
                              right: 20.0,
                            ),
                            child: CheckboxListTile(
                              value: _isSelected,
                              onChanged: (v) {
                                onSelect(snapshot.data[index]);
                              },
                              contentPadding: const EdgeInsets.only(
                                top: 10,
                                bottom: 10,
                                left: 30,
                                right: 30,
                              ),
                              tileColor: Colors.white,
                              shape: const RoundedRectangleBorder(
                                borderRadius: kDefaultRadius,
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    snapshot.data[index]["title"],
                                    style: GoogleFonts.roboto(
                                      color: kPrimary,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  _isSelected
                                      ? selectedItemQty >= 10
                                          ? Container(
                                              padding: const EdgeInsets.all(
                                                5.0,
                                              ),
                                              margin: const EdgeInsets.only(
                                                top: 5.0,
                                              ),
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                    5.0,
                                                  ),
                                                ),
                                                color: Colors.greenAccent,
                                              ),
                                              child: Text(
                                                "Get 1 for free",
                                                style: GoogleFonts.roboto(
                                                  color: kLight,
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            )
                                          : const SizedBox()
                                      : const SizedBox(),
                                  _isSelected
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "P${_total()}.0",
                                              style: GoogleFonts.robotoMono(
                                                color: kSecondary,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17.0,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                IconButton(
                                                  onPressed: () =>
                                                      changeQty("minus"),
                                                  splashRadius: 20,
                                                  icon: const Icon(
                                                    AntDesign.minussquare,
                                                    color: kPrimary,
                                                  ),
                                                ),
                                                Text(
                                                  selectedItemQty.toString(),
                                                  style: GoogleFonts.roboto(
                                                    color: kPrimary,
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: () =>
                                                      changeQty("add"),
                                                  splashRadius: 20,
                                                  icon: const Icon(
                                                    AntDesign.plussquare,
                                                    color: kPrimary,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                              isThreeLine: false,
                              dense: true,
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                          );
                        },
                      );
                    }),
              ),
            ],
          ),
          bottomNavigationBar: BottomAppBar(
            child: IgnorePointer(
              ignoring: selectedItem.isNotEmpty ? false : true,
              child: AnimatedOpacity(
                opacity: selectedItem.isNotEmpty ? 1 : 0.5,
                duration: const Duration(seconds: 1),
                child: Container(
                  padding: const EdgeInsets.all(25.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "TOTAL",
                              style: GoogleFonts.chivo(
                                color: kPrimary,
                                fontSize: 10.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "P${_total()}.0",
                              style: GoogleFonts.chivo(
                                color: kPrimary,
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          width: double.infinity,
                          height: 62,
                          child: TextButton(
                            onPressed: () => placeOrder(),
                            style: TextButton.styleFrom(
                              //primary: kFadeWhite,
                              backgroundColor: kPrimary,
                              shape: const RoundedRectangleBorder(
                                borderRadius: kDefaultRadius,
                              ),
                            ),
                            child: Text(
                              "PLACE ORDER",
                              style: GoogleFonts.roboto(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                                color: kLight,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
