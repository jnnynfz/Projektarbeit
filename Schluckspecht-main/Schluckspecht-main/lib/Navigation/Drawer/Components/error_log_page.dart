import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schluckspecht_app/AppThemes.dart';

import 'error_log.dart';

class ErrorLogPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Error Log'),
      ),
      backgroundColor: AppColors.backgroundColor,
      body: Consumer<ErrorLog>(
        builder: (context, errorLog, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (errorLog.errors.isNotEmpty) ...[
                _buildLatestErrorCard(errorLog.errors.first),
                const Divider(), // Add a divider between latest error and the list
              ],
              _buildErrorList(errorLog.errors),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLatestErrorCard(String latestError) {
    return Card(
      margin: EdgeInsets.all(16.0),
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Latest Error:',
              style: TextStyle(
                color: AppColors.primaryRed,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              latestError,
              style: TextStyle(
                color: AppColors.primaryBlue, fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorList(List<String> errors) {
    return Expanded(
      child: ListView.builder(
        itemCount: errors.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(errors[index]),
          );
        },
      ),
    );
  }
}
