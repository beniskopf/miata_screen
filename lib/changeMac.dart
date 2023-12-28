import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miata_screen/service.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

class ChangeMacPage extends StatefulWidget {
  ChangeMacPage({required this.title});

  final String title;

  @override
  _ChangeMacPageState createState() => _ChangeMacPageState();
}

class _ChangeMacPageState extends State<ChangeMacPage> {
  // Holds the text that user typed.
  String text = '';

  // CustomLayoutKeys _customLayoutKeys;
  // True if shift enabled.
  bool shiftEnabled = false;

  // is true will show the numeric keyboard.
  bool isNumericMode = false;

  late TextEditingController _controllerText;

  @override
  void initState() {
    // _customLayoutKeys = CustomLayoutKeys();
    _controllerText = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancel')),
                  Text(
                    _controllerText.text,
                    style: TextStyle(fontSize: 30, color: Colors.black),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        Map<String, dynamic> configData = await ServiceClass.readConfigFile();
                        configData['bluetoothMac'] = _controllerText.text;
                        await ServiceClass.writeConfigFile(configData);
                        Navigator.of(context).pop();
                      },
                      child: Text('OK')),
                ],
              ),
            ),
            Container(
              color: Colors.black,
              child: VirtualKeyboard(
                  fontSize: 20,
                  height: 300,
                  //width: 500,
                  textColor: Colors.white,
                  textController: _controllerText,
                  //customLayoutKeys: _customLayoutKeys,
                  defaultLayouts: [VirtualKeyboardDefaultLayouts.English],
                  //reverseLayout :true,
                  type: isNumericMode
                      ? VirtualKeyboardType.Numeric
                      : VirtualKeyboardType.Alphanumeric,
                  onKeyPress: _onKeyPress),
            )
          ],
        ),
      ),
    );
  }

  /// Fired when the virtual keyboard key is pressed.
  _onKeyPress(VirtualKeyboardKey key) {
    if (key.keyType == VirtualKeyboardKeyType.String) {
      text = text + (shiftEnabled ? key.capsText : key.text)!;
    } else if (key.keyType == VirtualKeyboardKeyType.Action) {
      switch (key.action) {
        case VirtualKeyboardKeyAction.Backspace:
          if (text.length == 0) return;
          text = text.substring(0, text.length - 1);
          break;
        case VirtualKeyboardKeyAction.Return:
          text = text + '\n';
          break;
        case VirtualKeyboardKeyAction.Space:
          text = text + key.text!;
          break;
        case VirtualKeyboardKeyAction.Shift:
          shiftEnabled = !shiftEnabled;
          break;
        default:
      }
    }
    // Update the screen
    setState(() {});
  }
}
