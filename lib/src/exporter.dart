import 'dart:ui' as ui show ImageByteFormat;

import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as image;

import 'frame.dart';

class Exporter {
  final List<Frame> _frames = [];
  int _maxWidthFrame = 0;
  int _maxHeightFrame = 0;

  List<Frame> get frames => _frames;

  void onNewFrame(Frame frame) {
    _frames.add(frame);
  }

  void clear() {
    _frames.clear();

    _maxWidthFrame = 0;
    _maxHeightFrame = 0;
  }

  bool get hasFrames => _frames.isNotEmpty;

  Future<List<RawFrame>?> exportFrames() async {
    if (_frames.isEmpty) {
      return null;
    }
    final bytesImages = <RawFrame>[];
    for (final frame in _frames) {
      final bytesImage = await frame.image.toByteData(format: ui.ImageByteFormat.png);

      if (frame.image.width >= _maxWidthFrame) {
        _maxWidthFrame = frame.image.width;
      }

      if (frame.image.height >= _maxHeightFrame) {
        _maxHeightFrame = frame.image.height;
      }

      if (bytesImage != null) {
        bytesImages.add(RawFrame(16, bytesImage));
      } else {
        debugPrint('Skipped frame while enconding');
      }
    }
    return bytesImages;
  }

  Future<List<int>?> exportGif({
    bool singleFrame = false,
    int repeat = 0,
    int samplingFactor = 10,
    image.DitherKernel dither = image.DitherKernel.floydSteinberg,
    bool ditherSerpentine = false,
  }) async {
    final frames = await exportFrames();
    if (frames == null) {
      return null;
    }
    return compute(
      _exportGif,
      DataHolder(
        frames,
        _maxWidthFrame,
        _maxHeightFrame,
        singleFrame: singleFrame,
        repeat: repeat,
        samplingFactor: samplingFactor,
        dither: dither,
        ditherSerpentine: ditherSerpentine,
      ),
    );
  }

  static Future<List<int>?> _exportGif(DataHolder data) async {
    final frames = data.frames;
    final width = data.width;
    final height = data.height;

    image.Image mainImage = image.Image.empty();

    for (final frame in frames) {
      final decodedImage = image.decodePng(frame.image.buffer.asUint8List());

      if (decodedImage == null) continue;

      decodedImage.frameDuration = frame.durationInMillis;

      mainImage.frames.add(
        _encodeGifWIthTransparency(
          image.copyExpandCanvas(
            decodedImage,
            newWidth: width,
            newHeight: height,
            toImage: image.Image(
              width: width,
              height: height,
              format: decodedImage.format,
              numChannels: 4,
            ),
          ),
        ),
      );
    }

    return image.encodeGif(
      mainImage,
      singleFrame: data.singleFrame,
      repeat: data.repeat,
      samplingFactor: data.samplingFactor,
      dither: data.dither,
      ditherSerpentine: data.ditherSerpentine,
    );
  }

  static image.PaletteUint8 _convertPalette(image.Palette palette) {
    final newPalette = image.PaletteUint8(palette.numColors, 4);
    for (var i = 0; i < palette.numColors; i++) {
      newPalette.setRgba(i, palette.getRed(i), palette.getGreen(i), palette.getBlue(i), 255);
    }
    return newPalette;
  }

  static image.Image _encodeGifWIthTransparency(image.Image srcImage, {int transparencyThreshold = 1}) {
    final newImage = image.quantize(srcImage);

    // GifEncoder will use palette colors with a 0 alpha as transparent. Look at the pixels
    // of the original image and set the alpha of the palette color to 0 if the pixel is below
    // a transparency threshold.
    final numFrames = srcImage.frames.length;
    for (var frameIndex = 0; frameIndex < numFrames; frameIndex++) {
      final srcFrame = srcImage.frames[frameIndex];
      final newFrame = newImage.frames[frameIndex];

      final palette = _convertPalette(newImage.palette!);

      for (final srcPixel in srcFrame) {
        if (srcPixel.a < transparencyThreshold) {
          final newPixel = newFrame.getPixel(srcPixel.x, srcPixel.y);
          palette.setAlpha(newPixel.index.toInt(), 0); // Set the palette color alpha to 0
        }
      }

      newFrame.data!.palette = palette;
    }

    return newImage;
  }
}

class RawFrame {
  RawFrame(this.durationInMillis, this.image);

  final int durationInMillis;
  final ByteData image;
}

class DataHolder {
  DataHolder(
    this.frames,
    this.width,
    this.height, {
    this.singleFrame = false,
    this.repeat = 0,
    this.samplingFactor = 10,
    this.dither = image.DitherKernel.floydSteinberg,
    this.ditherSerpentine = false,
  });

  final List<RawFrame> frames;
  final int width;
  final int height;

  final bool singleFrame;
  final int repeat;
  final int samplingFactor;
  final image.DitherKernel dither;
  final bool ditherSerpentine;
}
