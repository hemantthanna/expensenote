import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';

import '../main.dart';

class NewEntryPage extends StatefulWidget {
  late bool iscredit;
  NewEntryPage({Key? key, required bool iscredit}) {
    this.iscredit = iscredit;
  }

  @override
  State<NewEntryPage> createState() => _NewEntryPageState(iscredit: iscredit);
}

class _NewEntryPageState extends State<NewEntryPage> {
  _NewEntryPageState({required bool iscredit}) {
    this.iscredit = iscredit;
  }
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;
  //////////////////////////////////
  bool valuefirst = false;
  bool showmore = false;
  late bool iscredit;

  String description = '';
  String title = '';
  int amount = 0;
  String category = 'others';
  DateTime dateandtime = DateTime.now();
  String billurl = '';
  FilePickerResult? result;

  final _formKey = GlobalKey<FormState>();
  PlatformFile? pickedimage;
  UploadTask? uploadTask;
  Widget uploadingstate = Text('Upload');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ConstrainedBox(
              constraints: new BoxConstraints(
                maxHeight: 600,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Material(
                      type: MaterialType.transparency,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 80, 0, 30),
                        height: 90,
                        width: 300,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: TextFormField(
                          style: TextStyle(fontSize: 35),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '  *enter some amount';
                            }
                            return null;
                          },
                          textAlign: TextAlign.center,
                          autofocus: true,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            hintText: 'Amount',
                            hintStyle: TextStyle(fontSize: 35),
                            border: InputBorder.none,
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
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
                    ///////////////////////////////////////////////////////////
                    ///
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              category = 'Food & Grocery';
                            });
                          },
                          child: Text('Food & Grocery',
                              style: TextStyle(fontSize: 10)),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                category = 'Entertainment';
                              });
                            },
                            child: Text('Entertainment',
                                style: TextStyle(fontSize: 10))),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                category = 'Shopping';
                              });
                            },
                            child: Text('Shopping',
                                style: TextStyle(fontSize: 10))),
                        ElevatedButton(
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    _chooseCustomCategory(context),
                              ).then((value) {
                                setState(() {
                                  category = value;
                                });
                              });
                            },
                            child:
                                Text('custom', style: TextStyle(fontSize: 10))),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 5, left: 30, right: 30, top: 10),
                      child: TextFormField(
                        onTap: () {
                          setState(() {
                            showmore = false;
                          });
                        },
                        textAlign: TextAlign.center,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          labelText: "Add Description",
                          floatingLabelAlignment: FloatingLabelAlignment.center,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Colors.grey),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 2, color: Colors.blue),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onChanged: (value) {
                          title = value;
                        },
                      ),
                    ),
                    ////////////////////////////////////////////////////
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                          checkColor:
                              iscredit ? Colors.greenAccent : Colors.redAccent,
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
                        Text('necessary transaction like fees, rent etc.'),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        WidgetsBinding.instance.focusManager.primaryFocus
                            ?.unfocus();
                        setState(() {
                          showmore = !showmore;
                        });
                      },
                      child: Text('more options',
                          style: TextStyle(
                              color: iscredit ? Colors.green : Colors.red)),
                    ),
                    if (showmore)
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          decoration:   InputDecoration(
                          labelText: "Description",
                          floatingLabelAlignment: FloatingLabelAlignment.center,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          enabledBorder: OutlineInputBorder(
                            borderSide:BorderSide(width: 2, color: Colors.grey),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                 BorderSide(width: 2, color: Colors.blue),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                          onChanged: (value) {
                            description = value;
                          },
                        ),
                      ),
                    if (showmore)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  uploadingstate = CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 1.0,
                                  );
                                });
                                result = await FilePicker.platform.pickFiles(
                                    allowMultiple: false,
                                    type: FileType.image,
                                    allowCompression: true);
                                /////////////////////////////
                                if (result == null) {
                                  Get.snackbar(
                                      '', 'you did not selected any file');
                                  return null;
                                } else {
                                  final ref = FirebaseStorage.instance.ref().child(
                                      '${FirebaseAuth.instance.currentUser!.uid}/${firestore.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).collection('transactions').doc().id}');
                                  var tempurl = await ref
                                      .putFile(File(result!.files.first.path!))
                                      .then((p0) async => await ref
                                              .getDownloadURL()
                                              .then((value) {
                                            return value;
                                          }));
                                  setState(() {
                                    pickedimage = result!.files.first;
                                    billurl = tempurl;
                                    uploadingstate = Text('upload other bill');
                                  });
                                }
                                ///////////
                              },
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                          side:
                                              BorderSide(color: Colors.black))),
                                  fixedSize:
                                      MaterialStateProperty.all(Size(200, 40)),
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.black),
                                  padding: MaterialStateProperty.all(
                                      const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 10))),
                              child: uploadingstate),
                          // bill image preview
                          if (pickedimage != null)
                            ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        _watchpreview(
                                            imagepath: pickedimage!.path!),
                                  );
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.preview,
                                      color: Colors.black,
                                    ),
                                    Text('Preview',style: TextStyle(color: Colors.blue),)
                                  ],
                                ),
                                style: ButtonStyle(
                                    elevation: MaterialStateProperty.all(0),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                            side: BorderSide(
                                                color: Colors.transparent))),
                                    
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.transparent),
                                    padding: MaterialStateProperty.all(
                                        const EdgeInsets.symmetric(
                                            horizontal: 30, vertical: 10))))
                        ],
                      ),

                    ////// DONE BUTTON
                  ],
                ),
              ),
            ),
            Center(
                child: Padding(
              padding: const EdgeInsets.all(10),
              child: SwipeButton.expand(
                height: 70,
                thumb: Icon(
                  Icons.double_arrow_rounded,
                  color: Colors.white,
                ),
                child: Text(
                  iscredit ? "Credit entry" : "Debit entry",
                  style: TextStyle(
                    color: iscredit ? Colors.green : Colors.red,
                  ),
                ),
                activeThumbColor: iscredit ? Colors.green : Colors.red,
                activeTrackColor: Colors.grey.shade300,
                onSwipeEnd: () {
                  if (_formKey.currentState!.validate()) {
                    FocusManager.instance.primaryFocus?.unfocus();
                    firestore
                        .collection("users")
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection('transactions')
                        .doc()
                        .set({
                      "amount": iscredit ? amount : '-$amount',
                      "title": title,
                      "description": description,
                      "date": dateandtime,
                      "billurl": billurl,
                      "category": category
                    }).then((_) {
                      Get.off(() => const Home());
                      // Get.back();
                    });
                  }
                },
              ),
            ))
          ],
        ),
      ),
    );
  }

  Widget _watchpreview({required String imagepath}) {
    return AlertDialog(
        title: Center(child: const Text('Choose Chart Type')),
        content: new Container(
          width: 200,
          height: 300,
          child: Image.file(
            File(imagepath),
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ));
  }
}

///////////////////////////////
///cutom category popup code

Widget _chooseCustomCategory(BuildContext context) {
  String? customcategory;
  return new AlertDialog(
    title: const Text('Choose or create Category'),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextFormField(
          decoration: InputDecoration(
              hintText: 'custom category', labelText: 'Category'),
          onChanged: (value) {
            customcategory = value;
            print(customcategory);
          },
        ),
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(customcategory.toString());
            },
            child: Text('done'))
      ],
    ),
    actions: <Widget>[
      new TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text('Close'),
      ),
    ],
  );
}


//////////////////////////////////////////////////////////////////////////////////////////////////
