
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import '../sources/data_sources.dart';

///打算用来呈现书的详细介绍的页面，还没有实现
class DetailsView extends StatelessWidget {
  const DetailsView({required this.bk, super.key});
  final Book bk;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("我是Detail页\nbookName: ${bk.title}"),
    );
  }
}