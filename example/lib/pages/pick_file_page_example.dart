import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';
import 'package:path/path.dart' as path;

class PickFileExamplePage extends StatefulWidget {
  const PickFileExamplePage({Key? key}) : super(key: key);

  @override
  _PickFileExamplePageState createState() => _PickFileExamplePageState();
}

class _PickFileExamplePageState extends State<PickFileExamplePage> {
  final _controller = MeeduPlayerController(
    screenManager: const ScreenManager(forceLandScapeInFullscreen: false),
  );
  String fileName = "";
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _onPickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mov', 'avi', 'mp4', "mkv"],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      fileName = path.basename(file.path);
      _controller.launchAsFullscreen(context,
          autoplay: true,
          dataSource: DataSource(
            file: file,
            type: DataSourceType.file,
          ),
          header: header);
    } else {
      // User canceled the picker
    }
  }

  Widget get header {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          CupertinoButton(
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              // close the fullscreen
              Navigator.pop(context);
            },
          ),
          Expanded(
            child: Text(
              fileName,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          child: const Text("Pick video file"),
          onPressed: _onPickFile,
        ),
      ),
    );
  }
}
