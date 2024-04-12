import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import '../AppThemes.dart';
import '../Navigation/Drawer/Components/ErrorCard.dart';
import '../Navigation/Drawer/Components/error_log.dart';
import '../Navigation/Drawer/Components/error_log.dart';
import '../Navigation/mycustomappbar.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' as rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

import '../config.dart';


class Contactpage extends StatelessWidget {
  Contactpage({super.key});
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: MyAppBar(title: 'Kontakt', scaffoldKey: scaffoldKey),
      drawer: MyDrawer(),
      body: FutureBuilder<List<Contact>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            var items = snapshot.data!;
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Container(
                 margin: AppCardStyle.innerPadding,
                  child: buildContactCard(context, items[index]),
                   );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}


Widget buildContactCard(BuildContext context, Contact contact) {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController body = TextEditingController();
  final TextEditingController subject = TextEditingController();

  return Card(
  color: AppColors.cardColor,
  elevation: 0,
  margin: AppCardStyle.cardMargin,
  shape: RoundedRectangleBorder(
    borderRadius: AppCardStyle.cardBorderRadius,
  ),
  child: Padding(
    padding: AppCardStyle.innerPadding,
    child: Form(
      child: Column(
        children: [
          buildAvatar(contact.imagePath ?? ''),
          const SizedBox(height: 10),
          buildContactName(contact.name ?? ''),
          const SizedBox(height: 5),
          buildContactDetails(
            contact.position ?? '',
            contact.phonenumber ?? '',
            contact.email ?? '',
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: body,
            decoration: const InputDecoration(
              fillColor: Colors.white,
              filled: true,
              enabledBorder: InputBorder.none,
              hintText: "Betreff",
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: subject,
            decoration: const InputDecoration(
              fillColor: Colors.white,
              filled: true,
              enabledBorder: InputBorder.none,
              hintText: "Ihre Nachricht",
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              _key.currentState!.save();
              String recipientEmail = contact.email ?? '';
              sendEmail(subject.text, body.text, recipientEmail);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              shape: RoundedRectangleBorder(
                borderRadius: AppCardStyle.cardBorderRadius,
              ),
            ),
            child: const Text(
              'Kontakt Aufnehmen',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    ),
  ),
);
}


Future<List<Contact>>readLocalJson() async{
  final jsondata = await rootBundle.rootBundle.loadString('assets/localData/Contact/contact.json');
  final list = json.decode(jsondata) as List<dynamic>;

  return list.map((e) => Contact.fromJson(e)).toList();
}


Future<List<Contact>> fetchData() async {
  try {
    List<Contact> posts = await fetchPostsFromApi();
    await saveToLocal(posts);
    return posts;
  } catch (e) {
    print('API request failed. Trying to load local data...');
    ErrorLog().addError(e.toString());
    return readLocalJson();
  }
}


Future<void> saveToLocal(List<Contact> posts) async {
  try {
    final jsonData = jsonEncode(posts.map((post) => post.toJson()).toList());
    await writeLocalJson(jsonData, 'assets/localData/Contact/saveToLocal/contactsFromApi.json');
  } catch (e) {
    print('Error saving data locally: $e');
    ErrorLog().addError(e.toString());
  }
}


Future<void> writeLocalJson(String jsonData, String fileName) async {
  try {
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    String filePath = '${appDocumentsDirectory.path}/$fileName';

    File file = File(filePath);
    await file.writeAsString(jsonData);

    print('Data saved to local file: $filePath');
  } catch (e) {
    print('Error writing to local file: $e');
    ErrorLog().addError(e.toString());
  }
}


Future<List<Contact>> fetchPostsFromApi() async {
  final response = await http.get(Uri.parse('${myConfig.serverUrl}/Feedposts'));

  if (response.statusCode == 200) {
    final List<dynamic> list = json.decode(response.body);
    final posts = list.map((e) => Contact.fromJson(e)).toList();

    return posts;
  } else {
    throw Exception('Failed to load events');
  }
}


class Contact{
  int? id;
  String? name;
  String? position;
  String? phonenumber;
  String? email;
  String? imagePath;

  Contact(
    {
      this.id, 
      this.name, 
      this.position,
      this.phonenumber,
      this.email,
      this.imagePath,
    }
   );
  
  Contact.fromJson(Map<String,dynamic> json)
  {
    id=json['id'];
    name=json['name'];
    position=json['position'];
    phonenumber=json['phonenumber'];
    email=json['email'];
    imagePath=json['imagePath'];
  }

    Map<String, dynamic> toJson()
  {
    return {
      'id': id,
      'name': name,
      
      'position': position,
      'phonenumber': phonenumber,
      'email': email,
      'imagePath': imagePath,
    };

  }
    
}


  Widget buildAvatar(String imagePath) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        ClipOval(
          child: Container(

            width: 80,
            height: 80,
            color: AppColors.secondaryBlue,
            child: Image.asset(
              imagePath ?? '',
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget buildContactName(String name) {
    return Text(
      name ?? '',
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: AppTextStyle.regularFontSize,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryFontColor,
      ),
    );
  }

  Widget buildContactDetails(String position, String phonenumber, String email) {
    return SizedBox(
    
      child: Text(
        '$position \n $phonenumber \n $email',
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: AppTextStyle.smallFontSize,
          fontWeight: FontWeight.normal,
          color: AppColors.primaryFontColor,
        ),
      ),
    );
  }


sendEmail( String subject, String body, String recipientEmail) async {
  
  final Email email = Email(
    body: body,
    subject: subject,
    recipients: [recipientEmail],

    isHTML: false,
  );

  try {
    await FlutterEmailSender.send(email);
  } catch (error) {
    var scaffoldKey;
    scaffoldKey.currentState?.showSnackBar(SnackBar(
      content: Text('Fehler beim Senden der E-Mail: $error'),
    ));
  }
}




  

