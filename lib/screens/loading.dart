import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SizedBox(
            height: 35.0,
            child: LoadingIndicator(
              indicatorType: Indicator.ballScaleMultiple,
              colors: [],
              strokeWidth: 1,
            ),
          ),
        ),
      ),
    );
  }
}
