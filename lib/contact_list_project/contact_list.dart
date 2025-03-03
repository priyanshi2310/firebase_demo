import 'package:firebase_demo_project/contact_list_project/edit_contect.dart';
import 'package:firebase_demo_project/service/firebase_service.dart';
import 'package:flutter/material.dart';

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({super.key});

  @override
  State<ContactListScreen> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  CloudFirestoreService service = CloudFirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: Text(
          "Contact List",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: service.getUsers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                snapshot.connectionState == ConnectionState.none) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Text('Error fetching data: ${snapshot.error}');
            }

            if (snapshot.hasData && snapshot.data?.docs.isEmpty == true) {
              return const Center(
                child: Text(
                  'Empty Contacts',
                  style: TextStyle(fontSize: 20),
                ),
              );
            }

            final documents = snapshot.data?.docs;

            if (documents == null) {
              return const Center(child: Text('No contacts available.'));
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final document = documents[index];
                final contactNumber = document['contactNumber'] ?? '';
                final firstName = document['firstName'] ?? '';
                final lastName = document['lastName'] ?? '';

                return Dismissible(
                  key: Key(document.id),
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.endToStart) {
                      await service.deleteUser(document.id);
                    }
                  },
                  direction: DismissDirection.endToStart,
                  child: ListTile(
                    trailing: SizedBox(
                      width: 80,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                             
                              if (document.id != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return EditContactScreen(
                                        userData: {
                                          'id': document.id,
                                          'firstName': firstName,
                                          'lastName': lastName,
                                          'contactNumber': contactNumber,
                                        },
                                      );
                                    },
                                  ),
                                );
                              } else {
                                
                                print("Error: Document ID is null");
                              }
                            },
                            icon: Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () async {
                              await service.deleteUser(document.id);
                            },
                            icon: Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ),
                    title: Text(firstName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(lastName),
                        SizedBox(height: 5),
                        Text(
                          contactNumber.isNotEmpty
                              ? contactNumber
                              : 'No Contact Number',
                          style: TextStyle(
                            color: contactNumber.isNotEmpty
                                ? Colors.black
                                : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
