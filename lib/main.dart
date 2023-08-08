import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:notepad/services/data_state.dart';
import 'package:notepad/screens/sign_in.dart';
import 'package:notepad/services/gesture_state.dart';
import 'package:provider/provider.dart';
import 'package:notepad/services/auth_state.dart';
import 'firebase_options.dart';
import 'screens/sign_up.dart';
import 'screens/home.dart';
import '../screens/note_edit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => Auth(),
      ),
      ChangeNotifierProvider(
        create: (context) => Data(),
      ),
      ChangeNotifierProvider(
        create: (context) => GestureState(),
      )
    ],
    child: const Root(),
  ));
}

class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(245, 70, 70, 70),
          foregroundColor: Color.fromARGB(220, 235, 230, 230),
          elevation: 3,
          centerTitle: true,
          titleSpacing: 20,
        ),
        textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
          bodyText1: TextStyle(fontSize: 21),
        ),
      ),
      home: Consumer<Auth>(
          builder: (context, state, _) =>
              state.loggedIn ? const Home() : const SignIn()),
      routes: {
        '/sign-up': (context) => const SignUp(),
        '/home': (context) => const Home(),
        '/sign-in': (context) => const SignIn(),
        '/note-edit': (context) => NoteEdit(),
      },
    );
  }
}
