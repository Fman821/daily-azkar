import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/content.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'home_tab.dart';
import 'search_screen.dart';

/// The "አዝካር" tab: every category with how much of it is done.
class AzkarTab extends StatelessWidget {
  const AzkarTab({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final categories = context.read<Content>().categories;

    return Scaffold(
      appBar: AppBar(
        title: const Text('አዝካሮች'),
        actions: [
          IconButton(
            tooltip: 'ፈልግ',
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const SearchScreen()),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        children: [
          const Text(
            'የሚፈልጉትን ምድብ ይምረጡ',
            style: TextStyle(color: AppColors.muted),
          ),
          const SizedBox(height: 14),
          for (final category in categories) ...[
            _CategoryRow(
              category: category,
              doneCount: category.items
                  .where((d) => state.progressOf(d.key) >= d.repeat)
                  .length,
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({required this.category, required this.doneCount});

  final AzkarCategory category;
  final int doneCount;

  @override
  Widget build(BuildContext context) {
    final total = category.items.length;
    final progress = total == 0 ? 0.0 : doneCount / total;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () => openCategory(context, category),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0E5C4B), Color(0xFF062A21)],
            ),
            border: Border.all(color: AppColors.goldSoft.withAlpha(120)),
          ),
          child: Row(
            children: [
              GoldBadge(icon: iconFor(category.icon), size: 52),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.title,
                      style: const TextStyle(
                        color: AppColors.gold,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      category.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AppColors.textSoft, fontSize: 12.5),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 5,
                        backgroundColor: AppColors.border,
                        color: AppColors.gold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$doneCount / $total ተጠናቋል',
                      style: const TextStyle(color: AppColors.muted, fontSize: 11),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right, color: AppColors.gold),
            ],
          ),
        ),
      ),
    );
  }
}
