import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miata_screen/service.dart';

import 'bashCommands.dart';

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
      getListTileButton("restart raspberry", () {
        ServiceClass.runBashCommand(
            BashCommands.restartSystem);
      }),
      getListTileButton("shutdown raspberry", () {
        ServiceClass.runBashCommand(
            BashCommands.shutdownSystem);
      }),
      Divider(),
      getListTileButton("connect bt", () {
        ServiceClass.runBashCommand(
            BashCommands.btconnect);
      }),
      getListTileButton("disconnect bt", () {
        ServiceClass.runBashCommand(
            BashCommands.btdisconnect);
      }),
      getListTileButton("pair bt", () {
        ServiceClass.runBashCommand(
            BashCommands.btpair);
      }),
    ];
  }
}
