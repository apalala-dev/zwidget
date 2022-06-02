import 'package:flutter/material.dart';

enum ZDirection {
  both,
  backwards,
  forwards,
}

/// Use this `Matrix4` to perform 3D-like operations on anything (Widget,
/// Canvas, Path, ...)
///
///
/// ``` dart
/// // Widget example:
/// Transform(
///   transform: zMatrix4(xTilt: pi / 3, yTilt: pi / 4, perspective: 5),
///   child: Container(
///     color: Colors.red,
///     width: 100,
///     height: 100,
///   ),
/// );
/// ...
/// // Canvas example:
/// canvas.transform(zMatrix4(xTilt: pi/3).storage);
/// ...
/// // Path example:
/// Path p = Path()
///   ..addOval(Rect.fromCenter(
///        center: Offset(size.width / 2, size.height / 2),
///        width: size.width / 4,
///        height: size.height / 4))
///    ..transform(zMatrix4(xTilt: pi / 3).storage);
///  canvas.drawPath(p, Paint()..color = Colors.amber);
/// ```
Matrix4 zMatrix4({
  double xTilt = 0.0,
  double yTilt = 0.0,
  double perspective = 1.0,
  double zTranslation = 0.0,
}) {
  return Matrix4.identity()
    ..setEntry(3, 2, 0.001 * perspective)
    ..rotateX(xTilt)
    ..rotateY(yTilt)
    ..translate(0.0, 0.0, zTranslation);
}

// TODO The Opacity widget is bad for performances and is buggy (it makes things appear at a different place on android than on web)
class ZWidget extends StatelessWidget {
  final Widget Function(int) builder;

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

  /// When using this constructor, you are responsible to determine which [Widget]
  /// should be displayed at each [layer] using the [builder] parameter.
  ///
  /// You can take a look at other constructors to see how it is usually
  /// implemented.
  const ZWidget.builder({
    this.depth = 1,
    this.direction = ZDirection.both,
    this.rotationX = 0,
    this.rotationY = 0,
    this.fade = false,
    int layers = 4,
    this.reverse = false,
    this.debug = false,
    this.alignment,
    this.perspective = 1,
    required this.builder,
    super.key,
  }) : layers = layers % 2 == 0 ? layers + 1 : layers;

  /// Simulates 3D in the backwards direction using the provided [midChild],
  /// [midToBotChild] and [botChild].
  ///
  /// If you need more control, take a look at the [ZWidget.builder] constructor.
  ZWidget.backwards({
    this.depth = 1,
    this.rotationX = 0,
    this.rotationY = 0,
    this.fade = false,
    int layers = 4,
    this.reverse = false,
    this.debug = false,
    this.alignment,
    this.perspective = 1,
    required Widget midChild,
    Widget? midToBotChild,
    Widget? botChild,
    super.key,
  })  : layers = layers % 2 == 0 ? layers + 1 : layers,
        direction = ZDirection.backwards,
        builder = ((layer) {
          final nbLayers = layers % 2 == 0 ? layers + 1 : layers;
          Widget midToBot = midToBotChild ?? midChild;
          Widget bot = botChild ?? midToBotChild ?? midChild;

          Widget layerChild;
          if (layer == 0) {
            layerChild = bot;
          } else if (layer == nbLayers - 1) {
            layerChild = midChild;
          } else {
            layerChild = midToBot;
          }
          return layerChild;
        });

  /// Simulates 3D in the forwards direction using the provided [midChild],
  /// [midToTopChild] and [topChild].
  ///
  /// If you need more control, take a look at the [ZWidget.builder] constructor.
  ZWidget.forwards({
    this.depth = 1,
    this.rotationX = 0,
    this.rotationY = 0,
    this.fade = false,
    int layers = 4,
    this.reverse = false,
    this.debug = false,
    this.alignment,
    this.perspective = 1,
    required Widget midChild,
    Widget? midToTopChild,
    Widget? topChild,
    super.key,
  })  : layers = layers % 2 == 0 ? layers + 1 : layers,
        direction = ZDirection.forwards,
        builder = ((layer) {
          final nbLayers = layers % 2 == 0 ? layers + 1 : layers;
          Widget midToTop = midToTopChild ?? midChild;
          Widget top = topChild ?? midToTopChild ?? midChild;

          Widget layerChild;
          if (layer == 0) {
            layerChild = midChild;
          } else if (layer == nbLayers - 1) {
            layerChild = top;
          } else {
            layerChild = midToTop;
          }
          return layerChild;
        });

  /// Simulates 3D in both backwards and forwards directions using the provided
  /// Widgets.
  ///
  /// [midChild] will be at the middle of the layers
  ///
  /// [midToTopChild] and [topChild] define the layers above [midChild].
  ///
  /// [midToBotChild] and [botChild] define the layers below [midChild].
  ///
  /// When [midToTopChild] or [midToBotChild] is not provided, [midChild] will
  /// be used instead. Similarly, if [topChild] or [botChild] is null,
  /// [midToTopChild] and [midToBotChild] will be used instead respectively.
  /// If you need more control, take a look at the [ZWidget.builder] constructor.
  ZWidget.bothDirections({
    this.depth = 1,
    this.rotationX = 0,
    this.rotationY = 0,
    this.fade = false,
    int layers = 4,
    this.reverse = false,
    this.debug = false,
    this.alignment,
    this.perspective = 1,
    required Widget midChild,
    Widget? midToTopChild,
    Widget? topChild,
    Widget? midToBotChild,
    Widget? botChild,
    super.key,
  })  : layers = layers % 2 == 0 ? layers + 1 : layers,
        direction = ZDirection.both,
        builder = ((layer) {
          final nbLayers = layers % 2 == 0 ? layers + 1 : layers;

          Widget midToBot = midToBotChild ?? midChild;
          Widget midToTop = midToTopChild ?? midChild;
          Widget top = topChild ?? midToTopChild ?? midChild;
          Widget bot = botChild ?? midToBotChild ?? midChild;

          final midLayer = (nbLayers / 2).round() - 1;
          Widget layerChild;
          if (layer == midLayer) {
            layerChild = midChild;
          } else if (layer == 0) {
            layerChild = bot;
          } else if (layer < midLayer) {
            layerChild = midToBot;
          } else if (layer == nbLayers - 1) {
            layerChild = top;
          } else {
            layerChild = midToTop;
          }
          return layerChild;
        });

  @Deprecated(
      "Use ZWidget.builder(), ZWidget.backwards(), ZWidget.forwards() or ZWidget.bothDirections() instead")
  ZWidget({
    required Widget midChild,
    Widget? midToBotChild,
    Widget? botChild,
    Widget? midToTopChild,
    Widget? topChild,
    super.key,
    this.depth = 1,
    this.direction = ZDirection.both,
    this.rotationX = 0,
    this.rotationY = 0,
    this.fade = false,
    int layers = 4,
    this.reverse = false,
    this.debug = false,
    this.alignment,
    this.perspective = 1,
  })  : layers = layers % 2 == 0 ? layers + 1 : layers,
        builder = ((layer) {
          final nbLayers = layers % 2 == 0 ? layers + 1 : layers;

          Widget midToBot = midToBotChild ?? midChild;
          Widget midToTop = midToTopChild ?? midChild;
          Widget top = topChild ?? midToTopChild ?? midChild;
          Widget bot = botChild ?? midToBotChild ?? midChild;

          final midLayer = (nbLayers / 2).round() - 1;
          Widget layerChild;
          switch (direction) {
            case ZDirection.both:
              if (layer == midLayer) {
                layerChild = midChild;
              } else if (layer == 0) {
                layerChild = bot;
              } else if (layer < midLayer) {
                layerChild = midToBot;
              } else if (layer == nbLayers - 1) {
                layerChild = top;
              } else {
                layerChild = midToTop;
              }
              break;
            case ZDirection.backwards:
              if (layer == 0) {
                layerChild = bot;
              } else if (layer == nbLayers - 1) {
                layerChild = midChild;
              } else {
                layerChild = midToBot;
              }
              break;
            case ZDirection.forwards:
              if (layer == 0) {
                layerChild = midChild;
              } else if (layer == nbLayers - 1) {
                layerChild = top;
              } else {
                layerChild = midToTop;
              }
              break;
          }
          return layerChild;
        });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(
          layers,
          (index) => _ZWidgetLayer(
                builder: builder,
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

/// Determines which [Widget] should be put for a given [layer] using the
/// [builder].
/// It is also responsible to transform the [Widget] adequately based on its
/// [layer] position and the other settings ([depth], [xPercent], [yPercent],
/// [perspective], [reverse], [alignment])
class _ZWidgetLayer extends StatelessWidget {
  /// Determines which [Widget] to display for a given [layer]
  final Widget Function(int) builder;

  /// Which [layer] should be displayed
  final int layer;

  /// Total number of layers for this [ZWidget]
  final int nbLayers;

  /// Spacing between layers
  final double depth;

  /// Direction of the 3D effect
  final ZDirection direction;
  final bool reverse;

  /// Not used atm
  final bool fade;

  /// Percent rotation around X axis
  final double xPercent;

  /// Percent rotation around Y axis
  final double yPercent;

  /// Displays a border around the built [Widget] if [true]
  final bool debug;

  /// Alignment of the layers. You should probably stick to [Alignment.center]
  final Alignment? alignment;

  /// The bigger this value, the more difference there will be between each layer transformations
  final double perspective;

  const _ZWidgetLayer({
    required this.builder,
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

    double zTranslation;
    switch (direction) {
      case ZDirection.both:
        zTranslation = -(percent * depth) + depth / 2;
        break;
      case ZDirection.backwards:
        zTranslation = -(percent * depth) + depth;
        break;
      case ZDirection.forwards:
        zTranslation = -percent * depth;
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
    Widget layerChild = builder(layer);

    if (!fade) {
      final content = Transform(
        transform: zMatrix4(
          xTilt: xTilt,
          yTilt: yTilt,
          perspective: perspective,
          zTranslation: zTranslation,
        ),
        alignment: alignment ?? FractionalOffset.center,
        child: layerChild,
      );
      if (debug) {
        return Container(
          decoration:
              BoxDecoration(border: Border.all(width: 2, color: Colors.pink)),
          child: content,
        );
      } else {
        return content;
      }
    }

    return Opacity(
      opacity: fade ? percent / 2 : 1,
      child: Transform(
        transform: zMatrix4(
          xTilt: xTilt,
          yTilt: yTilt,
          perspective: perspective,
          zTranslation: zTranslation,
        ),
        alignment: FractionalOffset.center,
        child: layerChild,
      ),
    );
  }
}
