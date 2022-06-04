import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expensenote/Pages/profile.dart';
import 'package:expensenote/Pages/transactions.dart';
import 'package:expensenote/models/dbmodelclass.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'creditpage.dart';
import 'debitpage.dart';

int remainingamount = 0;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() {
    getremainingamount();
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
        children: const [MyHomePage(), Transactions(), Profile()],
        onPageChanged: (newindex) {
          if (this.mounted) {
            setState(() {
              _pageindex = newindex;
            });
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
          iconSize: 35,
          selectedFontSize: 18,
          currentIndex: _pageindex,
          onTap: (index) {
            pageController.animateToPage(index,
                duration: const Duration(milliseconds: 1), curve: Curves.ease);
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
                backgroundColor: Colors.blue),
            BottomNavigationBarItem(
                icon: Icon(Icons.list),
                label: 'Transactions',
                backgroundColor: Colors.blue),
            BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
                backgroundColor: Colors.blue),
          ]),

      // bottomNavigationBar: CustomAnimatedBottomBar(
      //   containerHeight: 70,
      //   backgroundColor: Colors.black,
      //   selectedIndex: _pageindex,
      //   showElevation: true,
      //   itemCornerRadius: 24,
      //   curve: Curves.easeIn,
      //   onItemSelected: (index) {
      //     pageController.animateToPage(index,
      //         duration: const Duration(milliseconds: 300),
      //         curve: Curves.ease);
      //   },
      //   items: <BottomNavyBarItem>[
      //     BottomNavyBarItem(
      //       icon: Icon(
      //         Icons.home,
      //         size: 30,
      //       ),
      //       title: Text('Home'),
      //       activeColor: Colors.green,
      //       inactiveColor: Colors.grey,
      //       textAlign: TextAlign.center,
      //     ),
      //     BottomNavyBarItem(
      //       icon: Icon(
      //         Icons.list,
      //         size: 30,
      //       ),
      //       title: Text('Transactions'),
      //       activeColor: Colors.purpleAccent,
      //       inactiveColor: Colors.grey,
      //       textAlign: TextAlign.center,
      //     ),
      //     BottomNavyBarItem(
      //       icon: Icon(
      //         Icons.person,
      //         size: 30,
      //       ),
      //       title: Text(
      //         'Profile ',
      //       ),
      //       activeColor: Colors.pink,
      //       inactiveColor: Colors.grey,
      //       textAlign: TextAlign.center,
      //     ),
      //   ],
      // )
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState() {
    getremainingamount();
  }

  // int remainingamount = 0;

  int temp = 0;
  int numoftransactions = 0;
  int moneyspent = 0;
  int moneyadded = 0;
  var tempspent = 0;
  var tempadded = 0;
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
          //////////rest of the body/////////

          Column(
            children: [
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
          ///////////
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Hero(
                    tag: 1,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 10))),
                        onPressed: () {
                          WidgetsFlutterBinding.ensureInitialized();
                          Get.to(() => CreditPage());
                        },
                        child: Text(
                          'Credit',
                          style: TextStyle(fontSize: 20),
                        )),
                  ),
                  //
                  Hero(
                    tag: 2,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 10))),
                        onPressed: () {
                          WidgetsFlutterBinding.ensureInitialized();
                          Get.to(() => DebitPage());
                        },
                        child: Text(
                          'Debit',
                          style: TextStyle(fontSize: 20),
                        )),
                  ),
                ]),
          ),
        ],
      ),
    );
  }
}
