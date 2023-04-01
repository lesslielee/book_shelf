import 'package:flutter/material.dart';


class HotBookPage extends StatefulWidget {
  HotBookPage({super.key});
  State<HotBookPage> createState() => _HotBookPageState();
}

class _HotBookPageState extends State<HotBookPage> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // decoration: const BoxDecoration(
        //   image: DecorationImage(
        //       image: AssetImage("lib/images/book.jpg"), fit: BoxFit.cover),
        // ),
        child: SizedBox(
          child: Center(
            child: Text(
              "我是Hot Books Page",
              style: TextStyle(
                fontSize: 36,
                color: Colors.purple,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
