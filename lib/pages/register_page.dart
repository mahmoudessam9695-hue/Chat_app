import 'package:chat_app/consts.dart';
import 'package:chat_app/helper/show_snack_bar.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/widgets/custom_TextField.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? email, password;

  bool isLoading = false;

  final GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                const SizedBox(height: 75),

                Image.asset(klogo, height: 100),

                const SizedBox(height: 10),

                const Center(
                  child: Text(
                    'Hi Chat',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Pacifico',
                    ),
                  ),
                ),

                const SizedBox(height: 75),

                const Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 10),

                /// Email
                CustomFormTextfield(
                  hintText: 'Email',
                  onChanged: (data) {
                    email = data;
                  },
                  isShow: false,
                ),

                const SizedBox(height: 10),

                /// Password
                CustomFormTextfield(
                  hintText: 'Password',
                  isShow: true,
                  onChanged: (data) {
                    password = data;
                  },
                ),

                const SizedBox(height: 25),

                /// Register Button
                CustomButton(
                  text: 'REGISTER',
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      if (email == null || password == null) {
                        showSnackBar(context, 'Please fill all fields');
                        return;
                      }

                      setState(() => isLoading = true);

                      try {
                        await registerUser();

                        Navigator.pushReplacementNamed(
                          context,
                          ChatPage.id,
                          arguments: email,
                        );
                      } on FirebaseAuthException catch (ex) {
                        if (ex.code == 'weak-password') {
                          showSnackBar(context, 'Weak password');
                        } else if (ex.code == 'email-already-in-use') {
                          showSnackBar(context, 'Email already exists');
                        } else {
                          showSnackBar(
                            context,
                            ex.message ?? 'Registration failed',
                          );
                        }
                      } catch (e) {
                        showSnackBar(context, 'Something went wrong');
                      }

                      setState(() => isLoading = false);
                    }
                  },
                ),

                const SizedBox(height: 10),

                /// Login redirect
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account?',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 🔐 Register Function
  Future<void> registerUser() async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email!,
      password: password!,
    );
  }
}
