import 'dart:developer';
import 'dart:io';

import 'package:app/screens/stations/sub/orders.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

void main() => runApp(const MaterialApp(home: MyHome()));

class MyHome extends StatelessWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Demo Home Page')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {},
          child: const Text('qrView'),
        ),
      ),
    );
  }
}

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildQrView(context),
      // body: Column(
      //   children: <Widget>[
      //     Expanded(flex: 4, child:),
      //     Expanded(
      //       flex: 1,
      //       child: FittedBox(
      //         fit: BoxFit.contain,
      //         child: Column(
      //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //           children: <Widget>[
      //             if (result != null)
      //               Text(
      //                   'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
      //             else
      //               const Text('Scan a code'),
      //             Row(
      //               mainAxisAlignment: MainAxisAlignment.center,
      //               crossAxisAlignment: CrossAxisAlignment.center,
      //               children: <Widget>[
      //                 Container(
      //                   margin: const EdgeInsets.all(8),
      //                   child: ElevatedButton(
      //                       onPressed: () async {
      //                         await controller?.toggleFlash();
      //                         setState(() {});
      //                       },
      //                       child: FutureBuilder(
      //                         future: controller?.getFlashStatus(),
      //                         builder: (context, snapshot) {
      //                           return Text('Flash: ${snapshot.data}');
      //                         },
      //                       )),
      //                 ),
      //                 Container(
      //                   margin: const EdgeInsets.all(8),
      //                   child: ElevatedButton(
      //                       onPressed: () async {
      //                         await controller?.flipCamera();
      //                         setState(() {});
      //                       },
      //                       child: FutureBuilder(
      //                         future: controller?.getCameraInfo(),
      //                         builder: (context, snapshot) {
      //                           if (snapshot.data != null) {
      //                             return Text(
      //                                 'Camera facing ${describeEnum(snapshot.data!)}');
      //                           } else {
      //                             return const Text('loading');
      //                           }
      //                         },
      //                       )),
      //                 )
      //               ],
      //             ),
      //             Row(
      //               mainAxisAlignment: MainAxisAlignment.center,
      //               crossAxisAlignment: CrossAxisAlignment.center,
      //               children: <Widget>[
      //                 Container(
      //                   margin: const EdgeInsets.all(8),
      //                   child: ElevatedButton(
      //                     onPressed: () async {
      //                       await controller?.pauseCamera();
      //                     },
      //                     child: const Text('pause',
      //                         style: TextStyle(fontSize: 20)),
      //                   ),
      //                 ),
      //                 Container(
      //                   margin: const EdgeInsets.all(8),
      //                   child: ElevatedButton(
      //                     onPressed: () async {
      //                       await controller?.resumeCamera();
      //                     },
      //                     child: const Text('resume',
      //                         style: TextStyle(fontSize: 20)),
      //                   ),
      //                 )
      //               ],
      //             ),
      //           ],
      //         ),
      //       ),
      //     )
      //   ],
      // ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.red,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: Get.width * 0.80,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });

      if (result != null) {
        Get.to(() => const Orders());
      }
    });
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
