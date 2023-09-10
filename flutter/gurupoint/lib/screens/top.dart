import 'package:flutter/material.dart';

import 'package:gurupoint/dummy/dummy_data.dart';
import 'package:gurupoint/widgets/guru_grid_item.dart';

class TopScreen extends StatelessWidget {
  const TopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      children: [
        for (final guru in gurus)
          GuruGridItem(
            guru: guru,
            onSelectGuru: () {
              print(guru.guruName);
            },
          )
      ],
    );
  }
}
