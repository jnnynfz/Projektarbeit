import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Navigation/Drawer/Components/error_log.dart';
import 'Navigation/navbar.dart';
import 'package:provider/provider.dart';
import 'package:schluckspecht_app/AppThemes.dart';


// Hex Color function
class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ErrorLog()),
      ],
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Schluckspecht',
      color: AppColors.backgroundColor,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.robotoTextTheme().copyWith(
          headline1: GoogleFonts.roboto(
            textStyle: const TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          headline2: GoogleFonts.roboto(
            textStyle: const TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          headline3: GoogleFonts.roboto(
            textStyle: const TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          headline4: GoogleFonts.roboto(
            textStyle: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          headline5: GoogleFonts.roboto(
            textStyle: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          headline6: GoogleFonts.roboto(
            textStyle: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle1: GoogleFonts.roboto(
            textStyle: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.normal,
            ),
          ),
          subtitle2: GoogleFonts.roboto(
            textStyle: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.normal,
            ),
          ),
          bodyText1: GoogleFonts.roboto(
            textStyle: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.normal,
            ),
          ),
          bodyText2: GoogleFonts.roboto(
            textStyle: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.normal,
            ),
          ),
          button: GoogleFonts.roboto(
            textStyle: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          caption: GoogleFonts.roboto(
            textStyle: const TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.normal,
              color: Colors.grey,
            ),
          ),
        ),
        cardTheme: const CardTheme(
          color: Colors.white,
        ),
      ),

      home: const MyHomePage(),
    );
  }
}


class MyAppState extends ChangeNotifier {
  var selectedpage = 0;
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth >= 750) {
        return const DesktopNavbar();
      } else if (constraints.maxWidth >= 600) {
        return const TabletNavbar();
      } else {
        return isLoading
            ? Center(
          child: CachedNetworkImage(
            imageUrl: '',
            placeholder: (context, url) => Image.asset('Preloader.gif'),
            errorWidget: (context, url, error) => Image.asset('Preloader.gif', width: 200, height: 200,),
          ),
        )
            : const MobileNavbar();
      }
    });
  }
}
