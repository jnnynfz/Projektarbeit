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


class Feedpage extends StatelessWidget {
  Feedpage({super.key});
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

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
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (snapshot.hasData) {
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
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget buildPostCard(BuildContext context, Posts post) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: post.content ?? '',
        style: const TextStyle(
          fontSize: AppTextStyle.regularFontSize,
          fontWeight: FontWeight.normal,
        ),
      ),
      maxLines: 4,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: MediaQuery.of(context).size.width - 40);

   return Card(
    color: AppColors.cardColor,
    elevation: 0,
    shape: RoundedRectangleBorder(
    borderRadius: AppCardStyle.cardBorderRadius,
    ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Padding(
            padding: const EdgeInsets.all(16.0),
            child:
            Row(
              children: [
                CircleAvatar(
                  // Load AdminImage here using the AdminImage URL
                  backgroundImage: AssetImage(post.AdminImage ?? ""),
                  radius: 20.0,
                ),
                const SizedBox(width: 8.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.AdminName ?? "",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
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
          
          Padding( // title
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              post.title ?? '',
              style: const TextStyle(
                fontSize: AppTextStyle.largeFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          if (post.content != null)
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.content!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 4,
                    style: const TextStyle(
                      fontSize: AppTextStyle.regularFontSize,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  if (textPainter.didExceedMaxLines)
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) {
                            return SecondPage(post: post);
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

          if (post.imagePath != null)
            AspectRatio(
              aspectRatio: 3 / 2,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(8.0),
                  bottomRight: Radius.circular(8.0),
                ),
                child: Image.asset(
                  post.imagePath!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
        ],
      ),
    
  );
  }
}


Future<List<Posts>>readLocalJson() async{
  final jsondata = await rootBundle.rootBundle.loadString('assets/localData/Feed/posts.json');
  final list = json.decode(jsondata) as List<dynamic>;

  return list.map((e) => Posts.fromJson(e)).toList();
}

Future<List<Posts>> fetchData() async {
  try {
    List<Posts> posts = await fetchPostsFromApi();
    await saveToLocal(posts);
    return posts;
  } catch (e) {
    print('API request failed. Trying to load local data...');
    ErrorLog().addError(e.toString());
    return readLocalJson();
  }
}

Future<void> saveToLocal(List<Posts> posts) async {
  try {
    final jsonData = jsonEncode(posts.map((post) => post.toJson()).toList());
    await writeLocalJson(jsonData, 'assets/localData/Feed/saveToLocal/postsFromApi.json');
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


Future<List<Posts>> fetchPostsFromApi() async {
  final response = await http.get(Uri.parse('${myConfig.serverUrl}/Feedposts'));

  if (response.statusCode == 200) {
    final List<dynamic> list = json.decode(response.body);
    final posts = list.map((e) => Posts.fromJson(e)).toList();

    return posts;
  } else {
    throw Exception('Failed to load events');
  }
}


Future<List<Posts>> readApiData() async {
  try {
    final response = await http.get(
      Uri.parse('${myConfig.serverUrl}/Feedposts'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> list = json.decode(response.body);
      return list.map((e) => Posts.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  } catch (error) {
    print('Error: $error');
    ErrorLog().addError(error.toString());
    throw error;
  }
}

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


class SecondPage extends StatelessWidget {
  final Posts post;

  const SecondPage({super.key, required this.post});

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
                      post.date ?? "",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              Text(
                post.title ?? "",
                style: const TextStyle(
                  fontSize: AppTextStyle.titleSize,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.visible,
              ),

              Padding(
                padding: const EdgeInsets.only(top:8.0, bottom:8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                  Text(
                    post.date ?? "",
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
                  aspectRatio: 16 / 9, // Verhältnis von Breite zu Höhe. Hier 16:9 als Beispiel.
                  child: Image.asset(
                    post.imagePath!,
                    fit: BoxFit.cover,
                  ),
                ),

              const SizedBox(height: 16),
              if (post.imageSource != null)
              Text(
                post.imageSource ?? "",
                style: const TextStyle(
                  color: AppColors.secondaryFontColor,
                  fontSize: AppTextStyle.smallFontSize
                  ),
                overflow: TextOverflow.visible,
              ),

              const SizedBox(height: 16),
              Text(
                post.content ?? "",
                style: const TextStyle(
                  fontSize: AppTextStyle.largeFontSize
                  ),
                overflow: TextOverflow.visible,
              ),

              const SizedBox(height: 16),
              Text(
                post.source ?? "",
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
