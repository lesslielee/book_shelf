import 'dart:io';
import 'dart:math';
import 'package:book_shelf/sources/data_sources.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../pages/details_page.dart';

/// 20230327 - 基本解决

class CarouselCard extends StatelessWidget {
  final Book book;
  const CarouselCard({required this.book, super.key});

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      width: ScreenUtil().setWidth(500),
      height: ScreenUtil().setHeight(200),
      borderRadius: 10,
      blur: 10,
      alignment: Alignment.bottomCenter,
      border: 2,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFffffff).withOpacity(0.1),
          Color(0xFFFFFFFF).withOpacity(0.05),
        ],
        stops: [
          0.1,
          1,
        ],
      ),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFffffff).withOpacity(0.5),
          Color((0xFFFFFFFF)).withOpacity(0.5),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.asset( //书封面图片
              book.cover,
              width: ScreenUtil().setWidth(100),
              height: ScreenUtil().setHeight(200),
              fit: BoxFit.fitWidth,
            ),
          ),
          SizedBox(
            width: ScreenUtil().setWidth(170),
            height: ScreenUtil().setHeight(200),
            child: Padding(
              padding: const EdgeInsets.only(left: 5.0, top: 18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(  //书名
                    book.title,  
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                  Text( //作者
                    book.author,
                    style: const TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                      Text(
                        (Random().nextInt(9999)+400).toString(),
                        style: TextStyle(fontSize: 15,),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CarouselSwiper extends StatefulWidget {
  const CarouselSwiper({super.key});

  @override
  State<CarouselSwiper> createState() => _CarouselSwiperState();
}

class _CarouselSwiperState extends State<CarouselSwiper> {
  List<Book> recBooks = [
    Book(
      title: "The Road Ahead",
      author: "Bill Gates",
      cover: "lib/images/pop_books/Pop011.jpg",
      category: "tech",
      details: "This is a book from 1995...",
    ),
  ];
  @override
  void initState() {
    //List<Book> bks =
    createBookListData().then((bks) {
      try {
        print("=====图书数量====: ${bks.length}");
        setState(
          () {
            // 调用reccomendBooks方法，从图书列表中取出5本书作为推荐图书 
            recBooks = recommendBooks(books: bks, num: 5);
            for (var b in recBooks) {
              print('书名：${b.title}, 封面图片：${b.cover}');
            }
          },
        );
      } catch (e) {
        print("====>生成推荐图书失败！<=====");
        throw ("推荐图书失败: Error $e");
      }
    });
    print(recBooks.length);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: recBooks.length,
      itemBuilder: (context, index) {
        Book bk = recBooks[index];
        return GestureDetector(
          onTap:() {
            Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (context) => DetailsView(bk: bk),
              ),
            );
          },
          child: CarouselCard(book: recBooks[index]), 
        );
      },
    );
  }
}
