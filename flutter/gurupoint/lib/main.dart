import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:gurupoint/screens/tabs.dart';
import 'package:gurupoint/screens/user_auth.dart';
import 'package:gurupoint/screens/home_page.dart';
import 'package:gurupoint/providers/member_provider.dart';
import 'package:gurupoint/models/member.dart';

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.light,
    seedColor: const Color.fromARGB(255, 255, 241, 204),
  ),
  textTheme: GoogleFonts.zenMaruGothicTextTheme(),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  String supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
  String supabaseKey = dotenv.env['SUPABASE_KEY'] ?? '';
  print(supabaseUrl);
  print(supabaseKey);
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);

  runApp(const ProviderScope(child: GurupointApp()));
}

class GurupointApp extends StatelessWidget {
  const GurupointApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Supabase',
        theme: theme,
        home: const AppEnter());
  }
}

class AppEnter extends ConsumerStatefulWidget {
  const AppEnter({super.key});

  @override
  ConsumerState<AppEnter> createState() => _AuthState();
}

class _AuthState extends ConsumerState<AppEnter> {
  final SupabaseClient supabase = Supabase.instance.client;
  User? _user;

  @override
  void initState() {
    _getAuth();
    // https://riverpod.dev/ja/docs/concepts/reading
    ref.read(memberStateProvider);

    print(' ★ member id $_user');
    print('🏹4 _user = $_user');
    final user_id = _user?.id;
    final email = _user?.email;
    print('🏹🍎4 _user = $user_id');

    super.initState();

    // final mId = (user_id) == null ? '' : user_id;
    // final mName = (email) == null ? '' : email;

    // ref
    //     .watch(memberStateProvider.notifier)
    //     .setMember(Member(memberId: mId, memberName: mName));
  }

  // To get current user : supabase.auth.currentUser

  Future<void> _getAuth() async {
    //void _getAuth() {
    setState(() {
      _user = supabase.auth.currentUser;

      print(' ★ member id $_user');
      print('💎2 _user = $_user');
      final user_id = _user?.id;
      final email = _user?.email;
      print('💎2 _user = $user_id');

      final mId = (user_id) == null ? '' : user_id;
      final mName = (email) == null ? '' : email;

      print('💎💎2 mId = $mId');
      print('💎💎2 mName = $mName');

      // this is error
      // ══╡ EXCEPTION CAUGHT BY WIDGETS LIBRARY ╞═══════════════════════════════════════════════════════════
      // The following assertion was thrown building Builder:
      // dependOnInheritedWidgetOfExactType<UncontrolledProviderScope>() or dependOnInheritedElement() was
      // called before _AuthState.initState() completed.

      // ref
      //     .watch(memberStateProvider.notifier)
      //     .setMember(Member(memberId: mId, memberName: mName));
    });
    supabase.auth.onAuthStateChange.listen((event) {
      setState(() {
        _user = event.session?.user;
        print(' ★2 member id $_user');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // return _user == null ? const UserAuthScreen() : HomePage();
    //final memberState = ref.watch(memberStateProvider);
    // final current = ref.watch(memberStateProvider);
    // print('⚡$current');
    // final id = current.memberId;
    // print('⚡$id');

    print(' ★ member id $_user');
    print('📞3 _user = $_user');
    final user_id = _user?.id;
    final email = _user?.email;
    print('🌳3 _user = $user_id');

    // final mId = (user_id) == null ? '' : user_id;
    // final mName = (email) == null ? '' : email;

    // this is error
    // ref
    //     .watch(memberStateProvider.notifier)
    //     .setMember(Member(memberId: mId, memberName: mName));

    return _user == null ? const UserAuthScreen() : TabsScreen();
  }
}
