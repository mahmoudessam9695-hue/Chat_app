import 'package:chat_app/consts.dart';
import 'package:chat_app/helper/show_snack_bar.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/pages/register_page.dart';
import 'package:chat_app/widgets/custom_TextField.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
// import 'chat_page.dart'; // فك الكومنت لما تعمل الصفحة

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? email, password;

  bool isLoading = false;
  GlobalKey<FormState> formKey = GlobalKey();

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

                Center(
                  child: const Text(
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
                  ' Login',
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

                /// Button
                CustomButton(
                  text: 'Sign in',
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      if (email == null || password == null) {
                        showSnackBar(context, 'Please fill all fields');
                        return;
                      }

                      setState(() => isLoading = true);

                      try {
                        await loginUser();

                        Navigator.pushReplacementNamed(
                          context,
                          ChatPage.id,
                          arguments: email,
                        );

                        /// 👇 روح لصفحة الشات
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => ChatPage(),
                        //   ),
                        // );
                      } on FirebaseAuthException catch (ex) {
                        if (ex.code == 'wrong-password') {
                          showSnackBar(context, 'Wrong password');
                        } else if (ex.code == 'user-not-found') {
                          showSnackBar(context, 'No user found for that email');
                        } else {
                          showSnackBar(context, ex.message ?? 'Login failed');
                        }
                      } catch (e) {
                        showSnackBar(context, 'Something went wrong');
                      }

                      setState(() => isLoading = false);
                    }
                  },
                ),

                const SizedBox(height: 10),

                /// Register
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Don\'t have an account?',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'REGISTER',
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

  /// 🔐 Login Function
  Future<void> loginUser() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email!,
      password: password!,
    );
  }
}
