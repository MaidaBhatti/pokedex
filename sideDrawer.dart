import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/Practic.dart';
import 'package:flutter_application_1/screens/catchpokemon.dart';

import 'package:flutter_application_1/screens/home.dart';

class Sidedrawer extends StatelessWidget {
  const Sidedrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color.fromARGB(104, 98, 2, 136),
      child: ListView(
        children: buildMenuItems(context),
      ),
    );
  }

  List<Widget> buildMenuItems(BuildContext context) {
    List<Widget> menuItems = [];

    menuItems.add(
      DrawerHeader(
        decoration: BoxDecoration(
          color: Colors.white, // Change the header color
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "PokeBall",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,  color: Colors.grey),
            ),
            SizedBox(height: 5),
            Text(
              "Gotta Catch 'Em All!",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );

    final Map<String, IconData> menuItemsWithIcons = {
      "Home": Icons.home,
 
      "Catch Pokemon": Icons.catching_pokemon,
    "About": Icons.h_plus_mobiledata_outlined,
    };

    menuItemsWithIcons.forEach((title, icon) {
      menuItems.add(
        ListTile(
          leading: Icon(
            icon,
            color: Colors.white, // Change the icon color
          ),
          title: Text(
            title,
            style: TextStyle(fontSize: 16, color: Colors.white), // Change the text color
          ),
          onTap: () {
            late Widget screen;
            switch (title) {
              case "Home":
                screen = HomeScreen();
                break;

            
              case "Catch Pokemon":
                screen = CatchPokemon();
                break;

              case "About":
                screen = AboutPage();
                break;
              default:
                // Handle default case
                break;
            }
            Navigator.of(context).pop(); // Close the drawer
            Navigator.of(context).push(MaterialPageRoute(builder: ((context) => screen)));
          },
        ),
      );
    });

    return menuItems;
  }
}
