import 'dart:convert';
import 'dart:developer';

import 'package:news_app/consts/api_const.dart';
import 'package:news_app/models/news_model.dart';
import 'package:http/http.dart' as http;

class NewsApiServices {
  static Future<List<NewsModel>> getAllNews() async {
    // var url = Uri.parse(
    //     'https://newsapi.org/v2/everything?q=bitcoin&pageSize=5&apiKey=');

    var uri = Uri.https(BASEURL, "v2/everything", {
      "q": "bitcoin",
      "pageSize": "5",
      "apiKEY": API_KEY,
      "domains": "bbc.co.uk,techcrunch.com,engadget.com"
    });
    var response = await http.get(uri, headers: {"X-Api-key": API_KEY});
//print('Response status: ${response.statusCode}');
    //log('Response body: ${response.body}');

    Map data = jsonDecode(response.body);
    List newsTempList = [];
    for (var v in data["articles"]) {
      newsTempList.add(v);
      // log(v.toString());
      // print(data["articles"].length.toString());
    }
    return NewsModel.newsFromSnapshot(newsTempList);
  }
}
