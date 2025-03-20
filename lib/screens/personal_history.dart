import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'immunization.dart';

class PersonalHistoryPage extends StatefulWidget {
  const PersonalHistoryPage({super.key});

  @override
  _PersonalHistoryPageState createState() => _PersonalHistoryPageState();
}

class _PersonalHistoryPageState extends State<PersonalHistoryPage> {
  String? dietaryPattern, sleep, bowelHabit, bladderHabit, hospitalization;
  String? hobbies, areaOfInterest;
  bool showOtherHobbyField = false;
  bool showOtherInterestField = false;
  bool showHospitalizationReason = false;

  TextEditingController otherHobbyController = TextEditingController();
  TextEditingController otherInterestController = TextEditingController();
  TextEditingController hospitalizationController = TextEditingController();
  TextEditingController surgeriesController = TextEditingController();
  TextEditingController bloodTransfusionController = TextEditingController();
  TextEditingController allergyController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<String> communicableDiseases = [
    "Chickenpox", "Measles", "Mumps", "Jaundice", "TB", "Typhoid", "Malaria", "Dengue", "Chikungunya", "Pertussis"
  ];
  List<String> nonCommunicableDiseases = [
    "Congenital Heart Disease", "Asthma", "Hypertension", "Diabetes (DM)", "Cancer", "Pneumonia"
  ];

  Set<String> selectedCommunicable = {};
  Set<String> selectedNonCommunicable = {};

  @override
  void initState() {
    super.initState();
    // Add listeners to update the form state when text changes
    otherHobbyController.addListener(_updateFormState);
    otherInterestController.addListener(_updateFormState);
    hospitalizationController.addListener(_updateFormState);
    surgeriesController.addListener(_updateFormState);
    bloodTransfusionController.addListener(_updateFormState);
    allergyController.addListener(_updateFormState);
  }

  @override
  void dispose() {
    otherHobbyController.dispose();
    otherInterestController.dispose();
    hospitalizationController.dispose();
    surgeriesController.dispose();
    bloodTransfusionController.dispose();
    allergyController.dispose();
    super.dispose();
  }

  void _updateFormState() {
    setState(() {}); // Forces UI update when form changes
  }

  bool get _isFormComplete {
    return dietaryPattern != null &&
        sleep != null &&
        bowelHabit != null &&
        bladderHabit != null &&
        hospitalization != null &&
        hobbies != null &&
        areaOfInterest != null &&
        (!showOtherHobbyField || otherHobbyController.text.trim().isNotEmpty) &&
        (!showOtherInterestField || otherInterestController.text.trim().isNotEmpty) &&
        (!showHospitalizationReason || hospitalizationController.text.trim().isNotEmpty);
  }

  Future<String?> _getUserId() async {
    User? user = _auth.currentUser;
    return user?.uid;
  }

  Future<void> _savePersonalHistory() async {
    String? uid = await _getUserId();
    if (uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not signed in! Please log in.")),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('personal_history').doc(uid).set({
        'dietaryPattern': dietaryPattern,
        'sleep': sleep,
        'bowelHabit': bowelHabit,
        'bladderHabit': bladderHabit,
        'hobbies': hobbies,
        'otherHobby': showOtherHobbyField ? otherHobbyController.text.trim() : "",
        'areaOfInterest': areaOfInterest,
        'otherInterest': showOtherInterestField ? otherInterestController.text.trim() : "",
        'communicableDiseases': selectedCommunicable.toList(),
        'nonCommunicableDiseases': selectedNonCommunicable.toList(),
        'surgeries': surgeriesController.text.trim(),
        'bloodTransfusion': bloodTransfusionController.text.trim(),
        'allergies': allergyController.text.trim(),
        'hospitalization': hospitalization,
        'hospitalizationReason': showHospitalizationReason ? hospitalizationController.text.trim() : "",
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Personal history saved successfully!")),
      );

      // Navigate to next page
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving data: $e")),
      );
    }
  }

  Widget _buildCategory(String title, List<String> options, ValueChanged<String?> onChanged, String? selectedValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Wrap(
          spacing: 8.0,
          children: options.map((option) {
            return ChoiceChip(
              label: Text(option),
              selected: selectedValue == option,
              onSelected: (selected) {
                setState(() {
                  onChanged(selected ? option : null);
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildCheckboxGroup(String title, List<String> options, Set<String> selectedOptions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Wrap(
          spacing: 8.0,
          children: options.map((option) {
            return FilterChip(
              label: Text(option),
              selected: selectedOptions.contains(option),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    selectedOptions.add(option);
                  } else {
                    selectedOptions.remove(option);
                  }
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Personal History")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCategory("Dietary Pattern", ["Vegetarian", "Non Vegetarian"], (val) => setState(() => dietaryPattern = val), dietaryPattern),
              _buildCategory("Sleep", ["Adequate", "Inadequate"], (val) => setState(() => sleep = val), sleep),
              _buildCategory("Bowel Habit", ["Regular", "Irregular"], (val) => setState(() => bowelHabit = val), bowelHabit),
              _buildCategory("Bladder Habit", ["Normal", "Abnormal"], (val) => setState(() => bladderHabit = val), bladderHabit),

              _buildCategory("Hobbies", ["Reading", "Stamp Collection", "Gardening", "Any other"], (val) {
                setState(() {
                  hobbies = val;
                  showOtherHobbyField = val == "Any other";
                });
              }, hobbies),
              if (showOtherHobbyField) TextField(controller: otherHobbyController, decoration: const InputDecoration(hintText: "Specify Hobby")),

              _buildCheckboxGroup("Communicable Diseases", communicableDiseases, selectedCommunicable),
              _buildCheckboxGroup("Non-Communicable Diseases", nonCommunicableDiseases, selectedNonCommunicable),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _savePersonalHistory ,
                  child: const Text("Save & Next"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
