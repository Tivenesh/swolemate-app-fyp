// lib/screens/auth_screen.dart
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // GlobalKey for form validation, allows us to interact with the Form widget
  final _formKey = GlobalKey<FormState>();

  // Text controllers for input fields to get text values
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController(); // Specific for registration

  // State variable to toggle between login and register mode
  bool _isLoginMode = true;

  @override
  void dispose() {
    // Important: Dispose controllers when the widget is removed to prevent memory leaks
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  // Function to handle form submission (Login or Register button press)
  void _submitAuthForm() {
    // Validate all fields in the form using the formKey
    // The .validate() method triggers all validators defined in TextFormFields
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Optional: Saves the current state of form fields

      // For now, let's just print the values to the console for debugging
      // In a real app, you'd send these to your authentication backend (e.g., Firebase)
      print('Email: ${_emailController.text}');
      print('Password: ${_passwordController.text}');
      if (!_isLoginMode) { // If NOT in login mode (i.e., in register mode)
        print('Full Name: ${_fullNameController.text}');
        print('Confirm Password: ${_confirmPasswordController.text}');
      }

      // Display a temporary message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isLoginMode ? 'Attempting to log in...' : 'Attempting to register...'),
        ),
      );

      // TODO: Integrate with Firebase Authentication service here in future steps
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLoginMode ? 'SwoleMate Login' : 'SwoleMate Register'),
        backgroundColor: Colors.blue, // Using primarySwatch color
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(20),
          child: SingleChildScrollView( // Allows the content to scroll if it overflows (e.g., on small screens)
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey, // Assign the GlobalKey to the Form
              child: Column(
                mainAxisSize: MainAxisSize.min, // Column takes minimum vertical space
                children: <Widget>[
                  // Full Name field (only visible in registration mode)
                  if (!_isLoginMode) // If NOT in login mode (i.e., in register mode)
                    TextFormField(
                      controller: _fullNameController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(labelText: 'Full Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty || value.trim().length < 4) {
                          return 'Please enter at least 4 characters for your full name.';
                        }
                        return null; // Validation passed
                      },
                    ),
                  // Email field
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Email address'),
                    validator: (value) {
                      if (value == null || !value.contains('@') || value.isEmpty) {
                        return 'Please enter a valid email address.';
                      }
                      return null;
                    },
                  ),
                  // Password field
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true, // Hides the characters typed (like for passwords)
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 7) {
                        return 'Password must be at least 7 characters long.';
                      }
                      return null;
                    },
                  ),
                  // Confirm Password field (only visible in registration mode)
                  if (!_isLoginMode) // If NOT in login mode (i.e., in register mode)
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: const InputDecoration(labelText: 'Confirm Password'),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty || value != _passwordController.text) {
                          return 'Passwords do not match.';
                        }
                        return null;
                      },
                    ),
                  const SizedBox(height: 20), // Adds vertical space
                  // Elevated button for submitting the form (Login or Register)
                  ElevatedButton(
                    onPressed: _submitAuthForm, // Call the submit function when pressed
                    child: Text(_isLoginMode ? 'Login' : 'Register'),
                  ),
                  // Text button to toggle between Login and Register modes
                  TextButton(
                    onPressed: () {
                      setState(() { // Rebuilds the widget to reflect the mode change
                        _isLoginMode = !_isLoginMode;
                        _formKey.currentState!.reset(); // Resets form fields when toggling
                      });
                    },
                    child: Text(_isLoginMode
                        ? 'Create new account'
                        : 'I already have an account'),
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