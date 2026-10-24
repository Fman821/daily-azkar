import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/content.dart';
import '../widgets/common.dart';
import '../widgets/dhikr_card.dart';
import 'names_screen.dart';

/// The "ጸሎት" tab: the 99 names entry point and the list of duas.
class DuasTab extends StatelessWidget {
  const DuasTab({super.key});

  @override
  Widget build(BuildContext context) {
    final duas = context.read<Content>().duas;

    return Scaffold(
      appBar: AppBar(title: const Text('ጸሎቶች')),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        itemCount: duas.length + 1,
        itemBuilder: (context, i) {
          if (i == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: ImageTile(
                image: 'bg_names.jpg',
                height: 130,
                icon: Icons.auto_awesome_outlined,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (_) => const NamesScreen()),
                ),
                child: const TileBody(
                  title: '99 የአላህ ስሞች',
                  subtitle: 'ስሞችን ለማንበብና ትርጉማቸውን ለማወቅ',
                ),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: DhikrCard(dhikr: duas[i - 1], index: i),
          );
        },
      ),
    );
  }
}
