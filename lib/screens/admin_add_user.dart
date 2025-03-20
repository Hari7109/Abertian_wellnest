import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String selectedRole = "user"; // Default role

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUser() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      String uid = userCredential.user!.uid;

      // Store user details in Firestore
      await _firestore.collection('users').doc(uid).set({
        'email': email,
        'role': selectedRole,
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("User added successfully!")));

      // Clear fields after success
      emailController.clear();
      passwordController.clear();
      setState(() {
        selectedRole = "user";
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Add New User",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email")),
            const SizedBox(height: 10),
            TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: selectedRole,
              onChanged: (value) {
                setState(() {
                  selectedRole = value!;
                });
              },
              items: ["user", "teacher", "admin", "doctor"].map((role) {
                return DropdownMenuItem(
                    value: role, child: Text(role.toUpperCase()));
              }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: addUser, child: const Text("Add User"))
          ],
        ),
      ),
    );
  }
}
