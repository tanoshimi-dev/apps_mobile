import 'package:flutter/material.dart';

class PointGridItem extends StatelessWidget {
  const PointGridItem({
    super.key,
    required this.guruId,
    required this.categoryId,
    required this.pointId,
    required this.pointName,
    required this.point,
    required this.onSelectGuru,
  });

  final int guruId;
  final int categoryId;
  final int pointId;
  final String pointName;
  final int point;
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
          // gradient: LinearGradient(
          //   colors: [
          //     guru.color.withOpacity(0.55),
          //     guru.color.withOpacity(0.9),
          //   ],
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          //)
        ),
        child: Text(
          pointName,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
      ),
    );
  }
}
