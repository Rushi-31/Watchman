import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CertificateFormScreen extends StatefulWidget {
  const CertificateFormScreen({super.key});

  @override
  _CertificateFormScreenState createState() => _CertificateFormScreenState();
}

class _CertificateFormScreenState extends State<CertificateFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String dob = '';
  bool isLoading = false;

  // Function to handle form submission for certificate generation
  Future<void> _generateCertificate() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        isLoading = true;
      });

      try {
        final response = await http.post(
          Uri.parse('http://localhost:5000/generate-certificate'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'name': name,
            'dob': dob,
          }),
        );

        if (response.statusCode == 200) {
          final jsonResponse = jsonDecode(response.body);
          final filePath = jsonResponse['filePath'];
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Certificate generated! Download at $filePath')));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${response.reasonPhrase}')));
        }
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('An error occurred: $e')));
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // Function to show date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        dob = "${picked.toLocal()}".split(' ')[0]; // Formatting the date
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generate Certificate'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
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
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  Text(
                    'Fill in the details below',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 20),

                  // Name field
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Name',
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                    onSaved: (value) => name = value!,
                  ),

                  SizedBox(height: 16),

                  // Date of Birth field (with date picker)
                  TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Date of Birth',
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    controller: TextEditingController(text: dob),
                    onTap: () => _selectDate(context),
                    validator: (value) {
                      if (dob.isEmpty) {
                        return 'Please select a date of birth';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 20),

                  // Generate button
                  isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                    onPressed: _generateCertificate,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 60),
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Generate',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
