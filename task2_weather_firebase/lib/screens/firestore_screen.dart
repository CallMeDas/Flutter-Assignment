import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';

class FirestoreScreen extends StatelessWidget {
  const FirestoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nameCtrl = TextEditingController();
    final ageCtrl = TextEditingController();
    final service = FirestoreService();

    void showForm({String? id, String? name, int? age}) {
      nameCtrl.text = name ?? '';
      ageCtrl.text = age?.toString() ?? '';

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(id == null ? "Add User" : "Edit User"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
              TextField(controller: ageCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Age')),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
            ElevatedButton(
              onPressed: () {
                final name = nameCtrl.text;
                final age = int.tryParse(ageCtrl.text) ?? 0;
                if (id == null) {
                  service.addUser(name, age);
                } else {
                  service.updateUser(id, name, age);
                }
                Navigator.pop(context);
              },
              child: const Text("Save"),
            )
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Firestore CRUD")),
      body: StreamBuilder(
        stream: service.getUsers(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();
          final docs = snapshot.data!.docs;

          return ListView(
            children: docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return ListTile(
                title: Text(data['name']),
                subtitle: Text("Age: ${data['age']}"),
                trailing: IconButton(icon: const Icon(Icons.delete), onPressed: () => service.deleteUser(doc.id)),
                onTap: () => showForm(id: doc.id, name: data['name'], age: data['age']),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
