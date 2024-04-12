import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:schluckspecht_app/Admin/Admin.dart';
import 'package:schluckspecht_app/AppThemes.dart';

import '../Navigation/Drawer/Components/error_log.dart';
import '../config.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void handleLogin() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AdminPage()),
    );
    String username = usernameController.text;
    String password = passwordController.text;

    String apiUrl = '${myConfig.serverUrl}/login';

    try {

      var response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AdminPage()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AdminPage()),
        );
        // Handle unsuccessful login
        print('Login failed. Status code: ${response.statusCode}');
      }
    } catch (error) {
      ErrorLog().addError(error.toString());
      print('Error during login: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Panel"),),
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Willkommen',
              style: TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'zum Admin Panel',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10.0),

            const Text(
              'Bitte loggen Sie sich ein',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey,
              ),
            ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0), // Add padding to the entire Card
          child:Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        labelText: 'Benutzername',
                        hintText: 'Geben Sie Ihren Admin Username ein',
                        filled: true,
                        fillColor: AppColors.backgroundColor,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Passwort',
                        hintText: 'Geben Sie ihr Passwort ein',
                        filled: true,
                        fillColor: AppColors.backgroundColor,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: handleLogin,
                      style: ElevatedButton.styleFrom(
                        primary: AppColors.primaryBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: const Text(
                        'Einloggen',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ],
        ),
      ),
    );
  }
}
