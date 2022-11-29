import 'package:screen_recorder/screen_recorder.dart';

import 'io_gif_exporter.dart' if (dart.library.html) 'web_gif_exporter.dart';

abstract class GifExporter implements Exporter {
  factory GifExporter() => gifExporter();
}
