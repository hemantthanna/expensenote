import 'package:expensenote/auth.dart';
import 'package:expensenote/models/hivetransactionmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import 'Pages/myhomepage.dart';

late Box box;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(HiveTransactionsAdapter());
  box = await Hive.openBox('box');

  

// box document name is 0
  box.put(
      0,
      HiveTransactions(
          amount: 1234,
          description: 'first transaction in hive database',
          dateTime: DateTime.now()));
  box.put(
      1,
      HiveTransactions(
          amount: 100,
          description: 'second transaction in hive',
          dateTime: DateTime.now()));

  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // bool permissionGranted;




  @override
  Widget build(BuildContext context) {
  bool permissionGranted;


  
  

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Wrapper(),
    );
  }
}

class Wrapper extends StatelessWidget {


  
  Wrapper() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        Get.off(const Auth());
      } else {
        print(user.uid);
        Get.off(const MyHomePage());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
