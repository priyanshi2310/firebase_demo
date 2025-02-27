import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_demo_project/forget_pass_screen.dart';
import 'package:firebase_demo_project/home_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isSuccess = false;
  bool isLoginState = true;
  bool isLoading = false;
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_back_ios),
        title: Text(
          'Sign In',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xff010F07),
          ),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to Tamang \nFood Services',
                    style: TextStyle(
                      fontSize: 33,
                      fontWeight: FontWeight.w100,
                      color: Color(0xff010F07),
                    ),
                  ),
                  SizedBox(height: 42),
                  Text(
                    'Enter your Phone number or Email \naddress for sign in. Enjoy your food :)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff868686),
                    ),
                  ),
                  SizedBox(height: 24),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty ||
                          !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value)) {
                        return "Please Enter valid email";
                      }
                      return null;
                    },
                    controller: emailController,
                    cursorColor: Colors.grey,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffF3F2F2)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffF3F2F2)),
                      ),
                      labelText: 'EMAIL ADDRESS',
                      labelStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: Color(0xff868686),
                      ),
                    ),
                  ),
                  SizedBox(height: 18),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please Enter password";
                      }
                      return null;
                    },
                    controller: passwordController,
                    obscureText: !isPasswordVisible,
                    cursorColor: Colors.grey,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffF3F2F2)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffF3F2F2)),
                      ),
                      labelText: 'PASSWORD',
                      labelStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: Color(0xff868686),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          size: 20,
                          color: Color(0xff868686),
                        ),
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotPasswordScreen()),
                        );
                      },
                      child: Text(
                        'Forget Password?',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          color: Color(0xff010F07),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  isLoading
                      ? Container(
                          color: Colors.black,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                              });

                              if (isLoginState) {
                                userLogin();
                              } else {
                                userRegistration();
                              }
                            }
                          },
                          child: Container(
                            height: 48,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Color(0xffEEA734),
                            ),
                            child: Center(
                              child: Text(
                                isLoginState ? "Sign in" : "Sign up",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xffFFFFFF),
                                ),
                              ),
                            ),
                          ),
                        ),
                  SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      setState(() {
                        isLoginState = !isLoginState;
                      });
                    },
                    child: Center(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '    Create new account.',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                color: Color(0xffEEA734),
                              ),
                            ),
                          ],
                          text: 'Don’t have account?',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: Color(0xff010F07),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isLoading)
            Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }

  void userRegistration() async {
    setState(() {
      isLoading = true;
    });

    await auth
        .createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text)
        .then((value) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }).onError((error, stackTrace) {
      setState(() {
        isLoading = false;
      });
      return;
    }).whenComplete(
      () {
        setState(() {
          isLoading = false;
        });
        print("Success");
        setState(() {
          isSuccess = true;
        });
        return true;
      },
    );
  }

  void userLogin() async {
    setState(() {
      isLoading = true;
    });

    await auth
        .signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text)
        .then((value) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }).onError((error, stackTrace) {
      print("Error is ======== ${error.toString()}");
      setState(() {
        isLoading = false;
      });
      return;
    }).whenComplete(
      () {
        setState(() {
          isLoading = false;
        });
        print("Success");
        setState(() {
          isSuccess = true;
        });
        return true;
      },
    );
  }
}
