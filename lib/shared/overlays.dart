import 'package:flutter/material.dart';

List<OverlayEntry> showOverlay(
  BuildContext context,
  AnimationController _positionController,
  AnimationController _colorController,
  List<Animation> animations,
  List<dynamic> functions,
  List<IconData> icons,
  String colorScheme,
) {
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
      child: AnimatedBuilder(
        animation: _colorController,
        builder: (context, child) {
          return RawMaterialButton(
            onPressed: func1,
            elevation: 2.0,
            fillColor: colorScheme == "dark"
                ? darkBackground.evaluate(
                    AlwaysStoppedAnimation(_colorController.value),
                  )
                : lightBackground.evaluate(
                    AlwaysStoppedAnimation(_colorController.value),
                  ),
            child: child,
            padding: EdgeInsets.all(12.0),
            shape: CircleBorder(),
          );
        },
        child: Icon(
          icons[0],
          size: 40.0,
          color: Colors.white,
        ),
      ),
    ),
  );

  final overlayEntry2 = OverlayEntry(
    maintainState: false,
    builder: (context) => Positioned(
      bottom: 0.24 * height,
      right: _animation2.value * width,
      child: AnimatedBuilder(
        animation: _colorController,
        builder: (context, child) {
          return Tooltip(
            message: "this is a tooltip",
            child: RawMaterialButton(
              onPressed: func2,
              elevation: 2.0,
              fillColor: colorScheme == "dark"
                  ? darkBackground.evaluate(
                      AlwaysStoppedAnimation(_colorController.value),
                    )
                  : lightBackground.evaluate(
                      AlwaysStoppedAnimation(_colorController.value),
                    ),
              child: child,
              padding: EdgeInsets.all(12.0),
              shape: CircleBorder(),
            ),
          );
        },
        child: Icon(
          icons[1],
          size: 40.0,
          color: Colors.white,
        ),
      ),
    ),
  );

  final overlayEntry3 = OverlayEntry(
    maintainState: false,
    builder: (context) => Positioned(
      bottom: 0.36 * height,
      right: _animation3.value * width,
      child: AnimatedBuilder(
        animation: _colorController,
        builder: (context, child) {
          return RawMaterialButton(
            onPressed: func3,
            elevation: 2.0,
            fillColor: colorScheme == "dark"
                ? darkBackground.evaluate(
                    AlwaysStoppedAnimation(_colorController.value),
                  )
                : lightBackground.evaluate(
                    AlwaysStoppedAnimation(_colorController.value),
                  ),
            child: child,
            padding: EdgeInsets.all(12.0),
            shape: CircleBorder(),
          );
        },
        child: Icon(
          icons[2],
          size: 40.0,
          color: Colors.white,
        ),
      ),
    ),
  );

  _positionController.addListener(() {
    overlayState.setState(() {});
  });

  overlayState.insert(overlayEntry1);
  overlayState.insert(overlayEntry2);
  overlayState.insert(overlayEntry3);

  _positionController.forward();

  return [overlayEntry1, overlayEntry2, overlayEntry3];
}

removeOverlay(AnimationController controller, List<OverlayEntry> entries) {
  print("removing overlay");

  controller.reverse().whenComplete(() {
    for (var entry in entries) {
      entry.remove();
    }
  });
}

Animatable<Color> darkBackground = TweenSequence<Color>([
  TweenSequenceItem(
    weight: 1.0,
    tween: ColorTween(
      begin: Colors.blue[400],
      end: Colors.indigo[900],
    ),
  ),
  TweenSequenceItem(
    weight: 1.0,
    tween: ColorTween(
      begin: Colors.indigo[900],
      end: Colors.blue[400],
    ),
  ),
]);

Animatable<Color> lightBackground = TweenSequence<Color>([
  TweenSequenceItem(
    weight: 1.0,
    tween: ColorTween(
      begin: Colors.grey[500],
      end: Colors.grey[900],
    ),
  ),
  TweenSequenceItem(
    weight: 1.0,
    tween: ColorTween(
      begin: Colors.grey[900],
      end: Colors.grey[500],
    ),
  ),
]);
