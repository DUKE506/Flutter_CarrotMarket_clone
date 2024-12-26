import 'package:flutter/material.dart';

class MannerTemperatureWidget extends StatelessWidget {
  final double mannerTemp;
  late int level;
  final List<Color> temperColors = const [
    Color(0xff072038),
    Color(0xff0d3a65),
    Color(0xff186ec0),
    Color(0xff37b24d),
    Color(0xffffad13),
    Color(0xfff76707),
  ];
  final List<String> temperImages = [
    'assets/images/level-0.jpg',
    'assets/images/level-1.jpg',
    'assets/images/level-2.jpg',
    'assets/images/level-3.jpg',
    'assets/images/level-4.jpg',
    'assets/images/level-5.jpg',
  ];

  MannerTemperatureWidget({super.key, required this.mannerTemp}) {
    _calcTempLevel();
  }

  void _calcTempLevel() {
    if (mannerTemp <= 20) {
      level = 0;
    } else if (mannerTemp > 20 && mannerTemp <= 32) {
      level = 1;
    } else if (mannerTemp > 32 && mannerTemp <= 36.5) {
      level = 2;
    } else if (mannerTemp > 36.5 && mannerTemp <= 40) {
      level = 3;
    } else if (mannerTemp > 40 && mannerTemp <= 50) {
      level = 4;
    } else if (mannerTemp > 50) {
      level = 5;
    }
  }

  Widget _makeTempLabelAndBar() {
    return Container(
      width: 60,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "${mannerTemp}℃",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: temperColors[level],
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            child: Container(
              height: 5,
              color: Colors.grey[600],
              child: Row(
                children: [
                  Container(
                    height: 6,
                    width: 60 * (mannerTemp / 100),
                    color: temperColors[level],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _makeTempLabelAndBar(),
            Container(
              margin: const EdgeInsets.only(left: 5),
              child: Image.asset(
                temperImages[level],
                width: 30,
              ),
            ),
          ],
        ),
        Text(
          "매너온도",
          style: TextStyle(
            decoration: TextDecoration.underline,
            fontSize: 11,
            color: Colors.grey[800],
          ),
        )
      ],
    );
  }
}
