import 'dart:io';

import 'package:app/common/pretty_print.dart';
import 'package:app/common/radius.dart';
import 'package:app/const/colors.dart';
import 'package:app/controllers/globalController.dart';
import 'package:app/controllers/orderController.dart';
import 'package:app/controllers/profileController.dart';
import 'package:app/controllers/userController.dart';
import 'package:app/screens/stations/sub/orders.dart';
import 'package:app/screens/stations/sub/preview_order.dart';
import 'package:app/screens/stations/sub/sub_orders/qr/scan.dart';
import 'package:app/widget/snapshot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class PageReadyorders extends StatefulWidget {
  const PageReadyorders({Key? key}) : super(key: key);

  @override
  State<PageReadyorders> createState() => _PageReadyordersState();
}

class _PageReadyordersState extends State<PageReadyorders> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

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
        status: "ready",
      );
    });
  }

  Future<void> onUpdateStatus({id, status}) async {
    Get.bottomSheet(
      Container(
        height: Get.height,
        width: Get.width,
        decoration: const BoxDecoration(
          color: kPrimary,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0),
          ),
        ),
        child: buildQrView(context),
      ),
      isDismissible: false,
      isScrollControlled: false,
    );
  }
  //   Get.bottomSheet(
  //     Container(
  //       padding: const EdgeInsets.only(left: 40.0, right: 40.0),
  //       height: Get.height * 0.60,
  //       width: Get.width,
  //       decoration: const BoxDecoration(
  //         color: kPrimary,
  //         borderRadius: BorderRadius.only(
  //           topLeft: Radius.circular(15.0),
  //           topRight: Radius.circular(15.0),
  //         ),
  //       ),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(
  //             "UPDATE STATUS TO \n\"DELIVERED?",
  //             style: GoogleFonts.chivo(
  //               fontWeight: FontWeight.bold,
  //               fontSize: 26.0,
  //               color: Colors.white,
  //             ),
  //           ),
  //           Container(
  //             margin: const EdgeInsets.only(top: 10.0),
  //             child: Text(
  //               "This Order will be moved to \nDelivered Screen",
  //               style: GoogleFonts.roboto(
  //                 fontWeight: FontWeight.w300,
  //                 fontSize: 13.0,
  //                 color: Colors.white,
  //               ),
  //             ),
  //           ),
  //           Container(
  //             margin: const EdgeInsets.only(top: 30.0),
  //             width: Get.width * 0.60,
  //             child: Row(
  //               children: [
  //                 Expanded(
  //                   child: SizedBox(
  //                     width: double.infinity,
  //                     height: 62,
  //                     child: TextButton(
  //                       onPressed: () {
  // Get.back();
  // Future.delayed(const Duration(milliseconds: 300),
  //     () async {
  //   // setState(() => onUpdateStatusIsOngoing = true);
  //   setState(() {
  //     _toUpdateId = id;
  //   });
  //   await _order.updateOrderStatus(
  //     id: id,
  //     status: "delivered",
  //   );
  //   refresh();
  //   //setState(() => onUpdateStatusIsOngoing = false);
  // });
  //                       },
  //                       style: TextButton.styleFrom(
  //                         //primary: kFadeWhite,
  //                         backgroundColor: kSecondary,
  //                         shape: const RoundedRectangleBorder(
  //                           borderRadius: kDefaultRadius,
  //                         ),
  //                       ),
  //                       child: Text(
  //                         "YES",
  //                         style: GoogleFonts.roboto(
  //                           fontSize: 14.0,
  //                           fontWeight: FontWeight.w400,
  //                           color: Colors.white,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 const SizedBox(width: 5),
  //                 Expanded(
  //                   child: SizedBox(
  //                     width: double.infinity,
  //                     height: 62,
  //                     child: TextButton(
  //                       onPressed: () {
  //                         Get.back();
  //                       },
  //                       style: TextButton.styleFrom(
  //                         //primary: kFadeWhite,
  //                         backgroundColor: kSecondary,
  //                         shape: const RoundedRectangleBorder(
  //                           borderRadius: kDefaultRadius,
  //                         ),
  //                       ),
  //                       child: Text(
  //                         "NO",
  //                         style: GoogleFonts.roboto(
  //                           fontSize: 14.0,
  //                           fontWeight: FontWeight.w400,
  //                           color: Colors.white,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           )
  //         ],
  //       ),
  //     ),
  //     isDismissible: false,
  //     isScrollControlled: false,
  //   );
  // }

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
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
      status: "ready",
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
                    "Sorry, you do not have any \nIn-Progress orders yet.",
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
                        trailing: _toUpdateId == snapshot.data[index]["_id"]
                            ? const SizedBox(
                                height: 22.0,
                                width: 22.0,
                                child: LoadingIndicator(
                                  indicatorType: Indicator.ballSpinFadeLoader,
                                  colors: [Colors.green],
                                  strokeWidth: 3,
                                ),
                              )
                            : GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () => onUpdateStatus(
                                  id: snapshot.data[index]["_id"],
                                  status: "ready",
                                ),
                                child: const Icon(
                                  AntDesign.arrowright,
                                  color: Colors.green,
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
                                margin: const EdgeInsets.only(top: 10.0),
                                child: TextButton.icon(
                                  onPressed: () async {
                                    try {
                                      await FlutterPhoneDirectCaller.callNumber(
                                        snapshot.data[index]["header"]
                                            ["customer"]["contactNo"],
                                      );
                                    } catch (e) {
                                      print(e);
                                    }
                                  },
                                  style: TextButton.styleFrom(
                                    //primary: kFadeWhite,
                                    backgroundColor: kPrimary,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: kDefaultRadius,
                                    ),
                                  ),
                                  icon: const Icon(
                                    FontAwesome.phone_square,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                  label: Text(
                                    "CALL CUSTOMER",
                                    style: GoogleFonts.roboto(
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                      height: 1.4,
                                    ),
                                  ),
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

  Widget buildQrView(BuildContext context) {
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: kPrimary,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: Get.width * 0.80,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) async {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        result = scanData;
      });
    });
    if (result != null) {
      setState(() {
        _toUpdateId = result!.code.toString();
      });
      await _order.updateOrderStatus(
        id: result!.code.toString(),
        status: "delivered",
      );
      Get.back();
      refresh();
    }
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
