import 'package:flutter_test/flutter_test.dart';
import 'package:screen_recorder/screen_recorder.dart';

class CustomExporter extends Exporter {
  @override
  Future<List<int>?> export() {
    throw UnimplementedError();
  }

  @override
  void onNewFrame(Frame frame) {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('adds one to input values', () {});

  test('ScreenRecorderController allows to use custom exporter', () {
    final exporter = CustomExporter();
    final scrennRecorder = ScreenRecorderController(exporter: exporter);

    expect(scrennRecorder._exporter, equals(exporter));
  });
}
