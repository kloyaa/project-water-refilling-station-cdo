import 'package:app/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';

snapshotSpinner() {
  return const Center(
    child: SizedBox(
      height: 35.0,
      child: LoadingIndicator(
        indicatorType: Indicator.ballSpinFadeLoader,
        colors: [kPrimary],
        strokeWidth: 1,
      ),
    ),
  );
}

snapshotEmptyMessage(message) {
  return Center(
    child: Text(
      message,
      style: GoogleFonts.roboto(
        color: kPrimary.withOpacity(0.5),
        fontWeight: FontWeight.w300,
        fontSize: 14.0,
      ),
      textAlign: TextAlign.center,
    ),
  );
}
