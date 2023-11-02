import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SpeedoMeterBars extends StatefulWidget {
  double speed;

  SpeedoMeterBars(this.speed);

  @override
  State<SpeedoMeterBars> createState() => _SpeedoMeterBarsState();
}

class _SpeedoMeterBarsState extends State<SpeedoMeterBars> {
  List<bool> getActiveList(double x) {
    List<bool> activeList = List.generate(30, (index) => index < x / 100 * 30);
    return activeList;
  }

  @override
  Widget build(BuildContext context) {
    var activeList = getActiveList(widget.speed);
    return Row(
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
      width: 100,
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
