import 'package:campus_connect/RegisterPage.dart';
import 'package:campus_connect/homescreen.dart';
import 'package:campus_connect/messageProvider.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'package:campus_connect/userProvider.dart';
import 'package:campus_connect/volunteerEventProvider.dart';
import 'package:campus_connect/themeProvider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:campus_connect/volunteerEvent.dart';
import 'package:hive/hive.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// createdTime is actually updatedTime
// username is user's english name

late Box<VolunteerEvent> volunteerBox;
late Box<String> updatedEventIdBox;

final SupabaseClient supabase = Supabase.instance.client;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.env['URL']!,
    anonKey: dotenv.env['ANONKEY']!,
  );
  Hive.init((await getApplicationDocumentsDirectory()).path);
  Hive.registerAdapter(VolunteerEventAdapter());
  volunteerBox = await Hive.openBox("volunteerBox");
  updatedEventIdBox = await Hive.openBox("updatedEventIdBox");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => VolunteerEventProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => MessageProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, ThemeProvider themeProvider, child) {
          return MaterialApp(
              title: 'CampusConnect',
              debugShowCheckedModeBanner: false,
              themeMode: themeProvider.themeMode,
              ////////////dark theme here
              darkTheme: ThemeData(
                buttonTheme: Theme.of(context).buttonTheme.copyWith(
                      highlightColor: const Color(0xff105924),
                    ),
                colorScheme: ColorScheme.fromSeed(
                    seedColor: const Color.fromARGB(255, 58, 90, 72),
                    brightness: Brightness.dark),
                visualDensity: VisualDensity.adaptivePlatformDensity,
                // cardColor: Colors.grey,
                cardTheme: const CardTheme(
                  color: Colors.black,
                ),
                useMaterial3: true,
                textTheme: const TextTheme(
                  bodyMedium: TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(255, 203, 217, 202),
                  ),
                ),
                iconTheme: const IconThemeData(
                  color: Color.fromARGB(255, 203, 217, 202),
                ),
                scaffoldBackgroundColor: Colors.black,
              ),
              theme: ThemeData(
                  buttonTheme: Theme.of(context).buttonTheme.copyWith(
                        highlightColor: Colors.green,
                      ),
                  colorScheme:
                      ColorScheme.fromSeed(seedColor: Colors.greenAccent),
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                  useMaterial3: true,
                  textTheme:
                      const TextTheme(bodyMedium: TextStyle(fontSize: 20))),
              home: (supabase.auth.currentUser != null)
                  ? const homescreen()
                  : const RegisterPage());
        },
      ),
    );
  }
}
