import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';

import 'news-details.dart';

class SavedArticlesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         backgroundColor: const Color(0xFFFFFFF0),
          foregroundColor: Color(0xFF1D52A9),
        title: Text('Saved Articles',style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: FutureBuilder<List<String>>(
        future: getSavedArticles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<String> savedArticles = snapshot.data ?? [];
            return ListView.builder(
              itemCount: savedArticles.length,
              itemBuilder: (context, index) {
                // Parse the saved article string and display it as needed
                final articleMap = safeJsonDecode(savedArticles[index]);
                final title = articleMap['title'];
                 final publishedAt = articleMap['publishedAt'] != null
                    ? DateFormat('d MMM yyyy').format(DateTime.parse(articleMap['publishedAt']!))
                    : 'Unknown Date';
                return  ListTile(
                                    leading: articleMap['urlToImage'] !=
                                            null
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                15), // Adjust radius as needed
                                            child: Image.network(
                                              articleMap
                                                  ['urlToImage'], // Image URL
                                              width:
                                                  80, // Adjust width as needed
                                              height:
                                                  80, // Adjust height as needed
                                              fit: BoxFit
                                                  .contain, // Adjust image fit as needed
                                            ),
                                          )
                                        : ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                10), // Adjust radius as needed
                                            child: Image.asset(
                                              'img/user.png', // Placeholder asset image
                                              width:
                                                  70, // Adjust width as needed
                                              height:
                                                  80, // Adjust height as needed
                                              fit: BoxFit
                                                  .fill, // Adjust image fit as needed
                                            ),
                                          ),

                                    title:GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsPage(
          author:articleMap['author'] ?? '',
          title: articleMap['title'] ?? '',
          publishedAt: articleMap['publishedAt'] ?? '',
           description: articleMap['description'] ?? '',
            urlToImage: articleMap['urlToImage'] ?? '',
             content: articleMap['content'] ?? '',
        ),
      ),
    );
  },
  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          articleMap['author'] ?? '',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                            height:
                                                4), // Adjust spacing as needed
                                        Text(
                                          articleMap['title'] ??
                                              'No Title',
                                          style: TextStyle(fontSize: 13),
                                        ),
                                        SizedBox(
                                            height:
                                                4), // Adjust spacing as needed
                                        Text(publishedAt, style: TextStyle(color: Colors.grey)),
                                      ],
                                    ),


                 ) );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<String>> getSavedArticles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedArticles = prefs.getStringList('savedArticles') ?? [];
    return savedArticles;
  }

  Map<String, dynamic> safeJsonDecode(String jsonString) {
    try {
      return jsonDecode(jsonString);
    } catch (e) {
      print('Error decoding JSON: $e');
      return {}; // Return an empty map if decoding fails
    }
  }
}

