import 'package:expensenote/constants/bottomnavigationbar.dart';
import 'package:expensenote/main.dart';
import 'package:expensenote/models/hivetransactionmodel.dart';
import 'package:flutter/material.dart';

class HiveTutotial extends StatefulWidget {
  const HiveTutotial({Key? key}) : super(key: key);

  @override
  State<HiveTutotial> createState() => _HiveTutotialState();
}

class _HiveTutotialState extends State<HiveTutotial> {
  @override
  Widget build(BuildContext context) {
    HiveTransactions transaction0 = box.get(0);
    HiveTransactions transaction1 = box.get(1);
    String data0 = transaction0.amount.toString();
    String data1 = transaction1.amount.toString();
    return Scaffold(
      appBar: AppBar(
        title: Text(data0),
      ),
      body: Column(
        children: [
          Text(data1),
          Text(data0,style: TextStyle(fontSize: 20)),
        ],
      ),
      bottomNavigationBar: BottomBar(3).BottomBarWidget(),
    );
  }
}
