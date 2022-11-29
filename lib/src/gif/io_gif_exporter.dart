import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as image;
import 'dart:ui' as ui show ImageByteFormat;
import 'package:flutter/foundation.dart';
import 'package:screen_recorder/src/frame.dart';
import 'package:screen_recorder/src/gif/gif_exporter.dart';
import 'package:stream_channel/isolate_channel.dart';

GifExporter gifExporter() => IoGifExporter();

class IoGifExporter implements GifExporter {
  IoGifExporter() {
    _controller.stream.listen((event) async {
      if (event is _InitIsolateMessage) {
        await _initIsolate();
      }
      if (event is Frame) {
        final i = await event.image.toByteData(format: ui.ImageByteFormat.png);
        if (i != null) {
          channel!.sink.add(RawFrame(16, i));
        } else {
          print('Skipped frame while enconding');
        }
      }
    });

    _controller.add(_InitIsolateMessage());
  }

  StreamController _controller = StreamController();

  ReceivePort receivePort = ReceivePort();

  IsolateChannel? channel;

  Isolate? _isolate;

  Future<void> _initIsolate() async {
    channel = new IsolateChannel.connectReceive(receivePort);

    _isolate = await Isolate.spawn<SendPort>(
      _isolateEntryPoint,
      receivePort.sendPort,
      debugName: 'GifExporterIsolate',
    );
  }

  @override
  Future<List<int>?> export() async {
    channel!.sink.add(_ExportMessage());
    return await channel!.stream.first;
  }

  @override
  void onNewFrame(Frame frame) {
    _controller.add(frame);
  }
}

class RawFrame {
  RawFrame(this.durationInMillis, this.image);

  final int durationInMillis;
  final ByteData image;
}

void _isolateEntryPoint(SendPort sendPort) {
  final exporter = _InternalExporter();
  IsolateChannel channel = new IsolateChannel.connectSend(sendPort);
  channel.stream.listen((message) {
    if (message is RawFrame) {
      exporter.add(message);
    }
    if (message is _ExportMessage) {
      final gif = exporter.export();
      channel.sink.add(gif);
    }
  });
}

class _InternalExporter {
  _InternalExporter() {
    animation = image.Animation();
    animation.backgroundColor = Colors.transparent.value;
  }

  late image.Animation animation;

  void add(RawFrame rawFrame) {
    final iAsBytes = rawFrame.image.buffer.asUint8List();
    final decodedImage = image.decodePng(iAsBytes);

    if (decodedImage == null) {
      print('Skipped frame while enconding');
      return;
    }
    decodedImage.duration = rawFrame.durationInMillis;
    animation.addFrame(decodedImage);
  }

  List<int>? export() => image.encodeGifAnimation(animation);
}

class _ExportMessage {}

class _InitIsolateMessage {}
