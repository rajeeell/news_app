import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:newzy/models/news_model.dart';

import '../consts/api_const.dart';

import 'package:http/http.dart' as http;

import '../models/bookmarks_model.dart';
import '../screens/news_api.dart';

class BookmarksProvider with ChangeNotifier {
  List<BookmarksModel> bookmarkList = [];

  List<BookmarksModel> get getBookmarkList {
    return bookmarkList;
  }

  Future<List<BookmarksModel>> fetchBookmarks() async {
    bookmarkList = await NewsAPiServices.getBookmarks() ?? [];
    notifyListeners();
    return bookmarkList;
  }

  Future<void> addToBookmark({required NewsModel newsModel}) async {
    try {
      var uri = Uri.https(BASEURL_FIREBASE, "bookmarks.json");
      var response = await http.post(uri,
          body: json.encode(
            newsModel.toJson(),
          ));
      log('Response status: ${response.statusCode}');
      log('Response body: ${response.body}');
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteBookmark({required String key }) async {
    try {
      var uri =
          Uri.https(BASEURL_FIREBASE, "bookmarks/-NZbCCfEzUrFEUGh0_Mq.json");
      var response = await http.delete(
        uri,
      );
      notifyListeners();
      log('Response status: ${response.statusCode}');
      log('Response body: ${response.body}');
    } catch (error) {
      rethrow;
    }
  }
}
