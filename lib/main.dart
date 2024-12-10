import 'package:provider/provider.dart';
import 'provider/auth_provider.dart';
import 'package:task1/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:task1/global/globalValues.dart';
import 'package:task1/screen/login.dart';
import 'package:task1/screen/info.dart';
import 'package:task1/screen/register.dart';
// import 'package:task1/screen/newUser.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => Global(),
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({Key? key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => CustomAuthProvider(),
          )
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Task1',
          themeMode: ThemeMode.system,
          initialRoute: '/register',
          routes: {
            '/info': (context) => const Info(),
            '/login': (context) => const Login(),
            '/register': (context) => const Register(
                  email: '',
                ),
            // '/newuser': (context) => const NewUser(
            //       email: '',
            //     ),
          },
        ));
  }
}
