import 'package:flutter/material.dart';

PreferredSizeWidget customAppBar({
  required String title,
  required IconData icon,
  required Function onPressed,
  required Color color,
}) {
  return AppBar(
    backgroundColor: color,
    title: Text(title),
    centerTitle: true,
    actions: [
      IconButton(
        icon: Icon(icon),
        onPressed: () => onPressed(),
      ),
    ],
  );
}