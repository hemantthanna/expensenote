import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expensenote/Pages/myhomepage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CreditPage extends StatefulWidget {
  const CreditPage({Key? key}) : super(key: key);

  @override
  State<CreditPage> createState() => _CreditPageState();
}

class _CreditPageState extends State<CreditPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;
  bool valuefirst = false;

  String description = '';
  String title = '';
  int amount = 0;
  DateTime dateandtime = DateTime.now();
  String billurl = '';
  FilePickerResult? result;

  final _formKey = GlobalKey<FormState>();
  PlatformFile? pickedimage;
  UploadTask? uploadTask;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      //   toolbarHeight: 80,
      //   backgroundColor: Colors.transparent,
      //   shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.only(
      //           bottomRight: Radius.circular(70),
      //           bottomLeft: Radius.circular(70))),
      //   centerTitle: true,
      //   title: Container(
      //     decoration: BoxDecoration(
      //         borderRadius: BorderRadius.circular(10), color: Colors.blue),
      //     padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      //     child: Text(
      //       'Credit entry',
      //       style: TextStyle(color: Colors.white, fontSize: 27),
      //     ),
      //   ),
      // ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Hero(
              tag: 1,
              child: Material(
                type: MaterialType.transparency,
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 100, 0, 20),
                  height: 100,
                  width: 300,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.green[400],
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
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) {
                      if (value == '') {
                        amount = 0;
                      } else {
                        amount = int.parse(value);
                      }
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                    hintText: 'Title', border: OutlineInputBorder()),
                onChanged: (value) {
                  title = value;
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  checkColor: Colors.greenAccent,
                  // activeColor: Colors.red,
                  value: this.valuefirst,
                  onChanged: (bool? value) {
                    setState(() {
                      this.valuefirst = value!;
                      print(value);
                      print(this.valuefirst);
                    });
                  },
                ),
                Text('necessary transaxtion like fees, rent etc.'),
                Icon(
                  Icons.arrow_drop_down,
                  size: 90,
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                    hintText: 'Description', border: OutlineInputBorder()),
                onChanged: (value) {
                  description = value;
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          result = await FilePicker.platform.pickFiles(
                              allowMultiple: false,
                              type: FileType.image,
                              allowCompression: true);
                          /////////////////////////////
                          if (result == null) {
                            Get.snackbar('', 'you did not selected any file');
                            return null;
                          } else {
                            final ref = FirebaseStorage.instance.ref().child(
                                '${FirebaseAuth.instance.currentUser!.uid}/${firestore.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).collection('transactions').doc().id}');
                            var tempurl = await ref
                                .putFile(File(result!.files.first.path!))
                                .then((p0) async =>
                                    await ref.getDownloadURL().then((value) {
                                      return value;
                                    }));

                            Get.snackbar('billurl', tempurl);

                            setState(() {
                              pickedimage = result!.files.first;
                              billurl = tempurl;
                            });
                          }
                          ///////////
                        },
                        child: Text('upload')),
                    // bill image preview
                    if (pickedimage != null)
                      Container(
                        width: 100,
                        height: 100,
                        child: Image.file(
                          File(pickedimage!.path!),
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                  ],
                ),

                ////// DONE BUTTON
                GestureDetector(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      FocusManager.instance.primaryFocus?.unfocus();
                      firestore
                          .collection("users")
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection('transactions')
                          .doc()
                          .set({
                        "amount": amount,
                        "title": title,
                        "description": description,
                        "date": dateandtime,
                        "billurl": billurl,
                      }).then((_) {
                        Get.off(() => const Home());
                      });
                    }
                  },

                  child: Container(
                    height: 70,
                    width: 70,
                    child: Image.asset(
                      'assets/checkbox.png',
                      fit: BoxFit.fill,
                    ),
                  ),

                  // child: const Text('Done')
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
