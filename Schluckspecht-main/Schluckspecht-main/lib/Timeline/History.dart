import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "package:schluckspecht_app/Timeline/componentsTimeline/my_timeline_tile.dart";
import 'package:flutter/services.dart' as rootBundle;
import 'package:schluckspecht_app/Navigation/mycustomappbar.dart';
import 'package:http/http.dart' as http;
import 'package:schluckspecht_app/config.dart';
import '../AppThemes.dart';
import '../Navigation/Drawer/Components/ErrorCard.dart';
import 'componentsTimeline/tags.dart';
import '../Navigation/Drawer/Components/error_log.dart';
import 'componentsTimeline/my_timeline_tile.dart';



class Historypage extends StatelessWidget {
  const Historypage({super.key});

  @override
  Widget build(BuildContext context) {
    return Timeline();
  }
}

class Timeline extends StatefulWidget {
  const Timeline({super.key});

  @override
  State<Timeline> createState() => _Timeline();

}

class _Timeline extends State<Timeline> {


  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: MyAppBar(title: 'Historie', scaffoldKey: scaffoldKey),
      drawer: MyDrawer(),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.cardColor,
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) {
              return PopupDialog();
            }
          );
        },
        child: const Icon(Icons.filter_alt),
      ),

      body: Padding(
        padding: AppCardStyle.innerPadding,
        child: FutureBuilder(
          future: fetchData(),
          builder: (context, data) {
            if(data.hasError) {
              return Center(child: CenteredErrorCard(errorCode: "Api Request failed"));
            }
            else if (data.hasData) {
              var items = data.data as List<Events>;
              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) {
                          return FullText(event: items[index]);
                        },
                      ));
                    },
                    child: MyTimelineTile(
                      items[index].id, 
                      items[index].day,
                      items[index].month, 
                      items[index].year, 
                      items[index].country, 
                      items[index].eventName, 
                      items[index].placement, 
                      items[index].title, 
                      items[index].tags, 
                      items[index].content, 
                      items[index].imagePath,
                    ),
                  );
                  
                },
              );
            }
            else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      )
    );
  }

}

Future<List<Events>> fetchData() async {
  try {
    return await fetchEventsFromApi();
  } catch (e) {
    print('API request failed for History. Trying to load local data...');
    ErrorLog().addError(e.toString());
    return ReadJsonData();
  }
}


Future<List<Events>>ReadJsonData() async{
  print('reading local JSON');
  final jsondata = await rootBundle.rootBundle.loadString('localData/History/events.json');
  final list = json.decode(jsondata) as List<dynamic>;

  return list.map((e) => Events.fromJson(e)).toList();
}


Future<List<Events>> fetchEventsFromApi() async {
  final response = await http.get(Uri.parse('${myConfig.serverUrl}/Timelineposts'));

  if (response.statusCode == 200) {
    final List<dynamic> list = json.decode(response.body);
    return list.map((e) => Events.fromJson(e)).toList();
  } else {
    throw Exception('Failed to load events');
  }
}


class Events{
  int? id;

  int? day;
  int? month;
  int? year;

  String? country;
  String? eventName;

  String? placement;
  String? title;
  String? tags;

  String? content;
  String? imagePath;
  

  Events(
    {
      this.id, 
      this.day,
      this.month,
      this.year,
      this.country,
      this.eventName,
      this.placement,
      this.title, 
      this.tags,
      this.content,
      this.imagePath,
    }
   );
  
  Events.fromJson(Map<String,dynamic> json)
  {
    id=json['id'];

    day=json['day'];
    month=json['month'];
    year=json['year'];

    country=json['country'];
    eventName=json['event'];

    placement=json['placement'];
    title=json['title'];
    tags=json['tags'];  

    content=json['content'];
    imagePath=json['imagePath'];
  }
}


class FullText extends StatelessWidget {
  final Events event;

  int? day;
  int? month;
  int? year;

  FullText({super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    day = event.day;
    month = event.month;
    year = event.year;

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: AppCardStyle.innerPadding,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [

                  //DATUM
                  Text(
                    "$day / $month / $year",
                    style: const TextStyle(fontSize: AppTextStyle.regularFontSize),
                  ),
                ],
              ),
              //HEADING
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //PLATZIERUNG
                  Text(
                    event.placement ?? "",
                    style: const TextStyle(
                      fontSize: AppTextStyle.titleSize,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.visible,
                  ),

                  //TITEL
                  Text(
                    event.title ?? "",
                    style: const TextStyle(
                      fontSize: AppTextStyle.largeFontSize,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accentFontColor,
                    ),
                    overflow: TextOverflow.visible,
                  ),
                ],
              ),

              const SizedBox(height: 16),
              if (event.imagePath != null)
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.asset(
                    event.imagePath!,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Text(
                  event.content ?? "",
                  style: const TextStyle(fontSize: AppTextStyle.largeFontSize),
                  overflow: TextOverflow.visible,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PopupDialog extends StatefulWidget {
  @override
  _PopupDialog createState() => new _PopupDialog();
}

class _PopupDialog extends State<PopupDialog> {


  @override 
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nach Tags filtern'),
      surfaceTintColor: AppColors.cardColor,
      content: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
                const SizedBox(height: 8.0),
                Wrap(
                  spacing: 8.0,
                  children: Tags.tags.map((tag) {
                    return Padding(padding: EdgeInsets.all(3), child: FilterChip(
                      backgroundColor: AppColors.secondaryGrey,
                      selectedColor: AppColors.primaryBlue,
                      showCheckmark: false,

                      label: Text(tag,
                        style: const TextStyle(
                          fontSize: AppTextStyle.regularFontSize,
                          color: AppColors.primaryFontColor,
                        ),
                      ),
                      selected: Tags.selectedTags.contains(tag),
                      onSelected: (selected) {
                        setState(() {
                          if(selected) {
                            Tags.selectedTags.add(tag);
                          } else {
                            Tags.selectedTags.remove(tag);
                          }
                        });
                      }
                    ),);
                  }).toList(),
                ),
            ],
          );
        }
      ),
    );
  }
}