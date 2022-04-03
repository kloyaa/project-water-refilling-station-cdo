import 'package:app/common/pretty_print.dart';
import 'package:app/const/colors.dart';
import 'package:app/controllers/globalController.dart';
import 'package:app/controllers/orderController.dart';
import 'package:app/controllers/profileController.dart';
import 'package:app/controllers/userController.dart';
import 'package:app/widget/snapshot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomerOrders extends StatefulWidget {
  const CustomerOrders({Key? key}) : super(key: key);

  @override
  State<CustomerOrders> createState() => _CustomerOrdersState();
}

class _CustomerOrdersState extends State<CustomerOrders> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final _profile = Get.put(ProfileController());
  final _user = Get.put(UserController());
  final _global = Get.put(GlobalController());
  final _order = Get.put(OrderController());

  Map profile = {};
  Map user = {};
  String _toDeleteId = "0";
  late Future<dynamic> _orders;

  void selectCustomerOrder(data) {
    _global.selectedOrder = data;

    // Get.to(const PreviewStation());
    prettyPrint("SELECTED_ORDER", _global.selectedOrder);
  }

  Future<void> refresh() async {
    setState(() {
      _orders = _order.getOrders(
        accountId: _profile.profile["accountId"],
        accountType: _profile.profile["accountType"],
        status: "pending",
      );
    });
  }

  Future<void> delete(id) async {
    setState(() {
      _toDeleteId = id;
    });
    //await _order.deleteOrder(id);
    refresh();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // INITIALIZE
    profile = _profile.profile;
    user = _user.userLoginData;

    // INITIALIZE ORDERS
    _orders = _order.getOrders(
      accountId: _profile.profile["accountId"],
      accountType: _profile.profile["accountType"],
      status: "pending",
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: kPrimary,
          leading: const SizedBox(),
          leadingWidth: 0.0,
          title: Text(
            "Orders",
            style: GoogleFonts.roboto(
              color: Colors.white,
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
              DrawerHeader(
                padding: const EdgeInsets.all(0),
                decoration: BoxDecoration(
                  color: kPrimary,
                  image: DecorationImage(
                    image: NetworkImage(profile["img"]),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      kPrimary.withOpacity(0.8),
                      BlendMode.overlay,
                    ),
                  ),
                ),
                child: UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(color: Colors.transparent),
                  currentAccountPictureSize: const Size.square(70.0),
                  margin: const EdgeInsets.all(0),
                  accountName: Text(
                    profile["stationName"],
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
              ),
              const SizedBox(height: 15),
              ListTile(
                onTap: () => Get.toNamed("/station-create-listings"),
                isThreeLine: true,
                leading: const Icon(
                  FontAwesome.cog,
                  color: kPrimary,
                ),
                title: Text(
                  "Listings",
                  style: GoogleFonts.roboto(
                    color: kPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  "Manage your Water Refilling \nStation Items",
                  style: GoogleFonts.roboto(
                    color: kPrimary.withOpacity(0.5),
                    fontSize: 12.0,
                  ),
                ),
              ),
              ListTile(
                onTap: () {},
                isThreeLine: true,
                leading: const Icon(
                  MaterialCommunityIcons.washing_machine,
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
                  "View Customer Laundry \nOrders",
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
            future: _orders,
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
                    "Sorry, you do not have any \norders yet.",
                  );
                }
              }
              return RefreshIndicator(
                onRefresh: () => refresh(),
                child: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () => selectCustomerOrder(
                        snapshot.data[index],
                      ),
                      contentPadding: EdgeInsets.only(
                        top: index == 0 ? 40.0 : 15,
                        left: 30.0,
                        right: 30.0,
                        bottom: 15.0,
                      ),
                      leading: CircleAvatar(
                        backgroundColor: kPrimary,
                        backgroundImage: NetworkImage(
                          snapshot.data[index]["header"]["customer"]["avatar"],
                        ),
                        radius: 30.0,
                      ),
                      trailing: _toDeleteId == snapshot.data[index]["_id"]
                          ? const SizedBox(
                              height: 25.0,
                              width: 25.0,
                              child: CircularProgressIndicator(
                                color: Colors.red,
                                strokeWidth: 1.5,
                              ),
                            )
                          : GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => delete(
                                snapshot.data[index]["_id"],
                              ),
                              child: const Icon(
                                AntDesign.close,
                                color: Colors.red,
                              ),
                            ),
                      title: Container(
                        margin: const EdgeInsets.only(top: 13.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.data[index]["header"]["customer"]
                                  ["firstName"],
                              style: GoogleFonts.roboto(
                                color: kPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 10.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    MaterialCommunityIcons.truck_delivery,
                                    color: kPrimary.withOpacity(0.8),
                                    size: 15,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    "DELIVERY ADDRESS",
                                    style: GoogleFonts.roboto(
                                      color: kPrimary.withOpacity(0.8),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              snapshot.data[index]["header"]["customer"]
                                  ["address"],
                              style: GoogleFonts.roboto(
                                color: kPrimary.withOpacity(0.5),
                                fontWeight: FontWeight.w400,
                                fontSize: 12.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
      ),
    );
  }
}
