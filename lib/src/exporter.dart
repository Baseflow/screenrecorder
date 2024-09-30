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

  Future<List<int>?> exportGif() async {
    final frames = await exportFrames();
    if (frames == null) {
      return null;
    }
    return compute(_exportGif, DataHolder(frames, _maxWidthFrame, _maxHeightFrame));
  }

  static Future<List<int>?> _exportGif(DataHolder data) async {
    List<RawFrame> frames = data.frames;
    int width = data.width;
    int height = data.height;

    image.Image mainImage = image.Image.empty();

    for (final frame in frames) {
      final iAsBytes = frame.image.buffer.asUint8List();
      final decodedImage = image.decodePng(iAsBytes);

      if (decodedImage == null) {
        debugPrint('Skipped frame while enconding');
        continue;
      }
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

    return image.encodeGif(mainImage);
  }

  static image.PaletteUint8 _convertPalette(image.Palette palette) {
    final newPalette = image.PaletteUint8(palette.numColors, 4);
    for (var i = 0; i < palette.numColors; i++) {
      newPalette.setRgba(i, palette.getRed(i), palette.getGreen(i), palette.getBlue(i), 255);
    }
    return newPalette;
  }

  static image.Image _encodeGifWIthTransparency(image.Image srcImage, {int transparencyThreshold = 1}) {
    var format = srcImage.format;
    image.Image image32;
    if (format != image.Format.int8) {
      image32 = srcImage.convert(format: image.Format.uint8);
    } else {
      image32 = srcImage;
    }
    final newImage = image.quantize(image32);

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
  DataHolder(this.frames, this.width, this.height);

  List<RawFrame> frames;

  int width;
  int height;
}
