import 'package:flutter/material.dart';

class Guru {
  const Guru({
    required this.guruId,
    required this.guruName,
    this.color = Colors.orange,
    this.guruDescription = '',
  });

  final String guruId;
  final String guruName;
  final Color color;
  final String guruDescription;
}
