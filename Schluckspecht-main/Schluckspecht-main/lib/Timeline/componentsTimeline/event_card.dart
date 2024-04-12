import "package:flutter/material.dart";
import "package:schluckspecht_app/AppThemes.dart";


class EventCard extends StatelessWidget {
  String? country;
  String? eventName;
  int? year;

  String? placement;
  String? title;
  String? tags;

  String? content;
  String? imagePath;
  


  EventCard(this.country, this.eventName, this.year, this.placement, this.title, this.tags, this.content, this.imagePath,{
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      margin: AppCardStyle.innerPadding,
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(AppCardStyle.borderRadiusValue),
      ),
      constraints: const BoxConstraints(
        minHeight: 175,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          //LEFT SIDE : TEXT
          Expanded ( 
            flex:2,
            child : Container(
              padding: AppCardStyle.cardMargin,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //LAND TURNIER JAHR
                  Text("$country $eventName $year", style: const TextStyle(color: AppColors.secondaryFontColor, fontSize: AppTextStyle.smallFontSize,) ),

                  //PLATZIERUNG TURNIER
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("$placement", style: const TextStyle(fontSize: AppTextStyle.largeFontSize,)),
                      Text("$title"),
                    ],
                  ),
                  
                  //TAGS
                  Text("$tags", style: const TextStyle(color: AppColors.secondaryFontColor, fontSize: AppTextStyle.smallFontSize,)),
                ]
              ),
            ),
          ),

          //RIGHT SIDE : PICTURE
          if (imagePath != null)
            Expanded(
              flex: 3,
              child: ClipRect(
                child: Image.asset(
                  imagePath!,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

