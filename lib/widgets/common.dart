import 'package:flutter/material.dart';

import '../theme.dart';

/// Maps the icon names used in azkar.json to Material icons.
IconData iconFor(String name) {
  switch (name) {
    case 'sun':
      return Icons.wb_sunny_outlined;
    case 'clock':
      return Icons.schedule;
    case 'moon':
      return Icons.nights_stay_outlined;
    case 'home':
      return Icons.home_outlined;
    case 'plane':
      return Icons.flight_outlined;
    case 'list':
      return Icons.format_list_bulleted;
    case 'names':
      return Icons.auto_awesome_outlined;
    case 'hand':
      return Icons.front_hand_outlined;
    default:
      return Icons.menu_book_outlined;
  }
}

/// Dark green card with a gold border, used for every content block.
class GoldCard extends StatelessWidget {
  const GoldCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0F3B29), AppColors.cardDeep],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.goldSoft.withAlpha(150)),
        boxShadow: const [
          BoxShadow(color: Color(0x66000000), blurRadius: 14, offset: Offset(0, 6)),
        ],
      ),
      // A transparent Material gives ListTile, IconButton and TextField the
      // Material ancestor they need, without painting anything extra.
      child: Material(
        type: MaterialType.transparency,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

/// A tile with a background photo, a dark gradient on top and content at the bottom.
class ImageTile extends StatelessWidget {
  const ImageTile({
    super.key,
    required this.image,
    required this.height,
    required this.child,
    this.onTap,
  });

  final String image;
  final double height;
  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(20);
    return SizedBox(
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: radius,
          border: Border.all(color: AppColors.goldSoft.withAlpha(160)),
          boxShadow: const [
            BoxShadow(color: Color(0x66000000), blurRadius: 14, offset: Offset(0, 6)),
          ],
        ),
        child: ClipRRect(
          borderRadius: radius,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset('assets/images/$image', fit: BoxFit.cover),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.bg.withAlpha(60),
                      AppColors.card.withAlpha(235),
                    ],
                  ),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: radius,
                  onTap: onTap,
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Align(alignment: Alignment.bottomLeft, child: child),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Icon, optional badge, title and subtitle, used on top of an [ImageTile].
class TileText extends StatelessWidget {
  const TileText({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.gold, size: 26),
            const Spacer(),
            if (trailing != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.goldSoft),
                  color: AppColors.gold.withAlpha(30),
                ),
                child: Text(
                  trailing!,
                  style: const TextStyle(color: AppColors.gold, fontSize: 13),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.gold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 12, color: AppColors.textSoft),
        ),
      ],
    );
  }
}
