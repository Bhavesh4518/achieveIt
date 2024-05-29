// lib/services/news_service.dart
import 'dart:convert';
import 'package:achieve_it/models/my_api.dart';
import 'package:http/http.dart' as http;

import '../models/article_model.dart';

class NewsService {
  static const String _apiKey = MYAPIKEY;
  static const String _baseUrl = 'https://newsapi.org/v2/everything';

  Future<List<Article>> fetchArticles(String query) async {
    final response = await http.get(Uri.parse('$_baseUrl?q=$query&apiKey=$_apiKey'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> articlesJson = data['articles'];

      return articlesJson.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load articles');
    }
  }
}
