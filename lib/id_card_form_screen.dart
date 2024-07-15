import 'dart:convert'; // For Base64 encoding
import 'dart:io'; // For platform detection
// For handling byte data
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // For date formatting
import 'package:path_provider/path_provider.dart'; // For file storage
import 'package:permission_handler/permission_handler.dart'; // For permission handling

class IdCardFormScreen extends StatefulWidget {
  const IdCardFormScreen({super.key});

  @override
  _IdCardFormScreenState createState() => _IdCardFormScreenState();
}

class _IdCardFormScreenState extends State<IdCardFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  DateTime? dob; // Use DateTime for Date of Birth
  String role = '';
  String? base64Image;
  bool isLoading = false; // To show a loading indicator while generating

  final picker = ImagePicker();

  // Function to pick image from gallery
  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      pickedFile.readAsBytes().then((bytes) {
        setState(() {
          base64Image = base64Encode(bytes);
        });
      });
    }
  }

  // Function to dynamically generate the base URL based on the platform
  String getBaseUrl() {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:5000'; // Android emulator
    } else if (Platform.isIOS) {
      return 'http://localhost:5000'; // iOS emulator
    } else {
      return 'http://localhost:5000'; // Web or other platforms
    }
  }

  // Function to download and save the PDF file
  Future<void> downloadPdf(String filePath) async {
    try {
      final status = await Permission.storage.request();
      if (status.isGranted) {
        // Download the file
        final response = await http.get(Uri.parse(filePath));
        if (response.statusCode == 200) {
          final bytes = response.bodyBytes;

          // Save the file to the device
          final directory = await getExternalStorageDirectory();
          final path = '${directory!.path}/generated_id_card.pdf';
          final file = File(path);
          await file.writeAsBytes(bytes);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('ID Card PDF downloaded to $path')),
          );
        } else {
          throw 'Failed to download file.';
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Storage permission denied.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error downloading PDF: $e')),
      );
    }
  }

  // Function to submit the form and generate the ID card
  Future<void> submitForm() async {
    if (_formKey.currentState!.validate() && base64Image != null) {
      _formKey.currentState!.save();

      setState(() {
        isLoading = true; // Show loading indicator
      });

      // Prepare the request body
      Map<String, dynamic> requestBody = {
        'name': name,
        'dob': DateFormat('yyyy-MM-dd').format(dob!), // Format Date of Birth
        'role': role,
        'photoBase64': base64Image, // Send the base64 image string
      };

      // Send POST request to the backend
      final response = await http.post(
        Uri.parse('${getBaseUrl()}/generate-id-card'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      setState(() {
        isLoading = false; // Hide loading indicator
      });

      if (response.statusCode == 200) {
        // Handle success and show the generated ID card link
        final data = jsonDecode(response.body);
        final filePath = data['filePath'];
        await downloadPdf(filePath); // Download the PDF file

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ID Card generated successfully!')),
        );
      } else {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error generating ID card')),
        );
      }
    }
  }

  // Function to pick date from the calendar
  Future<void> pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != dob) {
      setState(() {
        dob = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generate ID Card'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              // Name input field
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onSaved: (value) => name = value!,
              ),

              // Date of Birth input field
              GestureDetector(
                onTap: () => pickDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: dob == null
                          ? 'Date of Birth'
                          : DateFormat('yyyy-MM-dd').format(dob!),
                    ),
                    validator: (value) {
                      if (dob == null) {
                        return 'Please select date of birth';
                      }
                      return null;
                    },
                  ),
                ),
              ),

              // Role input field
              TextFormField(
                decoration: InputDecoration(labelText: 'Role/Position'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter role';
                  }
                  return null;
                },
                onSaved: (value) => role = value!,
              ),

              SizedBox(height: 20),

              // Display selected image or prompt to select
              base64Image == null
                  ? Text('No image selected.')
                  : Image.memory(base64Decode(base64Image!), height: 200),

              ElevatedButton(
                onPressed: pickImage,
                child: Text('Pick Image'),
              ),

              SizedBox(height: 20),

              isLoading
                  ? Center(child: CircularProgressIndicator()) // Loading indicator
                  : ElevatedButton(
                onPressed: submitForm,
                child: Text('Generate ID Card'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
