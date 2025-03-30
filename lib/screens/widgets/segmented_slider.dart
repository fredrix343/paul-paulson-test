import 'package:flutter/material.dart';

class SegmentedSlider extends StatefulWidget {
  @override
  _SegmentedSliderState createState() => _SegmentedSliderState();
}

class _SegmentedSliderState extends State<SegmentedSlider> {
  double thumbPosition = 0.0;

  final double sliderWidth = 260;
  final double sliderHeight = 30;
  final int segments = 4;

  void _onDragUpdate(DragUpdateDetails details) {
    setState(() {
      double newPos = thumbPosition + details.delta.dx;
      thumbPosition = newPos.clamp(0.0, sliderWidth - sliderHeight);
    });
  }

  @override
  Widget build(BuildContext context) {
    double segmentWidth = sliderWidth / segments;

    return Container(
      width: sliderWidth,
      height: sliderHeight,
      decoration: BoxDecoration(
        color: Color(0xff2c3c50),
        borderRadius: BorderRadius.circular(sliderHeight / 2),
      ),
      child: Stack(
        children: [
          // Active Segment Highlight
          Positioned(
            left: 0,
            child: Container(
              width: thumbPosition + sliderHeight,
              height: sliderHeight,
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.3),
                borderRadius: BorderRadius.circular(sliderHeight / 2),
              ),
            ),
          ),

          // Vertical Segment Lines
          for (int i = 1; i < segments; i++)
            Positioned(
              left: segmentWidth * i - 1,
              top: 10,
              bottom: 10,
              child: Container(width: 1.5, color: Colors.white24),
            ),

          // Thumb
          Positioned(
            left: thumbPosition,
            top: 0,
            child: GestureDetector(
              onHorizontalDragUpdate: _onDragUpdate,
              child: Container(
                width: sliderHeight,
                height: sliderHeight,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
