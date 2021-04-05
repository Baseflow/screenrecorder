import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'dart:ui' as ui show Image, ImageByteFormat;

import 'package:image/image.dart' as image;

class ScreenRecorderController {
  ScreenRecorderController({
    SchedulerBinding? binding,
    GlobalKey? globalKey,
  })  : _containerKey = globalKey ?? GlobalKey(),
        _binding = binding ?? SchedulerBinding.instance!;

  final GlobalKey _containerKey;
  final SchedulerBinding _binding;
  final List<Frame> _frames = [];
  bool record = false;

  void start() {
    record = true;
    _binding.addPostFrameCallback(postFrameCallback);
  }

  void stop() {
    record = false;
  }

  void postFrameCallback(Duration timestamp) async {
    if (record == false) {
      return;
    }
    try {
      final image = await capture();
      if (image == null) {
        return;
      }
      _frames.add(Frame(timestamp, image));
    } catch (e) {
      print(e.toString());
    }
    _binding.addPostFrameCallback(postFrameCallback);
  }

  Future<ui.Image?> capture({
    double pixelRatio = 1,
    Duration delay = const Duration(milliseconds: 20),
  }) async {
    final renderObject = _containerKey.currentContext?.findRenderObject();

    if (renderObject is! RenderRepaintBoundary) {
      FlutterError.reportError(_noRenderObject());
    } else {
      final image = await renderObject.toImage(pixelRatio: pixelRatio);
      return image;
    }
  }

  FlutterErrorDetails _noRenderObject() {
    return FlutterErrorDetails(
      exception: Exception(
        '_containerKey.currentContext is null. '
        'Thus we can\'t create a screenshot',
      ),
      library: 'feedback',
      context: ErrorDescription(
        'Tried to find a context to use it to create a screenshot',
      ),
    );
  }

  Future<List<int>?> export() async {
    List<ByteData?> bytes = [];
    for (final frame in _frames) {
      final i = await frame.image.toByteData(format: ui.ImageByteFormat.png);
      bytes.add(i);
    }
    return compute(_export, bytes);
  }

  static Future<List<int>?> _export(List<ByteData?> frames) async {
    final animation = image.Animation();
    for (final frame in frames) {
      if (frame == null) {
        print('Skipped frame while enconding');
        continue;
      }
      final iAsBytes = frame.buffer.asUint8List();
      final decodedImage = image.decodePng(iAsBytes);

      if (decodedImage == null) {
        print('Skipped frame while enconding');
        continue;
      }
      animation.addFrame(decodedImage);
    }
    return image.encodeGifAnimation(animation);
  }
}

class ScreenRecorder extends StatelessWidget {
  const ScreenRecorder({
    Key? key,
    required this.child,
    required this.controller,
  }) : super(key: key);

  final Widget child;
  final ScreenRecorderController controller;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: controller._containerKey,
      child: child,
    );
  }
}

class Frame {
  Frame(this.timeStamp, this.image);

  final Duration timeStamp;
  final ui.Image image;
}
