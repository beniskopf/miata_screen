import 'dart:io';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ServiceClass{

  static Future<void> showDialogBox(BuildContext context, String hintText) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Message'),
          content: Text(hintText),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static Future<Map<String, dynamic>> readConfigFile() async {
    try {
      // Specify the path to the config file
      String filePath = '/home/rp/config.txt';

      // Read the contents of the file
      File file = File(filePath);
      String contents = await file.readAsString();

      // Parse the JSON data
      Map<String, dynamic> configData = json.decode(contents);

      return configData;
    } catch (e) {
      // Handle any errors that might occur during the file read
      print('Error reading config file: $e');
      return {};
    }
  }

  static Future<void> writeConfigFile(Map<String, dynamic> data) async {
    try {
      // Specify the path to the config file
      String filePath = '/home/rp/config.txt';

      // Encode the data to JSON format
      String jsonData = json.encode(data);

      // Write the data to the file
      File file = File(filePath);
      await file.writeAsString(jsonData);
    } catch (e) {
      // Handle any errors that might occur during the file write
      print('Error writing to config file: $e');
    }
  }

  static Future<String> runBashCommand(String command) async {
    try {
      // Execute a Bash command
      ProcessResult result = await Process.run('bash', ['-c', command]);

      // Check the exit code and standard output
      if (result.exitCode == 0) {
        // print('Command executed successfully');
        // print('Output: ${result.stdout}');
        return result.stdout;
      } else {
        // print('Error executing the command');
        // print('Exit code: ${result.exitCode}');
        // print('Error: ${result.stderr}');
        return "error";
      }
    } catch (e) {
      // print('Error: $e');
      return "error";
    }
  }

  static Map<String, String> extractArtistAndTitle(String payload) {
    final artistRegex = RegExp(r'"Artist"\s+variant\s+string\s+"([^"]+)"');
    final titleRegex = RegExp(r'"Title"\s+variant\s+string\s+"([^"]+)"');

    final artistMatch = artistRegex.firstMatch(payload);
    final titleMatch = titleRegex.firstMatch(payload);

    final artist = artistMatch?.group(1) ?? 'x';
    final title = titleMatch?.group(1) ?? 'x';

    return {
      'Artist': artist,
      'Title': title,
    };
  }

}