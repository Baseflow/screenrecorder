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
  <a href="https://pub.dev/packages/screen_recorder/score"><img src="https://img.shields.io/pub/likes/screen_recorder" alt="likes"></a>
  <a href="https://pub.dev/packages/screen_recorder/score"><img src="https://img.shields.io/pub/popularity/screen_recorder" alt="popularity"></a>
  <a href="https://pub.dev/packages/screen_recorder/score"><img src="https://img.shields.io/pub/points/screen_recorder" alt="pub points"></a>
</p>

----

> 🚧 This is highly experimental! 🚧
>
> 🚧 API is subject to change! 🚧

This is a package to create recordings of Flutter widgets.
The recordings can be exported as GIFs.

This is pure Flutter/Dart implementation without any dependencies on native
or platform code. Thus it runs on all supported platforms.

Please note, that the encoding of the GIF takes a lot of time. On web it is basically useless because it takes so much time.

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
```dart
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

A complete example can be found [here](https://pub.dev/packages/screen_recorder/example).

## ⚠️ Known issues and limitations

- Platform views are invisible in screenshots (like [webview](https://pub.dev/packages/webview_flutter) or [Google Maps](https://pub.dev/packages/google_maps_flutter)). For further details, see this [Flutter issue](https://github.com/flutter/flutter/issues/25306) and [this issue](https://github.com/flutter/flutter/issues/102866). Please give a 👍 to those issues in order to raise awareness and the prio of those issues.
- Web only works with Flutter's CanvasKit Renderer, for more information see [Flutter Web Renderer docs](https://flutter.dev/docs/development/tools/web-renderers).
- This package does not and will not support audio until it is possible in a pure Dart/Flutter environment.
- This package does not and will not support exporting as a video until it is possible in a pure Dart/Flutter environment.

## Convert gif to video

In order to convert the gif to a video, you can try one of the following libraries. Please note, that compatibility was not tested.

| Library | Stats |
|---------|-------|
| [ffmpeg_kit_flutter](https://pub.dev/packages/ffmpeg_kit_flutter) | <a href="https://pub.dev/packages/ffmpeg_kit_flutter/score"><img src="https://img.shields.io/pub/likes/ffmpeg_kit_flutter" alt="likes"></a>  <a href="https://pub.dev/packages/ffmpeg_kit_flutter/score"><img src="https://img.shields.io/pub/popularity/ffmpeg_kit_flutter" alt="popularity"></a>  <a href="https://pub.dev/packages/ffmpeg_kit_flutter/score"><img src="https://img.shields.io/pub/points/ffmpeg_kit_flutter" alt="pub points"></a> |
| [flutter_video_compress](https://pub.dev/packages/flutter_video_compress) | <a href="https://pub.dev/packages/flutter_video_compress/score"><img src="https://img.shields.io/pub/likes/flutter_video_compress" alt="likes"></a>  <a href="https://pub.dev/packages/flutter_video_compress/score"><img src="https://img.shields.io/pub/popularity/flutter_video_compress" alt="popularity"></a>  <a href="https://pub.dev/packages/flutter_video_compress/score"><img src="https://img.shields.io/pub/points/flutter_video_compress" alt="pub points"></a> |
| [video_editor](https://pub.dev/packages/video_editor) | <a href="https://pub.dev/packages/video_editor/score"><img src="https://img.shields.io/pub/likes/video_editor" alt="likes"></a>  <a href="https://pub.dev/packages/video_editor/score"><img src="https://img.shields.io/pub/popularity/video_editor" alt="popularity"></a>  <a href="https://pub.dev/packages/video_editor/score"><img src="https://img.shields.io/pub/points/video_editor" alt="pub points"></a> |
| [video_trimmer](https://pub.dev/packages/video_trimmer) | <a href="https://pub.dev/packages/video_trimmer/score"><img src="https://img.shields.io/pub/likes/video_trimmer" alt="likes"></a>  <a href="https://pub.dev/packages/video_trimmer/score"><img src="https://img.shields.io/pub/popularity/video_trimmer" alt="popularity"></a>  <a href="https://pub.dev/packages/video_trimmer/score"><img src="https://img.shields.io/pub/points/video_trimmer" alt="pub points"></a> |
| [video_compress](https://pub.dev/packages/video_compress) | <a href="https://pub.dev/packages/video_compress/score"><img src="https://img.shields.io/pub/likes/video_compress" alt="likes"></a>  <a href="https://pub.dev/packages/video_compress/score"><img src="https://img.shields.io/pub/popularity/video_compress" alt="popularity"></a>  <a href="https://pub.dev/packages/video_compress/score"><img src="https://img.shields.io/pub/points/video_compress" alt="pub points"></a> |

## 📣 About the author

[![GitHub followers](https://img.shields.io/github/followers/ueman?style=social)](https://github.com/ueman)
[![Twitter Follow](https://img.shields.io/twitter/follow/ue_man?style=social)](https://twitter.com/ue_man)

## Contributors

<a href="https://github.com/ueman/screenrecorder/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=ueman/screenrecorder" />
</a>

