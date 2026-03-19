import 'dart:io';
import 'package:demo_project/views/base/profile_picture.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              ProfilePicture(
                size: 120,
                imageUrl: "https://randomuser.me/api/portraits/men/32.jpg",
                imageFile: selectedImage,
                isEditable: true,
                onImagePicked: (file) {
                  setState(() {
                    selectedImage = file;
                  });
                },
              ),
            

          
              
              const SizedBox(height: 20),
              const Text(
                'Palash Chandra Barman',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              const Text(
                'palash@example.com',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TermsPage()),
                  );
                },
                icon: const Icon(Icons.description),
                label: const Text('Terms & Conditions'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PrivacyPolicyPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.privacy_tip),
                label: const Text('Privacy Policy'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Dummy Terms & Conditions Page
class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Terms & Conditions')),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Here you can write your Terms & Conditions content...',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

// Dummy Privacy Policy Page
class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Here you can write your Privacy Policy content...',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
