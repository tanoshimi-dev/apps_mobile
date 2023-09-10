import 'package:flutter/material.dart';

class GuruCategory {
  const GuruCategory({
    required this.guruId,
    required this.categoryId,
    required this.categoryName,
    this.color = Colors.orange,
    this.imageUrl = '',
    this.categoryDescription = '',
  });

  final String guruId;
  final String categoryId;
  final String categoryName;
  final Color color;
  final String imageUrl;
  final String categoryDescription;
}
