import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:provider/provider.dart';

import 'home_page.dart';
import '../utils/carousel_swiper_widget.dart';
import '../utils/title_widget.dart';
import '../utils/pull_up_list_wraper_widget.dart';
import '../sources/data_sources.dart';
import 'details_page.dart';

class MemberPage extends StatefulWidget {
  MemberPage({super.key});
  State<MemberPage> createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {


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
              "我是会员中心",
              style: TextStyle(
                fontSize: 36,
                color: Colors.redAccent,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
