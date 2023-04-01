import 'package:flutter/material.dart';


class SearchPage extends StatefulWidget {
  SearchPage({super.key});
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {


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
              "我是Search Page",
              style: TextStyle(
                fontSize: 36,
                color: Colors.green,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
