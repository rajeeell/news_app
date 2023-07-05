import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/inner_screens/bookmarks_screen.dart';
import 'package:news_app/screens/home_screen.dart';
import 'package:news_app/widgets/vertical_spacing.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../inner_screens/search_screen.dart';
import '../provider/dark_theme_provider.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Drawer(
      child: Material(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Image.asset(
                      'assets/images/newspaper.png',
                      height: 60,
                      width: 60,
                    ),
                  ),
                  const VerticalSpacing(20),
                  Flexible(
                    child: Text(
                      'News App',
                      style: GoogleFonts.lobster(
                        textStyle:
                            const TextStyle(fontSize: 20, letterSpacing: 0.6),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const VerticalSpacing(20),
            listTilesWidget(
              label: "Home",
              icon: IconlyBold.home,
              fct: () {
                Navigator.pushReplacement(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: const HomeScreen(),
                      inheritTheme: true,
                      ctx: context),
                );
              },
            ),
            listTilesWidget(
              label: "Bookmark",
              icon: IconlyBold.bookmark,
              fct: () {
                Navigator.pushReplacement(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: const BookmarkScreen(),
                      inheritTheme: true,
                      ctx: context),
                );
              },
            ),
            const Divider(
              thickness: 5,
            ),
            SwitchListTile(
                value: themeProvider.getDarkTheme,
                title: Text(
                  themeProvider.getDarkTheme ? 'Dark' : 'Light',
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                secondary: Icon(
                  themeProvider.getDarkTheme
                      ? Icons.dark_mode_outlined
                      : Icons.light_mode_outlined,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                onChanged: (bool value) {
                  themeProvider.setDarkTheme = value;
                }),
          ],
        ),
      ),
    );
  }
}

class listTilesWidget extends StatelessWidget {
  const listTilesWidget(
      {super.key, required this.label, required this.fct, required this.icon});
  final String label;
  final Function fct;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.secondary,
      ),
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 20,
        ),
      ),
      onTap: () {
        fct();
      },
    );
  }
}
