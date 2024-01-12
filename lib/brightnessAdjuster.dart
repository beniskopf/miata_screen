import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BrightnessProvider with ChangeNotifier {
  double _brightness = 0.0;

  double get brightness => _brightness;

  setBrightness(double value) {
    _brightness = value.clamp(0.0, .6);
    notifyListeners();
  }
}

class BrightnessAdjuster extends StatelessWidget {
  final Widget child;

  BrightnessAdjuster({required this.child});

  @override
  Widget build(BuildContext context) {
    double brightness = Provider.of<BrightnessProvider>(context).brightness;
    brightness = brightness.clamp(0.0, .6);

    return Stack(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          child: child,
        ),
        IgnorePointer(
          ignoring: true,
          child: Opacity(
            opacity: brightness,
            child: Container(
              color: Colors.black, // Customize the color as needed
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
          ),
        ),
      ],
    );
  }
}