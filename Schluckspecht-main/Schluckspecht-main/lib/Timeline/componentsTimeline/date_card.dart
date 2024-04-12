import "package:flutter/material.dart";
import "package:schluckspecht_app/AppThemes.dart";

class DateCard extends StatelessWidget {
  int? day;
  int? month;
  int? year;

  DateCard(this.day, this.month, this.year, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: AppCardStyle.cardMargin,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text("$year", style: const TextStyle(color: AppColors.secondaryFontColor, fontSize: AppTextStyle.smallFontSize,) ),
          Text("$day/$month", style: const TextStyle(color: AppColors.primaryFontColor, fontSize: AppTextStyle.smallFontSize) ),
        ],
      ),
    );
  }
}

