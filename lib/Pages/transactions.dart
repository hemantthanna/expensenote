import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants/bottomnavigationbar.dart';

class Transactions extends StatefulWidget {
  const Transactions({Key? key}) : super(key: key);

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions'),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomBar(1).BottomBarWidget(),
      body: Container(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('transactions')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView(
                children: snapshot.data!.docs
                    .map((e) => Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width / 1.05,
                            height: 80,
                            color: Colors.grey[300],
                            margin: EdgeInsets.all(5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(left: 15),
                                  child: Text(e['amount'].toString(),
                                      style: TextStyle(fontSize: 30)),
                                ),
                                Container(
                                  width: 280,
                                  height: 60,
                                  decoration: const BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                  ),
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(7),
                                  child: Text(
                                    e['description'],
                                    maxLines: 3,
                                    overflow: TextOverflow.fade,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ))
                    .toList(),
              );
            }
          },
        ),
      ),
    );
  }
}



//return Card(
                //   child: ListTile(
                //     title: Text(doc.data()['title']),
                //   ),
                // );