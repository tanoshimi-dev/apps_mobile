import 'package:flutter/material.dart';

class Member {
  const Member({
    required this.guruId,
    required this.memberId,
    required this.memberName,
    this.iconUrl = '',
  });

  final String guruId;
  final String memberId;
  final String memberName;
  final String iconUrl;
}
