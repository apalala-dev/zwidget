import 'dart:math';

import 'package:flutter/material.dart';

enum ZDirection {
  both,
  backwards,
  forwards,
}

zMatrix4() {
  // TODO Implement this method, with all args needed to replace layers business logic
  // This way, we could apply this matrix4 to anything: a widget, a canvas or a path (other things might apply)
}

// TODO The Opacity widget is bad for performances and is buggy (it makes things appear at a different place on android than on web)
class ZWidget extends StatelessWidget {
  final Widget midChild;
  final Widget? midToBotChild;
  final Widget? botChild;
  final Widget? midToTopChild;
  final Widget? topChild;

  // final Widget Function(int) builder;

  final double depth;
  final ZDirection direction;
  final double rotationX;
  final double rotationY;
  final bool fade;
  final int layers;
  final bool reverse;
  final bool debug;
  final double perspective;
  final Alignment? alignment;

  const ZWidget(
      {required this.midChild,
      this.midToBotChild,
      this.botChild,
      this.midToTopChild,
      this.topChild,
      Key? key,
      this.depth = 1,
      this.direction = ZDirection.both,
      this.rotationX = 0,
      this.rotationY = 0,
      this.fade = false,
      int layers = 4,
      this.reverse = false,
      this.debug = false,
      this.alignment,
      this.perspective = 1})
      : layers = layers % 2 == 0 ? layers + 1 : layers,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(
          layers,
          (index) => _ZWidgetLayer(
                midChild,
                midToBotChild: midToBotChild ?? midChild,
                midToTopChild: midToTopChild ?? midChild,
                topChild: topChild ?? midToTopChild ?? midChild,
                botChild: botChild ?? midToBotChild ?? midChild,
                layer: index,
                nbLayers: layers,
                direction: direction,
                depth: depth,
                fade: fade,
                xPercent: rotationX,
                yPercent: rotationY,
                reverse: false,
                debug: debug,
                alignment: alignment,
                perspective: perspective,
              )),
    );
  }
}

// see https://pub.dev/packages/zflutter for an other way of doing it
class _ZWidgetLayer extends StatelessWidget {
  final Widget midChild;
  final Widget midToBotChild;
  final Widget midToTopChild;
  final Widget topChild;
  final Widget botChild;
  final int layer;
  final int nbLayers;
  final double depth;
  final ZDirection direction;
  final bool reverse;
  final bool fade;
  final double xPercent;
  final double yPercent;
  final bool debug;
  final Alignment? alignment;
  final double perspective;

  const _ZWidgetLayer(
    this.midChild, {
    required this.midToBotChild,
    required this.midToTopChild,
    required this.topChild,
    required this.botChild,
    required this.layer,
    required this.nbLayers,
    required this.direction,
    required this.reverse,
    required this.depth,
    required this.fade,
    required this.xPercent,
    required this.yPercent,
    this.debug = false,
    required this.alignment,
    required this.perspective,
  });

  @override
  Widget build(BuildContext context) {
    var percent = layer / nbLayers;

    Widget layerChild;
    double zTranslation;
    final midLayer = (nbLayers / 2).round() - 1;
    switch (direction) {
      case ZDirection.both:
        zTranslation = -(percent * depth) + depth / 2;
        if (layer == midLayer) {
          layerChild = midChild;
        } else if (layer == 0) {
          layerChild = botChild;
        } else if (layer < midLayer) {
          layerChild = midToBotChild;
        } else if (layer == nbLayers - 1) {
          layerChild = topChild;
        } else {
          layerChild = midToTopChild;
        }
        break;
      case ZDirection.backwards:
        zTranslation = -(percent * depth) + depth;
        if (layer == 0) {
          layerChild = botChild;
        } else if (layer == nbLayers - 1) {
          layerChild = midChild;
        } else {
          layerChild = midToBotChild;
        }
        break;
      case ZDirection.forwards:
        zTranslation = -percent * depth;
        if (layer == 0) {
          layerChild = midChild;
        } else if (layer == nbLayers - 1) {
          layerChild = topChild;
        } else {
          layerChild = midToTopChild;
        }
        break;
    }

    // Switch neg/pos values if eventDirection is reversed
    double eventDirectionAdj;
    if (reverse) {
      eventDirectionAdj = -1;
    } else {
      eventDirectionAdj = 1;
    }

    var xTilt = xPercent * eventDirectionAdj;
    var yTilt = -yPercent * eventDirectionAdj;

    if (!fade) {
      final content = Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001 * perspective)
          ..rotateX(xTilt)
          ..rotateY(yTilt)
          ..translate(0.0, 0.0, zTranslation),
        child: layerChild,
        alignment: alignment ?? FractionalOffset.center,
      );
      if (debug) {
        return Container(
          child: content,
          decoration:
              BoxDecoration(border: Border.all(width: 2, color: Colors.pink)),
        );
      } else {
        return content;
      }
    }

    return Opacity(
      child: Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateX(xTilt)
          ..rotateY(yTilt)
          ..translate(0.0, 0.0, zTranslation),
        child: layerChild,
        alignment: FractionalOffset.center,
      ),
      opacity: fade ? percent / 2 : 1,
    );

    return Opacity(
      child: Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateX(xTilt)
          ..rotateY(yTilt)
          ..translate(0, 0, zTranslation),
        child: layerChild,
      ),
      opacity: fade ? percent / 2 : 1,
    );
  }
}
