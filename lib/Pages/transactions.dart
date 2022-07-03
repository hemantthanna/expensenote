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
  bool searchbarfolded = false;

  @override
  Widget build(BuildContext context) {
    ////////////////////////////////////////////////////////////////////////////////////
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: AnimatedContainer(
          duration: Duration(milliseconds: 400),
          height: 55,
          width: searchbarfolded ? 60 : MediaQuery.of(context).size.width - 70,
          // width: 300,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32), color: Colors.grey[300]
              // boxShadow: kElevationToShadow[6],
              ),
          child: Row(
            children: [
              Expanded(
                  child: Container(
                      padding: EdgeInsets.only(left: searchbarfolded ? 0 : 22),
                      child: !searchbarfolded
                          ? TextField(
                              decoration: InputDecoration(
                                  hintText: 'Enter keyword or amount',
                                  hintStyle: TextStyle(color: Colors.black),
                                  border: InputBorder.none),
                            )
                          : null)),
              AnimatedContainer(
                duration: Duration(milliseconds: 400),
                child: Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        searchbarfolded = !searchbarfolded;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Icon(
                        searchbarfolded ? Icons.search : Icons.close,
                        size: 24,
                        color: Colors.blue[900],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {},
                child: Icon(
                  Icons.more_vert,
                  color: Colors.black,
                  size: 30,
                ),
              )),
        ],
      ),

      //////////////////////////////////////////////////////////////////
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [],
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Text(
                'Amount',
                style: TextStyle(fontSize: 30, color: Colors.black),
              ),
              Container(
                height: 30,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.black,
                        width: 1,
                        style: BorderStyle.solid)),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 90.0, left: 65),
                child: Text(
                  'Title',
                  style: TextStyle(fontSize: 30, color: Colors.blue),
                ),
              ),
            ]),
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
                          .map((e) => Container(
                                margin: EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  // color: Colors.grey
                                ),
                                child: Card(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: ExpansionTile(
                                      title: GestureDetector(
                                        child: Container(
                                          height: 40,
                                          child: Container(
                                            width: 100,
                                            decoration: BoxDecoration(
                                              color: int.parse(e['amount']
                                                          .toString()) >
                                                      0
                                                  ? Colors.green
                                                  : Colors.red,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              ('₹ ${int.parse(e['amount'].toString()).abs()}')
                                                  .toString(),
                                              overflow: TextOverflow.fade,
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ),
                                        ),
                                      ),
                                      trailing: Container(
                                        width: 240,
                                        height: 40,
                                        decoration: const BoxDecoration(
                                          // color:
                                          //     Color.fromARGB(255, 190, 190, 190),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                        ),
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.all(7),
                                        child: Text(
                                          e['title'],
                                          maxLines: 3,
                                          overflow: TextOverflow.fade,
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      children: [
                                        Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20, right: 20),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Container(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 3),
                                                          width: 100,
                                                          child: Text(
                                                            DateFormat.yMMMd()
                                                                .add_jm()
                                                                .format(DateTime
                                                                    .parse(e[
                                                                            'date']
                                                                        .toDate()
                                                                        .toString())),
                                                            style: TextStyle(
                                                                fontSize: 13),
                                                          )),
                                                      Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 15,
                                                                vertical: 6),
                                                        decoration: BoxDecoration(
                                                            color: Colors
                                                                .lightGreen,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        child: Text(
                                                            e['category']
                                                                .toString()),
                                                      )
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      if (e['billurl'] != '')
                                                        ElevatedButton(
                                                            onPressed: () {
                                                              String image = Uri
                                                                      .parse(e[
                                                                              'billurl']
                                                                          .toString())
                                                                  .toString();
                                                              Get.to(SeeBill(
                                                                image: image,
                                                              ));
                                                            },
                                                            child: Text(
                                                                'show bill')),
                                                      InkWell(
                                                        onTap: () {
                                                          print(
                                                              e.id.toString());
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'users')
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
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 5),
                                                child: Text(
                                                  e['description'].toString(),
                                                  style: TextStyle(
                                                    fontSize: 17,
                                                  ),
                                                )),
                                          ],
                                        ),
                                      ]),
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
      ),
      
    );
    //////////////////////////////////////////////////////////////////////////
  }
}
