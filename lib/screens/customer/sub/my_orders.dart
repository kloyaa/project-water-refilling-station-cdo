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
import 'package:timelines/timelines.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({Key? key}) : super(key: key);

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  final _order = Get.put(OrderController());
  final _profile = Get.put(ProfileController());

  late Future<dynamic> _orders;

  Future<void> refresh() async {
    setState(() {
      _orders = _order.getOrders(
        accountId: _profile.profile["accountId"],
        accountType: "customer",
        status: "pending",
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
      status: "pending",
    );
  }

  @override
  Widget build(BuildContext context) {
    final _appBar = AppBar(
      elevation: 0,
      backgroundColor: kPrimary,
      leading: IconButton(
        onPressed: () => Get.toNamed("/customer"),
        splashRadius: 20.0,
        icon: const Icon(
          AntDesign.arrowleft,
          color: Colors.white,
        ),
      ),
      title: Text(
        "My Orders",
        style: GoogleFonts.chivo(
          color: Colors.white,
          fontSize: 16.0,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          splashRadius: 20,
          icon: const Icon(
            FontAwesome.history,
            color: Colors.white,
          ),
        ),
      ],
    );
    const _timelineNode = TimelineNode(
      indicator: DotIndicator(color: kPrimary),
      startConnector: SolidLineConnector(color: kSecondary),
      endConnector: SolidLineConnector(color: kSecondary),
    );

    List<TimelineTile> timeline(data) {
      final _timelines = [
        TimelineTile(
          nodeAlign: TimelineNodeAlign.start,
          contents: Container(
            margin: const EdgeInsets.only(left: 10.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: data["status"] == "pending" ? kPrimary : Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            ),
            child: Text(
              "Pending",
              style: GoogleFonts.roboto(
                color: data["status"] == "pending" ? Colors.white : kPrimary,
                fontSize: 12.0,
              ),
            ),
          ),
          node: _timelineNode,
        ),
        TimelineTile(
          nodeAlign: TimelineNodeAlign.start,
          contents: Container(
            margin: const EdgeInsets.only(left: 10.0, top: 20.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: data["status"] == "in-progress" ? kPrimary : Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            ),
            child: Text(
              "Order is already in-progress",
              style: GoogleFonts.roboto(
                color:
                    data["status"] == "in-progress" ? Colors.white : kPrimary,
                fontSize: 12.0,
              ),
            ),
          ),
          node: _timelineNode,
        ),
        TimelineTile(
          nodeAlign: TimelineNodeAlign.start,
          contents: Container(
            margin: const EdgeInsets.only(left: 10.0, top: 20.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: data["status"] == "ready" ? kPrimary : Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Ready",
                  style: GoogleFonts.roboto(
                    color: data["status"] == "ready" ? Colors.white : kPrimary,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Delivery Schedule",
                  style: GoogleFonts.roboto(
                    color: data["status"] == "ready" ? Colors.white : kPrimary,
                    fontSize: 12.0,
                  ),
                ),
                Text(
                  data["header"]["customer"]["deliveryDateAndTime"],
                  style: GoogleFonts.roboto(
                    color: data["status"] == "ready" ? Colors.white : kPrimary,
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
          ),
          node: _timelineNode,
        ),
        TimelineTile(
          nodeAlign: TimelineNodeAlign.start,
          contents: Container(
            margin: const EdgeInsets.only(left: 10.0, top: 20.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: data["status"] == "delivered" ? kPrimary : Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            ),
            child: Text(
              "Order has been delivered",
              style: GoogleFonts.roboto(
                color: data["status"] == "delivered" ? Colors.white : kPrimary,
                fontSize: 12.0,
              ),
            ),
          ),
          node: _timelineNode,
        ),
      ];
      return _timelines;
    }

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
                "Sorry, We did not find any nearby\nWater Refilling Stations in your area.",
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
                            snapshot.data[index]["header"]["station"]["name"],
                            style: GoogleFonts.chivo(
                              color: kPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 17.0,
                            ),
                          ),
                          Text(
                            snapshot.data[index]["header"]["station"]
                                ["address"],
                            style: GoogleFonts.roboto(
                              color: kPrimary,
                              fontWeight: FontWeight.w500,
                              fontSize: 12.0,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 20.0),
                          FixedTimeline(
                            children: timeline(snapshot.data[index]).toList(),
                          ),
                          const SizedBox(height: 20.0),
                          Container(
                            margin: const EdgeInsets.only(top: 10.0),
                            padding: const EdgeInsets.all(15.0),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: kDefaultRadius,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      MaterialCommunityIcons.truck_delivery,
                                      color: kPrimary,
                                      size: 24.0,
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: Text(
                                        _deliveryAddress,
                                        style: GoogleFonts.roboto(
                                          color: kPrimary,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12.0,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
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
