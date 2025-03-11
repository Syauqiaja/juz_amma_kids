import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Globals {
  static late SharedPreferences prefs;

  // Initialize SharedPreferences
  static Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  // Text styles used globally
  static TextStyle get shamel => const TextStyle(fontFamily: 'Poppins');
  static TextStyle get hafsfont => const TextStyle(fontFamily: 'Hafs');
  static double get buttonsFontSize => 16.0;

  // Method to set the locale
  static void setLocale(BuildContext context, String languageCode) {
    Locale locale = Locale(
      languageCode == 'device'
          ? WidgetsBinding.instance.window.locale.languageCode
          : languageCode,
    );
    MyApp.setLocale(context, locale);
  }

  // Convert dp to pixels
  static double convertDpToPixel(double dp) {
    final double scale = WidgetsBinding.instance.window.devicePixelRatio;
    return dp * scale;
  }

  // Convert pixels to dp
  static double convertPixelsToDp(double px) {
    final double scale = WidgetsBinding.instance.window.devicePixelRatio;
    return px / scale;
  }

  // Convert dp to integer pixels
  static int convertDpToPixelInt(double dp) {
    final double scale = WidgetsBinding.instance.window.devicePixelRatio;
    final double px = dp * scale;
    return px.round(); // Convert to int using round()
  }

  // Current locale
  static Locale get currentLocale => _MyAppState.currentLocale;

  // Load border images (utility method to be used in other classes)
  static Future<BorderImages> loadBorderImages() async {
    return BorderImages(
      topleft: await _loadImage('assets/border/topleft.png'),
      topright: await _loadImage('assets/border/topright.png'),
      bottomleft: await _loadImage('assets/border/bottomleft.png'),
      bottomright: await _loadImage('assets/border/bottomright.png'),
      top: await _loadImage('assets/border/top.png'),
      left: await _loadImage('assets/border/left.png'),
      right: await _loadImage('assets/border/right.png'),
      bottom: await _loadImage('assets/border/bottom.png'),
    );
  }

  // Load a single image
  static Future<ui.Image> _loadImage(String path) async {
    final ByteData data = await rootBundle.load(path);
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    final frame = await codec.getNextFrame();
    return frame.image;
  }
}

// BorderImages class to hold the border images
class BorderImages {
  final ui.Image topleft;
  final ui.Image topright;
  final ui.Image bottomleft;
  final ui.Image bottomright;
  final ui.Image top;
  final ui.Image left;
  final ui.Image right;
  final ui.Image bottom;

  BorderImages({
    required this.topleft,
    required this.topright,
    required this.bottomleft,
    required this.bottomright,
    required this.top,
    required this.left,
    required this.right,
    required this.bottom,
  });
}

// BorderPainter class for painting borders around a widget
class BorderPainter extends CustomPainter {
  final BorderImages images;
  final double frameWidth;
  final double frameHeight;

  BorderPainter({
    required this.images,
    required this.frameWidth,
    required this.frameHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final scaleWidth = size.width / frameWidth;
    final scaleHeight = size.height / frameHeight;
    final scale = scaleWidth < scaleHeight ? scaleWidth : scaleHeight;

    final cornerScale = scale * 1.2;
    final sideScale = scale * 1.2;
    final topBottomScale = scale * 1.2;

    // Scale and draw corners
    final scaledTopLeftWidth = images.topleft.width * cornerScale;
    final scaledTopLeftHeight = images.topleft.height * cornerScale;
    final scaledTopRightWidth = images.topright.width * cornerScale;
    final scaledTopRightHeight = images.topright.height * cornerScale;
    final scaledBottomLeftWidth = images.bottomleft.width * cornerScale;
    final scaledBottomLeftHeight = images.bottomleft.height * cornerScale;
    final scaledBottomRightWidth = images.bottomright.width * cornerScale;
    final scaledBottomRightHeight = images.bottomright.height * cornerScale;

    // Draw top-left corner
    canvas.drawImageRect(
      images.topleft,
      Rect.fromLTWH(0, 0 + 4, images.topleft.width.toDouble(),
          images.topleft.height.toDouble()),
      Rect.fromLTWH(0, 0 + 4, scaledTopLeftWidth, scaledTopLeftHeight),
      paint,
    );

    // Draw top-right corner
    canvas.drawImageRect(
      images.topright,
      Rect.fromLTWH(0, 0 + 4, images.topright.width.toDouble(),
          images.topright.height.toDouble()),
      Rect.fromLTWH(size.width - scaledTopRightWidth, 0 + 4, scaledTopRightWidth,
          scaledTopRightHeight),
      paint,
    );

    // Draw bottom-left corner
    canvas.drawImageRect(
      images.bottomleft,
      Rect.fromLTWH(0, 0, images.bottomleft.width.toDouble(),
          images.bottomleft.height.toDouble()),
      Rect.fromLTWH(0, size.height - scaledBottomLeftHeight - 3,
          scaledBottomLeftWidth, scaledBottomLeftHeight),
      paint,
    );

    // Draw bottom-right corner
    canvas.drawImageRect(
      images.bottomright,
      Rect.fromLTWH(0, 0, images.bottomright.width.toDouble(),
          images.bottomright.height.toDouble()),
      Rect.fromLTWH(
          size.width - scaledBottomRightWidth,
          size.height - scaledBottomRightHeight - 3,
          scaledBottomRightWidth,
          scaledBottomRightHeight),
      paint,
    );

    // Draw top border
    double topX = scaledTopLeftWidth;
    while (topX < size.width - scaledTopRightWidth) {
      double nextTopX = topX + images.top.width * topBottomScale;
      if (nextTopX > size.width - scaledTopRightWidth) {
        nextTopX = size.width - scaledTopRightWidth;
      }
      canvas.drawImageRect(
        images.top,
        Rect.fromLTWH(
            0, 0 + 4, images.top.width.toDouble(), images.top.height.toDouble()),
        Rect.fromLTWH(
            topX, 0 + 4, nextTopX - topX, images.top.height * topBottomScale),
        paint,
      );
      topX = nextTopX;
    }

    // Draw bottom border
    double bottomX = scaledBottomLeftWidth;
    while (bottomX < size.width - scaledBottomRightWidth) {
      double nextBottomX = bottomX + images.bottom.width * topBottomScale;
      if (nextBottomX > size.width - scaledBottomRightWidth) {
        nextBottomX = size.width - scaledBottomRightWidth;
      }
      canvas.drawImageRect(
        images.bottom,
        Rect.fromLTWH(0, 0  - 1, images.bottom.width.toDouble(),
            images.bottom.height.toDouble()),
        Rect.fromLTWH(
            bottomX,
            size.height - images.bottom.height.toDouble() * topBottomScale - 3,
            nextBottomX - bottomX,
            images.bottom.height * topBottomScale),
        paint,
      );
      bottomX = nextBottomX;
    }

    // Draw left border
    double leftY = scaledTopLeftHeight;
    while (leftY < size.height - scaledBottomLeftHeight) {
      double nextLeftY = leftY + images.left.height * sideScale;
      if (nextLeftY > size.height - scaledBottomLeftHeight) {
        nextLeftY = size.height - scaledBottomLeftHeight;
      }
      canvas.drawImageRect(
        images.left,
        Rect.fromLTWH(
            0, 0, images.left.width.toDouble(), images.left.height.toDouble()),
        Rect.fromLTWH(
            0, leftY, images.left.width * sideScale, nextLeftY - leftY),
        paint,
      );
      leftY = nextLeftY;
    }

    // Draw right border
    double rightY = scaledTopRightHeight;
    while (rightY < size.height - scaledBottomRightHeight) {
      double nextRightY = rightY + images.right.height * sideScale;
      if (nextRightY > size.height - scaledBottomRightHeight) {
        nextRightY = size.height - scaledBottomRightHeight;
      }
      canvas.drawImageRect(
        images.right,
        Rect.fromLTWH(0, 0, images.right.width.toDouble(),
            images.right.height.toDouble()),
        Rect.fromLTWH(
            size.width - images.right.width.toDouble() * sideScale + 0.5,
            rightY,
            images.right.width.toDouble() * sideScale + 2,
            nextRightY - rightY),
        paint,
      );
      rightY = nextRightY;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>()!;
    state.setLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static Locale _locale = const Locale('en');
  late Future<BorderImages> _borderImagesFuture;

  static Locale get currentLocale => _locale;

  @override
  void initState() {
    super.initState();
    _borderImagesFuture = Globals.loadBorderImages();
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: _locale,
      supportedLocales: const [Locale('en'), Locale('ar')],
      localizationsDelegates: const [
        // Add localization delegates if needed
      ],
      home: FutureBuilder<BorderImages>(
        future: _borderImagesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading border images'));
          } else if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Bordered App'),
              ),
              body: Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: BorderPainter(
                        images: snapshot.data!,
                        frameWidth: MediaQuery.of(context).size.width,
                        frameHeight: MediaQuery.of(context).size.height,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      'Hello, World!',
                      style: Globals.hafsfont.copyWith(fontSize: 24),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
