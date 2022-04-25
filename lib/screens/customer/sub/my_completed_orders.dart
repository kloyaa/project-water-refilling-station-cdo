import 'package:app/common/radius.dart';
import 'package:app/const/colors.dart';
import 'package:app/controllers/orderController.dart';
import 'package:app/controllers/profileController.dart';
import 'package:app/widget/snapshot.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:timelines/timelines.dart';

class MyCompletedOrders extends StatefulWidget {
  const MyCompletedOrders({Key? key}) : super(key: key);

  @override
  State<MyCompletedOrders> createState() => _MyCompletedOrdersState();
}

class _MyCompletedOrdersState extends State<MyCompletedOrders> {
  final _order = Get.put(OrderController());
  final _profile = Get.put(ProfileController());

  late Future<dynamic> _orders;

  Future<void> refresh() async {
    setState(() {
      _orders = _order.getOrders(
        accountId: _profile.profile["accountId"],
        accountType: "customer",
        status: "delivered",
      );
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _orders = _order.getOrders(
      accountId: _profile.profile["accountId"],
      accountType: "customer",
      status: "delivered",
    );
  }

  @override
  Widget build(BuildContext context) {
    final _appBar = AppBar(
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
        "My Order History",
        style: GoogleFonts.chivo(
          color: Colors.white,
          fontSize: 16.0,
        ),
      ),
    );

    return Scaffold(
      backgroundColor: kLight,
      appBar: _appBar,
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
                "Your Order History is empty",
              );
            }
          }
          return RefreshIndicator(
            onRefresh: () => refresh(),
            child: ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                final _itemQty = snapshot.data[index]["content"]["qty"];
                final _itemName = snapshot.data[index]["content"]["item"];
                final _item = "x$_itemQty $_itemName";
                final _total = snapshot.data[index]["content"]["total"];
                final _deliveryAddress =
                    snapshot.data[index]["header"]["customer"]["address"];

                return Container(
                  margin: const EdgeInsets.only(
                    top: 10.0,
                    left: 20.0,
                    right: 20.0,
                  ),
                  child: ListTile(
                    onTap: () {},
                    contentPadding: const EdgeInsets.all(20.0),
                    isThreeLine: true,
                    tileColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: kDefaultRadius,
                    ),
                    leading: Hero(
                      tag: snapshot.data[index]["_id"],
                      child: CachedNetworkImage(
                        imageUrl: snapshot.data[index]["header"]["station"]
                            ["img"],
                        placeholder: (context, url) => Container(
                          color: kLight,
                        ),
                        fit: BoxFit.cover,
                        width: 60,
                        height: 60,
                      ),
                    ),
                    title: Container(
                      margin: const EdgeInsets.only(top: 7.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "#${snapshot.data[index]["refNumber"]}",
                            style: GoogleFonts.roboto(
                              color: kPrimary,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                AntDesign.checkcircle,
                                color: Colors.greenAccent,
                                size: 20.0,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "Delivered",
                                style: GoogleFonts.chivo(
                                  color: kPrimary,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text(
                            Jiffy(snapshot.data[index]["date"]["updatedAt"])
                                .yMMMdjm,
                            style: GoogleFonts.roboto(
                              color: kPrimary.withOpacity(0.5),
                              fontSize: 10.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10.0),
                            child: const Divider(),
                          ),
                          Text(
                            "From",
                            style: GoogleFonts.roboto(
                              color: kPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 13.0,
                            ),
                          ),
                          Text(
                            snapshot.data[index]["header"]["station"]
                                ["address"],
                            style: GoogleFonts.roboto(
                              color: kPrimary,
                              fontWeight: FontWeight.w500,
                              fontSize: 10.0,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            "Destination",
                            style: GoogleFonts.roboto(
                              color: kPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 13.0,
                            ),
                          ),
                          Text(
                            _deliveryAddress,
                            style: GoogleFonts.roboto(
                              color: kPrimary,
                              fontWeight: FontWeight.w500,
                              fontSize: 10.0,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 10.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _item,
                                style: GoogleFonts.roboto(
                                  color: kPrimary,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12.0,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                "P$_total.0",
                                style: GoogleFonts.robotoMono(
                                  color: kPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22.0,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    subtitle: const SizedBox(),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
