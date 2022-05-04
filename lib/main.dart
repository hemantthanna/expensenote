import 'package:expensenote/Pages/auth.dart';
import 'package:expensenote/models/hivetransactionmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'Pages/myhomepage.dart';

late Box box;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(HiveTransactionsAdapter());
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      defaultTransition: Transition.fade
      ,
      debugShowCheckedModeBanner: false,
      home: Wrapper(),
    );
  }
}

class Wrapper extends StatelessWidget {
  Wrapper() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null) {
        Get.off(const Auth());
      } else {
        box = await Hive.openBox(
            FirebaseAuth.instance.currentUser!.uid.toString());

        Get.off(const Home());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
