import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/bottomnavigationbar.dart';
import 'myhomepage.dart';

class DebitPage extends StatefulWidget {
  const DebitPage({Key? key}) : super(key: key);

  @override
  State<DebitPage> createState() => _DebitPageState();
}

class _DebitPageState extends State<DebitPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String description = '';
  int amount = 0;
  DateTime dateandtime = DateTime.now();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Credit Page')),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 100, 0, 20),
              height: 100,
              width: 300,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  border: Border.all(width: 4, color: Colors.green),
                  borderRadius: BorderRadius.circular(10)),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '  *enter some amount';
                  }
                  return null;
                },
                textAlign: TextAlign.center,
                autofocus: true,
                decoration: InputDecoration(
                    hintText: 'Amount', border: InputBorder.none),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (value == '') {
                    amount = 0;
                  } else
                    amount = int.parse(value);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextFormField(
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                    hintText: 'Description', border: OutlineInputBorder()),
                onChanged: (value) {
                  description = value;
                },
              ),
            ),
            ElevatedButton(
                style: ButtonStyle(),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')),
                    );
                    FocusManager.instance.primaryFocus?.unfocus();
                    var firebaseUser = FirebaseAuth.instance.currentUser;
                    firestore
                        .collection("users")
                        .doc(firebaseUser!.uid)
                        .collection('transactions')
                        .doc()
                        .set({
                      "amount": '-$amount',
                      "description": description,
                      "date": dateandtime,
                    }).then((_) {
                      Get.off(const MyHomePage());
                    });
                  }
                },
                child: Text('Done')),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(0).BottomBarWidget(),
    );
  }
}
