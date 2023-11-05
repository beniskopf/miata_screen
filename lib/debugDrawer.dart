import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DrawerContentClass {
  static Widget getListTileButton(String title, Function onPress) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                0.0), // Set the radius to 0 for square corners
          ),
        ),
        onPressed: () => onPress(),
        child: Text(title));
  }

  static List<Widget> debugContent() {
    return [
      getListTileButton("restart raspberry", () {}),
      getListTileButton("shutdown raspberry", () {}),
      Divider(),
      getListTileButton("connect bt", () {}),
      getListTileButton("disconnect bt", () {}),
      getListTileButton("pair bt", () {}),
    ];
  }
}
