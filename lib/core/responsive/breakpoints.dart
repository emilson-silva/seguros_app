import 'package:flutter/widgets.dart';

class Breakpoints {
  const Breakpoints._();
  static const double tablet = 600;
  static const double desktop = 900;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= desktop;
  static bool isWide(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= tablet;
}
