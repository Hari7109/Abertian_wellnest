import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PublishArticlePage extends StatefulWidget {
  const PublishArticlePage({super.key});

  @override
  _PublishArticlePageState createState() => _PublishArticlePageState();
}

class _PublishArticlePageState extends State<PublishArticlePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  File? _selectedImage;
  String _dateTime = DateTime.now().toString();

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _publishArticle() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Article Published Successfully!")),
      );
      _titleController.clear();
      _contentController.clear();
      setState(() {
        _selectedImage = null;
        _dateTime = DateTime.now().toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Publish Health Article")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Title",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                    hintText: "Enter article title",
                    border: OutlineInputBorder()),
                validator: (value) =>
                    value!.isEmpty ? "Please enter a title" : null,
              ),
              const SizedBox(height: 16),
              const Text("Content",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Expanded(
                child: TextFormField(
                  controller: _contentController,
                  maxLines: null,
                  expands: true,
                  decoration: const InputDecoration(
                      hintText: "Write your article here...",
                      border: OutlineInputBorder()),
                  validator: (value) =>
                      value!.isEmpty ? "Please enter article content" : null,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                    onPressed: _publishArticle, child: const Text("Publish")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
