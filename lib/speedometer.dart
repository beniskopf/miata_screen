import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miata_screen/service.dart';

import 'GpsDto.dart';
import 'bashCommands.dart';
import 'compassui.dart';

class SpeedoMeterBars extends StatefulWidget {
  @override
  State<SpeedoMeterBars> createState() => _SpeedoMeterBarsState();
}

class _SpeedoMeterBarsState extends State<SpeedoMeterBars> {
  double speed = 0;
  GpsDto? gpsTemp;
  double degreeDirectionTempDemo = 0.1;
  double degreeDirection = 0;
  bool isGoingUpDemoSpeed = true;

  @override
  initState() {
    speedSpinningDemo();
    super.initState();
  }

  gpsSpinning() async {
    final rawData = await ServiceClass.runBashCommand(BashCommands.getGpsData);
    Map<String, dynamic> jsonMap = json.decode(rawData);
    GpsDto response = GpsDto.fromJson(jsonMap);
    if (response.latitude == 0.0 || response.latitude == 0.0) {
      gpsSpinning();
    } else {
      setState(() {
        speed = response.speed ?? response.speed! * 3.6;

        // if (gpsTemp != null &&
        //     gpsTemp?.longitude != null &&
        //     gpsTemp?.latitude != null &&
        //     response != null &&
        //     response.latitude != null &&
        //     response.longitude != null) {
        //   degreeDirection = CompassCalc.calculateBearing(gpsTemp!.latitude!,
        //       gpsTemp!.longitude!, response.latitude!, response.longitude!);
        // }

        gpsTemp = response;
      });
      gpsSpinning();
    }
  }

  List<bool> getActiveList(double x) {
    List<bool> activeList = List.generate(30, (index) => index < x / 100 * 30);
    return activeList;
  }

  double degreeToOffset(double degree) {
    return -degree * (770 / 180) - 370;
  }

  speedSpinningDemo() async {
    setState(() {
      isGoingUpDemoSpeed ? speed++ : speed--;
    });
    await Future.delayed(Duration(milliseconds: 10));

    if (speed > 100) {
      setState(() {
        isGoingUpDemoSpeed = false;
      });
    }
    if (speed < 1) {
      gpsSpinning();
      return;
    }
    speedSpinningDemo();
  }

  @override
  Widget build(BuildContext context) {
    var activeList = getActiveList(speed);
    return Stack(
      children: [
        Positioned(
            left: 0,
            top: 0,
            child: CompassUi(
              x: degreeToOffset(degreeDirection),
              y: 0,
              imagePath: "assets/compass.png",
            )),
        Positioned(
          left: 0,
          top: 70,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              lowBar(activeList[0]),
              lowBar(activeList[1]),
              lowBar(activeList[2]),
              lowBar(activeList[3]),
              mediumBar(activeList[4]),
              mediumBar(activeList[5]),
              mediumBar(activeList[6]),
              mediumBar(activeList[7]),
              highBar(activeList[8]),
              highBar(activeList[9]),
              highBar(activeList[10]),
              highBar(activeList[11]),
              highBar(activeList[12]),
              highBar(activeList[13]),
              highBar(activeList[14]),
              ultraHighBar(activeList[15]),
              ultraHighBar(activeList[16]),
              ultraHighBar(activeList[17]),
              ultraHighBar(activeList[18]),
              ultraHighBar(activeList[19]),
              ultraHighBar(activeList[20]),
              ultraHighBar(activeList[21]),
              ultraHighBar(activeList[22]),
              ultraHighBar(activeList[23]),
              ultraHighBar(activeList[24]),
              ultraHighBar(activeList[25]),
              ultraHighBar(activeList[26]),
              ultraHighBar(activeList[27]),
              ultraHighBar(activeList[28]),
              ultraHighBar(activeList[29]),
            ],
          ),
        ),
        Positioned(left: 600, top: 70, child: SpeedoMeterNumber(speed))
      ],
    );
  }

  Widget lowBar(bool active) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 3, 0),
      height: 33,
      width: 24,
      color: active ? Colors.white : Colors.white.withOpacity(.2),
    );
  }

  Widget mediumBar(bool active) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 3, 0),
      height: 74,
      width: 24,
      color: active ? Colors.green : Colors.green.withOpacity(.2),
    );
  }

  Widget highBar(bool active) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 3, 0),
      height: 84,
      width: 24,
      color: active ? Colors.yellow : Colors.yellow.withOpacity(.2),
    );
  }

  Widget ultraHighBar(bool active) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 3, 0),
      height: 95,
      width: 24,
      color: active ? Color(0xFFB71C1C) : Color(0xFFB71C1C).withOpacity(.2),
    );
  }
}

class SpeedoMeterNumber extends StatelessWidget {
  double speed;

  SpeedoMeterNumber(this.speed);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${speed.toInt()}',
            style: TextStyle(fontSize: 50, color: Colors.white),
          ),
          Text('KMH', style: TextStyle(fontSize: 10, color: Colors.white))
        ],
      ),
    );
  }
}
