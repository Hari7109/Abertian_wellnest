import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ImmunizationPage extends StatefulWidget {
  const ImmunizationPage({super.key});

  @override
  _ImmunizationPageState createState() => _ImmunizationPageState();
}

class _ImmunizationPageState extends State<ImmunizationPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Map<String, dynamic>> vaccines = [
    {"name": "Hepatitis B", "firstDose": null, "secondDose": null, "thirdDose": null},
    {"name": "Rubella", "firstDose": null, "secondDose": null, "thirdDose": null},
  ];

  TextEditingController vaccineController = TextEditingController();

  void _addVaccine() {
    if (vaccineController.text.trim().isNotEmpty) {
      setState(() {
        vaccines.add({
          "name": vaccineController.text.trim(),
          "firstDose": null,
          "secondDose": null,
          "thirdDose": null
        });
        vaccineController.clear();
      });
    }
  }

  bool get _isFormComplete {
    for (var vaccine in vaccines) {
      if (vaccine["firstDose"] == null || vaccine["secondDose"] == null || vaccine["thirdDose"] == null) {
        return false;
      }
    }
    return true;
  }

  Future<void> _submitForm() async {
    String? uid = _auth.currentUser?.uid;
    if (uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not signed in! Please log in.")),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('immunization').doc(uid).set({
        'vaccines': vaccines,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Immunization details saved successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving data: $e")),
      );
    }
  }

  Widget _buildVaccineCard(int index) {
    var vaccine = vaccines[index];
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(vaccine["name"], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            _buildDoseSelector("First Dose", (value) => setState(() => vaccine["firstDose"] = value), vaccine["firstDose"]),
            _buildDoseSelector("Second Dose", (value) => setState(() => vaccine["secondDose"] = value), vaccine["secondDose"]),
            _buildDoseSelector("Third Dose", (value) => setState(() => vaccine["thirdDose"] = value), vaccine["thirdDose"]),
          ],
        ),
      ),
    );
  }

  Widget _buildDoseSelector(String title, ValueChanged<bool?> onChanged, bool? selectedValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16)),
          Row(
            children: [
              _buildToggleButton("✔", true, selectedValue, onChanged),
              const SizedBox(width: 10),
              _buildToggleButton("✘", false, selectedValue, onChanged),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String label, bool value, bool? groupValue, ValueChanged<bool?> onChanged) {
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: groupValue == value ? Colors.blueAccent : Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: groupValue == value ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Immunization")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...List.generate(vaccines.length, (index) => _buildVaccineCard(index)),
              const SizedBox(height: 10),
              TextField(
                controller: vaccineController,
                decoration: const InputDecoration(labelText: "Enter Vaccine Name"),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _addVaccine,
                child: const Text("+ Add Vaccine"),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isFormComplete ? _submitForm : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    textStyle: const TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Submit"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}