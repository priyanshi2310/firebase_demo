import 'package:firebase_demo_project/service/firebase_service.dart';
import 'package:flutter/material.dart';

class EditContactScreen extends StatefulWidget {
  final Map<String, dynamic>? userData;

  const EditContactScreen({super.key, this.userData});

  @override
  State<EditContactScreen> createState() => _EditContactScreenState();
}

class _EditContactScreenState extends State<EditContactScreen> {
  CloudFirestoreService service = CloudFirestoreService();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final contactNumberController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    firstNameController.text = widget.userData!["firstName"];
    lastNameController.text = widget.userData!["lastName"];
    contactNumberController.text = widget.userData!["contactNumber"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: Text("Edit Contacts"),
      ),
      body: SafeArea(
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
                  return "Please enter valid last name";
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
              SizedBox(
                height: 15,
              ),
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
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: contactNumberController,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value != null && value.isNotEmpty && value.length == 10) {
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
              SizedBox(
                height: 50,
              ),
              isLoading
                  ? CircularProgressIndicator()
                  : TextButton(
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        final doc = {
                          "firstName": firstNameController.text,
                          "lastName": lastNameController.text,
                          "contactNumber": contactNumberController.text,
                        };
                        final result = await service.updateUser(
                            doc, widget.userData!["id"]);
                        if (!result) {
                          setState(() {
                            isLoading = false;
                          });
                          Navigator.pop(
                            context,
                          );
                        } else {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                      child: Text(
                        "Save Changes",
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
