import 'package:flutter/material.dart';

class OcassionCard extends StatelessWidget {
  final String image;
  final String title;
  final double radius;
  final void Function()? ontap;
  const OcassionCard({
    Key? key,
    required this.image,
    required this.title, this.ontap,
    this.radius = 25,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: CircleAvatar(
              radius: radius,
              backgroundImage: AssetImage(image),
            ),
          ),
          Text(title)
        ],
      ),
    );
  }
}
