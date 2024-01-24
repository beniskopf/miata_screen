import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
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


    if (songTitle != artistSongMap['Title'] ||
        artistName != artistSongMap['Artist']) {
      setState(() {
        songTitle = artistSongMap['Title'] ?? "x";
        artistName = artistSongMap['Artist'] ?? "x";
      });
    }
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
      padding: EdgeInsets.all(5),
      child: Column(
        children: [
          Expanded(
            flex: 3,
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
              flex: 2,
              child: Column(
                children: [
              Container(
                //color: Colors.green,
                width: 400,
                height: 30,
                child: Marquee(
                            text: songTitle,
                             style: TextStyle(color: Colors.white, fontSize: 25),
                            scrollAxis: Axis.horizontal,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            blankSpace: 40,
                            velocity: 40,
                            pauseAfterRound: Duration(seconds: 1),
                            showFadingOnlyWhenScrolling: true,
                            fadingEdgeStartFraction: 0.1,
                            fadingEdgeEndFraction: 0.1,
                            startPadding: 10,
                            accelerationDuration: Duration(seconds: 1),
                            accelerationCurve: Curves.linear,
                            decelerationDuration: Duration(milliseconds: 500),
                            decelerationCurve: Curves.easeOut,
                            textDirection: TextDirection.rtl
                          ),
              ),
                  Container(
                   // color: Colors.yellow,
                    width: 400,
                    height: 30,
                    child: Marquee(
                        text: artistName,
                        style: TextStyle(color: Colors.white, fontSize: 25),
                        scrollAxis: Axis.horizontal,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        blankSpace: 30,
                        velocity: 50,
                        pauseAfterRound: Duration(seconds: 1),
                        showFadingOnlyWhenScrolling: true,
                        fadingEdgeStartFraction: 0.1,
                        fadingEdgeEndFraction: 0.1,
                        startPadding: 10,
                        accelerationDuration: Duration(seconds: 1),
                        accelerationCurve: Curves.linear,
                        decelerationDuration: Duration(milliseconds: 500),
                        decelerationCurve: Curves.easeOut,
                        textDirection: TextDirection.rtl
                    ),
                  ),
                  // Text(
                  //   songTitle,
                  //   style: TextStyle(color: Colors.white, fontSize: 16),
                  // ),
                  // Text(
                  //   artistName,
                  //   style: TextStyle(color: Colors.white),
                  // )
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
        MainMenuButton(showShadow: false, " ", () {
          ServiceClass.runBashCommand("amixer sset 'Master' 5%+");
        }, "assets/vol_up.png", 95, 95),
        MainMenuButton(showShadow: false, " ", () {
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
