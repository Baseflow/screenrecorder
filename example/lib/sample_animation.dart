import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class SampleAnimation extends StatefulWidget {
  const SampleAnimation({Key? key});

  @override
  State<SampleAnimation> createState() => _SampleAnimationState();
}

class _SampleAnimationState extends State<SampleAnimation> {
  // Define the various properties with default values. Update these properties
  // when the user taps a FloatingActionButton.
  double paddingTop = 5;
  double paddingleft = 5;
  Color _color = Colors.green;
  BorderRadiusGeometry _borderRadius = BorderRadius.circular(8);

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Timer? _timer;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        setState(() {
          // Create a random number generator.
          final random = Random();

          // Generate a random width and height.
          paddingTop = random.nextInt(150).toDouble();
          paddingTop = random.nextInt(150).toDouble();

          // Generate a random color.
          _color = Color.fromRGBO(
            random.nextInt(256),
            random.nextInt(256),
            random.nextInt(256),
            1,
          );

          // Generate a random border radius.
          _borderRadius = BorderRadius.circular(random.nextInt(100).toDouble());
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      // Use the properties stored in the State class.
      margin:
          EdgeInsets.symmetric(horizontal: paddingleft, vertical: paddingTop),
      decoration: BoxDecoration(
        color: _color,
        borderRadius: _borderRadius,
      ),
      // Define how long the animation should take.
      duration: const Duration(seconds: 1),
      // Provide an optional curve to make the animation feel smoother.
      curve: Curves.fastOutSlowIn,
    );
  }
}
