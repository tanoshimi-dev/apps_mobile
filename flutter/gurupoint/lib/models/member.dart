import 'package:flutter/material.dart';

class Member {
  const Member({
    required this.memberId,
    required this.memberName,
    this.memberProfile,
    this.defaultGuruId,
    this.defaultCategoryId,
    this.iconUrl,
  });

  final int memberId;
  final String memberName;
  final String? memberProfile;
  final int? defaultGuruId;
  final int? defaultCategoryId;
  final String? iconUrl;
}
