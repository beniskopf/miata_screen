import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miata_screen/service.dart';

import 'bashCommands.dart';
import 'changeMac.dart';

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

  static List<Widget> debugContent(BuildContext context) {
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
      getListTileButton("change bt mac address", () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChangeMacPage(title: '',)),
        );
        //_showDialog(context);
      }),
    ];
  }

  static Future<void> _showDialog(BuildContext context) async {
    TextEditingController _textFieldController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Text'),
          content: TextField(
            controller: _textFieldController,
            decoration: InputDecoration(hintText: 'Enter text here...'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                // Get the entered text when OK is pressed
                String enteredText = _textFieldController.text;
                print('Entered text: $enteredText');

                // Close the dialog
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                // Close the dialog without doing anything
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

