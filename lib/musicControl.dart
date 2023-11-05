import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miata_screen/service.dart';
import 'package:miata_screen/squareButton.dart';

class MusicControl extends StatelessWidget {

  String songTitle;
  String artistName;


  MusicControl(this.songTitle, this.artistName);

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
            ServiceClass.runBashCommand(
                "dbus-send --system --print-reply --dest=org.bluez /org/bluez/hci0/dev_DC_52_85_B0_B8_04 org.bluez.MediaControl1.Previous");
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
            ServiceClass.runBashCommand(
                "dbus-send --system --print-reply --dest=org.bluez /org/bluez/hci0/dev_DC_52_85_B0_B8_04 org.bluez.MediaControl1.Pause");
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
            ServiceClass.runBashCommand(
                "dbus-send --system --print-reply --dest=org.bluez /org/bluez/hci0/dev_DC_52_85_B0_B8_04 org.bluez.MediaControl1.Play");
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
            ServiceClass.runBashCommand(
                "dbus-send --system --print-reply --dest=org.bluez /org/bluez/hci0/dev_DC_52_85_B0_B8_04 org.bluez.MediaControl1.Next");
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

class VolumeControl extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      MainMenuButton(
        "VOL\nup",
          (){ServiceClass.runBashCommand(
              "amixer sset 'Master' 5%+");},
          "assets/debug.jpg",
        95,95
      ),
      MainMenuButton(
          "VOL\ndown",
              (){ServiceClass.runBashCommand(
              "amixer sset 'Master' 5%-");},
          "assets/debug.jpg",
          95,95
      )
    ],);
  }

}
