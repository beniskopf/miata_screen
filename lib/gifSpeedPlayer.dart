import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gif/flutter_gif.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'dart:ui';


class GifSpeedWidget extends StatefulWidget {
  double speed;

  GifSpeedWidget({required this.speed});

  @override
  _GifSpeedWidgetState createState() => _GifSpeedWidgetState();
}

class _GifSpeedWidgetState extends State<GifSpeedWidget> with TickerProviderStateMixin{
  late FlutterGifController controller1;

  @override
  void initState() {
    controller1 = FlutterGifController(vsync: this);
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      controller1.repeat(
        min: 0,
        max: 29, //wie soll man da dran kommen?
        period: Duration(milliseconds: (widget.speed.toInt())),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    controller1.repeat(
      min: 0,
      max: 29,
      period: Duration(milliseconds: (widget.speed.toInt())),
    );
    return GifImage(
      height: 200,
      width: 200,
      fit: BoxFit.cover,
      controller: controller1,
      image: const AssetImage("assets/trongrid.gif"),
    );
  }
}

class GifWidget extends StatelessWidget {

  String path;


  GifWidget(this.path);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(.4),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 0), // changes position of shadow
          ),
        ],
      ),
      height: 200,
      width: 200,
      child: Image.asset(path,fit: BoxFit.cover,),
    );
  }

}
