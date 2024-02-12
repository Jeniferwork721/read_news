import 'package:flutter/material.dart';

import 'services/api-service.dart';

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final NewsService _newsService = NewsService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _newsService.getBusiness(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final articles = snapshot.data as List<dynamic>;
            return ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                return ListTile(
                  title: Text(article['title']),
                 //subtitle: Text(article['source']),
                );
              },
            );
          }
        },
      
    );
  }
}