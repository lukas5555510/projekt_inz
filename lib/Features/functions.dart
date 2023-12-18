import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

void navigateToScreen(BuildContext context, Widget screen) {
  Navigator.push(
    context,
    PageTransition(
      type: PageTransitionType.fade,
      child: screen,
    ),
  );
}