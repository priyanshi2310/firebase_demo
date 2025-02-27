import 'package:firebase_demo_project/service/firebase_service.dart';
import 'package:firebase_demo_project/user_page.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  CloudFirestoreService service = CloudFirestoreService();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Form(
        key: _formKey,
        child: Column(children: [
          TextFormField(
            controller: firstNameController,
            validator: (value) {
              if (value != null && value.isNotEmpty) {
                return null;
              }
              return "Please enter valid first name";
            },
            decoration: InputDecoration(
              hintText: "First Name",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
            ),
          ),
          SizedBox(height: 15),
          TextFormField(
            controller: lastNameController,
            validator: (value) {
              if (value != null && value.isNotEmpty) {
                return null;
              }
              return "Please enter valid last name";
            },
            decoration: InputDecoration(
              hintText: "Last Name",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
            ),
          ),
          SizedBox(height: 50),
          isLoading
              ? CircularProgressIndicator()
              : TextButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        isLoading = true;
                      });
                      final firstName = firstNameController.text;
                      final lastName = lastNameController.text;
                      final result = await service
                          .add({"firstName": firstName, "lastName": lastName});
                      if (result != null) {
                        setState(() {
                          firstNameController.clear();
                          lastNameController.clear();
                          isLoading = false;
                        });
                      } else {
                        isLoading = false;
                      }
                      print("result ======= $result");
                    }
                  },
                  child: Text("Add User"),
                  ),
          TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return UserDataPage();
                  },
                ));
              },
              child: Text("Show All user"))
        ]),
      )),
    );
  }
}
