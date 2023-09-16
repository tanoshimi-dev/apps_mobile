import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gurupoint/models/member.dart';

class MemberStateNotifier extends StateNotifier<Member> {
  MemberStateNotifier() : super(Member(memberId: '', memberName: ''));

  void setMember(Member member) {
    state = member;
  }

  Member getMember() {
    return state;
  }
}

final memberStateProvider =
    StateNotifierProvider<MemberStateNotifier, Member>((ref) {
  return MemberStateNotifier();
});
