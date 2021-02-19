import 'package:flutter/material.dart';

List<OverlayEntry> showOverlay(
    BuildContext context,
    AnimationController controller,
    List<Animation> animations,
    List<dynamic> functions,
    List<IconData> icons) {
  OverlayState overlayState = Overlay.of(context);
  final double height = MediaQuery.of(context).size.height;
  final double width = MediaQuery.of(context).size.width;

  final _animation1 = animations[0];
  final _animation2 = animations[1];
  final _animation3 = animations[2];

  final func1 = functions[0];
  final func2 = functions[1];
  final func3 = functions[2];

  final overlayEntry1 = OverlayEntry(
    maintainState: false,
    builder: (context) => Positioned(
      bottom: 0.12 * height,
      right: _animation1.value * width,
      child: RawMaterialButton(
        onPressed: func1,
        elevation: 2.0,
        fillColor: Colors.white,
        child: Icon(
          icons[0],
          size: 40.0,
          color: Colors.black,
        ),
        padding: EdgeInsets.all(10.0),
        shape: CircleBorder(),
      ),
    ),
  );

  final overlayEntry2 = OverlayEntry(
    maintainState: false,
    builder: (context) => Positioned(
      bottom: 0.24 * height,
      right: _animation2.value * width,
      child: RawMaterialButton(
        onPressed: func2,
        elevation: 2.0,
        fillColor: Colors.white,
        child: Icon(
          icons[1],
          size: 40.0,
          color: Colors.black,
        ),
        padding: EdgeInsets.all(10.0),
        shape: CircleBorder(),
      ),
    ),
  );

  final overlayEntry3 = OverlayEntry(
    maintainState: false,
    builder: (context) => Positioned(
      bottom: 0.36 * height,
      right: _animation3.value * width,
      child: RawMaterialButton(
        onPressed: func3,
        // () {
        //   setState(() {
        //     photoMode = !photoMode;
        //   });
        // },
        elevation: 2.0,
        fillColor: Colors.white,
        child: Icon(
          icons[2],
          size: 40.0,
          color: Colors.black,
        ),
        padding: EdgeInsets.all(10.0),
        shape: CircleBorder(),
      ),
    ),
  );

  controller.addListener(() {
    overlayState.setState(() {});
  });

  overlayState.insert(overlayEntry1);
  overlayState.insert(overlayEntry2);
  overlayState.insert(overlayEntry3);

  controller.forward();

  return [overlayEntry1, overlayEntry2, overlayEntry3];
}

removeOverlay(
    context, AnimationController controller, List<OverlayEntry> entries) {
  controller.reverse().whenComplete(() {
    for (var entry in entries) {
      entry.remove();
    }
    // overlayEntry1.remove();
    // overlayEntry2.remove();
    // overlayEntry3.remove();
  });
}
