import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_demo_project/contact_list_project/add_contact_screen.dart';

import 'package:firebase_demo_project/service/firebase_push_notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'firebase_options.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Background Message Received: ${message.notification?.title}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Handle background notifications
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Initialize Notifications
  await FirebaseNotificationService.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
          useMaterial3: true,
        ),
        // home: const HomeScreen());
    home: AddContactScreen());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isSuccess = false;
  bool isLoginState = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Sign in"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: "Email",
              ),
              validator: (value) {
                if (value!.isEmpty ||
                    !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value)) {
                  Fluttertoast.showToast(
                      msg: "This is Center Short Toast",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  return "Please Enter valid email";
                }

                return null;
              },
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                hintText: "Password",
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please Enter password";
                }
                return null;
              },
            ),
            SizedBox(
              height: 20,
            ),
            isLoading
                ? CircularProgressIndicator()
                : TextButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (isLoginState) {
                          userLogin();
                        } else {
                          userRegistration();
                        }
                        print("result is ====== $isSuccess");
                      }
                    },
                    child: Text(isLoginState ? "Sign in" : "Sign up"),
                  ),
            InkWell(
              onTap: () {
                setState(() {
                  isLoginState = !isLoginState;
                });
              },
              child: Text(
                isLoginState
                    ? "Don't have an acoont Sign up"
                    : "Already have an account Singn in",
              ),
            ),
          ],
        ),
      ),
    );
  }

  void userRegistration() async {
    setState(() {
      isLoading = true;
    });

    /*
    await auth
        .sendPasswordResetEmail(
            email: emailController.text)
    */
    await auth
        .createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text)
        .then(
      (value) {
        print("then value is ===== $value");
      },
    ).onError(
      (error, stackTrace) {
        setState(() {
          isLoading = false;
        });
        print("${error.toString()}");
        return;
      },
    ).whenComplete(
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
        .then(
      (value) {
        print("then value is ===== $value");
      },
    ).onError(
      (error, stackTrace) {
        setState(() {
          isLoading = false;
        });
        print("${error.toString()}");
        return;
      },
    ).whenComplete(
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
