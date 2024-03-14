import 'package:lab2/pages/user_profile_page.dart';
import 'package:lab2/pages/favorites_page.dart';
import 'package:lab2/pages/user_main_page.dart';
import 'package:flutter/material.dart';

class CustomMenuBar extends StatefulWidget implements PreferredSizeWidget {
  final int currentIndex;
  const CustomMenuBar({super.key, required this.currentIndex});

  @override
  State<CustomMenuBar> createState() => _CustomMenuBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomMenuBarState extends State<CustomMenuBar> {
  var _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
  }

  void _loadScreen() {
    switch(_currentIndex) {
      case 0:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const UserMainPage()
            )
        );
        break;
      case 1:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const FavoritesPage()
            )
        );
        break;
      case 2:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const UserProfilePage()
            )
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.location_city, color: Theme.of(context).colorScheme.onPrimaryContainer),
                onPressed: () {
                  setState(() => _currentIndex = 0);
                  _loadScreen();
                },
              ),
              IconButton(
                icon: Icon(Icons.favorite_border_outlined, color: Theme.of(context).colorScheme.onPrimaryContainer),
                onPressed: () {
                  setState(() => _currentIndex = 1);
                  _loadScreen();
                },
              ),
              IconButton(
                icon: Icon(Icons.accessibility_sharp, color: Theme.of(context).colorScheme.onPrimaryContainer),
                onPressed: () {
                  setState(() => _currentIndex = 2);
                  _loadScreen();
                },
              ),
            ],
          ),
        ),
      ),
      body: Container(),
    );
  }

}
