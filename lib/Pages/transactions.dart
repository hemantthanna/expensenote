import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
      appBar: AppBar(
        title: const Text('Transactions'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            height: 50,
            padding: EdgeInsets.only(right: 30),
            color: Colors.grey[300],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Amount',
                  style: TextStyle(fontSize: 25),
                ),
                Text(
                  'Description',
                  style: TextStyle(fontSize: 25),
                )
              ],
            ),
          ),
          Divider(
            height: 20,
            thickness: 5,
          ),
          Container(
            height: 600,
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection('transactions')
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
                        .map((e) => GestureDetector(
                              onLongPress: () {
                                print(e.id.toString());
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .collection('transactions')
                                    .doc(e.id)
                                    .delete();
                              },
                              child: Center(
                                child: Container(
                                  padding: EdgeInsets.only(left: 10),
                                  width:
                                      MediaQuery.of(context).size.width / 1.05,
                                  height: 80,
                                  color: Colors.grey[300],
                                  margin: EdgeInsets.all(5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(left: 15),
                                        child: Text(e['amount'].toString(),
                                            style: TextStyle(fontSize: 27)),
                                      ),
                                      Container(
                                        width: 240,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: int.parse(
                                                      e['amount'].toString()) >
                                                  0
                                              ? Colors.green
                                              : Colors.red,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
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
                              ),
                            ))
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
