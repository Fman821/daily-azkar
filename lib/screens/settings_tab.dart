import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  Future<void> _confirmReset(BuildContext context) async {
    final state = context.read<AppState>();
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('ቆጠራዎችን አጽዳ?'),
        content: const Text('ሁሉም የዚክር ቆጠራዎችና የተስቢህ ቆጣሪ ወደ 0 ይመለሳሉ።'),
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
    if (ok == true) {
      state.resetAllCounts();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(title: const Text('ቅንብር (Settings)')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          GoldCard(
            child: Row(
              children: [
                const _SettingIcon(icon: Icons.person_outline),
                const SizedBox(width: 14),
                Expanded(
                  child: TextFormField(
                    initialValue: state.name,
                    onChanged: (value) =>
                        context.read<AppState>().setName(value),
                    decoration: const InputDecoration(
                      labelText: 'የተጠቃሚ ስም',
                      hintText: 'ስምህን ጻፍ',
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          GoldCard(
            child: Row(
              children: [
                const _SettingIcon(icon: Icons.text_fields),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'የጽሑፍ መጠን',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.gold,
                        ),
                      ),
                      Slider(
                        min: 0.8,
                        max: 1.6,
                        divisions: 8,
                        value: state.fontScale,
                        label: '${(state.fontScale * 100).round()}%',
                        onChanged: (value) =>
                            context.read<AppState>().setFontScale(value),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          GoldCard(
            padding: EdgeInsets.zero,
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              leading: const _SettingIcon(icon: Icons.restart_alt),
              title: const Text(
                'ቆጠራዎችን አጽዳ',
                style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.w700),
              ),
              subtitle: const Text(
                'የዚክር ቆጠራና የተስቢህ ቆጣሪ ወደ 0',
                style: TextStyle(color: AppColors.muted),
              ),
              onTap: () => _confirmReset(context),
            ),
          ),
          const SizedBox(height: 12),
          const GoldCard(
            padding: EdgeInsets.zero,
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              leading: _SettingIcon(icon: Icons.info_outline),
              title: Text(
                'የመተግበሪያው መረጃ',
                style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.w700),
              ),
              subtitle: Text(
                'ቅጽ 1.0.0 (Version 1.0.0)',
                style: TextStyle(color: AppColors.muted),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingIcon extends StatelessWidget {
  const _SettingIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.goldSoft),
        color: AppColors.bg,
      ),
      child: Icon(icon, color: AppColors.gold),
    );
  }
}
