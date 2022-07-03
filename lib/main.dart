import 'package:expensenote/Pages/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Pages/analysis.dart';
import 'Pages/myhomepage.dart';
import 'Pages/profile.dart';
import 'Pages/transactions.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      defaultTransition: Transition.fade,
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
        Get.off(const Home());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
////////////////////////////////////////////////////////////////////////////////////////

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _pageindex = 0;
  PageController pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        children: [MyHomePage(), Transactions(), Analysis(), Profile()],
        onPageChanged: (newindex) {
          if (this.mounted) {
            setState(() {
              _pageindex = newindex;
            });
          }
        },
      ),
     
      bottomNavigationBar: FloatingNavbar(
        currentIndex: _pageindex,
        iconSize: 30,
        fontSize: 11,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        onTap: (index) {
          pageController.animateToPage(index,
              duration: const Duration(milliseconds: 1), curve: Curves.ease);
        },
        items: [
          FloatingNavbarItem(
            icon: Icons.home,
            title: 'Home',

            // backgroundColor: Colors.blue
          ),
          FloatingNavbarItem(
            icon: Icons.list,
            title: 'Transactions',
            // backgroundColor: Colors.blue
          ),
          FloatingNavbarItem(
            icon: Icons.analytics,
            title: 'Analysis',
            // backgroundColor: Colors.blue
          ),
          FloatingNavbarItem(
            icon: Icons.person,
            title: 'Profile',
            // backgroundColor: Colors.blue
          ),
        ],
      ),
    );
  }
}