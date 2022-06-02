import 'dart:math';

import 'package:flutter/material.dart';
import 'package:zwidget/zwidget.dart';

import 'example_custom_painter.dart';

class AnimatedExample extends StatefulWidget {
  const AnimatedExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AnimatedExampleState();
  }
}

class _AnimatedExampleState extends State<AnimatedExample> {
  final _contentKey = GlobalKey(); // declare a global key
  Size? _size;
  double? _statusBarHeight;
  double _rotationX = 0;
  double _rotationY = 0;
  Offset? _mousePosition;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _size = MediaQuery.of(context).size;
      _statusBarHeight = MediaQuery.of(context).viewPadding.top;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animated ZWidget'),
        leading: const BackButton(),
      ),
      body: Stack(children: [
        Center(
          child: Listener(
            onPointerMove: (PointerMoveEvent event) {
              if (event.down && _size != null) {
                RenderBox box =
                    _contentKey.currentContext!.findRenderObject() as RenderBox;
                Offset targetPosition =
                    box.localToGlobal(box.paintBounds.center);

                final distance = event.position - targetPosition;

                setState(() {
                  _mousePosition = event.position -
                      Offset(0, kToolbarHeight + (_statusBarHeight ?? 0));
                  _rotationY = distance.dx / (_size!.width / 2.0) * 2 * pi;
                  _rotationX = distance.dy / (_size!.height / 2.0) * 2 * pi;
                });
              }
            },
            child: ZWidget.backwards(
              key: _contentKey,
              midChild: ClipRect(
                  child: CustomPaint(
                painter: ExampleCustomPainter(),
                size: const Size(200, 200),
              )),
              rotationX: _rotationX,
              rotationY: _rotationY,
              layers: 11,
              depth: 12,
            ),
          ),
        ),
        if (_mousePosition != null)
          Positioned(
            child: Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white54,
                  boxShadow: [
                    BoxShadow(color: Colors.black26, spreadRadius: 2)
                  ]),
            ),
            left: _mousePosition!.dx - 15,
            top: _mousePosition!.dy - 15,
          ),
      ]),
    );
  }
}
