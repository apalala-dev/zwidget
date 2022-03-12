ZWidget creates a 3D-like visual by stacking widgets one above the other and transforming them
adequately.

This package is heavily inspired by [ztext.js](https://bennettfeely.com/ztext/).

Since Text is a Widget, and since everything is a Widget in Flutter, apply your 3D effect to any
element of your UI!

It was created for the Flutter Puzzle Hack.

**Note: this package is in early! Its API might change.**

## Features

// Show Gif of both example screens

## Usage

Use ZWidget in your UI like this:

```dart

final child = ZWidget(
  midChild: someWidget, // middle layer
  midToTopChild: otherWidget, // layers between mid and top child
  topChild: topChild, // layer at the top of the Stack
  midToBothild: otherWidget, // layers between mid and bot child
  botChild: botChild, // layer at the bottom of the Stack
  rotationX: pi / 3, // rotation around X axis
  rotationY: -pi / 4, // rotation around Y axis
  layers: 11, // Number of layers. Always odd (increased if even)
  depth: 16, // Space between layers
  direction: ZDirection.forwards, // forwards, backwards or both compared to the midChild.
);
```

You need to think in terms of layers when using `ZWidget`. They are visibles in the picture below:

// Insert picture

There is always an odd number of `layers`.
If you define an even number, it will be increased to be an odd number.
Increase `depth` to increase their spacing.

`ZDirection` can be `forward`, `backward` or `both`.

Mid layer is the `midChild`.
Depending on the `ZDirection`, other layers are displayed above or below the `midChild`.
You can define the `botChild` for the child at the bottom of the Stack and `topChild` for the one at the top.
Define Widgets between extremities and `midChild` with `midToTopChild` and `midToBotChild`.

Use the `alignment` property to set the Transform origin.

To effectively see the 3D effect, you must define a rotation to the ZWidget using `rotationX` and `rotationY`.


See the example project for more details.

## Performance considerations

If ZWidget has 11 layers, it means that 11 Widgets will be drawn.
Try to limit the complexity of widgets used for the 3D effect.

For instance, an opaque Image could use simple Containers to simulate a 3D effect:

```dart

final child = ZWidget(
  midChild: Container(
    color: Colors.black,
    // ...
  ),
  topChild: Image(
    // ...
  ),
  rotationX: pi / 3,
  rotationY: -pi / 4,
  layers: 11,
  depth: 16,
  direction: ZDirection.forwards,
);
```

## Other arguments

``` dart
final Widget? midToBotChild;
final Widget? botChild;
final Widget? midToTopChild;
final Widget? topChild;

final double depth;
final ZDirection direction;
final double rotationX;
final double rotationY;
final bool fade;
final int layers;
final bool z;
final bool reverse;
final bool debug;
final double perspective;
final Alignment? alignment;

```

## Using this package

- [ZPuzzle](https://play-zpuzzle.web.app)

Contact me if you are using this package and I will add you to the list!