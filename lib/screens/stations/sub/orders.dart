import 'package:app/const/colors.dart';
import 'package:app/screens/stations/sub/sub_orders/orders_delivered.dart';
import 'package:app/screens/stations/sub/sub_orders/orders_inprogress.dart';
import 'package:app/screens/stations/sub/sub_orders/orders_ready.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  PageController? _pageController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _pageController = PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabController?.dispose();
    super.dispose();
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
        "Orders",
        style: GoogleFonts.chivo(
          color: Colors.white,
          fontSize: 16.0,
        ),
      ),
      bottom: _tabController == null
          ? null
          : TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white54,
              isScrollable: true,
              labelPadding: const EdgeInsets.only(
                top: 15.0,
                bottom: 15.0,
                left: 15.0,
                right: 15.0,
              ),
              labelStyle: GoogleFonts.chivo(
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
              indicatorWeight: 1,
              physics: const ScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              indicatorColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              unselectedLabelStyle: GoogleFonts.roboto(
                fontSize: 11,
              ),
              onTap: (index) {
                _pageController?.jumpToPage(index);
              },
              tabs: [
                SizedBox(
                  width: Get.width * 0.30,
                  child: const Text(
                    "In-Progress",
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  width: Get.width * 0.30,
                  child: const Text(
                    "Ready",
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  width: Get.width * 0.30,
                  child: const Text(
                    "Delivered",
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
    );
    return Scaffold(
      backgroundColor: kLight,
      appBar: _appBar,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          _tabController!.animateTo(index);
        },
        children: const [
          PageInProgressOrders(),
          PageReadyorders(),
          PageDeliveredOrders(),
        ],
      ),
    );
  }
}
