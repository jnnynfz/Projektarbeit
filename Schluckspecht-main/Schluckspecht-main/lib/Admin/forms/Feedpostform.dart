import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FeedPostForm extends StatefulWidget {
  @override
  _FeedPostFormState createState() => _FeedPostFormState();
}

class _FeedPostFormState extends State<FeedPostForm> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String _imagePath = "";

  Future<void> _getImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  Future<void> _submitForm() async {
    // Construct the API URL
    final String apiUrl = "http://localhost:8080"; // Replace with your Spring Boot API base URL
    final String endpoint = "/create_newFeedpost";

    final Map<String, dynamic> requestBody = {
      'newFeedpost': {
        'title': _titleController.text,
        'content': _descriptionController.text,
        'date': _locationController.text,
        // Add other fields as needed
      },
      'password': _passwordController.text,
    };

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final String apiUrlWithEndpoint = apiUrl + endpoint;

    try {
      final response = await http.post(
        Uri.parse(apiUrlWithEndpoint),
        headers: headers,
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        print('Feedpost created successfully. Response: ${response.body}');
        // Optionally, you can navigate to another screen or show a success message.
      } else if (response.statusCode == 401) {
        print('Unauthorized. Invalid password.');
        // Optionally, you can show an error message to the user.
      } else {
        print('Failed to create feedpost. Status code: ${response.statusCode}');
        // Optionally, you can show an error message to the user.
      }
    } catch (error) {
      print('Error creating feedpost: $error');
      // Optionally, you can show an error message to the user.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feed Post Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _descriptionController,
              maxLines: null, // Allows for unlimited lines
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(labelText: 'Text'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _locationController,
              decoration: InputDecoration(labelText: 'Datum'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _getImage,
              child: Text('Upload Image'),
            ),
            SizedBox(height: 16.0),
            _imagePath.isNotEmpty
                ? Image.file(
              File(_imagePath),
              height: 150.0, // Set the desired height of the displayed image
            )
                : Container(), // Placeholder for the image
            SizedBox(height: 16.0),
            TextFormField(
              controller: _passwordController,
              obscureText: true, // Hide the password
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}