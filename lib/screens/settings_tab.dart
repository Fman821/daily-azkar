import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../notifications/azkar_reminders.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                'ቅጽ 1.2.1 (Version 1.2.1)',
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
  static const _kOn = 'reminder_on';
  static const _kMorning = 'reminder_morning';
  static const _kEvening = 'reminder_evening';

  bool _enabled = false;
  TimeOfDay _morning = const TimeOfDay(hour: 6, minute: 0);
  TimeOfDay _evening = const TimeOfDay(hour: 18, minute: 0);
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  /// Reads the saved reminder settings so the card shows what is really set.
  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _enabled = prefs.getBool(_kOn) ?? false;
      _morning = _fromMinutes(prefs.getInt(_kMorning) ?? 6 * 60);
      _evening = _fromMinutes(prefs.getInt(_kEvening) ?? 18 * 60);
      _ready = true;
    });
  }

  static TimeOfDay _fromMinutes(int m) => TimeOfDay(hour: m ~/ 60, minute: m % 60);
  static int _toMinutes(TimeOfDay t) => t.hour * 60 + t.minute;

  /// Saves the settings and rebuilds the reminders. Returns false if the
  /// reminders could not be turned on (permission refused or an error).
  Future<bool> _apply({
    required bool enabled,
    required TimeOfDay morning,
    required TimeOfDay evening,
  }) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      if (enabled) {
        final granted = await AzkarReminders.instance.requestPermission();
        if (granted != true) {
          messenger.showSnackBar(const SnackBar(
            content: Text('ማሳወቂያ እንዲታይ ፍቃድ መስጠት አለብዎት።'),
          ));
          return false;
        }
      }
      await AzkarReminders.instance.configure(
        enabled: enabled,
        morningHour: morning.hour, morningMinute: morning.minute,
        eveningHour: evening.hour, eveningMinute: evening.minute,
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_kOn, enabled);
      await prefs.setInt(_kMorning, _toMinutes(morning));
      await prefs.setInt(_kEvening, _toMinutes(evening));
      if (enabled) {
        messenger.showSnackBar(const SnackBar(
          content: Text('የጠዋትና የማታ ማስታወሻ ተቀናብሯል።'),
        ));
      }
      return true;
    } catch (e) {
      // Shows the real error so it can be reported and fixed.
      messenger.showSnackBar(SnackBar(
        duration: const Duration(seconds: 10),
        content: Text('ማስታወሻውን ማቀናበር አልተቻለም። ($e)'),
      ));
      return false;
    }
  }

  Future<void> _setEnabled(bool value) async {
    final ok = await _apply(enabled: value, morning: _morning, evening: _evening);
    if (ok && mounted) setState(() => _enabled = value);
  }

  Future<void> _pick(bool morning) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: morning ? _morning : _evening,
      helpText: morning ? 'የጠዋት አዝካር ሰዓት' : 'የማታ አዝካር ሰዓት',
    );
    if (picked == null || !mounted) return;
    final newMorning = morning ? picked : _morning;
    final newEvening = morning ? _evening : picked;
    final ok = await _apply(enabled: _enabled, morning: newMorning, evening: newEvening);
    if (ok && mounted) {
      setState(() {
        _morning = newMorning;
        _evening = newEvening;
      });
    }
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
      SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: const Text('ማስታወሻዎችን አብራ'),
        value: _enabled,
        onChanged: _ready ? (v) => _setEnabled(v) : null,
      ),
      ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.wb_sunny_outlined, color: AppColors.gold), title: const Text('የጠዋት አዝካር'), trailing: Text(_format(_morning), style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold)), onTap: () => _pick(true)),
      ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.nightlight_outlined, color: AppColors.gold), title: const Text('የማታ አዝካር'), trailing: Text(_format(_evening), style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold)), onTap: () => _pick(false)),
      const SizedBox(height: 4),
      const Text('መደበኛ ሰዓት፦ ጠዋት 06:00፣ ማታ 18:00 (የኢትዮጵያ ሰዓት። ሊቀየር ይችላል።)', style: TextStyle(fontSize: 11, color: AppColors.muted)),
    ]),
  );
}
