import 'package:amazon_clone/comman/widgets/custom_button.dart';
import 'package:amazon_clone/comman/widgets/custom_textFiel.dart';
import 'package:amazon_clone/constants/global_variable.dart';
import 'package:amazon_clone/features/auth/services/auth_service.dart';
import 'package:flutter/material.dart';

enum Auth {
  signIn,
  signUp,
}

class AuthScreen extends StatefulWidget {
  static const String routeName = '/auth-screen';

  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  Auth _auth = Auth.signUp;
  final signUpFormKey = GlobalKey<FormState>();
  final signInFormKey = GlobalKey<FormState>();
  final AuthService authService = AuthService();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void signUpUser() {
    authService.signUpUser(
      context: context,
      email: _emailController.text,
      password: _passwordController.text,
      name: _nameController.text,
    );
  }

  void signInUser() {
    authService.signInUser(
      context: context,
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVariables.greyBackgroundCOlor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              ),
              ListTile(
                tileColor: _auth == Auth.signUp
                    ? GlobalVariables.backgroundColor
                    : GlobalVariables.greyBackgroundCOlor,
                title: Text(
                  "Create Account",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                leading: Radio(
                    activeColor: GlobalVariables.secondaryColor,
                    value: Auth.signUp,
                    groupValue: _auth,
                    onChanged: (Auth? val) {
                      setState(() {
                        _auth = val!;
                      });
                    }),
              ),
              if (_auth == Auth.signUp)
                Container(
                  padding: const EdgeInsets.all(8),
                  color: GlobalVariables.backgroundColor,
                  child: Form(
                    key: signUpFormKey,
                    child: Column(
                      children: [
                        CustomTextfield(
                            controller: _nameController, hintText: "Name"),
                        SizedBox(
                          height: 10,
                        ),
                        CustomTextfield(
                            controller: _emailController, hintText: "Email"),
                        SizedBox(
                          height: 10,
                        ),
                        CustomTextfield(
                            controller: _passwordController,
                            hintText: "Password"),
                        SizedBox(
                          height: 10,
                        ),
                        CustomButton(
                          text: "Sign Up",
                          onTap: () {
                            if (signUpFormKey.currentState!.validate()) {
                              signUpUser();
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ListTile(
                tileColor: _auth == Auth.signIn ? GlobalVariables
                    .backgroundColor : GlobalVariables.greyBackgroundCOlor,
                title: Text(
                  "Sign-In",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                leading: Radio(
                    value: Auth.signIn,
                    groupValue: _auth,
                    onChanged: (Auth? val) {
                      setState(() {
                        _auth = val!;
                      });
                    }),
              ),
              if (_auth == Auth.signIn)
                Container(
                  padding: const EdgeInsets.all(8),
                  color: GlobalVariables.backgroundColor,
                  child: Form(
                    key: signInFormKey,
                    child: Column(
                      children: [
                        CustomTextfield(
                            controller: _emailController, hintText: "Email"),
                        SizedBox(
                          height: 10,
                        ),
                        CustomTextfield(
                            controller: _passwordController,
                            hintText: "Password"),
                        SizedBox(
                          height: 10,
                        ),
                        CustomButton(
                          text: "Sign In",
                          onTap: () {
                            if(signInFormKey.currentState!.validate()){
                              signInUser();
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
