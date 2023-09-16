import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as Reverpot;

import 'package:gurupoint/screens/tabs.dart';

import 'package:gurupoint/providers/member_provider.dart';
import 'package:gurupoint/models/member.dart';

class UserAuthScreen extends Reverpot.ConsumerStatefulWidget {
  const UserAuthScreen({super.key});

  @override
  Reverpot.ConsumerState<UserAuthScreen> createState() => _UserAuthState();
}

class _UserAuthState extends Reverpot.ConsumerState<UserAuthScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  bool _signInLoading = false;
  bool _signUpLoading = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _googleSignInLoading = false;

  // Sign up functionality
  // Syntax : supabase.auth.signup(email:'',password:'');
  // Sign In Syntax : supabase.auth.signInWithPassword(email:'',password:'');

  @override
  void dispose() {
    supabase.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.network(
                    "https://seeklogo.com/images/S/supabase-logo-DCC676FFE2-seeklogo.com.png",
                    height: 150,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  // Email Field
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Field is required";
                      }
                      return null;
                    },
                    controller: _emailController,
                    decoration: const InputDecoration(label: Text("Email")),
                    keyboardType: TextInputType.emailAddress,
                  ),

                  // Password Field
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Field is required";
                      }
                      return null;
                    },
                    controller: _passwordController,
                    decoration: const InputDecoration(label: Text("Password")),
                    obscureText: true,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  _signInLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ElevatedButton(
                          onPressed: () async {
                            final isValid = _formKey.currentState?.validate();
                            if (isValid != true) {
                              return;
                            }
                            setState(() {
                              _signInLoading = true;
                            });
                            try {
                              await supabase.auth.signInWithPassword(
                                  email: _emailController.text,
                                  password: _passwordController.text);

                              final User? _user = supabase.auth.currentUser;
                              ref.read(memberStateProvider);

                              print(' ★ member id $_user');
                              print('🏹userauth _user = $_user');
                              final user_id = _user?.id;
                              final email = _user?.email;
                              print('🏹🍑 _user = $user_id');

                              if (user_id != null && email != null) {
                                ref
                                    .watch(memberStateProvider.notifier)
                                    .setMember(Member(
                                        memberId: user_id, memberName: email));
                              }

                              ref.read(memberStateProvider);

                              print(ref
                                  .watch(memberStateProvider.notifier)
                                  .getMember());
                            } catch (e) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Sign In Failed"),
                                backgroundColor: Colors.red,
                              ));
                              setState(() {
                                _signInLoading = false;
                              });
                            }
                          },
                          child: const Text("Sign In")),

                  _signUpLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : OutlinedButton(
                          onPressed: () async {
                            final isValid = _formKey.currentState?.validate();
                            if (isValid != true) {
                              return;
                            }
                            setState(() {
                              _signUpLoading = true;
                            });
                            try {
                              await supabase.auth.signUp(
                                  email: _emailController.text,
                                  password: _passwordController.text);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content:
                                    Text("Success ! Confirmation Email Sent"),
                                backgroundColor: Colors.green,
                              ));

                              setState(() {
                                _signUpLoading = false;
                              });
                            } catch (e) {
                              print(e);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Sign Up Failed"),
                                backgroundColor: Colors.red,
                              ));
                              setState(() {
                                _signUpLoading = false;
                              });
                            }
                          },
                          child: const Text("Sign Up")),

                  Row(children: const [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Text("OR"),
                    ),
                    Expanded(child: Divider()),
                  ]),

                  _googleSignInLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : OutlinedButton.icon(
                          onPressed: () async {
                            setState(() {
                              _googleSignInLoading = true;
                            });
                            try {
                              // Syntax for Google Sign in
                              await supabase.auth.signInWithOAuth(
                                  Provider.google,
                                  redirectTo: kIsWeb
                                      ? null
                                      : 'io.supabase.myflutterapp://login-callback');
                            } catch (e) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("Sign Up Failed"),
                                backgroundColor: Colors.red,
                              ));
                              setState(() {
                                _googleSignInLoading = false;
                              });
                            }
                          },
                          icon: Image.network(
                            "https://www.freepnglogos.com/uploads/google-logo-png/google-logo-png-webinar-optimizing-for-success-google-business-webinar-13.png",
                            height: 20,
                          ),
                          label: const Text("Continue with Google"))
                ],
              ),
            )),
      )),
    );
  }
}
