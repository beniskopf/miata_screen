import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:miata_screen/bashCommands.dart';
import 'package:miata_screen/service.dart';

class ColorPicker extends StatefulWidget {
  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  Color currentColor = Colors.amber;
  String finalColor = "";
  List<Color> currentColors = [Colors.yellow, Colors.green];
  List<Color> colorHistory = [];

  void changeColor(Color color, double brightness) {
    String colorCodeWithoutAlpha = color.value.toRadixString(16).substring(2);
    // print(color.value.toRadixString(16));
    // print(colorCodeWithoutAlpha);
    // print(brightness.toString());

    // Extract RGB components
    int red = (color.value >> 16) & 0xFF;
    int green = (color.value >> 8) & 0xFF;
    int blue = color.value & 0xFF;

    // Calculate new RGB values with the original brightness
    red = (red * brightness).round().clamp(0, 255);
    green = (green * brightness).round().clamp(0, 255);
    blue = (blue * brightness).round().clamp(0, 255);

    // Combine the new RGB values into a color
    Color adjustedColor = Color.fromRGBO(red, green, blue, 1.0);

    // Combine the adjusted color's RGB with the original alpha (brightness) information
    String adjustedColorCode =
        adjustedColor.value.toRadixString(16).substring(2);
    String finalColorCode =
        colorCodeWithoutAlpha + adjustedColorCode.substring(2);
print(BashCommands.changeColor + finalColorCode);
    ServiceClass.runBashCommand(BashCommands.changeColor + finalColorCode);
    finalColor = finalColorCode;
    setState(() => currentColor = adjustedColor);
  }

  void changeColors(List<Color> colors) {
    setState(() => currentColors = colors);
  }

  void changeBrightness(double value) {
    changeColor(currentColor, value);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            getBrightnessButton(() {
              changeBrightness(.6);
            }, "75"),
            getBrightnessButton(() {
              changeBrightness(.3);
            }, "50"),
            getBrightnessButton(() {
              changeBrightness(.2);
            }, "20"),
            getBrightnessButton(() {
              changeBrightness(.1);
            }, "10")
          ],
        ),
        // BlockColorPickerExample
        Expanded(
          child: BlockColorPickerExample(
            pickerColor: currentColor,
            onColorChanged: (x) => changeColor(x, 1),
            pickerColors: currentColors,
            onColorsChanged: changeColors,
            colorHistory: colorHistory,
          ),
        ),
        ElevatedButton(
            onPressed: () async {
              try {
                Map<String, dynamic> configData =
                    await ServiceClass.readConfigFile();
                print(configData);
                configData["ledColor"] = finalColor;
                print(configData);
                await ServiceClass.writeConfigFile(configData);
                Navigator.of(context).pop();
                ServiceClass.showDialogBox(context, "settings changed");

              } catch (e) {
                Navigator.of(context).pop();
                ServiceClass.showDialogBox(context, "error");
              }
            },
            child: Text('save'))
      ],
    );
  }

  getBrightnessButton(void Function() onTap, String text) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 5, 0, 5),
        child: SizedBox(
          height: 80,
          width: 100,
          child:
              Container(child: Center(child: Text(text)), color: Colors.white),
        ),
      ),
    );
  }
}

const List<Color> colors = [
  Colors.white,
  Colors.black,
  Color(0xFFFF0000),
  Color(0xFF00FF00),
  Color(0xFF0000FF),
  Color(0xFFFFFF00),
  Colors.red,
  Colors.pink,
  Colors.purple,
  Colors.deepPurple,
  Colors.indigo,
  Colors.blue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.lightGreen,
  Colors.lime,
  Colors.yellow,
  Colors.amber,
  Colors.deepOrange,
];

class BlockColorPickerExample extends StatefulWidget {
  const BlockColorPickerExample({
    Key? key,
    required this.pickerColor,
    required this.onColorChanged,
    required this.pickerColors,
    required this.onColorsChanged,
    required this.colorHistory,
  }) : super(key: key);

  final Color pickerColor;
  final ValueChanged<Color> onColorChanged;
  final List<Color> pickerColors;
  final ValueChanged<List<Color>> onColorsChanged;
  final List<Color> colorHistory;

  @override
  State<BlockColorPickerExample> createState() =>
      _BlockColorPickerExampleState();
}

class _BlockColorPickerExampleState extends State<BlockColorPickerExample> {
  int _portraitCrossAxisCount = 4;
  int _landscapeCrossAxisCount = 5;
  double _borderRadius = 0;
  double _iconSize = 24;

  Widget pickerLayoutBuilder(
      BuildContext context, List<Color> colors, PickerItem child) {
    Orientation orientation = MediaQuery.of(context).orientation;

    return SizedBox(
      width: 300,
      height: orientation == Orientation.portrait ? 360 : 240,
      child: GridView.count(
        crossAxisCount: orientation == Orientation.portrait
            ? _portraitCrossAxisCount
            : _landscapeCrossAxisCount,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        children: [for (Color color in colors) child(color)],
      ),
    );
  }

  Widget pickerItemBuilder(
      Color color, bool isCurrentColor, void Function() changeColor) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_borderRadius),
        color: color,
        //boxShadow: [BoxShadow(color: color.withOpacity(0.8), offset: const Offset(1, 2), blurRadius: _blurRadius)],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: changeColor,
          borderRadius: BorderRadius.circular(_borderRadius),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 250),
            opacity: isCurrentColor ? 1 : 0,
            child: Icon(
              Icons.done,
              size: _iconSize,
              color: useWhiteForeground(color) ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(0.0))),
      title: const Text('Select a color'),
      content: SingleChildScrollView(
        child: BlockPicker(
          pickerColor: widget.pickerColor,
          onColorChanged: widget.onColorChanged,
          availableColors:
              widget.colorHistory.isNotEmpty ? widget.colorHistory : colors,
          layoutBuilder: pickerLayoutBuilder,
          itemBuilder: pickerItemBuilder,
        ),
      ),
    );
  }
}
