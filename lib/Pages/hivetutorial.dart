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
    return Scaffold(
      appBar: AppBar(
        title: Text('hive transactions'),
      ),
      // body: Text(box.get(0).amount.toString()),
      body: ListView.builder(itemBuilder: (BuildContext context,int  index) => Center(
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
                                  child: Text(box.get(index).amount.toString(),
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
                                    box.get(index).amount.toString(),
                                    maxLines: 3,
                                    overflow: TextOverflow.fade,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),),
    );
  }
}
