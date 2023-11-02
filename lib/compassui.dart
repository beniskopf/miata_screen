import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CompassUi extends StatelessWidget {
  final double x; // X-coordinate within the 200x200 box
  final double y; // Y-coordinate within the 200x200 box
  final String imagePath; // Path to the image in your assets

  CompassUi({
    required this.x,
    required this.y,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.grey,
      width: 800.0,
      height: 60.0, // Container background color (optional)
      child: Stack(
        alignment: Alignment.centerLeft,
        children: <Widget>[
          Positioned(
            left: x+1540, // X-coordinate within the 200x200 box
            top: y, // Y-coordinate within the 200x200 box
            child: Image.asset(

              imagePath,
              height: 60,
              fit: BoxFit.fitHeight,
              // Height of the image// You can choose a different BoxFit value as needed
            ),
          ),
          Positioned(
            left: x-1540, // X-coordinate within the 200x200 box
            top: y, // Y-coordinate within the 200x200 box
            child: Image.asset(

              imagePath,
              height: 60,
              fit: BoxFit.fitHeight,
              // Height of the image// You can choose a different BoxFit value as needed
            ),
          ),
          Positioned(
            left: x, // X-coordinate within the 200x200 box
            top: y, // Y-coordinate within the 200x200 box
            child: Image.asset(

              imagePath,
              height: 60,
              fit: BoxFit.fitHeight,
              // Height of the image// You can choose a different BoxFit value as needed
            ),
          ),
          Positioned(
            left: (770/2)-3, // X-coordinate within the 200x200 box
            top: y, // Y-coordinate within the 200x200 box
            child: Container(height: 60,width: 6,color: Colors.red,),
          ),
        ],
      ),
    );
  }
}