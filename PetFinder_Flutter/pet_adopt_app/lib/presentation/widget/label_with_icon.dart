import 'package:flutter/material.dart';

class LabelWithIcon extends StatelessWidget {
  final String text;
  final double textSize;
  final IconData icon;
  final double iconSize;
  final Color iconColor;
  final bool result;

  const LabelWithIcon({
    super.key,
    required this.text,
    required this.textSize,
    required this.icon,
    required this.iconSize,
    required this.result,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: iconSize, color: iconColor),
        const SizedBox(width: 5),
        if (result)
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                fontSize: textSize,
                color: const Color.fromRGBO(66, 66, 66, 1.0),
              ),
            ),
          )
        else
          Text(
            text,
            style: TextStyle(
              fontSize: textSize,
              color: const Color.fromRGBO(66, 66, 66, 1.0),
            ),
            maxLines: 1,
          ),
      ],
    );
  }
}
