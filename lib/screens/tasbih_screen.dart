import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme.dart';

/// Tasbih counter on its own page: a big tap target with a ring that fills
/// up to the chosen goal, and a light vibration on every count.
class TasbihScreen extends StatelessWidget {
  const TasbihScreen({super.key});

  // 0 means no goal: the counter just goes up.
  static const _targets = [33, 99, 100, 0];

  Future<void> _confirmReset(BuildContext context) async {
    final state = context.read<AppState>();
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('ተስቢህን አጽዳ?'),
        content: const Text('ቆጠራው ወደ 0 ይመለሳል።'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('አይ'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('አዎ'),
          ),
        ],
      ),
    );
    if (ok == true) state.resetTasbih();
  }

  void _tap(BuildContext context) {
    final state = context.read<AppState>();
    final before = state.tasbih;
    state.tapTasbih();
    if (!state.hapticOn) return;
    final target = state.tasbihTarget;
    final completedRound = target > 0 && (before + 1) % target == 0;
    if (completedRound) {
      HapticFeedback.heavyImpact();
    } else {
      HapticFeedback.lightImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final target = state.tasbihTarget;
    final count = state.tasbih;
    final rounds = target > 0 ? count ~/ target : 0;
    final inRound = target > 0 ? count % target : count;
    final progress = target > 0 ? inRound / target : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ተስቢህ መቁጠሪያ'),
        actions: [
          IconButton(
            tooltip: 'አጽዳ',
            icon: const Icon(Icons.restart_alt),
            onPressed: () => _confirmReset(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 10,
              children: [
                for (final t in _targets)
                  ChoiceChip(
                    label: Text(t == 0 ? 'ያለ ገደብ' : '$t'),
                    selected: target == t,
                    onSelected: (_) => state.setTasbihTarget(t),
                  ),
              ],
            ),
            Expanded(
              child: Center(
                child: GestureDetector(
                  onTap: () => _tap(context),
                  child: SizedBox(
                    width: 280,
                    height: 280,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 280,
                          height: 280,
                          child: CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 12,
                            backgroundColor: AppColors.border,
                            color: AppColors.gold,
                          ),
                        ),
                        Container(
                          width: 230,
                          height: 230,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF0E6B57), AppColors.cardDeep],
                            ),
                            border: Border.all(color: AppColors.goldSoft.withAlpha(150)),
                            boxShadow: [
                              BoxShadow(color: AppColors.gold.withAlpha(40), blurRadius: 24),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '$inRound',
                                style: const TextStyle(
                                  fontSize: 68,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.gold,
                                  height: 1.1,
                                ),
                              ),
                              Text(
                                target > 0 ? 'ከ $target' : 'ጠቅላላ $count',
                                style: const TextStyle(color: AppColors.textSoft, fontSize: 15),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'ዙር $rounds',
                                style: const TextStyle(color: AppColors.muted, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 18),
              child: Text(
                'ክብሩን ነክተው ይቁጠሩ',
                style: TextStyle(color: AppColors.muted),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
