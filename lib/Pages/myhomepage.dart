import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expensenote/Pages/newentrypage.dart';
import 'package:expensenote/models/dbmodelclass.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

int remainingamount = 0;

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState() {
    getremainingamount();
  }

  int temp = 0;
  int numoftransactions = 0;
  int moneyspent = 0;
  int moneyadded = 0;
  var tempspent = 0;
  var tempadded = 0;
  Color swipebuttoncolor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //title////////////////////////////
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
          /////////amount stats//////////////

          Column(
            children: [
              Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  children: [
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
                            moneyspent.abs().toString(),
                            style: const TextStyle(
                              fontSize: 20.0,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              ////////////////
              Divider(
                height: 20,
                thickness: 5,
              ),
            ],
          ),
          const SizedBox(
            height: 66.0,
          ),

          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Dismissible(
              movementDuration: const Duration(milliseconds: 800),
              resizeDuration: Duration(milliseconds: 0),
              key: Key('swipebutton'),
              dismissThresholds: {
                DismissDirection.endToStart: 1,
                DismissDirection.startToEnd: 1
              },
              onUpdate: (details) {
                if (details.progress > 0.5) {
                  if (details.direction == DismissDirection.endToStart) {
                    Get.to(NewEntryPage(
                      iscredit: false,
                    ));
                  } else {
                    Get.to(NewEntryPage(
                      iscredit: true,
                    ));
                  }
                }
              },
              onDismissed: (direction) {},
              background: Container(
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        bottomLeft: Radius.circular(50))),
                child: Align(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                      Text(
                        " Credit Entry",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  alignment: Alignment.centerLeft,
                ),
              ),
              secondaryBackground: Container(
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50),
                        bottomRight: Radius.circular(50))),
                child: Align(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                      Text(
                        " Debit Entry",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.right,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                  alignment: Alignment.centerRight,
                ),
              ),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('<<<<'),
                    Text(
                      'Swipe for New Entry',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text('>>>>'),
                  ],
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.00),
                    color: Colors.grey[300]),
                width: MediaQuery.of(context).size.width - 30,
                height: 80,
              ),
            ),
          )
        ],
      ),
    );
  }
  /////////////////////functions //////////////////////////////////////

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

    for (int i = 0; i < allData.length; i++) {
      if (int.parse(allData[i].toString()) < 0) {
        tempspent += int.parse(allData[i].toString());
      } else if (allData[i] > 0) {
        tempadded += int.parse(allData[i].toString());
      }
    }
  

    setState(() {
      remainingamount = temp;
      numoftransactions = data.size;
      moneyspent = tempspent;
      moneyadded = tempadded;
    });
  }
//   Future<int> getremainingamount() async {
//   int remainingamount = 0;

//   final data = FirebaseFirestore.instance
//       .collection('users')
//       .doc(FirebaseAuth.instance.currentUser!.uid)
//       .collection('transactions')
//       .get();

//   data.then((value) => value.docs.forEach((element) {
//         remainingamount += int.parse((element['amount']).toString());
//       }));

//   return remainingamount;
// }
}
