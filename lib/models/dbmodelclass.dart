import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Transactionmodel {
  final int amount;
  final String title;
  final String description;
  final DateTime date;

  Transactionmodel({required this.amount,required this.title,required this.description, required this.date});

  // factory Transactionmodel.fromJson(Map<String, dynamic> json) =>
  //     TransactionsFromJson(json);

  // Map<String, dynamic> toJson() => TransactionsToJson(this);
}

// Helper function to convert json data to transactionmodel object
Transactionmodel TransactionsFromJson(Map<String, dynamic> json) {
  return Transactionmodel(
    amount: json['amount'] as int,
    title: json['title'] as String,
    date: json['date'] as DateTime,
    description: json['description'] as String,
  );
}
// Helper function to convert transactionmodel object to json format

Map<String, dynamic> TransactionsToJson(Transactionmodel instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'description': instance.description,
      'date': instance.date,
    };

Future<int> getremainingamount() async {
  int remainingamount = 0;

  final data = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('transactions')
      .get();

  data.then((value) => value.docs.forEach((element) {
        remainingamount += int.parse((element['amount']).toString());
      }));

  return remainingamount;
}
