import 'package:flutter/material.dart';
import 'chatpage.dart'; // Ensure this file exists

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final List<String> students = [
    "John Wick",
    "Emma Stone",
    "Michael B Jordan",
    "Sophia Vergara"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chat List")),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: CircleAvatar(child: Text(students[index][0])),
              title: Text(students[index]),
              subtitle: const Text("Tap to chat"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ChatPage(studentName: students[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
