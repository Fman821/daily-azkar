import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../notifications/azkar_reminders.dart';
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
          const _AzkarReminderCard(),
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


class _AzkarReminderCard extends StatefulWidget {
  const _AzkarReminderCard();
  @override
  State<_AzkarReminderCard> createState() => _AzkarReminderCardState();
}

class _AzkarReminderCardState extends State<_AzkarReminderCard> {
  bool _enabled = false;
  TimeOfDay _morning = const TimeOfDay(hour: 6, minute: 0);
  TimeOfDay _evening = const TimeOfDay(hour: 18, minute: 0);
  bool _saving = false;

  Future<void> _pick(bool morning) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: morning ? _morning : _evening,
      helpText: morning ? 'የጠዋት አዝካር ሰዓት' : 'የማታ አዝካር ሰዓት',
    );
    if (picked != null && mounted) {
      setState(() { if (morning) { _morning = picked; } else { _evening = picked; } });
    }
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      if (_enabled) await AzkarReminders.instance.requestPermission();
      await AzkarReminders.instance.configure(
        enabled: _enabled,
        morningHour: _morning.hour, morningMinute: _morning.minute,
        eveningHour: _evening.hour, eveningMinute: _evening.minute,
      );
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(_enabled ? 'የጠዋትና የማታ ማስታወሻ ተቀናብሯል።' : 'የአዝካር ማስታወሻ ጠፍቷል።'),
      ));
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('ማስታወሻውን ማቀናበር አልተቻለም። የnotification ፈቃድን ይመልከቱ።'),
      ));
    } finally { if (mounted) setState(() => _saving = false); }
  }

  String _format(TimeOfDay t) => '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) => GoldCard(
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Row(children: [
        _SettingIcon(icon: Icons.notifications_active_outlined), SizedBox(width: 12),
        Expanded(child: Text('የጠዋትና የማታ ማስታወሻ', style: TextStyle(color: AppColors.gold, fontSize: 16, fontWeight: FontWeight.w700))),
      ]),
      const SizedBox(height: 8),
      const Text('“አዝካር ማለትዎን አይርሱ” የሚል ዕለታዊ ማሳሰቢያ።', style: TextStyle(color: AppColors.muted)),
      SwitchListTile(contentPadding: EdgeInsets.zero, title: const Text('ማስታወሻዎችን አብራ'), value: _enabled, onChanged: (v) => setState(() => _enabled = v)),
      ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.wb_sunny_outlined, color: AppColors.gold), title: const Text('የጠዋት አዝካር'), trailing: Text(_format(_morning), style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold)), onTap: () => _pick(true)),
      ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.nightlight_outlined, color: AppColors.gold), title: const Text('የማታ አዝካር'), trailing: Text(_format(_evening), style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold)), onTap: () => _pick(false)),
      SizedBox(width: double.infinity, child: FilledButton.icon(onPressed: _saving ? null : _save, icon: const Icon(Icons.save_outlined), label: Text(_saving ? 'በመቀመጥ ላይ…' : 'ማስታወሻውን አስቀምጥ'))),
      const SizedBox(height: 4),
      const Text('መደበኛ ሰዓት፦ ጠዋት 06:00፣ ማታ 18:00 (የኢትዮጵያ ሰዓት። ሊቀየር ይችላል።)', style: TextStyle(fontSize: 11, color: AppColors.muted)),
    ]),
  );
}
