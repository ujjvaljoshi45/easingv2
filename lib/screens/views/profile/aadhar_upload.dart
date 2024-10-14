import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/tools.dart';

class AadharUploadPage extends StatefulWidget {
  const AadharUploadPage({super.key});

  @override
  State<AadharUploadPage> createState() => _AadharUploadPageState();
}

class _AadharUploadPageState extends State<AadharUploadPage> {
  File? _aadharPdfFile; // To store the selected PDF file
  bool isAadharSubmitted = false; // Flag for submission status

  // Method to pick a PDF file
  Future<void> _pickPdfFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _aadharPdfFile = File(result.files.single.path!);
      });
    }
  }

  // Method to handle PDF submission
  void _submitAadhar() {
    if (_aadharPdfFile != null) {
      setState(() {
        isAadharSubmitted = true;
      });
      // Logic to upload the PDF to server or Firebase
      // e.g. FirebaseStorage upload implementation
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Aadhar PDF'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upload Aadhar Card',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            space(15),
            Text(
              'Please upload a PDF file containing both the front and back of your Aadhar card for verification.',
              style: TextStyle(fontSize: 16.sp),
            ),
            space(20),
            // Aadhar PDF File Display
            _aadharPdfFile != null
                ? Column(
                    children: [
                      Icon(Icons.picture_as_pdf, size: 80.sp, color: Colors.red),
                      space(10),
                      Text(_aadharPdfFile!.path.split('/').last),
                    ],
                  )
                : ElevatedButton.icon(
                    onPressed: _pickPdfFile,
                    icon: const Icon(Icons.upload_file),
                    label: const Text('Select Aadhar PDF'),
                  ),
            space(30),

            // Submit Button
            Center(
              child: ElevatedButton(
                onPressed: _aadharPdfFile != null ? _submitAadhar : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                child: const Text('Submit for Verification'),
              ),
            ),

            space(20),

            // Display the current status
            isAadharSubmitted
                ? Text(
                    'Aadhar submitted successfully for verification.',
                    style: TextStyle(color: Colors.green, fontSize: 16.sp),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
