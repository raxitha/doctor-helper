import 'package:flutter/material.dart';
import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:image_picker/image_picker.dart';

class PrescriptionScreen extends StatefulWidget {
  const PrescriptionScreen({Key? key, required String phoneNumber}) : super(key: key);

  @override
  State<PrescriptionScreen> createState() => _PrescriptionScreenState();
}

class _PrescriptionScreenState extends State<PrescriptionScreen> {
  final TextEditingController _prescriptionTextController = TextEditingController();
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _savePrescription() {
    // TODO: Implement saving prescription to database/storage
    // You'll need to handle both the text and image
    Navigator.pop(context); // Return to dashboard after saving
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Prescription'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _prescriptionTextController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Prescription Details',
                border: OutlineInputBorder(),
                hintText: 'Enter prescription details...',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _showImageSourceDialog,
              icon: const Icon(Icons.add_photo_alternate),
              label: const Text('Add Prescription Image'),
            ),
            const SizedBox(height: 20),
            if (_selectedImage != null) ...[
              Image.file(
                _selectedImage!,
                height: 200,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),
            ],
            ElevatedButton(
              onPressed: _savePrescription,
              child: const Text('Save Prescription'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _prescriptionTextController.dispose();
    super.dispose();
  }
}