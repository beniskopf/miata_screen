import 'dart:io';
import 'package:chewie/chewie.dart';
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
          builder: (context) => _BumbleBeeRemoteVideo(widget.context
              // videoPath: '${widget.directoryPath}/$fileName',
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
        title: Text('MEDIA PLAYER 6'),
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

class _BumbleBeeRemoteVideo extends StatefulWidget {
  BuildContext context;

  _BumbleBeeRemoteVideo(this.context);

  @override
  _BumbleBeeRemoteVideoState createState() => _BumbleBeeRemoteVideoState();
}

class _BumbleBeeRemoteVideoState extends State<_BumbleBeeRemoteVideo> {
  late VideoPlayerController _controller;
  late ChewieController cc;

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();

    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize();
  }

  void _initVideoPlayer() async {
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'),
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );

    /// Initialize the video player
    await _controller.initialize();

    /// The rest of your code
    cc = ChewieController(
      videoPlayerController: _controller,
      autoPlay: true,
      looping: true,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(20),
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    Chewie(
                      controller: cc,
                    ),
                    ClosedCaption(text: _controller.value.caption.text),
                    _ControlsOverlay(controller: _controller),
                    VideoProgressIndicator(_controller, allowScrubbing: true),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({required this.controller});

  static const List<Duration> _exampleCaptionOffsets = <Duration>[
    Duration(seconds: -10),
    Duration(seconds: -3),
    Duration(seconds: -1, milliseconds: -500),
    Duration(milliseconds: -250),
    Duration.zero,
    Duration(milliseconds: 250),
    Duration(seconds: 1, milliseconds: 500),
    Duration(seconds: 3),
    Duration(seconds: 10),
  ];
  static const List<double> _examplePlaybackRates = <double>[
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? const SizedBox.shrink()
              : const ColoredBox(
                  color: Colors.black26,
                  child: Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 100.0,
                      semanticLabel: 'Play',
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
        Align(
          alignment: Alignment.topLeft,
          child: PopupMenuButton<Duration>(
            initialValue: controller.value.captionOffset,
            tooltip: 'Caption Offset',
            onSelected: (Duration delay) {
              controller.setCaptionOffset(delay);
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<Duration>>[
                for (final Duration offsetDuration in _exampleCaptionOffsets)
                  PopupMenuItem<Duration>(
                    value: offsetDuration,
                    child: Text('${offsetDuration.inMilliseconds}ms'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.captionOffset.inMilliseconds}ms'),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: PopupMenuButton<double>(
            initialValue: controller.value.playbackSpeed,
            tooltip: 'Playback speed',
            onSelected: (double speed) {
              controller.setPlaybackSpeed(speed);
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<double>>[
                for (final double speed in _examplePlaybackRates)
                  PopupMenuItem<double>(
                    value: speed,
                    child: Text('${speed}x'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.playbackSpeed}x'),
            ),
          ),
        ),
      ],
    );
  }
}
