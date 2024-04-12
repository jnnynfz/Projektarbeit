import 'package:flutter/material.dart';
import 'package:schluckspecht_app/AppThemes.dart';


class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Über uns'),
      ),
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CardWidget(title: "SCHLUCKSPECHT", content: "Das Schluckspecht ist ein renommiertes Team, das sich auf Hocheffizienz Fahrzeuge spezialisiert und mit selbstgebauten Fahrzeugen an weltweiten Wettkämpfen teilnimmt. Das Projekt Schluckspecht ist eine Quelle endloser Inspiration für Innovation und Zusammenarbeit, diese Dedikation wollen wir in einer entwickelten App widerspiegeln."),
              const SizedBox(height: 24.0),
              Infocardwidget(title: 'Unser Entwicklerteam', content:'Wir sind ein fünfköpfiges Team, bestehend aus MI-Studenten, welches sich der Aufgabe gewidmet hat, die digitale Präsenz des Schluckspechts anlässlich des Jubiläumsjahres zu erweitern.',),
              const SizedBox(height: 24.0),
              const Text(
                'Impressum',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Hochschule Offenburg\nBadstraße 24\n77652 Offenburg',
                style: TextStyle(fontSize: 16.0),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16.0),
              _buildTeamMemberCard('Jennifer Nafz', 'Projektleiterin', 'jnafz@stud.hs-offenburg.de'),
              _buildTeamMemberCard('Sira Weiner', 'Frontend', 'sweiner1@hs-offenburg.de'),
              _buildTeamMemberCard('Luca Prell', 'Backend', 'lprell@hs-offenburg.de'),
              _buildTeamMemberCard('Joshua Gargano', 'Frontend', 'Jgargan2@hs-offenburg.de'),
              _buildTeamMemberCard('Quoc Vinh Lao', 'Grafikdesign', 'qlao@stud.hs-offenburg.de'),
              const SizedBox(height: 16.0),
              Infocardwidget(title: 'Haftungshinweis', content:'Trotz sorgfältiger inhaltlicher Kontrolle übernehmen wir keine Haftung für die Inhalte externer Links. Für den Inhalt der verlinkten Seiten sind ausschließlich deren Betreiber verantwortlich.',),
              const SizedBox(height: 16.0),
              Infocardwidget(title: 'Urheberrecht', content:'Die Inhalte dieser App unterliegen dem deutschen Urheberrecht. Die Vervielfältigung, Bearbeitung, Verbreitung und jede Art der Verwertung außerhalb der Grenzen des Urheberrechts bedürfen der schriftlichen Zustimmung des jeweiligen Autors bzw. Erstellers.',),
              const SizedBox(height: 16.0),
              Infocardwidget(title: 'Datenschutz', content: 'Informationen zum Datenschutz findest du in unserer Datenschutzerklärung.')
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamMemberCard(String name, String role, String email) {
    return Container(
      width: 300,
      child: Card(
      margin: EdgeInsets.all(12),
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: $name',
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text('Role: $role'),
            SizedBox(height: 8.0),
            Text('Email: $email'),
          ],
        ),
      ),
    ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final String title;
  final String content;

  CardWidget({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0, // You can customize the elevation as needed
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Image.asset(
              'assets/logo1.png',
              fit: BoxFit.contain,
              height: 150,
              width: 150,
            ),),
            Text(
              title,
              style: TextStyle(
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            SizedBox(height: 8),
            Text(
              content,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class Infocardwidget extends StatelessWidget {
  final String title;
  final String content;

  Infocardwidget({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0, // You can customize the elevation as needed
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}