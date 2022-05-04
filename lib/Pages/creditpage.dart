import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expensenote/Pages/myhomepage.dart';
import 'package:expensenote/main.dart';
import 'package:expensenote/models/hivetransactionmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreditPage extends StatefulWidget {
  const CreditPage({Key? key}) : super(key: key);

  @override
  State<CreditPage> createState() => _CreditPageState();
}

class _CreditPageState extends State<CreditPage> {
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
                  color: Colors.green[300],
                  // color: Colors.grey[300],
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
                decoration: const InputDecoration(
                    hintText: 'Amount', border: InputBorder.none),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (value == '') {
                    amount = 0;
                  } else {
                    amount = int.parse(value);
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextFormField(
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                    hintText: 'Description', border: OutlineInputBorder()),
                onChanged: (value) {
                  description = value;
                },
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    FocusManager.instance.primaryFocus?.unfocus();
                    firestore
                        .collection("users")
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection('transactions')
                        .doc()
                        .set({
                      "amount": amount,
                      "description": description,
                      "date": dateandtime,
                    }).then((_) {
                      Get.off(() => const Home());
                    });
                  }
                },
                child: const Text('Done')),
          ],
        ),
      ),
    );
  }
}
