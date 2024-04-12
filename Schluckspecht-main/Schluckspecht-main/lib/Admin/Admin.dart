import 'package:flutter/material.dart';
import 'package:schluckspecht_app/Admin/forms/Feedpostform.dart';
import 'package:schluckspecht_app/AppThemes.dart';

class AdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
      ),
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Hier können Sie',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 5.0,),
            const Text(
              'Posts erstellen und bearbeiten',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20.0,),
            roundedIconButton(
              icon: Icons.home,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FeedPostForm()),
                );
              },
            ),
            SizedBox(height: 5,),
            Text("Feedpost"),
            SizedBox(height: 16.0), // Spacer
            roundedIconButton(
              icon: Icons.contact_page_rounded,
              onPressed: () {
                // Navigate to Timelinepost page
              },
            ),
            SizedBox(height: 5,),
            Text("Kontakteintrag"),
            SizedBox(height: 16.0), // Spacer
            roundedIconButton(
              icon: Icons.work_history,
              onPressed: () {
                // Navigate to Historypost page
              },
            ),
            SizedBox(height: 5,),
            Text("Historieneintrag"),
          ],
        ),
      ),
    );
  }

  Widget roundedIconButton({required IconData icon, required VoidCallback onPressed}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: Material(
        color: AppColors.primaryBlue,
        child: InkWell(
          onTap: onPressed,
          child: Container(
            width: 100,
            height: 100,
            child: Icon(icon, size: 50, color: Colors.white),
          ),
        ),
      ),
    );
  }
}