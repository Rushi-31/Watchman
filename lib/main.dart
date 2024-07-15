import 'package:flutter/material.dart';
import 'package:idandcert/BulkOperationScreen.dart';
import 'FeatureSelectionScreen.dart';
import 'authentication_screen.dart';
import 'certificate_form_screen.dart';
import 'id_card_form_screen.dart'; // Import the ID Card Form Screen


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp( debugShowCheckedModeBanner: false,
      title: 'WatchMen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => AuthScreen(),                     // Authentication screen
        '/featureSelection': (context) => FeatureSelectionScreen(), 
        '/certificateFrom':(context)=> const CertificateFormScreen(),// Feature Selection Screen
        '/bulkOperation': (context)=> BulkGenerationScreen(),
        '/idCardForm': (context) => const IdCardFormScreen(),     // ID Card Form
        // Add routes for bulk operations when implemented
      },
    );
  }
}
