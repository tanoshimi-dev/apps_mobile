import 'package:flutter/material.dart';

import 'package:gurupoint/models/guru.dart';

class GuruGridItem extends StatelessWidget {
  const GuruGridItem({
    super.key,
    required this.guru,
    required this.onSelectGuru,
  });

  final Guru guru;
  final void Function() onSelectGuru;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelectGuru,
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                guru.color.withOpacity(0.55),
                guru.color.withOpacity(0.9),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )),
        child: Text(
          guru.guruName,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
      ),
    );
  }
}
