import 'package:app/common/destroy_textFocus.dart';
import 'package:app/common/radius.dart';
import 'package:app/const/colors.dart';
import 'package:app/controllers/listingsController.dart';
import 'package:app/widget/snapshot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';

class CreatedListings extends StatefulWidget {
  const CreatedListings({Key? key}) : super(key: key);

  @override
  State<CreatedListings> createState() => _CreatedListingsState();
}

class _CreatedListingsState extends State<CreatedListings> {
  String _toDeleteId = "";
  final _listing = Get.put(ListingsController());

  late Future<dynamic> _listings;

  Future<void> onDelete(id) async {
    setState(() {
      _toDeleteId = id;
    });
    await _listing.deleteListing(id);
    refresh();
  }

  Future<void> refresh() async {
    setState(() {
      _listings = _listing.getMyListings();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listings = _listing.getMyListings();
  }

  @override
  Widget build(BuildContext context) {
    final _appBar = AppBar(
      elevation: 0,
      backgroundColor: kPrimary,
      leading: IconButton(
        onPressed: () => Get.toNamed("/station-customer-orders"),
        splashRadius: 20.0,
        icon: const Icon(
          AntDesign.arrowleft,
          color: Colors.white,
        ),
      ),
      title: Text(
        "My Listings",
        style: GoogleFonts.chivo(
          color: Colors.white,
          fontSize: 16.0,
        ),
      ),
    );

    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => destroyTextFieldFocus(context),
        child: Scaffold(
          backgroundColor: kLight,
          appBar: _appBar,
          body: FutureBuilder(
            future: _listings,
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
                    "You have no listings available\nplease create a new one.",
                  );
                }
              }
              return RefreshIndicator(
                onRefresh: () => refresh(),
                child: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(
                        top: index == 0 ? 40 : 10.0,
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: ListTile(
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
                        trailing: _toDeleteId == snapshot.data[index]["_id"]
                            ? const SizedBox(
                                height: 25.0,
                                width: 25.0,
                                child: LoadingIndicator(
                                  indicatorType: Indicator.ballSpinFadeLoader,
                                  colors: [Colors.redAccent],
                                  strokeWidth: 1,
                                ),
                              )
                            : GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () =>
                                    onDelete(snapshot.data[index]["_id"]),
                                child: const Icon(
                                  FontAwesome.trash,
                                  color: Colors.red,
                                ),
                              ),
                        title: Text(
                          snapshot.data[index]["title"],
                          style: GoogleFonts.chivo(
                            color: kPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14.0,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          "P${snapshot.data[index]["price"]}",
                          style: GoogleFonts.robotoMono(
                            color: kPrimary,
                            fontWeight: FontWeight.w400,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
