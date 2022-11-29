import 'package:flutter_test/flutter_test.dart';
import 'package:screen_recorder/screen_recorder.dart';

class CustomExporter extends Exporter {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('ScreenRecorderController allows to use custom exporter', () {
    final exporter = CustomExporter();
    final scrennRecorder = ScreenRecorderController(exporter: exporter);

    expect(scrennRecorder.exporter, equals(exporter));
  });
}
