import 'package:flutter/material.dart';
import 'package:image/image.dart' as image;
import 'dart:ui' as ui show ImageByteFormat;
import 'package:flutter/foundation.dart';
import 'package:screen_recorder/src/frame.dart';

abstract class Exporter {
  void onNewFrame(Frame frame);

  Future<List<int>?> export();
}

class GifExporter implements Exporter {
  final List<Frame> _frames = [];

  @override
  Future<List<int>?> export() async {
    List<RawFrame> bytes = [];
    for (final frame in _frames) {
      final i = await frame.image.toByteData(format: ui.ImageByteFormat.png);
      if (i != null) {
        bytes.add(RawFrame(16, i));
      } else {
        print('Skipped frame while enconding');
      }
    }
    final result = compute(_export, bytes);
    _frames.clear();
    return result;
  }

  @override
  void onNewFrame(Frame frame) {
    _frames.add(frame);
  }

  static Future<List<int>?> _export(List<RawFrame> frames) async {
    final animation = image.Animation();
    animation.backgroundColor = Colors.transparent.value;
    for (final frame in frames) {
      final iAsBytes = frame.image.buffer.asUint8List();
      final decodedImage = image.decodePng(iAsBytes);

      if (decodedImage == null) {
        print('Skipped frame while enconding');
        continue;
      }
      decodedImage.duration = frame.durationInMillis;
      animation.addFrame(decodedImage);
    }
    return image.encodeGifAnimation(animation);
  }
}

class RawFrame {
  RawFrame(this.durationInMillis, this.image);

  final int durationInMillis;
  final ByteData image;
}
