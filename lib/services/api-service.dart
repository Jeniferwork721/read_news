import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/article-model.dart';

class NewsService {
  
 final String apikey ='69d0773e96e345a08079b34fd33c2659';
  

  Future<List<dynamic>> getAllTopHeadlines() async {
    return await fetchNews('general');
  }

  Future<List<dynamic>> getBusiness() async {
    return await fetchNews('business');
  }

  Future<List<dynamic>> getEntertainment() async {
    return await fetchNews('entertainment');
  }

  Future<List<dynamic>> getHealth() async {
    return await fetchNews('health');
  }

  Future<List<dynamic>> getSports() async {
    return await fetchNews('sports');
  }

  Future<List<dynamic>> getTechnology() async {
    return await fetchNews('technology');
  }

  Future<List<dynamic>> getGeneral() async {
    return await fetchNews('general');
  }

  Future<List<dynamic>> fetchNews(String category) async {
    final Uri url = Uri.parse(
        'http://newsapi.org/v2/top-headlines?category=$category&language=en&apiKey=$apikey');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> articles = json.decode(response.body)['articles'];
      // Add category field to each article
      articles.forEach((article) {
        // article['category'] = category;
           articles = articles.take(10).toList();
      });
      return articles;
    } else {
      throw Exception('Failed to load Topheadlines');
    }
  }


 

}
