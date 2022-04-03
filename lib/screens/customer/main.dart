import 'package:app/common/pretty_print.dart';
import 'package:app/common/radius.dart';
import 'package:app/const/colors.dart';
import 'package:app/controllers/globalController.dart';
import 'package:app/controllers/profileController.dart';
import 'package:app/controllers/userController.dart';
import 'package:app/screens/customer/sub/preview_station.dart';
import 'package:app/widget/snapshot.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class NearbyWaterRefillingStations extends StatefulWidget {
  const NearbyWaterRefillingStations({Key? key}) : super(key: key);

  @override
  State<NearbyWaterRefillingStations> createState() =>
      _NearbyWaterRefillingStationsState();
}

class _NearbyWaterRefillingStationsState
    extends State<NearbyWaterRefillingStations> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final _profile = Get.put(ProfileController());
  final _user = Get.put(UserController());
  final _global = Get.put(GlobalController());

  late Future<dynamic> _waterRefillingStations;

  Map profile = {};
  Map user = {};

  Future<void> refresh() async {
    setState(() {
      _waterRefillingStations = _profile.getWaterRefillingStations();
    });
  }

  void selectStation(data) {
    _global.selectedStation = data;

    Get.to(() => const PreviewStation());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profile = _profile.profile;
    user = _user.userLoginData;
    _waterRefillingStations = _profile.getWaterRefillingStations();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: kLight,
        appBar: AppBar(
          //title: _breadCrumbs,
          backgroundColor: kPrimary,
          leading: const SizedBox(),
          leadingWidth: 0.0,
          title: Text(
            "Water Refilling Stations",
            style: GoogleFonts.chivo(
              color: kLight,
              fontSize: 16.0,
            ),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 15.0),
              child: IconButton(
                onPressed: () => _scaffoldKey.currentState!.openDrawer(),
                splashRadius: 20.0,
                icon: const Icon(
                  AntDesign.ellipsis1,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
        drawer: Drawer(
          backgroundColor: Colors.white,
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                decoration: const BoxDecoration(color: kPrimary),
                currentAccountPictureSize: const Size.square(70.0),
                currentAccountPicture: CircleAvatar(
                  radius: 70.0,
                  backgroundColor: kPrimary,
                  backgroundImage: NetworkImage(
                    profile["img"],
                  ),
                ),
                accountName: Text(
                  profile["name"]["first"] + " " + profile["name"]["last"],
                  style: GoogleFonts.chivo(
                    color: Colors.white,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                accountEmail: Text(
                  profile["contact"]["email"],
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: 12.0,
                  ),
                ),
              ),
              ListTile(
                onTap: () => Get.toNamed("/customer-orders"),
                isThreeLine: true,
                leading: const Icon(
                  MaterialCommunityIcons.receipt,
                  color: kPrimary,
                ),
                title: Text(
                  "Orders",
                  style: GoogleFonts.roboto(
                    color: kPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  "View My Current Orders and \nHistory",
                  style: GoogleFonts.roboto(
                    color: kPrimary.withOpacity(0.5),
                    fontSize: 12.0,
                  ),
                ),
              ),
              const Spacer(),
              const Divider(),
              ListTile(
                onTap: () => _user.logout(),
                leading: const Icon(
                  MaterialIcons.logout,
                  size: 22,
                  color: kPrimary,
                ),
                title: Text(
                  "Logout",
                  style: GoogleFonts.roboto(
                    color: kPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
        body: FutureBuilder(
          future: _waterRefillingStations,
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
                  "Sorry, We did not find any nearby\nWater Refilling Stations in your area.",
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
                      onTap: () => selectStation(snapshot.data[index]),
                      contentPadding: const EdgeInsets.all(20.0),
                      tileColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: kDefaultRadius,
                      ),
                      leading: Hero(
                        tag: snapshot.data[index]["accountId"],
                        child: CachedNetworkImage(
                          imageUrl: snapshot.data[index]["img"],
                          placeholder: (context, url) => Container(
                            color: kLight,
                          ),
                          fit: BoxFit.cover,
                          width: 60,
                          height: 60,
                        ),
                      ),
                      title: Text(
                        snapshot.data[index]["stationName"],
                        style: GoogleFonts.chivo(
                          color: kPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 17.0,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            snapshot.data[index]["address"]["name"],
                            style: GoogleFonts.roboto(
                              color: kPrimary,
                              fontWeight: FontWeight.w400,
                              fontSize: 12.0,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Fontisto.map_marker_alt,
                                  color: kPrimary,
                                  size: 12.0,
                                ),
                                const SizedBox(width: 5.0),
                                Text(
                                  "${snapshot.data[index]["distanceBetween"]}km",
                                  style: GoogleFonts.roboto(
                                    color: kPrimary,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
