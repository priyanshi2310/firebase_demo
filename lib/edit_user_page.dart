import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_demo_project/service/firebase_service.dart';
import 'package:flutter/material.dart';

class EditUserPage extends StatefulWidget {
  const EditUserPage({super.key, required this.userData});
  final QueryDocumentSnapshot<Map<String, dynamic>>? userData;

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  CloudFirestoreService service = CloudFirestoreService();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    firstNameController.text = widget.userData!["firstName"];
    lastNameController.text = widget.userData!["lastName"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit"),
      ),
      body: SafeArea(
          child: Column(
        children: [
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
                      "lastName": lastNameController.text
                    };
                    final result =
                        await service.updateUser(doc, widget.userData!.id);
                    if (!result) {
                      setState(() {
                        isLoading = false;
                      });
                      Navigator.pop(context);
                    } else {
                      setState(() {
                        isLoading = false;
                      });
                    }
                  },
                  child: Text("Update"))
        ],
      )),
    );
  }
}
