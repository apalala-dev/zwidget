import 'dart:math';

import 'package:example/animated_example.dart';
import 'package:example/example_custom_painter.dart';
import 'package:flutter/material.dart';
import 'package:zwidget/zwidget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZWidget Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const ZWidgetShowcase(),
    );
  }
}

class ZWidgetShowcase extends StatefulWidget {
  const ZWidgetShowcase({Key? key}) : super(key: key);

  @override
  State<ZWidgetShowcase> createState() => _ZWidgetShowcaseState();
}

class _ZWidgetShowcaseState extends State<ZWidgetShowcase> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ZWidget Example'),
        actions: [
          IconButton(
            icon: const Icon(Icons.animation),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AnimatedExample()));
            },
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _textOnly(),
          _backwardOnly(),
          _forwardOnly(),
          _bothDirections(),
          _otherWidgets(),
        ],
      ),
    );
  }

  Widget _textOnly() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const ZWidget(
          midChild: Text(
            'ZWidget',
            style: TextStyle(
                color: Colors.blue, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          midToBotChild: Text(
            'ZWidget',
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          rotationX: pi / 4,
          rotationY: pi / 4,
          layers: 5,
          depth: 8,
          direction: ZDirection.backwards,
        ),
        Column(children: const [
          ZWidget(
            midChild: Text(
              'Example',
              style: TextStyle(
                  color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            midToBotChild: Text(
              'Example',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            rotationX: -pi / 3,
            rotationY: 0,
            layers: 5,
            depth: 8,
            direction: ZDirection.backwards,
          ),
          ZWidget(
            midChild: Text(
              'Example',
              style: TextStyle(
                  color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            midToBotChild: Text(
              'Example',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            rotationX: pi / 3,
            rotationY: 0,
            layers: 5,
            depth: 8,
            direction: ZDirection.backwards,
          ),
        ]),
        const ZWidget(
          midChild: Text(
            'Text',
            style: TextStyle(
                color: Colors.green, fontSize: 26, fontWeight: FontWeight.bold),
          ),
          midToBotChild: Text(
            'Text',
            style: TextStyle(
                color: Colors.black, fontSize: 26, fontWeight: FontWeight.bold),
          ),
          rotationX: 0,
          rotationY: -pi / 3,
          layers: 5,
          depth: 8,
          direction: ZDirection.backwards,
        ),
      ],
    );
  }

  Widget _backwardOnly() {
    return Column(children: [
      const Text('ZDirection.backwards'),
      const SizedBox(height: 10),
      Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        ZWidget(
          midChild: Container(
            width: 60,
            height: 60,
            color: Colors.blue,
          ),
          midToBotChild: Container(
            width: 60,
            height: 60,
            color: Colors.black,
          ),
          rotationX: pi / 3,
          rotationY: -pi / 4,
          layers: 5,
          depth: 8,
          direction: ZDirection.backwards,
        ),
        ZWidget(
          midChild: Container(
            width: 60,
            height: 60,
            color: Colors.red,
          ),
          midToBotChild: Container(
            width: 60,
            height: 60,
            color: Colors.black,
          ),
          rotationX: -pi / 6,
          rotationY: -pi / 4,
          layers: 15,
          depth: 20,
          direction: ZDirection.backwards,
        ),
        ZWidget(
          midChild: Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green,
            ),
          ),
          midToBotChild: Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
            ),
          ),
          rotationX: -pi / 3,
          rotationY: 0,
          layers: 5,
          depth: 8,
          direction: ZDirection.backwards,
        ),
        ZWidget(
          midChild: Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.pink,
            ),
          ),
          midToBotChild: Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
            ),
          ),
          rotationX: -pi / 6,
          rotationY: pi / 6,
          layers: 11,
          depth: 16,
          direction: ZDirection.backwards,
        )
      ]),
    ]);
  }

  Widget _forwardOnly() {
    return Column(children: [
      const Text('ZDirection.forwards'),
      const SizedBox(height: 10),
      Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        ZWidget(
          midChild: Container(
            width: 60,
            height: 60,
            color: Colors.blue,
          ),
          midToTopChild: Container(
            width: 60,
            height: 60,
            color: Colors.black.withOpacity(0.4),
          ),
          topChild: Container(
            width: 60,
            height: 60,
            color: Colors.blue,
          ),
          rotationX: pi / 3,
          rotationY: -pi / 4,
          layers: 5,
          depth: 16,
          direction: ZDirection.forwards,
        ),
        ZWidget(
          midChild: Container(
            width: 60,
            height: 60,
            color: Colors.red.withOpacity(0.6),
          ),
          midToTopChild: Container(
            width: 60,
            height: 60,
            color: Colors.black.withOpacity(0.2),
          ),
          topChild: Container(
            width: 60,
            height: 60,
            color: Colors.red.withOpacity(0.6),
          ),
          rotationX: pi / 3,
          rotationY: -pi / 4,
          layers: 11,
          depth: 16,
          direction: ZDirection.forwards,
        ),
        ZWidget(
          midChild: Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green,
            ),
          ),
          midToTopChild: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withOpacity(0.2),
            ),
          ),
          topChild: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.greenAccent,
            ),
          ),
          rotationX: -pi / 3,
          rotationY: 0,
          layers: 5,
          depth: 8,
          direction: ZDirection.forwards,
        ),
        ZWidget(
          midChild: Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
            ),
          ),
          midToTopChild: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withOpacity(0.3),
            ),
          ),
          topChild: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
            ),
          ),
          rotationX: -pi / 6,
          rotationY: pi / 6,
          layers: 11,
          depth: 32,
          direction: ZDirection.forwards,
        )
      ]),
    ]);
  }

  Widget _bothDirections() {
    return Column(children: [
      const Text('ZDirection.both'),
      const SizedBox(height: 10),
      Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        ZWidget(
          midChild: Container(
            width: 60,
            height: 60,
            color: Colors.blue,
          ),
          midToBotChild: Container(
            width: 60,
            height: 60,
            color: Colors.blueGrey,
          ),
          midToTopChild: Container(
            width: 60,
            height: 60,
            color: Colors.lightBlue,
          ),
          botChild: Container(
            width: 60,
            height: 60,
            color: Colors.grey,
          ),
          topChild: Container(
            width: 60,
            height: 60,
            color: Colors.lightBlueAccent,
          ),
          rotationX: pi / 3,
          rotationY: -pi / 4,
          layers: 5,
          depth: 32,
          direction: ZDirection.both,
        ),
        ZWidget(
          midChild: Container(
            width: 60,
            height: 60,
            color: Colors.red,
          ),
          midToBotChild: Container(
            width: 60,
            height: 60,
            color: Colors.black.withOpacity(0.2),
          ),
          midToTopChild: Container(
            width: 60,
            height: 60,
            color: Colors.white.withOpacity(0.2),
          ),
          topChild: Container(
            width: 60,
            height: 60,
            color: Colors.red,
          ),
          botChild: Container(
            width: 60,
            height: 60,
            color: Colors.red,
          ),
          rotationX: -pi / 6,
          rotationY: -pi / 4,
          layers: 15,
          depth: 24,
          direction: ZDirection.both,
        ),
        ZWidget(
          midChild: Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green,
            ),
          ),
          midToBotChild: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withOpacity(0.2),
            ),
          ),
          midToTopChild: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.lightGreen.withOpacity(0.4),
            ),
          ),
          topChild: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green,
            ),
          ),
          botChild: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green,
            ),
          ),
          rotationX: -pi / 3,
          rotationY: 0,
          layers: 9,
          depth: 24,
          direction: ZDirection.both,
        ),
        ZWidget(
          midChild: Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.pink,
            ),
          ),
          midToBotChild: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withOpacity(0.3),
            ),
          ),
          midToTopChild: Container(
            width: 60,
            height: 60,
            child: Center(
                child: Icon(
              Icons.star,
              color: Colors.white,
            )),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withOpacity(0.3),
            ),
          ),
          topChild: Container(
            width: 60,
            height: 60,
            child: Center(
                child: Icon(
              Icons.star,
              color: Colors.white,
            )),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(width: 2, color: Colors.green),
            ),
          ),
          botChild: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.pink,
              border: Border.all(width: 2, color: Colors.black),
            ),
          ),
          rotationX: -pi / 6,
          rotationY: pi / 6,
          layers: 11,
          depth: 25,
          direction: ZDirection.both,
        )
      ]),
    ]);
  }

  Widget _otherWidgets() {
    return Column(children: [
      const Text('Other widgets'),
      const SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const ZWidget(
            midChild: FlutterLogo(
              size: 50,
            ),
            rotationX: pi / 6,
            rotationY: pi / 3,
            layers: 11,
            depth: 12,
            direction: ZDirection.backwards,
          ),
          ZWidget(
            midChild: Image.asset(
              'assets/dashatar.png',
              width: 100,
              height: 100,
              fit: BoxFit.fitHeight,
            ),
            rotationX: pi / 6,
            rotationY: pi / 4,
            layers: 11,
            depth: 12,
            direction: ZDirection.backwards,
          ),
          const ZWidget(
            midChild: Icon(Icons.home_rounded),
            midToBotChild: Icon(
              Icons.home_rounded,
              color: Colors.grey,
            ),
            rotationX: pi / 6,
            rotationY: -pi / 4,
            layers: 11,
            depth: 12,
            direction: ZDirection.backwards,
          ),
          ZWidget(
            midChild: CustomPaint(
              painter: ExampleCustomPainter(),
              size: const Size(50, 50),
            ),
            rotationX: -pi / 3,
            rotationY: -pi / 6,
            layers: 11,
            depth: 12,
            direction: ZDirection.backwards,
          ),
        ],
      ),
    ]);
  }
}
