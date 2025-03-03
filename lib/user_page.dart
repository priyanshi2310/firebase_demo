import 'package:firebase_demo_project/edit_user_page.dart';
import 'package:firebase_demo_project/service/firebase_service.dart';
import 'package:flutter/material.dart';

class UserDataPage extends StatefulWidget {
  const UserDataPage({super.key});

  @override
  State<UserDataPage> createState() => _UserDataPageState();
}

class _UserDataPageState extends State<UserDataPage> {
  CloudFirestoreService service = CloudFirestoreService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Users"),
      ),
      body: SafeArea(
          child: StreamBuilder(
        stream: service.getUsers(),
        builder: (context, snapshot) {
         
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.none) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error fetching data: ${snapshot.data}');
          } else if (snapshot.hasData && snapshot.data?.docs.isEmpty == true) {
            return const Center(child: Text('Empty documents'));
          }
          final documents = snapshot.data?.docs;
          return ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: documents?.length,
            itemBuilder: (context, index) {
              return Dismissible(
                key: Key(documents![index].id),
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.endToStart) {
                    await service.deleteUser(documents![index].id);
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
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return EditUserPage(
                                      userData: documents![index]);
                                },
                              ));
                            },
                            icon: Icon(Icons.edit)),
                        IconButton(
                            onPressed: () async {
                              await service.deleteUser(documents![index].id);
                            },
                            icon: Icon(Icons.delete)),
                      ],
                    ),
                  ),
                  title: Text(documents?[index]['firstName']),
                  subtitle: Text(documents?[index]['lastName']),
                ),
              );
            },
          );
        },
      )),
    );
  }
}
