<p align="center">
    <img src="https://raw.githubusercontent.com/ueman/screenrecorder/main/img/screen_recorder.svg">
</p>

<p align="center">
  <a href="https://pub.dev/packages/screen_recorder"><img src="https://img.shields.io/pub/v/screen_recorder.svg" alt="pub.dev"></a>
  <!--
  <a href="https://github.com/ueman/feedback/actions?query=workflow%3Abuild"><img src="https://github.com/ueman/feedback/workflows/build/badge.svg?branch=master" alt="GitHub Workflow Status"></a>
  <a href="https://codecov.io/gh/ueman/feedback"><img src="https://codecov.io/gh/ueman/feedback/branch/master/graph/badge.svg" alt="code coverage"></a>
  -->
  <a href="https://github.com/ueman#sponsor-me"><img src="https://img.shields.io/github/sponsors/ueman" alt="Sponsoring"></a>
  <a href="https://pub.dev/packages/screen_recorder/score"><img src="https://badges.bar/screen_recorder/likes" alt="likes"></a>
  <a href="https://pub.dev/packages/screen_recorder/score"><img src="https://badges.bar/screen_recorder/popularity" alt="popularity"></a>
  <a href="https://pub.dev/packages/screen_recorder/score"><img src="https://badges.bar/screen_recorder/pub%20points" alt="pub points"></a>
</p>

----

🚧 This is highly experimental! 🚧

🚧 API is subject to change! 🚧

This is a package to create recordings of Flutter widgets.
The recordings can be exported as GIFs.

This is pure Flutter/Dart implementation without any dependencies on native
or platform code. Thus it runs on all supported platforms.

Please note, that the encoding of the GIF takes a lot of time. On web it is basically useless because it takes so much time.

Please see the [example](https://pub.dev/packages/screen_recorder/example) if you want to know how it works.

## 🚀 Getting Started

### Setup

First, you will need to add `screen_recorder` to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  screen_recorder: x.y.z # use the latest version found on pub.dev
```

Then, run `flutter packages get` in your terminal.

## Example 

Wrap your widget which should be recorded in a `ScreenRecorder`:
```
ScreenRecorder(
  height: 200,
  width: 200,
  background: Colors.white,
  controller: ScreenRecorderController(
    pixelRatio: 0.5,
    skipFramesBetweenCaptures: 2,
  ),
  child: // child which should be recorded
);
```

Then use `ScreenRecorderController.start()` to start recording and 
`ScreenRecorderController.stop()` to stop the recording.
`final gif = await ScreenRecorderController.export()` gives you the result which can be written to disk.

## ⚠️ Known issues and limitations

- Platform views are invisible in screenshots (like [webview](https://pub.dev/packages/webview_flutter) or [Google Maps](https://pub.dev/packages/google_maps_flutter)). For further details, see this [Flutter issue](https://github.com/flutter/flutter/issues/25306).
- Web only works with Flutter's CanvasKit Renderer, for more information see [Flutter Web Renderer docs](https://flutter.dev/docs/development/tools/web-renderers).
- This package does not and will not support audio until it is possible in a pure Dart/Flutter environment.
- This package does not and will not support exporting as a video until it is possible in a pure Dart/Flutter environment.


## 📣  Author

- Jonas Uekötter [GitHub](https://github.com/ueman) [Twitter](https://twitter.com/ue_man)

## Sponsoring

I'm working on my packages on my free-time, but I don't have as much time as I would. If this package or any other package I created is helping you, please consider to [sponsor](https://github.com/ueman#sponsor-me) me. By doing so, I will prioritize your issues or your pull-requests before the others.
