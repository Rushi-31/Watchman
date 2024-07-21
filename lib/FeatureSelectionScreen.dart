import 'package:flutter/material.dart';

class FeatureSelectionScreen extends StatelessWidget {
  const FeatureSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
        title: const Text(
          '               WatchMan',
          style: TextStyle(color: Colors.black,

          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch, // To stretch buttons full-width
          children: <Widget>[
            _buildActionButton(context, 'Generate ID', Icons.credit_card, '/idCardForm'),
            _buildActionButton(context, 'Generate Certificate', Icons.document_scanner, '/certificateFrom'),
            _buildActionButton(context, 'Bulk ID/Certificate Generation', Icons.library_books, '/bulkOperation')

          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.home, size: 30),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.analytics, size: 30),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.settings, size: 30),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),

    );
  }

  Widget _buildActionButton(BuildContext context, String text, IconData icon, String routeName) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pink[200], // Updated from 'primary' to 'backgroundColor'
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          Navigator.pushNamed(context, routeName); // Navigate to the corresponding screen
        },
        icon: Icon(icon, color: Colors.black),
        label: Text(
          text,
          style: const TextStyle(fontSize: 16, color: Colors.black),
        ),
      ),
    );
  }
}
