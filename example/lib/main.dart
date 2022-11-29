import 'dart:typed_data';

import 'package:example/sample_animation.dart';
import 'package:flutter/material.dart';
import 'package:screen_recorder/screen_recorder.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _recording = false;
  bool _exporting = false;
  ScreenRecorderController controller = ScreenRecorderController();
  bool get canExport => controller.exporter.hasFrames;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_exporting)
              Center(child: CircularProgressIndicator())
            else ...[
              ScreenRecorder(
                height: 500,
                width: 500,
                controller: controller,
                child: SampleAnimation(),
              ),
              if (!_recording && !_exporting)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      controller.start();
                      setState(() {
                        _recording = true;
                      });
                    },
                    child: Text('Start'),
                  ),
                ),
              if (_recording && !_exporting)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      controller.stop();
                      setState(() {
                        _recording = false;
                      });
                    },
                    child: Text('Stop'),
                  ),
                ),
              if (canExport && !_exporting)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _exporting = true;
                      });
                      var frames = await controller.exporter.exportFrames();
                      if (frames == null) {
                        throw Exception();
                      }
                      setState(() => _exporting = false);
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: SizedBox(
                              height: 500,
                              width: 500,
                              child: ListView.builder(
                                padding: EdgeInsets.all(8.0),
                                itemCount: frames.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final image = frames[index].image;
                                  return Container(
                                    height: 150,
                                    child: Image.memory(
                                      image.buffer.asUint8List(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Text('Export as frames'),
                  ),
                ),
              if (canExport && !_exporting) ...[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _exporting = true;
                      });
                      var gif = await controller.exporter.exportGif();
                      if (gif == null) {
                        throw Exception();
                      }
                      setState(() => _exporting = false);
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Image.memory(Uint8List.fromList(gif)),
                          );
                        },
                      );
                    },
                    child: Text('Export as GIF'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        controller.exporter.clear();
                      });
                    },
                    child: Text('Clear recorded data'),
                  ),
                )
              ]
            ]
          ],
        ),
      ),
    );
  }
}
