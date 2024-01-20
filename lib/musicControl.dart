import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miata_screen/service.dart';
import 'package:miata_screen/squareButton.dart';

import 'bashCommands.dart';

class MusicControl extends StatefulWidget {
  @override
  State<MusicControl> createState() => _MusicControlState();
}

class _MusicControlState extends State<MusicControl> {
  String songTitle = "x";
  String artistName = "x";

  songInfoSpinning() async {
    String payload =
        await ServiceClass.runBashCommand(BashCommands.getSongInfo1);
    if (payload == "error") {
      payload = await ServiceClass.runBashCommand(BashCommands.getSongInfo2);
    }
    Map<String, String> artistSongMap =
        ServiceClass.extractArtistAndTitle(payload);

    setState(() {
      songTitle = artistSongMap['Title'] ?? "xx";
      artistName = artistSongMap['Artist'] ?? "xx";
    });
    await Future.delayed(Duration(seconds: 5));
    songInfoSpinning();
  }

  @override
  initState() {
    songInfoSpinning();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                musicButton(0),
                musicButton(1),
                musicButton(2),
                musicButton(3)
              ],
            ),
          ),
          Expanded(
              flex: 1,
              child: Column(
                children: [
                  Text(
                    songTitle,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Text(
                    artistName,
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ))
        ],
      ),
    );
  }

  Widget musicButton(int type) {
    switch (type) {
      case 0: //back button
        return GestureDetector(
          onTap: () {
            ServiceClass.runBashCommand(BashCommands.backButton);
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white, // White color for the border
                width: 2.0, // 2-pixel width
              ),
            ),
            height: 80,
            width: 80,
            //color: Colors.amber,
            child: Center(
              child: Icon(color: Colors.white, Icons.skip_previous, size: 50),
            ),
          ),
        );
        break; // The switch statement must be told to exit, or it will execute every case.
      case 1: //pause
        return GestureDetector(
          onTap: () {
            ServiceClass.runBashCommand(BashCommands.pauseButton);
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white, // White color for the border
                width: 2.0, // 2-pixel width
              ),
            ),
            height: 80,
            width: 80,
            //color: Colors.amber,
            child: Center(
              child: Icon(color: Colors.white, Icons.pause, size: 50),
            ),
          ),
        );
        break;
      case 2:
        return GestureDetector(
          onTap: () {
            ServiceClass.runBashCommand(BashCommands.playButton);
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white, // White color for the border
                width: 2.0, // 2-pixel width
              ),
            ),
            height: 80,
            width: 80,
            //color: Colors.amber,
            child: Center(
              child: Icon(color: Colors.white, Icons.play_arrow, size: 50),
            ),
          ),
        );
        break;
      case 3: //next
        return GestureDetector(
          onTap: () {
            ServiceClass.runBashCommand(BashCommands.skipButton);
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white, // White color for the border
                width: 2.0, // 2-pixel width
              ),
            ),
            height: 80,
            width: 80,
            //color: Colors.amber,
            child: Center(
              child: Icon(color: Colors.white, Icons.skip_next, size: 50),
            ),
          ),
        );
        break;
      default:
        return Container();
    }
  }
}

class VolumeControl extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MainMenuButton( showShadow: false," ", () {
          ServiceClass.runBashCommand("amixer sset 'Master' 5%+");
        }, "assets/vol_up.png", 95, 95),
        MainMenuButton(showShadow: false," ", () {
          ServiceClass.runBashCommand("amixer sset 'Master' 5%-");
        }, "assets/vol_down.png", 95, 95)
      ],
    );
  }
}

class BrightnessControl extends StatelessWidget {
  late Function onBrightnessUpPress;
  late Function onBrightnessDownPress;

  BrightnessControl(this.onBrightnessUpPress, this.onBrightnessDownPress);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MainMenuButton("BR.UP", () {
          onBrightnessUpPress();
        }, "assets/debug.jpg", 95, 95),
        MainMenuButton("BR.DOwn", () {
          onBrightnessDownPress();
        }, "assets/debug.jpg", 95, 95)
      ],
    );
  }
}
