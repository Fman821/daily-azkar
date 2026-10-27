import 'package:flutter/material.dart';

import '../theme.dart';

/// A photo behind a whole screen. The theme's background colour is laid over
/// it, lighter at the top and stronger at the bottom, so the text on top stays
/// readable in every theme.
///
/// [image] is a file name inside assets/images. To use another photo, put a
/// file with the same name there.
class PhotoBackdrop extends StatelessWidget {
  const PhotoBackdrop({super.key, required this.image, required this.child});

  final String image;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Solid colour first, so nothing shows through while the photo loads.
        ColoredBox(color: AppColors.bg),
        Image.asset(
          'assets/images/$image',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.bg.withAlpha(135),
                AppColors.bg.withAlpha(230),
              ],
            ),
          ),
        ),
        child,
      ],
    );
  }
}

/// A rounded panel with a photo, a shade over the photo and a gold border.
/// [child] sits on top. Give it a [height] for tiles, or leave it out to let
/// the content decide.
class PhotoPanel extends StatelessWidget {
  const PhotoPanel({
    super.key,
    required this.image,
    required this.child,
    this.onTap,
    this.height,
    this.radius = 24,
    this.padding = const EdgeInsets.all(16),
  });

  final String image;
  final Widget child;
  final VoidCallback? onTap;
  final double? height;
  final double radius;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final shape = BorderRadius.circular(radius);
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: shape,
        border: Border.all(color: AppColors.goldSoft.withAlpha(150)),
        boxShadow: const [
          BoxShadow(color: Color(0x66000000), blurRadius: 14, offset: Offset(0, 6)),
        ],
        image: DecorationImage(
          image: AssetImage('assets/images/$image'),
          fit: BoxFit.cover,
        ),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: shape,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.bg.withAlpha(40),
              AppColors.card.withAlpha(205),
            ],
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: shape,
            onTap: onTap,
            child: Padding(padding: padding, child: child),
          ),
        ),
      ),
    );
  }
}
