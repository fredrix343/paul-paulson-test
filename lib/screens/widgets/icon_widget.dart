import 'package:flutter/material.dart';

// ignore: must_be_immutable
class IconWidget extends StatelessWidget {
  String? assetName;
  double? size;
  Color? color;
  IconWidget({
    super.key,
    required this.assetName,
    required this.size,
    @required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        "assets/icons/$assetName",
        fit: BoxFit.contain,
        width: size,
        height: size,
        color: color,
      ),
    );
  }
}
