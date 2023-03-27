import "dart:convert";
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:http/retry.dart';
import 'dart:math';
import 'dart:io';
import 'dart:async';

import "service_urls.dart";

/// 20230327 - 基本解决了异步调用数据加载过慢导致UI加载失败的问题，其原因目前看来是由于多层异步调用

List<String> popBooks = [
  'Pop001.jpg',
  'Pop002.jpg',
  'Pop003.jpg',
  'Pop004.jpg',
  'Pop005.jpg',
  'Pop006.jpg',
  'Pop007.jpg',
  'Pop008.jpg',
  'Pop009.jpg',
  'Pop010.jpg',
  'Pop011.jpg',
  'Pop012.jpg'
];
List<String> techBooks = [
  'C001.JPG',
  'Ceph001.jpg',
  'Compile001.jpg',
  'Compile002.jpg',
  'Compile003.jpg',
  'Computer001.jpg',
  'Computer002.jpg',
  'CSS001.JPG',
  'DataStructure001.jpg',
  'DataStructure002.jpg',
  'DB001.JPG',
  'DB002.JPG',
  'DB003.JPG',
  'DB004.JPG',
  'Game001.jpg',
  'Go001.jpg',
  'Go002.jpg',
  'Go003.jpg',
  'Go004.jpg',
  'Go005.jpg',
  'HTML001.JPG',
  'Java001.jpg',
  'Java002.jpg',
  'Java003.jpg',
  'Java004.jpg',
  'Java005.jpg',
  'Java006.jpg',
  'Java007.jpg',
  'JS001.JPG',
  'js002.jpg',
  'js003.jpg',
  'js004.jpg',
  'Linux001.jpg',
  'Linux002.jpg',
  'Linux003.jpg',
  'Linux004.jpg',
  'Linux005.jpg',
  'Linux006.jpg',
  'Linux007.jpg',
  'MicroService001.jpg',
  'MicroService002.jpg',
  'Network001.jpg',
  'Network002.jpg',
  'Programming001.jpg',
  'Programming002.jpg',
  'Python001.jpg',
  'Python002.jpg',
  'Python003.jpg',
  'Python004.jpg',
  'Python005.jpg',
  'Python006.jpg',
  'Python007.jpg',
  'Python008.jpg',
  'Python009.jpg',
  'Python010.jpg',
  'Python011.jpg',
  'Python012.jpg',
  'Python013.jpg',
  'Python014.jpg',
  'Redis001.jpg',
  'Redis002.jpg',
  'System001.jpg',
  'Virtualization001.jpg',
  'Virtualization002.jpg',
  'Virtualization003.jpg',
  'Virtualization004.jpg',
  'Virtualization005.jpg',
  'Web001.jpg',
  'Web002.jpg',
  'Web003.jpg',
  'Web004.jpg',
  'Web005.jpg',
  'Web006.jpg',
  'Web007.jpg'
];
List<String> allBooks = popBooks + techBooks;
const imagePath = 'lib/images/';
const popBookImagePath = '${imagePath}pop_books/';
const techBookImagePath = '${imagePath}tech_books/';

///Book Data structure definition
///图书类，用于构建图书的基本数据结构
class Book {
  String title = "";
  String author = "";
  String cover = "";
  String category = "";
  String details = "";

  Book(
      {this.title="",
      this.author="",
      this.cover="",
      this.category="",
      this.details=""});

/// Choose a book cover picture randomly from local book images path
/// 因为采用的数据源网站数据不太丰富，我在这里利用现有!!本地图片集!!，所以在取图片时要注意需要用Image.asset()，
/// 将来再考虑改为可自动切换Image.asset()和Image.network()
/// ，根据初始化时选定的图书类别，随机为图书选取封面
  String randomBookCover({String category = "all"}) {
    // Book _bk = Book();
    var rand = Random();
    String bookCover;
    try {
      switch (category) {
        case "tech":
          bookCover =
              techBookImagePath + techBooks[rand.nextInt(techBooks.length)];
          break;
        case "pop":
          bookCover =
              popBookImagePath + popBooks[rand.nextInt(popBooks.length)];
          break;
        case "all":
          int index = rand.nextInt(allBooks.length);
          bookCover = ((index < popBooks.length)
                  ? popBookImagePath
                  : techBookImagePath) +
              allBooks[index];
          break;
        default:
          bookCover = '${imagePath}book.jpg';
      }
    } catch (e) {
      bookCover = '${imagePath}book.jpg';
      throw ("Error: BookCover selecting failed...$e");
    }
    //_bk.cover = bookCover;
    //return _bk;
    return bookCover;
  }
}

/// Fetch JsonData from a URL
/// 这个方法是个公用方法，只管根据给定url取回json数据，并不关心数据内容
//Future<List<Map<dynamic, dynamic>>> fetchJsonData(String url) async {
Future fetchJsonData(String url) async {
  try {
    final response = await http.get(Uri.parse(url)); //.timeout(Duration(seconds:30));
    // String tmpStr = "";
      if (response.statusCode == 200) {
        final jsonData = (json.decode(response.body) as List).cast<Map<dynamic, dynamic>>();
        return jsonData;
      }
  } catch (e) {
    print("====>>>>数据获取异常<<<<====......");
    throw Exception('====>>>>数据获取异常<<<<====: Failed to fetch JSON data from $url: $e');
  }
}

/// Assemble a BookList，造一个图书列表，作为可用于展示的图书的数据源
/// 这个方法是返回后台数据可用的所有图书的列表
Future<List<Book>> createBookListData() async {
  //从图书网站接口读取图书的json格式数据列表
  List<Book> bks = <Book>[];
  List<Map<dynamic, dynamic>> jsonData = [];
  final url = bookUrlBase;
  try {
    //await异步调用，等待http.get获取到指定链接的内容
    final response = await http.get(Uri.parse(url)); //.timeout(Duration(seconds:30));
      if (response.statusCode == 200) {
        jsonData = (json.decode(response.body) as List).cast<Map<dynamic, dynamic>>();
      }
  } catch (e) {
    print("====>>>>数据获取异常<<<<====......");
    throw Exception('====>>>>数据获取异常<<<<====: Failed to fetch JSON data from $url: $e');
  }
  //这里原本还有一个自己编写的异步调用作为对前面http.get部分的封装，但是在两层异步调用后，数据加载不正常，返回也会有延迟。
  //所以把它们合并到一个函数里来实现，虽然耦合度增大了，但是至少数据获取正常了。
  //希望有时间再去研究一下多层异步调用的处理。 20230327
  // final jsonData = await fetchJsonData(bookUrlBase) as List<Map<dynamic, dynamic>>;
  // fetchJsonData(bookUrlBase).then((jsonData){
    
    for (var p in jsonData) {
      Book bk = Book();
      //print("=============jsonData数据源====================\n$p\n+++++++++++++++++++++++");
      bk.title = p['title'];
      bk.author = p['userId'].toString();
      bk.category = p['userId'].toString();
      bk.details = p['body'];
      // 目前用随机的方式从现有图库中取出图书封面图片的全路径名
      bk.cover = bk.randomBookCover();
      bks.add(bk);
    }
    print("<<<<<图书数据初始化结束>>>>>");
    print("///获取了${bks.length}本图书///");
  return bks;
}

///推荐书目列表，这里仅是在category列表长度范围内随机取出指定num个数字，作为推荐书目的下标
///返回值为一个Book数组，每个元素为指定书目类别category的Book
List<Book> recommendBooks({required List<Book> books, int num = 1, String category="all"}) {
  var rand = Random();
  List<Book> recList = [];
  int randSeed = books.length;
  for(int i=0; i<num; i++){
    recList.add(books[rand.nextInt(randSeed)]);
  }
  
  return recList;

  ///20230325由于暂时只从全部图书中随机取出一些图书作为推荐书，并没有根据指定类别来取，所以暂时注释掉此处代码
  ///也是由于后台数据分类有限的原因
  // switch(category) {
  //   case "pop":
  //     randSeed = popBooks.length;
  //     break;
  //   case "tech":
  //     randSeed = techBooks.length;
  //     break;
  //   case "all":
  //     randSeed = allBooks.length;
  //     break;
  //   default:
  //     randSeed = 1;
  // }
}