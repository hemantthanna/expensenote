import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: Home(),
    
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
         title:  Container(padding: EdgeInsets.all(20),child: Text('Port Scanner'),color: Colors.white,),
          backgroundColor: Colors.transparent,),
        body: Container(
           padding: const EdgeInsets.all(8.0),
           child: Column(
            children:  [
              TextField(
                decoration: InputDecoration(
                  hintText: "range",
                  labelStyle: TextStyle(
                    fontSize: 20,
                    color: Colors.white
                  ),
                  border: OutlineInputBorder()
                ),
                keyboardType: TextInputType.number,
              ),
              const TextField(
                decoration: InputDecoration(
                  hintText: "Ip Adresses",
                  labelStyle : TextStyle
                  (
                    fontSize: 20,
                    color: Colors.white
                  ),
                  border: OutlineInputBorder()
                ),
                keyboardType: TextInputType.number,
              ),
              TextButton(
                     child: const Text('Submit'),
                      onPressed: () {},
),
               TextField(
                  decoration: InputDecoration(
                  hintText: "Scanning Port Scanner",
                  labelStyle: TextStyle(
                    fontSize: 50,
                    color: Colors.white
                  )))

            ]
               ),
                      decoration:const BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                        "https://png.pngtree.com/background/20210715/original/pngtree-technology-background-binary-computer-code-vector-illustration-picture-image_1264149.jpg"),
                    fit: BoxFit.cover)),
                    ),
            );
  }
}

// class MyCustomForm extends StatelessWidget {
//   const MyCustomForm({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           const Padding(
//             padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
//             child: TextField(
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(),
//                 hintText: 'Enter a Ip address',
//               ),
//             ),
//           )
//         ]);
//   }
// }