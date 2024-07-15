import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';

class BulkGenerationScreen extends StatefulWidget {
  @override
  _BulkGenerationScreenState createState() => _BulkGenerationScreenState();
}

class _BulkGenerationScreenState extends State<BulkGenerationScreen> {
  String csvFilePath = '';
  String generationType = 'certificate'; // Default to certificate generation

  // Function to handle CSV file upload for bulk generation
  Future<void> _pickCsvFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null) {
      setState(() {
        csvFilePath = result.files.single.path!;
      });

      final response = await http.post(
        Uri.parse('https:// http://localhost:5000/bulk-generate'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'csvFilePath': csvFilePath,
          'generationType': generationType, // Pass type to backend
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final zipFilePath = jsonResponse['filePath'];

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Bulk generation complete! Download at $zipFilePath')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error generating bulk PDF')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bulk Generation'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10.0,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Text(
                  'Upload CSV for Bulk Generation',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),

                // Dropdown to select generation type (Certificate or ID)
                DropdownButtonFormField<String>(
                  value: generationType,
                  items: [
                    DropdownMenuItem(
                      value: 'certificate',
                      child: Text('Certificate Generation'),
                    ),
                    DropdownMenuItem(
                      value: 'id',
                      child: Text('ID Generation'),
                    ),
                  ],
                  onChanged: (String? newValue) {
                    setState(() {
                      generationType = newValue!;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Select Generation Type',
                    border: OutlineInputBorder(),
                  ),
                ),

                SizedBox(height: 20),

                // Instructions for CSV file structure
                Text(
                  generationType == 'certificate'
                      ? 'CSV should contain: Name, role'
                      : 'CSV should contain: Name, Role',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 20),

                // CSV Upload button
                ElevatedButton(
                  onPressed: _pickCsvFile,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 60),
                    backgroundColor: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Upload CSV',
                    style: TextStyle(color: Colors.black),
                  ),
                ),

                SizedBox(height: 20),

                // Generate button
                ElevatedButton(
                  onPressed: csvFilePath.isNotEmpty ? _pickCsvFile : null,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 60),
                    backgroundColor: csvFilePath.isNotEmpty ? Colors.black : Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Generate',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
