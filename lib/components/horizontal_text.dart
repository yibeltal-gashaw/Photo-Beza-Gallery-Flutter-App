import 'package:flutter/material.dart';

class HorizontalText extends StatelessWidget {
  final String textleft;
  final String textright;
  const HorizontalText({
    Key? key,
    required this.textleft,
    required this.textright,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(textleft, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[600])),
          Text(textright, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[300])),
        ],
      ),
    );
  }
}

