import 'package:flutter/material.dart';

import 'assets.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage(
          AppAssets.background,
        ),
        fit: BoxFit.cover, // You can change the BoxFit as needed
      )),
      child: child,
    );
  }
}
