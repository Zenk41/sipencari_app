import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:sipencari_app/page/home_page/home_page.dart';
import 'package:sipencari_app/page/main_page/add_missing.dart';
import 'package:sipencari_app/page/main_page/location_picker.dart';
import 'package:sipencari_app/page/missing_page/missing_page.dart';
import 'package:sipencari_app/page/my_missing_page/my_missing_page.dart';
import 'package:sipencari_app/page/setting_page/setting_page.dart';
import 'package:sipencari_app/shared/shared.dart';
import 'package:sipencari_app/widgets/bottom_nav.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;
  PageController pageController = PageController();
  List<Widget> screens = [
    const HomePage(),
    const MissingPage(),
    const MyMissingPage(),
    const SettingPage(),
  ];
  List<BottomNavigationItem> bottomItems = [
    BottomNavigationItem("Beranda", "assets/icons/home.png"),
    BottomNavigationItem("Kehilangan", "assets/icons/missing.png"),
    BottomNavigationItem("Kehilangan Ku", "assets/icons/my_missing.png"),
    BottomNavigationItem("Peraturan", "assets/icons/setting.png"),
  ];

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  @override
  void initState() {
    
    pageController = PageController(
      initialPage: selectedIndex,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: pageController,
        itemCount: screens.length,
        onPageChanged: (newPage) {
          setState(() {
            selectedIndex = newPage;
          });
        },
        itemBuilder: (BuildContext context, int index) {
          return screens[index];
        },
      ),
      floatingActionButton: FloatingActionButton(
        mini: true,
        onPressed: () {
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) => const LocationPickerPage()));
        },
        backgroundColor: primaryColor,
        child: Icon(
          Icons.add,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        notchMargin: 5.0,
        shape: CircularNotchedRectangle(),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          items: bottomItems
              .map(
                (item) => BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child: Image.asset(
                      item.icon,
                      width: 25,
                      height: 25,
                      color: selectedIndex == bottomItems.indexOf(item)
                          ? primaryColor
                          : Colors.grey,
                    ),
                  ),
                  label: item.label,
                ),
              )
              .toList(),
          currentIndex: selectedIndex,
          selectedItemColor: primaryColor,
          onTap: _onItemTapped,
          selectedFontSize: 14,
          unselectedFontSize: 14,
        ),
      ),
    );
  }
}
