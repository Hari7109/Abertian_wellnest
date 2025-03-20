import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  final List<Map<String, String>> notifications = [
    {
      "title": "New Report",
      "time": "10 mins ago",
      "description": "A new report has been uploaded."
    },
    {
      "title": "Health Seminar",
      "time": "1 hour ago",
      "description": "Join the webinar this Friday."
    },
    {
      "title": "Maintenance",
      "time": "Yesterday",
      "description": "System maintenance from 2 AM - 4 AM."
    },
  ];
  NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              title: Text(notifications[index]["title"]!,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  Text(notifications[index]["description"]!),
                  const SizedBox(height: 5),
                  Text(notifications[index]["time"]!,
                      style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
              leading: const Icon(Icons.notifications, color: Colors.blue),
            ),
          );
        },
      ),
    );
  }
}
