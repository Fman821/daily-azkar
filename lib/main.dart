import 'package:flutter/material.dart';

import 'app.dart';
import 'models/content.dart';
import 'state/app_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final state = await AppState.create();
  final content = await ContentRepository.load();
  runApp(AzkarApp(state: state, content: content));
}
