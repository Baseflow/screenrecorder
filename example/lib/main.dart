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
  ScreenRecorderController controller = ScreenRecorderController(
    exporter: FramesExporter(),
  );

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
                ElevatedButton(
                  onPressed: () {
                    controller.start();
                    setState(() {
                      _recording = true;
                    });
                  },
                  child: Text('Start'),
                ),
              const SizedBox(
                height: 15,
              ),
              if (_recording && !_exporting)
                ElevatedButton(
                  onPressed: () async {
                    controller.stop();
                    setState(() {
                      _recording = false;
                      _exporting = true;
                    });
                    var images =
                        await (controller.exporter as FramesExporter).export();
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
                              itemCount: images.length,
                              itemBuilder: (BuildContext context, int index) {
                                final image = images[index];
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
                  child: Text('Stop and Export'),
                ),
            ]
          ],
        ),
      ),
    );
  }
}
