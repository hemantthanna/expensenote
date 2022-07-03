import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class Analysis extends StatefulWidget {
  const Analysis({Key? key}) : super(key: key);

  @override
  State<Analysis> createState() => _AnalysisState();
}

class _AnalysisState extends State<Analysis> {
  _AnalysisState() {
    getcategoryitems();
    getChartData();
  }

  // Map<String, double> dataMap = {
  //   "Flutter": 5,
  //   "React": 3,
  //   "Xamarin": 2,
  //   "Ionic": 2,
  // };
  Map categorymap = {};

  int temp = 0;
  getcategoryitems() async {
    final data = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('transactions')
        .get();

    final allData = data.docs.map((doc) => doc.data()['category']).toList();

    var numbermap = Map();

    allData.forEach((item) {
      if (!numbermap.containsKey(item)) {
        numbermap[item] = 1.0;
      } else {
        numbermap[item] += 1.0;
      }
    });

    setState(() {
      categorymap = numbermap;
    });
  }

  getChartData() async {
    final data = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('transactions')
        .get();

    final testdata = Map();
    data.docs.map((e) {
      testdata[e.data()['category']] = e.data()['amount'];
    });

    print(testdata.toString());
  }


  String charttype = 'number of entries per category';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
            padding: EdgeInsets.only(top: 80),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                'Expense',
                style: TextStyle(fontSize: 37, color: Colors.black),
              ),
              Text(
                'Analysis',
                style: TextStyle(fontSize: 37, color: Colors.blue),
              ),
            ]),
          ),
            Container(
              padding: EdgeInsets.all(30),
              // height: 400,
              // color: Colors.amber,
              child: Column(
                children: [
                  if (categorymap.isNotEmpty)
                    PieChart(
                      dataMap: Map<String, double>.from(categorymap),
                      // gradientList: gradientList,
                      emptyColorGradient: [
                        Color(0xff6c5ce7),
                        Colors.blue,
                      ],
                      // chartType: ChartType.ring,
                      // chartRadius: 150.0,
                      chartValuesOptions:
                          ChartValuesOptions(showChartValuesOutside: true),
                    )
                  else
                    CircularProgressIndicator()
                ],
              ),
            ),
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey),
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  child: Text(
                    charttype,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            _chooseChartType(context),
                      ).then((value) {
                        setState(() {
                          charttype = value;
                        });
                      });
                    },
                    child: Text('change'))
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget _chooseChartType(BuildContext context) {
  return new AlertDialog(
    title: Center(child: const Text('Choose Chart Type')),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop('number of entries per category');
            },
            child: Text('number of entries per category')),
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop('total expenditure on a category');
            },
            child: Text('total expenditure on a category'))
      ],
    ),
  );
}
