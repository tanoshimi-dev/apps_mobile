import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:gurupoint/screens/tabs.dart';
import 'package:gurupoint/screens/user_auth.dart';
import 'package:gurupoint/screens/home_page.dart';

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

  runApp(const GurupointApp());
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

class AppEnter extends StatefulWidget {
  const AppEnter({super.key});

  @override
  State<AppEnter> createState() => _AuthState();
}

class _AuthState extends State<AppEnter> {
  final SupabaseClient supabase = Supabase.instance.client;
  User? _user;

  @override
  void initState() {
    _getAuth();
    super.initState();
  }

  // To get current user : supabase.auth.currentUser

  Future<void> _getAuth() async {
    setState(() {
      _user = supabase.auth.currentUser;
    });
    supabase.auth.onAuthStateChange.listen((event) {
      setState(() {
        _user = event.session?.user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // return _user == null ? const UserAuthScreen() : HomePage();
    return _user == null ? const UserAuthScreen() : TabsScreen();
  }
}
