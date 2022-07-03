import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expensenote/Pages/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  _ProfileState() {
    getnumberoftransactions();
  }
  int numoftransactions = 0;
  int moneyspent = 0;
  int moneyadded = 0;

  getnumberoftransactions() async {
    var tempspent = 0;
    var tempadded = 0;
    final data = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('transactions')
        .get();
    final allData = data.docs.map((doc) => doc.data()['amount']).toList();
    for (int i = 0; i < allData.length; i++) {
      if (int.parse(allData[i].toString()) < 0) {
        tempspent += int.parse(allData[i].toString());
      } else if (allData[i] > 0) {
        tempadded += int.parse(allData[i].toString());
      }
    }

    setState(() {
      numoftransactions = data.size;
      moneyspent = tempspent;
      moneyadded = tempadded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Container(
          padding: EdgeInsets.only(top: 80),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              'Expense',
              style: TextStyle(fontSize: 37, color: Colors.black),
            ),
            Text(
              'Note',
              style: TextStyle(fontSize: 37, color: Colors.blue),
            ),
          ]),
        ),
        ///////////////////
        Container(
          width: double.infinity,
          height: 350.0,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.account_circle,
                  size: 100,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Text(
                  FirebaseAuth.instance.currentUser!.email.toString(),
                  style: const TextStyle(fontSize: 22.0, color: Colors.black),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 5.0),
                  clipBehavior: Clip.antiAlias,
                  color: Colors.white,
                  elevation: 5.0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 22.0),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            const Text(
                              "Transactions",
                              style: TextStyle(
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              numoftransactions.toString(),
                              // length.toString(),
                              style: const TextStyle(
                                fontSize: 20.0,
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  const Text(
                                    "Money spent",
                                    style: TextStyle(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  Text(
                                    moneyspent.toString(),
                                    style: const TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  const Text(
                                    "Money added",
                                    style: TextStyle(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  Text(
                                    moneyadded.toString(),
                                    style: const TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 20.0,
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 20, right: 20, left: 20),
          child:
           
              ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18.0),
      side: BorderSide(color: Colors.black)
    )
  ),
                fixedSize: MaterialStateProperty.all(Size(250, 50)),
                backgroundColor: MaterialStateProperty.all(Colors.black),
                padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10))),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Get.off(Auth());
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.logout),
                const Text(
                  ' Signout',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
