import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MusicControl extends StatelessWidget {
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
                    'Song title',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Text(
                    'Interpret',
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ))
        ],
      ),
    );
  }

  Widget musicButton(int type) {
    switch(type) {
      case 0: //back button
        return GestureDetector(
          onTap:(){print('click music!');},
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
          onTap:(){print('click music!');},
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
          onTap:(){print('click music!');},
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
      case 3:
        return GestureDetector(
          onTap:(){print('click music!');},
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
