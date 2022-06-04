import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expensenote/Pages/seebill.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Transactions extends StatefulWidget {
  const Transactions({Key? key}) : super(key: key);

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  @override
  Widget build(BuildContext context) {
    ////////////////////////////////////////////////////////////////////////////////////
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 80, left: 15, right: 15),
            child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Amount',
                    style: TextStyle(fontSize: 37, color: Colors.black),
                  ),
                  Container(
                    width: 240,
                    child: Center(
                      child: Text(
                        'Title',
                        style: TextStyle(fontSize: 37, color: Colors.blue),
                      ),
                    ),
                  ),
                ]),
          ),
          // Container(
          //   height: 35,
          //   padding: const EdgeInsets.only(right: 30),
          //   color: Colors.grey[300],
          //   child: Row(
          //     children: const [
          //       Padding(
          //         padding: EdgeInsets.symmetric(horizontal: 50.0),
          //         child: Text(
          //           'Amount',
          //           style: TextStyle(fontSize: 17),
          //         ),
          //       ),
          //       Padding(
          //         padding: EdgeInsets.only(left: 90.0),
          //         child: Text(
          //           'Title',
          //           style: TextStyle(fontSize: 17),
          //         ),
          //       )
          //     ],
          //   ),
          // ),
          const Divider(
            thickness: 2,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.70,
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection('transactions')
                  .orderBy('date', descending: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView(
                    children: snapshot.data!.docs
                        .map((e) => ExpansionTile(
                                title: GestureDetector(
                                  child: Center(
                                    child: Container(
                                      height: 40,
                                      child: Container(
                                        width: 100,
                                        decoration: BoxDecoration(
                                          color: int.parse(
                                                      e['amount'].toString()) >
                                                  0
                                              ? Colors.green
                                              : Colors.red,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          (int.parse(e['amount'].toString())
                                                  .abs())
                                              .toString(),
                                          overflow: TextOverflow.fade,
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                trailing: Container(
                                  width: 240,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 190, 190, 190),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                  ),
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(7),
                                  child: Text(
                                    e['title'],
                                    maxLines: 3,
                                    overflow: TextOverflow.fade,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                children: [
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 30, right: 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 3),
                                                width: 100,
                                                child: Text(
                                                  DateFormat.yMMMd()
                                                      .add_jm()
                                                      .format(DateTime.parse(
                                                          e['date']
                                                              .toDate()
                                                              .toString())),
                                                  style:
                                                      TextStyle(fontSize: 13),
                                                )),
                                            Row(
                                              children: [
                                                if (e['billurl'] != '')
                                                  ElevatedButton(
                                                      onPressed: () {
                                                        String image = Uri.parse(
                                                                e['billurl']
                                                                    .toString())
                                                            .toString();
                                                        Get.to(SeeBill(
                                                          image: image,
                                                        ));
                                                      },
                                                      child: Text('show bill')),
                                                InkWell(
                                                  onTap: () {
                                                    print(e.id.toString());
                                                    FirebaseFirestore.instance
                                                        .collection('users')
                                                        .doc(FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid)
                                                        .collection(
                                                            'transactions')
                                                        .doc(e.id)
                                                        .delete();
                                                  },
                                                  child: const Icon(
                                                    Icons.delete,
                                                    size: 30,
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                          // width: MediaQuery.of(context)
                                          //         .size
                                          //         .width *
                                          //     0.5,

                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          child: Text(
                                            e['description'].toString(),
                                            style: TextStyle(
                                              fontSize: 17,
                                            ),
                                          )),
                                    ],
                                  ),
                                ]))
                        .toList(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
    //////////////////////////////////////////////////////////////////////////
  }
}
