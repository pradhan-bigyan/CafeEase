import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:kyafeease/admin/admin_dashboard.dart';
import 'package:kyafeease/employee/employeedashboard.dart';
import 'package:kyafeease/firebase_options.dart';

import 'package:kyafeease/pages/home.dart';
import 'package:kyafeease/pages/login.dart';
import 'package:kyafeease/pages/signup.dart';
import 'package:kyafeease/pages/startingscreen.dart';
import 'pages/buttomnav.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return KhaltiScope(
      publicKey: 'test_public_key_dafa9deec1da4f28aa6bbf1ce8380543',
      enabledDebugging: true,
      builder: (context, navKey) {
        return MaterialApp(
  home: StartingPage(),

     //  home: Employeedashboard(),
          navigatorKey: navKey,
          localizationsDelegates: const [
            KhaltiLocalizations.delegate
          ],
        );
      }, 
    );
  }
}