import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/content.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/dhikr_card.dart';

/// All items in one azkar category (morning, evening, house, ...).
class AzkarListScreen extends StatelessWidget {
  const AzkarListScreen({super.key, required this.category});

  final AzkarCategory category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.title),
        actions: [
          IconButton(
            tooltip: 'ቆጠራዎችን አጽዳ',
            icon: const Icon(Icons.restart_alt),
            onPressed: () => context.read<AppState>().resetCategory(category.id),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        itemCount: category.items.length + 1,
        itemBuilder: (context, i) {
          if (i == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Text(
                category.subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.muted),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: DhikrCard(dhikr: category.items[i - 1], index: i),
          );
        },
      ),
    );
  }
}
