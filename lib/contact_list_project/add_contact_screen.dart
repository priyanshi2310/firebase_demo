import 'package:firebase_demo_project/contact_list_project/contact_list.dart';
import 'package:firebase_demo_project/service/firebase_service.dart';
import 'package:flutter/material.dart';

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({super.key});

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final _formKey = GlobalKey<FormState>();
  CloudFirestoreService service = CloudFirestoreService();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final contactNumberController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[300],
        title: Text(
          "Add Contact",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: firstNameController,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      return null;
                    }
                    return "Please enter a valid first name";
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
                    return "Please enter a valid last name";
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
                SizedBox(height: 15),
                TextFormField(
                  controller: contactNumberController,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value != null &&
                        value.isNotEmpty &&
                        value.length == 10) {
                      return null;
                    }
                    return "Please enter a valid 10-digit phone number";
                  },
                  decoration: InputDecoration(
                    hintText: "Contact Number",
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
                            final contactNumber = contactNumberController.text;

                            final result = await service.add({
                              "firstName": firstName,
                              "lastName": lastName,
                              "contactNumber": contactNumber,
                            });

                            if (result != null) {
                              setState(() {
                                firstNameController.clear();
                                lastNameController.clear();
                                contactNumberController.clear();
                                isLoading = false;
                              });

                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return ContactListScreen();
                                },
                              ));
                            } else {
                              setState(() {
                                isLoading = false;
                              });
                            }

                            print("result ======= $result");
                          }
                        },
                        child: Text(
                          'Save',
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
