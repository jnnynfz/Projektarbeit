import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:schluckspecht_app/AppThemes.dart';
import 'package:http/http.dart' as http;
import '../Navigation/Drawer/Components/error_log.dart';
import '../Navigation/mycustomappbar.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' as rootBundle;

import '../config.dart';


// Die Klasse Feedpage definiert Oberfläche der Feed-Seite
class Feedpage extends StatelessWidget {
  Feedpage({super.key});
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  // Methode zum Erstellen des Widget-Baums
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: MyAppBar(title: 'Feed', scaffoldKey: scaffoldKey),
      drawer: MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: FutureBuilder<List<Posts>>(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              // Fehlerbehandlung, falls ein Fehler beim Abrufen der Daten auftritt
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (snapshot.hasData) {
               // Anzeigen der Daten, wenn sie erfolgreich abgerufen wurden
              var items = snapshot.data!;
              return ListView.builder(
                reverse: false,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Container(
                  padding: AppCardStyle.innerPadding,
                   color: AppColors.backgroundColor,
                    child: buildPostCard(context, items[index]),
                     );
                },
              );
            } else {
              // Anzeigen eines Ladeindikators, während auf die Daten gewartet wird
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

 // Methode zum Erstellen eines Beitragselements
  Widget buildPostCard(BuildContext context, Posts post) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: post.content ?? '', // Inhalt des Beitrags
        style: const TextStyle(
          fontSize: AppTextStyle.regularFontSize,
          fontWeight: FontWeight.normal,
        ),
      ),
      maxLines: 4, // Maximale Zeilenanzahl des Beitragsinhalts
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: MediaQuery.of(context).size.width - 40);// Layout-Berechnung basierend auf der verfügbaren Breite

   return Card(
    color: AppColors.cardColor,
    elevation: 0,
    shape: RoundedRectangleBorder(
    borderRadius: AppCardStyle.cardBorderRadius,
    ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bereich für Admin-Informationen (Bild, Name, Datum)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child:
            Row(
              children: [
                CircleAvatar(
                  // Admin-Bild
                  backgroundImage: AssetImage(post.AdminImage ?? ""),
                  radius: 20.0,
                ),
                const SizedBox(width: 8.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      //Admin-Name
                      post.AdminName ?? "",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      //Datum
                      post.date ?? "",
                      style: const TextStyle(
                          color: AppColors.secondaryFontColor,
                          fontSize: AppTextStyle.smallFontSize),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Titel des Beitrags
          Padding( 
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              post.title ?? '',
              style: const TextStyle(
                fontSize: AppTextStyle.largeFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          //Beitragstext und "Weiterlesen"-Link
          if (post.content != null)
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.content!, // Inhalt des Beitrags
                    overflow: TextOverflow.ellipsis,
                    maxLines: 4,
                    style: const TextStyle(
                      fontSize: AppTextStyle.regularFontSize,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  // Anzeigen des "Weiterlesen"-Links, falls der Text den verfügbaren Platz überschreitet
                  if (textPainter.didExceedMaxLines)
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) {
                            return SecondPage(post: post); //Weiterleitung zur SecondPage mit dem ausgewählten Beitrag
                          },
                        ));
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(top: 8, bottom: 8),
                        child: Text(
                          'Weiterlesen',
                          style: TextStyle(
                            fontSize: AppTextStyle.regularFontSize,
                            color: AppColors.accentFontColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

           //Bild des Beitrags, falls vorhanden
          if (post.imagePath != null)
            AspectRatio(
              aspectRatio: 3 / 2,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(8.0),
                  bottomRight: Radius.circular(8.0),
                ),
                child: Image.asset(
                  post.imagePath!, // Pfad zum Bild des Beitrags
                  fit: BoxFit.cover,
                ),
              ),
            ),
        ],
      ),
    
  );
  }
}


// Methode zum Lesen lokaler JSON-Daten und Konvertieren in eine Liste von Posts
Future<List<Posts>> readLocalJson() async {
  final jsondata = await rootBundle.rootBundle.loadString('assets/localData/Feed/posts.json'); // Laden der JSON-Daten
  final list = json.decode(jsondata) as List<dynamic>; // Dekodieren der JSON-Daten in eine Liste

  return list.map((e) => Posts.fromJson(e)).toList(); // Konvertieren der JSON-Daten in eine Liste von Posts
}

// Funktion zum Abrufen von Daten der API
Future<List<Posts>> fetchData() async {
  try {
    List<Posts> posts = await fetchPostsFromApi(); // Abrufen von Daten von der API
    await saveToLocal(posts); // Speichern der Daten lokal
    return posts; // Rückgabe der abgerufenen Daten
  } catch (e) {
    // Fehlerbehandlung bei der API-Anfrage
    print('API request failed. Trying to load local data...');
    ErrorLog().addError(e.toString()); // Protokollieren des Fehlers
    return readLocalJson(); // Laden lokaler Daten im Fehlerfall
  }
}

// Funktion zum Speichern von Daten lokal
Future<void> saveToLocal(List<Posts> posts) async {
  try {
    final jsonData = jsonEncode(posts.map((post) => post.toJson()).toList()); // Codieren der Daten in JSON
    await writeLocalJson(jsonData, 'assets/localData/Feed/saveToLocal/postsFromApi.json'); // Schreiben der Daten in eine lokale Datei
  } catch (e) {
    // Fehlerbehandlung beim Speichern lokal
    print('Error saving data locally: $e');
    ErrorLog().addError(e.toString()); // Protokollieren des Fehlers
  }
}

// Funktion zum Schreiben von JSON-Daten in eine lokale Datei
Future<void> writeLocalJson(String jsonData, String fileName) async {
  try {
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory(); // Zugriff auf das Verzeichnis der Anwendungsdateien
    String filePath = '${appDocumentsDirectory.path}/$fileName'; // Pfad zur Zieldatei

    File file = File(filePath); // Erstellen der Datei
    await file.writeAsString(jsonData); // Schreiben der JSON-Daten in die Datei

    print('Data saved to local file: $filePath'); // Bestätigung der Speicherung
  } catch (e) {
    // Fehlerbehandlung beim Schreiben lokal
    print('Error writing to local file: $e');
    ErrorLog().addError(e.toString()); // Protokollieren des Fehlers
  }
}

// Funktion zum Abrufen von Daten von einer API
Future<List<Posts>> fetchPostsFromApi() async {
  final response = await http.get(Uri.parse('${myConfig.serverUrl}/Feedposts')); // Senden der Anfrage an die API

  if (response.statusCode == 200) {
    // Überprüfung des Statuscodes der API-Antwort
    final List<dynamic> list = json.decode(response.body); // Dekodieren der JSON-Antwort in eine Liste 
    final posts = list.map((e) => Posts.fromJson(e)).toList(); // Konvertieren der JSON-Daten in eine Liste von Posts

    return posts; // Rückgabe der abgerufenen Daten
  } else {
    // Fehlerbehandlung bei der API-Antwort
    throw Exception('Failed to load events');
  }
}

// Funktion zum Lesen von Daten von einer API
Future<List<Posts>> readApiData() async {
  try {
    final response = await http.get(
      Uri.parse('${myConfig.serverUrl}/Feedposts'), // Senden der Anfrage an die API
      headers: {'Accept': 'application/json'}, // Hinzufügen von Header-Informationen zur Anfrage
    );

    if (response.statusCode == 200) {
      // Überprüfung des Statuscodes der API-Antwort
      final List<dynamic> list = json.decode(response.body); // Dekodieren der JSON-Antwort in eine Liste 
      return list.map((e) => Posts.fromJson(e)).toList(); // Konvertieren der JSON-Daten in eine Liste von Posts
    } else {
      // Fehlerbehandlung bei der API-Antwort
      throw Exception('Failed to load data');
    }
  } catch (error) {
    // Fehlerbehandlung bei der API-Anfrage
    print('Error: $error');
    ErrorLog().addError(error.toString()); // Protokollieren des Fehlers
    throw error; // Weiterleitung des Fehlers
  }
}

//Klasse Posts definiert die Struktur eines Beitragseintrags
class Posts{
  int? id;
  String? title;
  String? content;
  String? date;
  String? imagePath;
  String? imageSource;
  String? source;
  String? AdminImage;
  String? AdminName;

  // Konstruktor für die Posts-Klasse
  Posts(
    {
      this.id, 
      this.title, 
      this.content,
      this.date,
      this.imagePath,
      this.imageSource,
      this.source,
      this.AdminImage,
      this.AdminName,
    }
   );
  
  // Methode zur Erstellung eines Posts-Objekts aus JSON-Daten
  Posts.fromJson(Map<String,dynamic> json)
  {
    id=json['id'];
    title=json['title'];
    content=json['content'];
    date=json['date'];
    imagePath=json['imagePath'];
    imageSource=json['imageSource'];
    source=json['source'];
    AdminImage=json['AdminImage'];
    AdminName=json['AdminName'];
  }

// Methode zur Konvertierung eines Posts-Objekts in JSON-Daten
 Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date,
      'imagePath': imagePath,
      'imageSource': imageSource,
      'source': source,
      'AdminImage': AdminImage,
      'AdminName' : AdminName,
    };
  }
}

//Klasse SecondPage definiert Oberfläche der zweiten Seite
class SecondPage extends StatelessWidget {
  final Posts post;

   // Konstruktor für die SecondPage-Klasse
  const SecondPage({super.key, required this.post});

  // Methode zum Erstellen des Widget-Baums
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: AppCardStyle.innerPadding,
        child: SingleChildScrollView(
          padding: AppCardStyle.cardMargin,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
           
            children: [
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      post.date ?? "", // Datum des Beitrags
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              Text(
                post.title ?? "", // Titel des Beitrags
                style: const TextStyle(
                  fontSize: AppTextStyle.titleSize,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.visible,
              ),
              // Zeile für das Datum des Beitrags
              Padding(
                padding: const EdgeInsets.only(top:8.0, bottom:8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                  Text(
                    post.date ?? "", // Datum des Beitrags
                    style: const TextStyle(
                      color: AppColors.secondaryFontColor,
                      fontSize: AppTextStyle.regularFontSize),
                  ),
                    
                  ],
                ),
              ),

              const SizedBox(height: 16),
              if (post.imagePath != null)
                AspectRatio(
                  aspectRatio: 16 / 9, 
                  child: Image.asset(
                    post.imagePath!, // Pfad zum Bild des Beitrags
                    fit: BoxFit.cover,
                  ),
                ),

              const SizedBox(height: 16),
              // Anzeige der Bildquelle, falls verfügbar
              if (post.imageSource != null)
              Text(
                post.imageSource ?? "", // Bildquelle des Beitrags
                style: const TextStyle(
                  color: AppColors.secondaryFontColor,
                  fontSize: AppTextStyle.smallFontSize
                  ),
                overflow: TextOverflow.visible,
              ),

              const SizedBox(height: 16),
              Text(
                post.content ?? "", // Inhalt des Beitrags
                style: const TextStyle(
                  fontSize: AppTextStyle.largeFontSize
                  ),
                overflow: TextOverflow.visible,
              ),

              const SizedBox(height: 16),
              Text(
                post.source ?? "", // Quelle des Beitrags
                style: const TextStyle(
                  fontSize: AppTextStyle.smallFontSize,
                  color: AppColors.secondaryFontColor,
                  ),
                overflow: TextOverflow.visible,

              ),
            ],
          ),
        ),
      ),
    );
  }
}
