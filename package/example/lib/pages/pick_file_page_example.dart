import 'dart:io';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';

class PickFileExamplePage extends StatefulWidget {
  const PickFileExamplePage({Key? key}) : super(key: key);

  @override
  State<PickFileExamplePage> createState() => _PickFileExamplePageState();
}

class _PickFileExamplePageState extends State<PickFileExamplePage> {
  final _controller = MeeduPlayerController(
      screenManager: const ScreenManager(forceLandScapeInFullscreen: false),
      enabledControls: const EnabledControls(doubleTapToSeek: false));
  String fileName = "";
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

// Function to pick a file and return the file path
  Future<String?> pickFilePath() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mov', 'avi', 'mp4', 'mkv'],
    );

    if (result != null) {
      String filePath = result.files.single.path!;

      return filePath;
    } else {
      return null; // User canceled the picker
    }
  }

// Function to play a video file using the provided file path
  void playVideoFile(BuildContext context, String filePath) {
    File file = File(filePath);

    _controller.launchAsFullscreen(
      context,
      autoplay: true,
      dataSource: DataSource(
        file: file,
        type: DataSourceType.file,
      ),
      header: header,
    );
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
              Navigator.maybePop(context);
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
      appBar: AppBar(
        title: const Text("Pick File"),
      ),
      body: Center(
        child: DropTarget(
          onDragDone: (details) {
            if (details.files.isNotEmpty) {
              playVideoFile(context, details.files.first.path);
            }
          },
          child: GestureDetector(
            onTap: () async {
              String? filePath = await pickFilePath();
              if (filePath != null) {
                playVideoFile(context, filePath);
              }
            },
            child: Container(
              width: context.width * 0.80,
              height: context.height * 0.30,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.upload_file,
                    size: 50,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Pick or drop file here",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
