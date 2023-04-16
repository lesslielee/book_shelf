import 'package:flutter/material.dart';
import 'dart:ui';
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
import '../utils/comm_utils.dart';

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
        padding: EdgeInsets.symmetric(vertical: 20),
        child: ListView(
          children: [
            // 头像
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.blue[300],
              child: Image.asset("lib/images/person.png"),
            ),
            // Icon(Icons.account_circle,
            //   size: 150,
            //   color: Colors.black38,
            // ),
            SizedBox(
              height: ScreenUtil().setHeight(10),
            ),

            // Sign In/Up 按钮
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100),
              child: ElevatedButton(
                onPressed: () {}, //暂时还没有完成
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  )),
                ),
                child: const Text(
                  "Sign In / Sign Up",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            SizedBox(height: ScreenUtil().setHeight(40),),
            // 一系列卡片按钮
            MyCard(icon1: Icons.diversity_3, str: "Community", icon2: Icons.arrow_forward_ios),
            MyCard(icon1: Icons.remove_moderator, str: "Remove Ads", icon2: Icons.arrow_forward_ios),
            MyCard(icon1: Icons.star, str: "Review & Rating app", icon2: Icons.arrow_forward_ios),
            MyCard(icon1: Icons.share, str: "Share to Friends", icon2: Icons.arrow_forward_ios),
            MyCard(icon1: Icons.thumb_up, str: "Suggest Story", icon2: Icons.arrow_forward_ios),
            MyCard(icon1: Icons.translate, str: "Languages", icon2: Icons.arrow_forward_ios),
            MyCard(icon1: Icons.bug_report, str: "Bug Report", icon2: Icons.arrow_forward_ios),
            MyCard(icon1: Icons.logout, str: "Exit", icon2: Icons.arrow_forward_ios),

            

          ],
        ),
      ),
    );
  }
}
