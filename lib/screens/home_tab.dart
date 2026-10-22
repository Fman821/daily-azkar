import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/content.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'azkar_list_screen.dart';
import 'names_screen.dart';

class _Ayah {
  const _Ayah(this.arabic, this.amharic, this.reference);

  final String arabic;
  final String amharic;
  final String reference;
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key, required this.onOpenTab});

  /// Switches the bottom navigation to the tab at [index].
  final void Function(int index) onOpenTab;

  static const _ayat = <_Ayah>[
    _Ayah(
      'أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ',
      'አስታውሱ! ልቦች የሚረጋጉት በአላህ ማስታወስ ብቻ ነው።',
      'ሱረቱ አር-ረዕድ (13:28)',
    ),
    _Ayah(
      'فَاذْكُرُونِي أَذْكُرْكُمْ',
      'እኔን አስታውሱ፤ እኔም አስታውሳችኋለሁ።',
      'ሱረቱል በቀራ (2:152)',
    ),
    _Ayah(
      'إِنَّ مَعَ الْعُسْرِ يُسْرًا',
      'ከችግር ጋር ምቾት አለና።',
      'ሱረቱ አሽ-ሸርሕ (94:6)',
    ),
    _Ayah(
      'وَمَنْ يَتَوَكَّلْ عَلَى اللَّهِ فَهُوَ حَسْبُهُ',
      'በአላህ የሚመካ ሰው እርሱ ይበቃዋል።',
      'ሱረቱ ጦላቅ (65:3)',
    ),
    _Ayah(
      'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
      'ጌታችን ሆይ! በዱንያ መልካምን ስጠን፤ በአኼራም መልካምን ስጠን፤ ከእሳት ቅጣትም ጠብቀን።',
      'ሱረቱል በቀራ (2:201)',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final content = context.read<Content>();
    final morning = content.categoryById('morning')!;
    final evening = content.categoryById('evening')!;

    // A different verse each day.
    final dayIndex = DateTime.now().difference(DateTime(2024)).inDays;
    final ayah = _ayat[dayIndex % _ayat.length];

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          _Header(name: state.name),
          const SizedBox(height: 16),
          GoldCard(
            child: Column(
              children: [
                Text(
                  ayah.arabic,
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: 'Quran',
                    fontSize: 22 * state.fontScale,
                    height: 1.9,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  ayah.amharic,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15 * state.fontScale,
                    height: 1.6,
                    color: AppColors.textSoft,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  ayah.reference,
                  style: const TextStyle(fontSize: 12, color: AppColors.muted),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _CategoryTile(
                  category: morning,
                  onTap: () => openCategory(context, morning),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _CategoryTile(
                  category: evening,
                  onTap: () => openCategory(context, evening),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ImageTile(
                  image: 'bg_names.jpg',
                  height: 170,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (_) => const NamesScreen()),
                  ),
                  child: const TileText(
                    icon: Icons.auto_awesome_outlined,
                    title: '99 የአላህ ስሞች',
                    subtitle: 'አስማኡል ሁስና',
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ImageTile(
                  image: 'bg_duas.jpg',
                  height: 170,
                  onTap: () => onOpenTab(2),
                  child: const TileText(
                    icon: Icons.front_hand_outlined,
                    title: 'ጸሎቶች',
                    subtitle: 'ዱዓዎችና ምክሮች',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const _TasbihCard(),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () => onOpenTab(1),
            icon: const Icon(Icons.wb_sunny_outlined),
            label: const Text('ሁሉንም የአዝካር ክፍሎች ይመልከቱ'),
          ),
        ],
      ),
    );
  }
}

/// Opens an azkar category's list of items.
void openCategory(BuildContext context, AzkarCategory category) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => AzkarListScreen(category: category),
    ),
  );
}

class _Header extends StatelessWidget {
  const _Header({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 84,
          height: 84,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFFF3CF5A), Color(0xFFA8801F)],
            ),
            boxShadow: [
              BoxShadow(color: AppColors.gold.withAlpha(90), blurRadius: 18),
            ],
          ),
          child: const Icon(
            Icons.brightness_high,
            size: 44,
            color: Color(0xFF2A1D00),
          ),
        ),
        const SizedBox(height: 12),
        ShaderMask(
          shaderCallback: (rect) => const LinearGradient(
            colors: [Color(0xFFFFF1B8), Color(0xFFF0C84A), Color(0xFFB98A14)],
          ).createShader(rect),
          child: const Text(
            'እስላማዊ አዝካር',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          name.isEmpty ? 'የቀን በረከት ለማስታወስ' : 'ሰላም አለይኩም፣ $name',
          style: const TextStyle(color: AppColors.textSoft),
        ),
      ],
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.category, required this.onTap});

  final AzkarCategory category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ImageTile(
      image: category.image,
      height: 190,
      onTap: onTap,
      child: TileText(
        icon: iconFor(category.icon),
        title: category.title,
        subtitle: category.subtitle,
        trailing: '${category.items.length}',
      ),
    );
  }
}

class _TasbihCard extends StatelessWidget {
  const _TasbihCard();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return GoldCard(
      child: Row(
        children: [
          Container(
            width: 74,
            height: 74,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.orange, width: 3),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'ተስቢሕ',
                  style: TextStyle(fontSize: 12, color: AppColors.muted),
                ),
                Text(
                  '${state.tasbih}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.gold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'የተስቢህ ቆጣሪ',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.gold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'ሱብሓነላህ • አልሐምዱሊላህ • አላሁ አክበር',
                  style: TextStyle(fontSize: 12, color: AppColors.muted),
                ),
              ],
            ),
          ),
          FilledButton(
            onPressed: () => context.read<AppState>().tapTasbih(),
            child: const Text('+1'),
          ),
          IconButton(
            tooltip: 'ዳግም አስጀምር',
            onPressed: () => context.read<AppState>().resetTasbih(),
            icon: const Icon(Icons.refresh, color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}
