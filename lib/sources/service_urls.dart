String dataSrcUrlBase = "https://jsonplaceholder.typicode.com/";
String bookBase = "posts";
String commentBase = "comments";
String photosBase = "photos";
String authorsBase = "users";
String readersBase = "users";

String bookUrlBase = '${dataSrcUrlBase}${bookBase}';

Map requestHeader = {
  'method': 'GET',
  'path': '/posts/',
  'authority': 'jsonplaceholder.typicode.com',
  'scheme': 'https',
  'accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8',
  'accept-encoding': 'gzip, deflate, br',
  'accept-language': 'zh-CN,zh;q=0.8',
  'cache-control': 'max-age=0',
  'if-none-match': 'W/"6b80-Ybsq/K6GwwqrYkAsFxqDXGC7DoM"',
  'sec-ch-ua': '"Brave";v="111", "Not(A:Brand";v="8", "Chromium";v="111"',
  'sec-ch-ua-mobile': '?0',
  'sec-ch-ua-platform': '"Windows"',
  'sec-fetch-dest': 'document',
  'sec-fetch-mode': 'navigate',
  'sec-fetch-site': 'none',
  'sec-fetch-user': '?1',
  'sec-gpc': '1',
  'upgrade-insecure-requests': '1',
  'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36',
};