import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schluckspecht_app/AppThemes.dart';

class CenteredErrorCard extends StatelessWidget {
  final String errorCode;

  CenteredErrorCard({required this.errorCode});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.error,
                color: AppColors.primaryRed,
                size: 56.0,
              ),
              SizedBox(height: 12.0),
              Text(
                'Fehler aufgetreten',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),
              GestureDetector(
                onTap: () {
                  showSnackBar(context, errorCode);
                },
                child: Icon(
                  Icons.info_outline,
                  color: AppColors.primaryBlue,
                  size: 24.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showSnackBar(BuildContext context, String errorCode) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error Code: $errorCode'),
      ),
    );
  }
}