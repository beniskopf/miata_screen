import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:miata_screen/service.dart';
import 'package:path/path.dart';
import 'package:video_player/video_player.dart';

import 'bashCommands.dart';

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

  Future<void> _playVideo(String fileName, BuildContext context) async {
    if (fileName.endsWith('.mp4')) {
      Navigator.push(
        widget.context,
        MaterialPageRoute(
          builder: (context) => VideoPlayerScreen(
            videoPath: '/home/rp/media/$fileName',
          ),
        ),
      );
    } else if (fileName.endsWith(".mp3")) {
      print(BashCommands.playMp3Song + "/home/rp/media/$fileName");
      await ServiceClass.runBashCommand(BashCommands.stopAudioProcess);
      ServiceClass.runBashCommand(
          BashCommands.playMp3Song + "/home/rp/media/$fileName"+" &");
      Navigator.of(context).pop();
    } else {
      // Handle non-video files if needed
      print('Selected file is not a mp4 or mp3.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MEDIA PLAYER'),
      ),
      body: ListView.builder(
        itemCount: _fileNames.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_fileNames[index]),
            onTap: () {
              _playVideo(_fileNames[index], context);
            },
          );
        },
      ),
    );
  }
}

class AudioPlayerScreen extends StatefulWidget {
  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  @override
  void initState() {
    startMusic();
    super.initState();
  }

  startMusic() async {
    final player = AudioPlayer();
    await player.play(UrlSource(
        'https://cdn.pixabay.com/download/audio/2023/03/25/audio_ce5fb979a8.mp3?filename=champion-143955.mp3'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text('music'));
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
    )..initialize().then((_) async {
        setState(() {});
        await _controller.play();
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Row(
        children: [
          Column(
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('exit')),
              Divider(),
              ElevatedButton(
                  onPressed: () {
                    _controller.play();
                  },
                  child: Text('play')),
              ElevatedButton(
                  onPressed: () {
                    _controller.pause();
                  },
                  child: Text('pause')),
              Divider(),
              ElevatedButton(
                  onPressed: () {
                    _controller.setPlaybackSpeed(2.0);
                  },
                  child: Text('2x')),
              ElevatedButton(
                  onPressed: () {
                    _controller.setPlaybackSpeed(5.0);
                  },
                  child: Text('5x')),
              ElevatedButton(
                  onPressed: () {
                    _controller.setPlaybackSpeed(10.0);
                  },
                  child: Text('10x')),
              Divider(),
              ElevatedButton(
                  onPressed: () {
                    _controller.setVolume(1.0);
                  },
                  child: Text('vol up')),
              ElevatedButton(
                  onPressed: () {
                    _controller.setVolume(0.0);
                  },
                  child: Text('mute')),
            ],
          ),
          Expanded(
            child: Container(),
          ),
          _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : CircularProgressIndicator(
                  color: Colors.white,
                )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
