import 'package:flutter/material.dart';

class UploadHealthPage extends StatefulWidget {
  const UploadHealthPage({super.key});

  @override
  _UploadHealthPageState createState() => _UploadHealthPageState();
}

class _UploadHealthPageState extends State<UploadHealthPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController remarksController = TextEditingController();

  final List<String> healthFields = [
    "General Appearance",
    "Vital Signs - Temperature (°C)",
    "Vital Signs - Pulse (bpm)",
    "Vital Signs - Respiration (breaths/min)",
    "Vital Signs - BP (mmHg)",
    "Weight (kg)",
    "Height (cm)",
    "Integumentary System",
    "Neck",
    "Cardiovascular System",
    "Respiratory System",
    "Gastrointestinal System",
    "Genitourinary System",
    "Musculoskeletal System",
    "Central Nervous System",
    "ECG",
    "X-Ray",
  ];

  final Map<String, Map<String, TextEditingController>> yearWiseControllers = {
    "First Year": {},
    "Second Year": {},
    "Third Year": {},
  };

  @override
  void initState() {
    super.initState();
    for (var year in yearWiseControllers.keys) {
      for (var field in healthFields) {
        yearWiseControllers[year]![field] = TextEditingController();
      }
    }
  }

  @override
  void dispose() {
    for (var year in yearWiseControllers.keys) {
      for (var controller in yearWiseControllers[year]!.values) {
        controller.dispose();
      }
    }
    remarksController.dispose();
    super.dispose();
  }

  Widget buildHealthCard(String year) {
    return ExpansionTile(
      initiallyExpanded: year == "First Year",
      title: Text(year, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          child: Column(
            children: healthFields.map((field) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: yearWiseControllers[year]![field],
                  decoration: InputDecoration(
                    labelText: field,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  ),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter value";
                    }
                    return null;
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Health Report"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 20),
              const Text(
                "Enter Student's Health Records Year-Wise",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Yearly Health Input Sections
              buildHealthCard("First Year"),
              buildHealthCard("Second Year"),
              buildHealthCard("Third Year"),

              const SizedBox(height: 20),

              // Remarks Section
              const Text(
                "Additional Remarks",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: remarksController,
                decoration: InputDecoration(
                  labelText: "Remarks",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),

      // Floating Submit Button
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Health record uploaded successfully!")),
            );
          }
        },
        icon: const Icon(Icons.cloud_upload, color: Colors.white),
        label: const Text("Submit Report"),
      ),
    );
  }
}
