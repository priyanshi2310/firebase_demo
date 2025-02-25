import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            Text(
              'Welcome to Tamang \nFood Services',
              style: TextStyle(
                fontSize: 33,
                fontWeight: FontWeight.w100,
                color: Color(0xff010F07),
              ),
            ),
            SizedBox(
              height: 42,
            ),
            Text(
              'Enter your Phone number or Email \naddress for sign in. Enjoy your food :)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xff868686),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
