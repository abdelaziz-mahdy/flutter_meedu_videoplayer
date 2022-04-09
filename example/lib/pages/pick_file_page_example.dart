import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';

class PickFileExamplePage extends StatefulWidget {
  PickFileExamplePage({Key? key}) : super(key: key);

  @override
  _PickFileExamplePageState createState() => _PickFileExamplePageState();
}

class _PickFileExamplePageState extends State<PickFileExamplePage> {
  final _controller = MeeduPlayerController(
    screenManager: ScreenManager(forceLandScapeInFullscreen: false),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _onPickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mov', 'avi', 'mp4'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      _controller.launchAsFullscreen(
        context,
        autoplay: true,
        dataSource: DataSource(
          file: file,
          type: DataSourceType.file,
        ),
      );
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          child: Text("Pick video file"),
          onPressed: this._onPickFile,
        ),
      ),
    );
  }
}
