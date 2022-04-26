import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/bottomnavigationbar.dart';
import '../main.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
      ),
      body: Column(children: [
        ElevatedButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Get.off(Wrapper());
            },
            child: Text('SignOut')),
        Text(FirebaseAuth.instance.currentUser!.uid),
      ]),
      bottomNavigationBar: BottomBar(2).BottomBarWidget(),
    );
  }
}
