import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/content.dart';
import '../widgets/common.dart';
import 'home_tab.dart';
import 'search_screen.dart';

class AzkarTab extends StatelessWidget {
  const AzkarTab({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final category = categories[i];
          return ImageTile(
            image: category.image,
            height: 150,
            onTap: () => openCategory(context, category),
            child: TileText(
              icon: iconFor(category.icon),
              title: category.title,
              subtitle: category.subtitle,
              trailing: '${category.items.length}',
            ),
          );
        },
      ),
    );
  }
}
