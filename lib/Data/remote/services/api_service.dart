import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:news_api/App/Constants/api_constants.dart';
import 'package:news_api/Domain/article.dart';

class NewsApiService {
  NewsApiService();

  Future fetchNewsArticles(String query) async {
    var date = DateFormat('yyyy-mm-dd').format(DateTime.now());
    final response = await http.get(
      Uri.parse(
          '$baseUrl/everything?q=$query&from=$date&to=$date&sortBy=popularity&apiKey=$apiKey'),
    );
    final json = jsonDecode(response.body);
    if (json['status'] == 'ok') {
      final articlesJson = json['articles'] as List<dynamic>;
      var articles = articlesJson.map((e) => Articles.fromJson(e)).toList();
      return articles;
    }
  }

  fetchCountryNews(String country, String catogory) async {
    var date = DateFormat('yyyy-mm-dd').format(DateTime.now());
    final response = await http.get(Uri.parse(
        '$baseUrl/top-headlines?country=$country&category=$catogory&apiKey=$apiKey'));

    final json = jsonDecode(response.body);
    if (json['status'] == 'ok') {
      final articlesJson = json['articles'] as List<dynamic>;
      var articles = articlesJson.map((e) => Articles.fromJson(e)).toList();
      return articles;
    }
  }
}
