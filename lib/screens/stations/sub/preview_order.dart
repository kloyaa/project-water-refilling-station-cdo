import 'package:app/common/radius.dart';
import 'package:app/common/spacing.dart';
import 'package:app/const/colors.dart';
import 'package:app/controllers/globalController.dart';
import 'package:app/controllers/orderController.dart';
import 'package:app/screens/stations/sub/orders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class PreviewCustomerOrder extends StatefulWidget {
  const PreviewCustomerOrder({Key? key}) : super(key: key);

  @override
  State<PreviewCustomerOrder> createState() => _PreviewCustomerOrderState();
}

class _PreviewCustomerOrderState extends State<PreviewCustomerOrder> {
  final _global = Get.put(GlobalController());
  final _order = Get.put(OrderController());

  Future<void> callNumber(number) async {
    try {
      await FlutterPhoneDirectCaller.callNumber(number);
    } catch (e) {
      print(e);
    }
  }

  Future<void> onUpdateStatus({id, status}) async {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(left: 40.0, right: 40.0),
        height: Get.height * 0.60,
        width: Get.width,
        decoration: const BoxDecoration(
          color: kPrimary,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "UPDATE STATUS TO \n\"IN-PROGRESS?",
              style: GoogleFonts.chivo(
                fontWeight: FontWeight.bold,
                fontSize: 26.0,
                color: Colors.white,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10.0),
              child: Text(
                "This Order will be moved to \nIn-Progress Screen",
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w300,
                  fontSize: 13.0,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 30.0),
              width: Get.width * 0.60,
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      height: 62,
                      child: TextButton(
                        onPressed: () {
                          Get.back();
                          Future.delayed(const Duration(milliseconds: 300),
                              () async {
                            Get.toNamed("/loading");
                            await _order.updateOrderStatus(
                              id: id,
                              status: "in-progress",
                            );
                            Get.to(() => const Orders());
                          });
                        },
                        style: TextButton.styleFrom(
                          //primary: kFadeWhite,
                          backgroundColor: kSecondary,
                          shape: const RoundedRectangleBorder(
                            borderRadius: kDefaultRadius,
                          ),
                        ),
                        child: Text(
                          "YES",
                          style: GoogleFonts.roboto(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      height: 62,
                      child: TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        style: TextButton.styleFrom(
                          //primary: kFadeWhite,
                          backgroundColor: kSecondary,
                          shape: const RoundedRectangleBorder(
                            borderRadius: kDefaultRadius,
                          ),
                        ),
                        child: Text(
                          "NO",
                          style: GoogleFonts.roboto(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      isDismissible: false,
      isScrollControlled: false,
    );
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
        "#${_global.selectedCustomerOrder["refNumber"]}",
        style: GoogleFonts.chivo(
          color: Colors.white,
          fontSize: 16.0,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () => callNumber(
            _global.selectedCustomerOrder["header"]["customer"]["contactNo"],
          ),
          splashRadius: 20,
          icon: const Icon(
            MaterialIcons.call,
            color: Colors.white,
          ),
        ),
      ],
    );

    return Scaffold(
      backgroundColor: kLight,
      appBar: _appBar,
      body: SizedBox(
        width: Get.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: kDefaultRadius,
              ),
              padding: const EdgeInsets.all(50.0),
              margin: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
              ),
              child: Column(
                children: [
                  Hero(
                    tag: _global.selectedCustomerOrder["refNumber"],
                    child: CircleAvatar(
                      backgroundColor: kPrimary,
                      backgroundImage: NetworkImage(
                        _global.selectedCustomerOrder["header"]["customer"]
                            ["img"],
                      ),
                      radius: 50.0,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 10.0,
                      left: 20.0,
                      right: 20.0,
                    ),
                    child: Text(
                      _global.selectedCustomerOrder["header"]["customer"]
                              ["firstName"] +
                          ", " +
                          _global.selectedCustomerOrder["header"]["customer"]
                              ["lastName"],
                      style: GoogleFonts.chivo(
                        color: kPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      _global.selectedCustomerOrder["header"]["customer"]
                              ["contactNo"]
                          .toString()
                          .replaceAll(RegExp(r'0'), "+63 "),
                      style: GoogleFonts.robotoMono(
                        color: kPrimary,
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: kDefaultRadius,
              ),
              padding: const EdgeInsets.all(50.0),
              margin: const EdgeInsets.only(
                top: 20.0,
                left: 20.0,
                right: 20.0,
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                    ),
                    child: Text(
                      "x${_global.selectedCustomerOrder["content"]["qty"]} ${_global.selectedCustomerOrder["content"]["item"]}",
                      style: GoogleFonts.chivo(
                        color: kPrimary,
                        fontWeight: FontWeight.w400,
                        fontSize: 17.0,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 5.0,
                      left: 20.0,
                      right: 20.0,
                    ),
                    child: Text(
                      "P${_global.selectedCustomerOrder["content"]["total"]}.0",
                      style: GoogleFonts.chivo(
                        color: kPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 26.0,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20.0),
                    child: const Divider(),
                  ),
                  Container(
                    child: Text(
                      "Delivery Address",
                      style: GoogleFonts.roboto(
                        color: kPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                    ),
                    child: Text(
                      _global.selectedCustomerOrder["header"]["customer"]
                          ["address"],
                      style: GoogleFonts.chivo(
                        color: kPrimary,
                        fontWeight: FontWeight.w400,
                        fontSize: 14.0,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Delivery Schedule",
                      style: GoogleFonts.roboto(
                        color: kPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    child: Text(
                      _global.selectedCustomerOrder["header"]["customer"]
                          ["deliveryDateAndTime"],
                      style: GoogleFonts.chivo(
                        color: kPrimary,
                        fontWeight: FontWeight.w400,
                        fontSize: 14.0,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 30.0),
                    width: double.infinity,
                    height: 62,
                    child: TextButton(
                      onPressed: () => onUpdateStatus(
                        id: _global.selectedCustomerOrder["_id"],
                        status: "in-progress",
                      ),
                      style: TextButton.styleFrom(
                        //primary: kFadeWhite,
                        backgroundColor: kPrimary,
                        shape: const RoundedRectangleBorder(
                          borderRadius: kDefaultRadius,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "ACCEPT ORDER",
                            style: GoogleFonts.roboto(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "Order detail will be moved to \nIn-Progress screen",
                            style: GoogleFonts.roboto(
                              fontSize: 10.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
