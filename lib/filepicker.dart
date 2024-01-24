import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:video_player/video_player.dart';

class MyFileListWidget extends StatefulWidget {
  final String directoryPath;
  final BuildContext context;

  MyFileListWidget({required this.directoryPath, required this.context});

  @override
  _MyFileListWidgetState createState() => _MyFileListWidgetState();
}

class _MyFileListWidgetState extends State<MyFileListWidget> {
  List<String> _fileNames = [];

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  Future<void> _loadFiles() async {
    try {
      Directory directory = Directory(widget.directoryPath);

      List<String> fileNames = directory
          .listSync()
          .whereType<File>()
          .map((File file) => basename(file.path))
          .toList();

      setState(() {
        _fileNames = fileNames;
      });
    } catch (e) {
      print("Error loading files: $e");
    }
  }

  // void _playVideo(String fileName) async {
  //   print("vlc ${widget.directoryPath}/"+fileName);
  //   ServiceClass.runBashCommand("vlc ${widget.directoryPath}/"+fileName);
  // }

  void _playVideo(String fileName) {
    print('${widget.directoryPath}/$fileName');
    // Assume video files have a specific format, adjust as needed
    if (fileName.endsWith('.mp4')) {
      Navigator.push(
        widget.context,
        MaterialPageRoute(
          builder: (context) => VideoPlayerScreen(
            videoPath: '/home/rp/media/mtv.mp4',
          ),
        ),
      );
    } else {
      // Handle non-video files if needed
      print('Selected file is not a video.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MEDIA PLAYER 7'),
      ),
      body: ListView.builder(
        itemCount: _fileNames.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_fileNames[index]),
            onTap: () {
              _playVideo(_fileNames[index]);
            },
          );
        },
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String videoPath;

  VideoPlayerScreen({required this.videoPath});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(
      File(widget.videoPath),
    )..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
      ),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : CircularProgressIndicator(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
