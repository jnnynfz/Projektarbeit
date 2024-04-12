import "package:flutter/material.dart";
import "package:schluckspecht_app/Timeline/componentsTimeline/event_card.dart";
import "package:schluckspecht_app/Timeline/componentsTimeline/date_card.dart";
import 'package:timeline_tile/timeline_tile.dart';

class MyTimelineTile extends StatelessWidget {
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

  final bool isFirst;
  final bool isLast;

  MyTimelineTile(this.id, this.day, this.month, this.year, this.country, this.eventName, this.placement, this.title, this.tags, this.content, this.imagePath, {
    super.key,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,

      child: TimelineTile(
        isFirst: isFirst,
        isLast: isLast,  

        alignment: TimelineAlign.manual,
        lineXY: 0.16,
        
        //DECORATIONS
        beforeLineStyle: LineStyle(color: Color.fromARGB(255, 121, 121, 121), thickness: 2),
        indicatorStyle: IndicatorStyle(color: Color.fromARGB(255, 121, 121, 121), width: 15),

        startChild: DateCard(day, month, year),
        endChild: EventCard(country, eventName, year, placement, title, tags, content, imagePath),
      ),
    );
  }
}