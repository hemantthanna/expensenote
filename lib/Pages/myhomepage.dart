import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expensenote/main.dart';
import 'package:expensenote/models/dbmodelclass.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/bottomnavigationbar.dart';
import 'creditpage.dart';
import 'debitpage.dart';
import 'package:collection/collection.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState() {
    getremainingamount();
  }

  int remainingamount = 0;
  int temp = 0;
  getremainingamount() async {
    final data = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('transactions')
        .get();

    final allData = data.docs.map((doc) => doc.data()['amount']).toList();
    for (int i = 0; i < allData.length; i++) {
      temp += int.parse(allData[i].toString());
    }
    setState(() {
      remainingamount = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('ExpenseNote'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(children: [
            Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[300]),
                width: 300,
                height: 130,
                child: Column(
                  children: [
                    Text(
                      '$remainingamount',
                      style: TextStyle(fontSize: 45),
                    ),
                    Text(
                      'Remaining Amount',
                      style: TextStyle(fontSize: 17),
                    ),
                  ],
                )),
            Container(
              height: 370,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 10))),
                          onPressed: () {
                            WidgetsFlutterBinding.ensureInitialized();
                            Get.to(CreditPage());
                          },
                          child: Text(
                            'Credit',
                            style: TextStyle(fontSize: 20),
                          )),
                      ElevatedButton(
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 10))),
                          onPressed: () {
                            WidgetsFlutterBinding.ensureInitialized();
                            Get.to(DebitPage());
                          },
                          child: Text(
                            'Debit',
                            style: TextStyle(fontSize: 20),
                          )),
                    ]),
              ),
            ),
          ]),
        ),
      ),
      bottomNavigationBar: BottomBar(0).BottomBarWidget(),
    );
  }
}
