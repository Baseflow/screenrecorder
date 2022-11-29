import 'dart:ui' as ui show ImageByteFormat;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as image;
import 'package:screen_recorder/src/frame.dart';

class Exporter {
  final List<Frame> _frames = [];
  Map<int, RawFrame> framesMap = {};
  void onNewFrame(Frame frame) {
    _frames.add(frame);
    onNewFrameAsync(frame, _frames.length - 1);
  }

  Future<void> onNewFrameAsync(Frame frame, int index) async {
    final bytes = await frame.image.toByteData(format: ui.ImageByteFormat.png);
    if (bytes != null) {
      framesMap[index] = RawFrame(16, bytes);
    } else {
      print('Skipped frame while enconding');
    }
  }

  void clear() {
    _frames.clear();
  }

  bool get hasFrames => _frames.isNotEmpty;

  Future<List<RawFrame>?> exportFrames() async {
    return framesMap.values.toList();
  }

  Future<List<int>?> exportGif() async {
    final frames = await exportFrames();
    if (frames == null) {
      return null;
    }
    return compute(_exportGif, frames);
  }

  static Future<List<int>?> _exportGif(List<RawFrame> frames) async {
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
