import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../sources/data_sources.dart';

///打算用来呈现书的详细介绍的页面，还没有实现
// class DetailsView extends StatelessWidget {
//   const DetailsView({required this.bk, super.key});
//   final Book bk;

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text("我是Detail页\nbookName: ${bk.title}"),
//     );
//   }
// }

class BookDetails extends StatelessWidget {
  final Book book;

  BookDetails({required this.book});

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title,
          style: TextStyle(fontSize: 20),),
      ),
      body: Container(
        decoration:  BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/images/book.jpg"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.4),
            BlendMode.dstATop,   ),         
          ),
        ),        
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: EdgeInsets.only(top: 20, left: 100, right: 100, bottom: 20),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    //spreadRadius: 1.0,
                    blurRadius: 5.0,
                    offset: Offset(3.0, 4.0),
                    color: Colors.black26.withOpacity(0.5),
                  ),
                ],
              ),
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 0, top: 0, right: 5, bottom: 5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset(
                    book.cover,
                    width: ScreenUtil().setWidth(130),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(50),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style: TextStyle(
                      fontSize: 50.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(15),
                  ),
                  Text(
                    book.author,
                    style: TextStyle(
                      fontSize: 35.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(15),
                  ),
                  Text(
                    book.details,
                    style: TextStyle(
                      fontSize: 28.sp,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
