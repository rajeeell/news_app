import 'package:flutter/material.dart';
import 'package:newzy/consts/theme_data.dart';
import 'package:newzy/inner_screens/blog_details.dart';
import 'package:newzy/provider/dark_theme_provider.dart';
import 'package:newzy/providers/bookmarks_provider.dart';
import 'package:newzy/providers/news_provider.dart';
import 'package:newzy/screens/home_screen.dart';
import 'package:newzy/widgets/loading_widget.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeProvider themeChangeProvider = ThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.setDarkTheme =
        await themeChangeProvider.darkThemePreferences.getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) {
          return themeChangeProvider;
        }),
        ChangeNotifierProvider(
          create: (_) => NewsProvider(),
        ), //we added it here because Providers are kinda listeneres so they need to be above of the widget that requires data
        ChangeNotifierProvider(
          create: (_) => BookmarksProvider(),
        ),
      ],
      child: Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Newzy',
          theme: Styles.themeData(themeProvider.getDarkTheme, context),
          home: const HomeScreen(),
          routes: {
            NewsDetailsScreen.routeName: (context) => const NewsDetailsScreen(),
          },
        );
      }),
    );
  }
}
