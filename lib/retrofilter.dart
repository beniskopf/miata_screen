import 'package:flutter/material.dart';

class TVScanLinesFilter extends StatelessWidget {
  final Widget child;

  TVScanLinesFilter({required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child, // Display the child widget
        TVScanLinesOverlay(), // Overlay the scan lines
      ],
    );
  }
}

class TVScanLinesOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: TVScanLinesPainter(),
    );
  }
}

class TVScanLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.4) // Adjust opacity as needed
      ..strokeWidth = 1.0;

    // Draw horizontal lines with a gap to mimic scan lines
    for (double y = 0; y < size.height; y += 2) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}