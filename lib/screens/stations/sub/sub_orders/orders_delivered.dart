import 'package:app/common/radius.dart';
import 'package:app/const/colors.dart';
import 'package:app/controllers/orderController.dart';
import 'package:app/controllers/profileController.dart';
import 'package:app/controllers/userController.dart';
import 'package:app/widget/snapshot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:loading_indicator/loading_indicator.dart';

class PageDeliveredOrders extends StatefulWidget {
  const PageDeliveredOrders({Key? key}) : super(key: key);

  @override
  State<PageDeliveredOrders> createState() => _PageDeliveredOrdersState();
}

class _PageDeliveredOrdersState extends State<PageDeliveredOrders> {
  final _profile = Get.put(ProfileController());
  final _user = Get.put(UserController());
  final _order = Get.put(OrderController());

  Map profile = {};
  Map user = {};
  String _toUpdateId = "0";

  late Future<dynamic> _orders;

  Future<void> refresh() async {
    setState(() {
      _orders = _order.getOrders(
        accountId: _profile.profile["accountId"],
        accountType: _profile.profile["accountType"],
        status: "delivered",
      );
    });
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
      status: "delivered",
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: kLight,
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
                    "Sorry, you do not have any \nDelivered orders yet.",
                  );
                }
              }
              return RefreshIndicator(
                onRefresh: () => refresh(),
                child: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    final _fisrstName =
                        snapshot.data[index]["header"]["customer"]["firstName"];
                    final _lastName =
                        snapshot.data[index]["header"]["customer"]["lastName"];

                    final _refNumber = snapshot.data[index]["refNumber"];

                    final _item = snapshot.data[index]["content"]["item"];
                    final _qty = snapshot.data[index]["content"]["qty"];
                    final _total = snapshot.data[index]["content"]["total"];
                    final _dScehdule = snapshot.data[index]["header"]
                        ["customer"]["deliveryDateAndTime"];
                    final _deliveredOn =
                        snapshot.data[index]["date"]["updatedAt"];
                    return Container(
                      margin: const EdgeInsets.only(
                        top: 20.0,
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(20.0),
                        tileColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: kDefaultRadius,
                        ),
                        leading: Hero(
                          tag: snapshot.data[index]["refNumber"],
                          child: CircleAvatar(
                            backgroundColor: kPrimary,
                            backgroundImage: NetworkImage(
                              snapshot.data[index]["header"]["customer"]["img"],
                            ),
                            radius: 30.0,
                          ),
                        ),
                        title: Container(
                          margin: const EdgeInsets.only(top: 13.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "#$_refNumber",
                                style: GoogleFonts.robotoMono(
                                  color: kPrimary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.0,
                                ),
                              ),
                              Container(
                                child: Text(
                                  _fisrstName + ", " + _lastName,
                                  style: GoogleFonts.chivo(
                                    color: kSecondary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 25.0),
                                child: Text(
                                  "DELIVERY ADDRESS",
                                  style: GoogleFonts.chivo(
                                    color: kPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 2.0),
                                child: Text(
                                  snapshot.data[index]["header"]["customer"]
                                      ["address"],
                                  style: GoogleFonts.roboto(
                                    color: kPrimary,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 25.0),
                                child: Text(
                                  "DELIVERY SCHEDULE",
                                  style: GoogleFonts.chivo(
                                    color: kPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 2.0),
                                child: Text(
                                  _dScehdule,
                                  style: GoogleFonts.roboto(
                                    color: kPrimary,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 25.0),
                                child: Text(
                                  "DELIVERED ON",
                                  style: GoogleFonts.chivo(
                                    color: kPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 2.0),
                                child: Text(
                                  Jiffy(_deliveredOn).yMMMdjm,
                                  style: GoogleFonts.roboto(
                                    color: kPrimary,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 25.0),
                                child: Text(
                                  "ODER DETAIL",
                                  style: GoogleFonts.chivo(
                                    color: kPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 2.0),
                                child: Text(
                                  "x$_qty $_item",
                                  style: GoogleFonts.roboto(
                                    color: kPrimary,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  vertical: 20.0,
                                ),
                                child: const Divider(),
                              ),
                              Container(
                                child: Text(
                                  "SUB TOTAL",
                                  style: GoogleFonts.roboto(
                                    color: kPrimary,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 10.0,
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  "P$_total.0",
                                  style: GoogleFonts.robotoMono(
                                    color: kPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
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
