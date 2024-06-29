import 'dart:io';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:timetrader/constants/routes.dart';
import 'package:timetrader/services/auth/auth_exceptions.dart';
import 'package:timetrader/services/auth/auth_service.dart';
import 'package:timetrader/utilities/dialogs/error_dialog.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _fullName;
  late final TextEditingController _address;
  late final TextEditingController _phoneNumber;
  File? _profilePicture;

  @override
  void dispose() {
    _fullName.dispose();
    _email.dispose();
    _password.dispose();
    _address.dispose();
    _phoneNumber.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _fullName = TextEditingController();
    _address = TextEditingController();
    _phoneNumber = TextEditingController();
    super.initState();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: source);
    if (file != null) {
      setState(() {
        _profilePicture = File(file.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Screen'),
        backgroundColor: Colors.lightBlueAccent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: () async {
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return SafeArea(
                          child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: const Icon(Icons.photo_library),
                            title: const Text('Gallery'),
                            onTap: () {
                              Navigator.pop(context);
                              _pickImage(ImageSource.gallery);
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.photo_camera),
                            title: const Text('Camera'),
                            onTap: () {
                              Navigator.pop(context);
                              _pickImage(ImageSource.camera);
                            },
                          ),
                        ],
                      ));
                    });
              },
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[200],
                backgroundImage: _profilePicture != null
                    ? FileImage(_profilePicture!)
                    : null,
                child: _profilePicture == null
                    ? const Icon(Icons.camera_alt, color: Colors.grey, size: 50)
                    : null,
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _fullName,
              decoration: const InputDecoration(
                hintText: 'Enter your full name',
                labelText: 'Full Name',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Enter your email',
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _password,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Enter your password',
                labelText: 'Password',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _address,
              decoration: const InputDecoration(
                hintText: 'Enter your address',
                labelText: 'Address',
              ),
            ),
            const SizedBox(height: 16.0),
            IntlPhoneField(
              controller: _phoneNumber,
              keyboardType: TextInputType.phone,
              initialCountryCode: 'PK',
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                hintText: 'Enter your phone number',
              ),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () async {
                // Gather all user data
                final fullName = _fullName.text;
                final email = _email.text;
                final password = _password.text;
                final address = _address.text;
                final phoneNumber = _phoneNumber.text;

                // Validate and process registration
                try {
                  await AuthService.firebase().createUser(
                    email: email,
                    password: password,
                    fullName: fullName,
                    address: address,
                    phoneNumber: phoneNumber,
                  );
                  AuthService.firebase().sendEmailVerification();
                  if (!context.mounted) return;
                  Navigator.of(context).pushNamed(
                    verifyEmailRoute,
                  );
                } on EmailAlreadyInUseAuthException {
                  await showErrorDialog(
                      context, 'Email account already in use.');
                } on InvalidEmailAuthException {
                  await showErrorDialog(
                      context, 'Your email address is invalid!');
                } on WeakPasswordAuthException {
                  await showErrorDialog(
                      context, 'Please enter a strong password!');
                } on GenericAuthException {
                  await showErrorDialog(
                      context, 'An unexpected error occurred.');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent,
                foregroundColor: Colors.white,
              ),
              child: const Text('Register'),
            ),
            const SizedBox(height: 16.0),
            const Text('Already Registered?', textAlign: TextAlign.center),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  loginRoute,
                  (route) => false,
                );
              },
              style: TextButton.styleFrom(
                foregroundColor:
                    Colors.lightBlueAccent, // Font color: light blue
              ),
              child: const Text('Login Here'),
            ),
          ],
        ),
      ),
    );
  }
}