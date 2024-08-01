import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class SampleAnimation extends StatefulWidget {
  const SampleAnimation({super.key});

  @override
  State<SampleAnimation> createState() => _SampleAnimationState();
}

class _SampleAnimationState extends State<SampleAnimation> {
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
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        setState(() {
          final random = Random();

          paddingTop = random.nextInt(150).toDouble();
          paddingTop = random.nextInt(150).toDouble();

          _color = Color.fromRGBO(
            random.nextInt(256),
            random.nextInt(256),
            random.nextInt(256),
            1,
          );

          _borderRadius = BorderRadius.circular(random.nextInt(100).toDouble());
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      margin:
          EdgeInsets.symmetric(horizontal: paddingleft, vertical: paddingTop),
      decoration: BoxDecoration(
        color: _color,
        borderRadius: _borderRadius,
      ),
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }
}
