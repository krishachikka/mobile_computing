import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GUI',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green.shade800),
      ),
      debugShowCheckedModeBanner: false,
      home: const FormPage(), // FormPage is loaded here
    );
  }
}

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  String _gender = '';
  bool _termsAccepted = false;
  String? _selectedOption;

  final List<String> _dropdownOptions = ['Undergraduate', 'Postgraduate', 'Other'];

  void _submitForm() async {
    if (_formKey.currentState!.validate() && _termsAccepted) {
      // Prepare data to store in Firestore
      final userData = {
        'name': _nameController.text,
        'gender': _gender,
        'education_level': _selectedOption,
      };

      try {
        // Store data in Firestore collection "users"
        await _firestore.collection('users').add(userData);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Form submitted! Name: ${_nameController.text}, Gender: $_gender, Education: $_selectedOption'),
          ),
        );

        // Optionally, clear the form after successful submission
        _nameController.clear();
        setState(() {
          _gender = '';
          _selectedOption = null;
          _termsAccepted = false;
        });
      } catch (e) {
        // Show error message if data submission fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit form. Please try again.'),
          ),
        );
      }
    } else if (!_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You must accept the terms and conditions to proceed.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'DETAILS',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.green.shade900,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg3.jpg'), // Add your background image here
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Center(
                    child: Image.asset(
                      'assets/image.png', // Add your logo/image path here
                      height: 150, // Set your preferred height
                      width: 150, // Set your preferred width
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Enter Name',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Colors.green,
                          width: 2.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Colors.lightGreen,
                          width: 2.0,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text('Gender:'),
                  Row(
                    children: [
                      Radio<String>(
                        value: 'Male',
                        groupValue: _gender,
                        onChanged: (value) {
                          setState(() {
                            _gender = value!;
                          });
                        },
                      ),
                      const Text('Male'),
                      Radio<String>(
                        value: 'Female',
                        groupValue: _gender,
                        onChanged: (value) {
                          setState(() {
                            _gender = value!;
                          });
                        },
                      ),
                      const Text('Female'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Select your Education level',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Colors.green,
                          width: 2.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Colors.green,
                          width: 2.0,
                        ),
                      ),
                    ),
                    value: _selectedOption,
                    items: _dropdownOptions
                        .map((option) => DropdownMenuItem(
                      value: option,
                      child: Text(option),
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedOption = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select an option';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Checkbox(
                        value: _termsAccepted,
                        onChanged: (value) {
                          setState(() {
                            _termsAccepted = value!;
                          });
                        },
                      ),
                      const Text('I accept the terms and conditions'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade100,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 18.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        side: BorderSide(
                          color: Colors.green,
                          width: 2.0,
                        ),
                      ),
                      elevation: 5.0,
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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
