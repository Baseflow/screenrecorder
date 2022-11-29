import 'package:screen_recorder/src/frame.dart';

abstract class Exporter {
  void onNewFrame(Frame frame);

  Future<List<int>?> export();
}
