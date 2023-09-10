import 'package:flutter/material.dart';

class GuruCategory {
  const GuruCategory({
    required this.guruId,
    required this.categoryId,
    required this.pointId,
    required this.pointName,
    required this.point,
    this.color = Colors.orange,
    this.imageUrl = '',
    this.pointDescription = '',
  });

  final String guruId;
  final String categoryId;
  final String pointId;
  final String pointName;
  final int point;
  final Color color;
  final String imageUrl;
  final String pointDescription;
}
