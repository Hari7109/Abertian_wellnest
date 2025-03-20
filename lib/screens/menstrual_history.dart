import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MenstrualHistoryPage(),
    );
  }
}

class MenstrualHistoryPage extends StatefulWidget {
  const MenstrualHistoryPage({super.key});

  @override
  _MenstrualHistoryPageState createState() => _MenstrualHistoryPageState();
}

class _MenstrualHistoryPageState extends State<MenstrualHistoryPage> {
  bool isRegularCycle = true;
  List<String> symptoms = [];
  bool showOtherSymptoms = false;
  TextEditingController otherSymptomsController = TextEditingController();
  TextEditingController menarcheController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _toggleSymptom(String symptom) {
    setState(() {
      if (symptoms.contains(symptom)) {
        symptoms.remove(symptom);
      } else {
        symptoms.add(symptom);
      }
      showOtherSymptoms = symptoms.contains("Any other");
    });
  }

  // Function to get current user's UID
  Future<String?> _getUserId() async {
    User? user = _auth.currentUser;
    if (user == null) {
      return null;
    }
    return user.uid;
  }

  // Function to save/update data in Firestore
  Future<void> _saveMenstrualHistory() async {
    String? uid = await _getUserId();
    if (uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not signed in! Please log in.")),
      );
      return;
    }

    if (menarcheController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter age of menarche")),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('menstrual_history').doc(uid).set({
        'menarche_age': menarcheController.text,
        'cycle_regular': isRegularCycle,
        'symptoms': symptoms,
        'other_symptom': showOtherSymptoms ? otherSymptomsController.text : "",
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Data saved successfully!")),
      );

      // Clear input fields after saving
      menarcheController.clear();
      otherSymptomsController.clear();
      setState(() {
        symptoms.clear();
        isRegularCycle = true;
        showOtherSymptoms = false;
      });

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving data: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        title: const Text("Menstrual History"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Menarche attended", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextField(
                controller: menarcheController,
                decoration: const InputDecoration(hintText: "Enter age"),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              const Text("Menstrual Cycle", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  ChoiceChip(
                    label: const Text("Regular"),
                    selected: isRegularCycle,
                    onSelected: (selected) {
                      setState(() {
                        isRegularCycle = true;
                      });
                    },
                  ),
                  const SizedBox(width: 10),
                  ChoiceChip(
                    label: const Text("Irregular"),
                    selected: !isRegularCycle,
                    onSelected: (selected) {
                      setState(() {
                        isRegularCycle = false;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text("Associated Symptoms", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 10,
                children: [
                  "Dysmenorrhea", "Vomiting", "Back Pain", "Any other"
                ].map((symptom) {
                  return ChoiceChip(
                    label: Text(symptom),
                    selected: symptoms.contains(symptom),
                    onSelected: (selected) => _toggleSymptom(symptom),
                  );
                }).toList(),
              ),
              if (showOtherSymptoms)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: TextField(
                    controller: otherSymptomsController,
                    decoration: const InputDecoration(hintText: "Specify other symptoms"),
                  ),
                ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveMenstrualHistory,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFFFFF),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text("Save"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
