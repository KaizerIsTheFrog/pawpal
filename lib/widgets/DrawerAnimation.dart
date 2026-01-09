import 'package:flutter/material.dart';

class AnimatedRoute {
  static PageRouteBuilder slideFromLeftDrawer(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 150),
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(-1.0, 0.0);
        const end = Offset.zero;
        final tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: Curves.easeInOut));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }
}
