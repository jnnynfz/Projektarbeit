import 'package:flutter/material.dart';
import 'package:schluckspecht_app/AppThemes.dart';
import 'package:schluckspecht_app/Contact/Contact.dart';
import 'package:schluckspecht_app/Feed/Feed.dart';
import 'package:schluckspecht_app/Timeline/History.dart';


int pageIndex=0;

const icononeunselected = Icon(Icons.contact_page_outlined);
const icononeselected = Icon(Icons.contact_page_rounded);
const icononelabel = 'Contact';

const icontwounselected = Icon(Icons.home_outlined);
const icontwoselected = Icon(Icons.home);
const icontwolabel = 'Home';

const iconthreeunselected = Icon(Icons.work_history_outlined);
const iconthreeselected = Icon(Icons.work_history);
const iconthreelabel = 'History';


class MobileNavbar extends StatefulWidget {
  const MobileNavbar({super.key});

  @override
  State<MobileNavbar> createState() => _MobileNavbarState();
}


class _MobileNavbarState extends State<MobileNavbar> {

  var currentpageindex = pageIndex;

  @override
  Widget build(BuildContext context) {

    Widget page;
    switch (currentpageindex) {
      case 0:
        page = Contactpage();
        break;
      case 1:
        page = Feedpage();
        break;
      case 2:
        page = const Historypage();
        break;
      default:
        throw UnimplementedError('no widget selected');
    }

    return Scaffold(
      body: Center(
        child: page,
      ),
      bottomNavigationBar: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          currentIndex: currentpageindex,
          selectedItemColor: AppColors.primaryRed,
          unselectedItemColor: Colors.grey,
          onTap: (int index) {
            setState(() {
              currentpageindex = index;
            });
          },
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: icononeselected,
              label: '',
            ),
            BottomNavigationBarItem(
              icon: icontwoselected,
              label: '',
            ),
            BottomNavigationBarItem(
              icon: iconthreeselected,
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}


class TabletNavbar extends StatefulWidget {
  const TabletNavbar({super.key});

  @override
  State<TabletNavbar> createState() => _TabletNavbarState();
}


class _TabletNavbarState extends State<TabletNavbar> {

  var currentpageindex = pageIndex;

  @override
  Widget build(BuildContext context) {

    Widget page;
    switch (currentpageindex) {
      case 0:
        page = Feedpage();
        break;
      case 1:
        page = Contactpage();
        break;
      case 2:
        page = const Historypage();
        break;
      default:
        throw UnimplementedError('no widget selected');
    }

    return LayoutBuilder(
        builder: (context, constraints) {
          return Scaffold(
            body: Row(
              children: [
                SafeArea(
                  child: NavigationRail(
                    backgroundColor: Colors.white,
                    extended: constraints.maxWidth >= 750,
                    indicatorColor: Colors.white,
                    selectedIndex: currentpageindex,
                    labelType: NavigationRailLabelType.selected,
                    onDestinationSelected: (int index) {
                      setState(() {
                        currentpageindex = index;
                      });
                    },
                    destinations: const [
                      NavigationRailDestination(
                        selectedIcon: icononeselected,
                        icon: icononeunselected,
                        label: Text(icononelabel),
                      ),
                      NavigationRailDestination(
                        selectedIcon: icontwoselected,
                        icon: icontwounselected,
                        label: Text(icontwolabel),
                      ),
                      NavigationRailDestination(
                        selectedIcon: iconthreeselected,
                        icon: iconthreeunselected,
                        label: Text(iconthreelabel),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Theme.of(context).colorScheme.background,
                    child: page,
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class DesktopNavbar extends StatefulWidget {
  const DesktopNavbar({super.key});

  @override
  State<DesktopNavbar> createState() => _DesktopNavbarState();
}


class _DesktopNavbarState extends State<DesktopNavbar> {

  var currentpageindex = pageIndex;

  @override
  Widget build(BuildContext context) {

    Widget page;
    switch (currentpageindex) {
      case 0:
        page = Feedpage();
        break;
      case 1:
        page = Contactpage();
        break;
      case 2:
        page = const Historypage();
        break;
      default:
        throw UnimplementedError('no widget selected');
    }

    return LayoutBuilder(
        builder: (context, constraints) {
          return Scaffold(
            body: Row(
              children: [
                SafeArea(
                  child: NavigationRail(
                    backgroundColor: Colors.white,
                    indicatorColor: AppColors.primaryRed.withOpacity(0),
                    selectedIndex: currentpageindex,
                    extended: constraints.maxWidth >= 750,
                    onDestinationSelected: (int index) {
                      setState(() {
                        currentpageindex = index;
                      });
                    },
                    destinations: const [
                      NavigationRailDestination(
                        selectedIcon: icononeselected,
                        icon: icononeunselected,
                        label: Text(icononelabel),
                      ),
                      NavigationRailDestination(
                        selectedIcon: icontwoselected,
                        icon: icontwounselected,
                        label: Text(icontwolabel),
                      ),
                      NavigationRailDestination(
                        selectedIcon: iconthreeselected,
                        icon: iconthreeunselected,
                        label: Text(iconthreelabel),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: page,
                  ),
                ),
              ],
            ),
          );
        });
  }
}
