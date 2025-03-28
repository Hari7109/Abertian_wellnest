import 'package:flutter/material.dart';
import 'immunization.dart';

class PersonalHistoryPage extends StatefulWidget {
  const PersonalHistoryPage({Key? key}) : super(key: key);

  @override
  _PersonalHistoryPageState createState() => _PersonalHistoryPageState();
}

class _PersonalHistoryPageState extends State<PersonalHistoryPage> {
  String? dietaryPattern, sleep, bowelHabit, bladderHabit, hospitalization;
  String? hobbies, areaOfInterest, hospitalizationReason;
  bool showOtherHobbyField = false;
  bool showOtherInterestField = false;
  bool showHospitalizationReason = false;
  bool showCustomHobbies = false;
  bool showCustomInterests = false;
  bool showCustomCommunicableDiseases = false;
  bool showCustomNonCommunicableDiseases = false;

  final TextEditingController otherHobbyController = TextEditingController();
  final TextEditingController otherInterestController = TextEditingController();
  final TextEditingController hospitalizationController =
  TextEditingController();
  final TextEditingController surgeriesController = TextEditingController();
  final TextEditingController bloodTransfusionController =
  TextEditingController();
  final TextEditingController allergyController = TextEditingController();

  // Custom controllers
  final TextEditingController customHobbiesController = TextEditingController();
  final TextEditingController customInterestsController =
  TextEditingController();
  final TextEditingController customCommunicableDiseasesController =
  TextEditingController();
  final TextEditingController customNonCommunicableDiseasesController =
  TextEditingController();

  List<String> communicableDiseases = [
    "Chickenpox",
    "Measles",
    "Mumps",
    "Jaundice",
    "TB",
    "Typhoid",
    "Malaria",
    "Dengue",
    "Chikungunya",
    "Pertussis",
  ];
  List<String> nonCommunicableDiseases = [
    "Congenital Heart Disease",
    "Asthma",
    "Hypertension",
    "Diabetes (DM)",
    "Cancer",
    "Pneumonia",
  ];

  Set<String> selectedCommunicable = {};
  Set<String> selectedNonCommunicable = {};
  Set<String> customCommunicableDiseases = {};
  Set<String> customNonCommunicableDiseases = {};

  bool get _isFormComplete {
    return dietaryPattern != null &&
        sleep != null &&
        bowelHabit != null &&
        bladderHabit != null &&
        hospitalization != null &&
        hobbies != null &&
        areaOfInterest != null &&
        (!showOtherHobbyField || otherHobbyController.text.isNotEmpty) &&
        (!showOtherInterestField || otherInterestController.text.isNotEmpty) &&
        (!showHospitalizationReason ||
            hospitalizationController.text.isNotEmpty);
  }

  void _navigateToImmunizationPage() {
    if (_isFormComplete) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ImmunizationPage()),
      );
    }
  }

  Widget _buildCategory(
      String title,
      List<String> options,
      ValueChanged<String?> onChanged,
      String? selectedValue, {
        bool? showCustomField,
        VoidCallback? onCustomToggle,
        TextEditingController? customController,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (onCustomToggle != null)
              TextButton(
                onPressed: onCustomToggle,
                child: Text(
                  showCustomField == true ? "Hide Custom" : "Add Custom",
                ),
              ),
          ],
        ),
        Wrap(
          spacing: 8.0,
          children:
          options.map((option) {
            return ChoiceChip(
              label: Text(option),
              selected: selectedValue == option,
              onSelected: (selected) {
                setState(() {
                  onChanged(selected ? option : null);
                });
              },
              selectedColor: Colors.blue,
              backgroundColor: Colors.grey[300],
              labelStyle: TextStyle(
                color:
                selectedValue == option ? Colors.white : Colors.black,
              ),
            );
          }).toList(),
        ),
        if (showCustomField == true && customController != null)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: TextField(
              controller: customController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter custom option",
              ),
            ),
          ),
        const SizedBox(height: 10),
      ],
    );
  }

  // Rest of the code remains the same as in the previous implementation...

  Widget _buildCheckboxGroup(
      String title,
      List<String> options,
      Set<String> selectedOptions, {
        bool? showCustomField,
        TextEditingController? customController,
        Set<String>? customOptions,
        VoidCallback? onCustomToggle,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (onCustomToggle != null)
              TextButton(
                onPressed: onCustomToggle,
                child: Text(
                  showCustomField == true ? "Hide Custom" : "Add Custom",
                ),
              ),
          ],
        ),
        Wrap(
          spacing: 8.0,
          children: [
            ...options.map((option) {
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
                selectedColor: Colors.blue,
                backgroundColor: Colors.grey[300],
                labelStyle: TextStyle(
                  color:
                  selectedOptions.contains(option)
                      ? Colors.white
                      : Colors.black,
                ),
              );
            }).toList(),
            ...?customOptions?.map((option) {
              return FilterChip(
                label: Text(option),
                selected: true,
                onSelected: (_) {
                  setState(() {
                    customOptions.remove(option);
                  });
                },
                selectedColor: Colors.green,
                backgroundColor: Colors.grey[300],
                labelStyle: const TextStyle(color: Colors.white),
              );
            }).toList(),
          ],
        ),
        if (showCustomField == true)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: customController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter custom option",
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      if (customController!.text.isNotEmpty) {
                        customOptions!.add(customController.text);
                        customController.clear();
                      }
                    });
                  },
                ),
              ],
            ),
          ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildTextArea(String title, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextField(
          controller: controller,
          maxLines: 3,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Enter details...",
          ),
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
              _buildCategory(
                "Dietary Pattern",
                ["Vegetarian", "Non Vegetarian"],
                    (val) => setState(() => dietaryPattern = val),
                dietaryPattern,
              ),

              _buildCategory(
                "Sleep",
                ["Adequate", "Inadequate"],
                    (val) => setState(() => sleep = val),
                sleep,
              ),

              _buildCategory(
                "Bowel Habit",
                ["Regular", "Irregular"],
                    (val) => setState(() => bowelHabit = val),
                bowelHabit,
              ),

              _buildCategory(
                "Bladder Habit",
                ["Normal", "Abnormal"],
                    (val) => setState(() => bladderHabit = val),
                bladderHabit,
              ),

              _buildCategory(
                "Hobbies",
                ["Reading", "Stamp Collection", "Gardening", "Any other"],
                    (val) {
                  setState(() {
                    hobbies = val;
                    showOtherHobbyField = val == "Any other";
                  });
                },
                hobbies,
                showCustomField: showCustomHobbies,
                onCustomToggle:
                    () =>
                    setState(() => showCustomHobbies = !showCustomHobbies),
                customController: customHobbiesController,
              ),
              if (showOtherHobbyField)
                _buildTextArea("Specify Hobby", otherHobbyController),

              _buildCategory(
                "Area of Interest",
                ["Music", "Dance", "Sports", "Literature", "Any other"],
                    (val) {
                  setState(() {
                    areaOfInterest = val;
                    showOtherInterestField = val == "Any other";
                  });
                },
                areaOfInterest,
                showCustomField: showCustomInterests,
                onCustomToggle:
                    () => setState(
                      () => showCustomInterests = !showCustomInterests,
                ),
                customController: customInterestsController,
              ),
              if (showOtherInterestField)
                _buildTextArea("Specify Interest", otherInterestController),

              // Rest of the build method remains the same...
              _buildCheckboxGroup(
                "Communicable Diseases",
                communicableDiseases,
                selectedCommunicable,
                showCustomField: showCustomCommunicableDiseases,
                customController: customCommunicableDiseasesController,
                customOptions: customCommunicableDiseases,
                onCustomToggle:
                    () => setState(
                      () =>
                  showCustomCommunicableDiseases =
                  !showCustomCommunicableDiseases,
                ),
              ),

              _buildCheckboxGroup(
                "Non-Communicable (NCD)",
                nonCommunicableDiseases,
                selectedNonCommunicable,
                showCustomField: showCustomNonCommunicableDiseases,
                customController: customNonCommunicableDiseasesController,
                customOptions: customNonCommunicableDiseases,
                onCustomToggle:
                    () => setState(
                      () =>
                  showCustomNonCommunicableDiseases =
                  !showCustomNonCommunicableDiseases,
                ),
              ),

              _buildTextArea("Surgeries (if any)", surgeriesController),
              _buildTextArea("Blood Transfusion", bloodTransfusionController),
              _buildTextArea(
                "Allergic to Medication/Other Items",
                allergyController,
              ),

              _buildCategory("Hospitalization", ["Yes", "No"], (val) {
                setState(() {
                  hospitalization = val;
                  showHospitalizationReason = val == "Yes";
                });
              }, hospitalization),
              if (showHospitalizationReason)
                _buildTextArea(
                  "Reason for hospitalization",
                  hospitalizationController,
                ),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                  _isFormComplete ? _navigateToImmunizationPage : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text("Next"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
