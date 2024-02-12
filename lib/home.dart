// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, avoid_print, sized_box_for_whitespace

import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'news-details.dart';
import 'services/api-service.dart';
import 'stored-news.dart';

class HomePage extends StatefulWidget {
  @override
  _ImageSliderPageState createState() => _ImageSliderPageState();
}

class _ImageSliderPageState extends State<HomePage> {
  final NewsService _newsService = NewsService();
  List<dynamic> news = [];
  bool isPressed = false;
   List<dynamic> _selectedItems = [];

  @override
  void initState() {
    super.initState();
    fetchAllNews();
  }

  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Text('Home Page'),
    Text('Search Page'),
    Text('Favorites Page'),
    Text('Profile Page'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 2) {
        // Check if "Saved" button is tapped
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SavedArticlesPage()),
        );
      }
    });
  }

  Future<void> fetchAllNews() async {
    try {
      List<Future<List<dynamic>>> futures = [
        _newsService.getAllTopHeadlines(),
        _newsService.getBusiness(),
        _newsService.getEntertainment(),
        _newsService.getHealth(),
        _newsService.getSports(),
        _newsService.getTechnology(),
        _newsService.getGeneral(),
      ];

      List<List<dynamic>> results = await Future.wait(futures);

      List<dynamic> combinedNews = [];
      for (var result in results) {
        if (result.isNotEmpty) {
          combinedNews.addAll(result); // Add all articles from each category
        }
      }

      setState(() {
        news = combinedNews;
      });
    } catch (e) {
      print('Error fetching news: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFF0),
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'img/global-news.png',
                width: 60, // adjust the width as needed
                height: 60, // adjust the height as needed
              ),
            ),
          ],
        ),
        actions: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:const Color(0xFF1D52A9).withOpacity(0.9),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.notifications_outlined,
                color: Color(0xFFFFFFF0),
              ),
              onPressed: () {
                // Handle notification action
              },
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:const Color(0xFF1D52A9).withOpacity(0.9),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.search_sharp,
                color: Color(0xFFFFFFF0),
              ),
              onPressed: () {
                // Handle search action
              },
            ),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
     CarouselSlider(
  options: CarouselOptions(
    height: 200.0,
    aspectRatio: 16 / 9,
    viewportFraction: 1.1,
    initialPage: 0,
    enableInfiniteScroll: true,
    reverse: false,
    autoPlay: true,
    autoPlayInterval: Duration(seconds: 4),
    autoPlayAnimationDuration: Duration(milliseconds: 800),
    autoPlayCurve: Curves.fastOutSlowIn,
    enlargeCenterPage: true,
    onPageChanged: (index, reason) {
      // Handle page change
    },
    scrollDirection: Axis.horizontal,
  ),
  items: news.map((article) {
    return Builder(
      builder: (BuildContext context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            image: DecorationImage(
              image: NetworkImage(article['urlToImage'] ?? ''),
              fit: BoxFit.fill,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  color: Colors.black.withOpacity(0.5),
                  child: Text(
                    article['title'] ?? 'No Title',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              // Text(
              //       article['source']['category'] ?? 'No Title',
              //       textAlign: TextAlign.center,
              //       style: TextStyle(
              //         fontSize: 16.0,
              //         fontWeight: FontWeight.bold,
              //         color: Colors.white,
              //       ),
              //     ),
            ],
          ),

        );
      },
    );
  }).toList(),
),
            DefaultTabController(
              length: 6, // Number of tabs
              child: Column(
                children: [
                  TabBar(
                    isScrollable:
                        true, // Allows scrolling if there are many tabs
                    tabs:const [
                      Tab(
                          child: Padding(
                        padding:
                            EdgeInsets.all(8.0), // Adjust padding as needed
                        child: Text('Hot News'),
                      )),
                      Tab(
                          child: Padding(
                        padding:
                            EdgeInsets.all(8.0), // Adjust padding as needed
                        child: Text('Business'),
                      )),
                      Tab(
                          child: Padding(
                        padding:
                            EdgeInsets.all(8.0), // Adjust padding as needed
                        child: Text('Health'),
                      )),
                      Tab(
                          child: Padding(
                        padding:
                            EdgeInsets.all(8.0), // Adjust padding as needed
                        child: Text('Sports'),
                      )),
                      Tab(
                          child: Padding(
                        padding:
                            EdgeInsets.all(8.0), // Adjust padding as needed
                        child: Text('Entertainment'),
                      )),
                      Tab(
                          child: Padding(
                        padding:
                            EdgeInsets.all(8.0), // Adjust padding as needed
                        child: Text('Technology'),
                      )),
                    ],
                    indicator: BoxDecoration(
                      color: Colors.purple[
                          200], // Background color of the circular shape
                      shape: BoxShape.rectangle, // Circular shape
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    labelPadding:const EdgeInsets.symmetric(
                        horizontal: 10.0), // Padding around the text
                    labelStyle:const TextStyle(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold), // Text color
                    unselectedLabelColor: Colors.black,
                  ),
                  Container(
                    height: MediaQuery.of(context)
                        .size
                        .height, // Adjust height according to your UI
                    // Content for each tab `
                    child: TabBarView(
                      children: [
                        // Content for Tab 1
                        FutureBuilder<List<dynamic>>(
                          future: _newsService.getGeneral(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else {
                              List<dynamic> articles = snapshot.data ?? [];
                              return ListView.builder(
                                itemCount: articles.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    leading: articles[index]['urlToImage'] !=
                                            null
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                15), // Adjust radius as needed
                                            child: Image.network(
                                              articles[index]
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
                                    title: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DetailsPage(
                                              author: articles[index]
                                                      ['author'] ??
                                                  '',
                                              title: articles[index]['title'] ??
                                                  '',
                                              publishedAt: articles[index]
                                                      ['publishedAt'] ??
                                                  '',
                                              description: articles[index]
                                                      ['description'] ??
                                                  '',
                                              urlToImage: articles[index]
                                                      ['urlToImage'] ??
                                                  '',
                                              content: articles[index]
                                                      ['content'] ??
                                                  '',
                                            ),
                                          ),
                                        );
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            articles[index]['author'] ?? '',
                                            style:const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                       const   SizedBox(height: 4),
                                          Text(
                                            articles[index]['title'] ?? '',
                                            style:const TextStyle(fontSize: 13),
                                          ),
                                        const  SizedBox(height: 4),
                                          Text(
                                            'Published at: ${DateFormat('d MMM yyyy').format(DateTime.parse(articles[index]['publishedAt'] ?? ''))}',
                                            style:
                                              const  TextStyle(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                   trailing: IconButton(
                        icon: Icon(
                          _selectedItems.contains(articles[index])
                              ? Icons.bookmark
                              : Icons.bookmark_border_outlined,
                          color: _selectedItems.contains(articles[index])
                              ? Colors.green // Change color when selected
                              : null, // Use default color when not selected
                        ),
                        onPressed: () {
                          onSavePressed(articles[index]);
                        },
                      ),
                                  );
                                },
                              );
                            }
                          },
                        ),
                        // Content for Tab 2
                        FutureBuilder<List<dynamic>>(
                          future: _newsService.getBusiness(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else {
                              List<dynamic> articles = snapshot.data ?? [];
                              return ListView.builder(
                                itemCount: articles.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    leading: articles[index]['urlToImage'] !=
                                            null
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                15), // Adjust radius as needed
                                            child: Image.network(
                                              articles[index]
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
                                    title: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DetailsPage(
                                              author: articles[index]
                                                      ['author'] ??
                                                  '',
                                              title: articles[index]['title'] ??
                                                  '',
                                              publishedAt: articles[index]
                                                      ['publishedAt'] ??
                                                  '',
                                              description: articles[index]
                                                      ['description'] ??
                                                  '',
                                              urlToImage: articles[index]
                                                      ['urlToImage'] ??
                                                  '',
                                              content: articles[index]
                                                      ['content'] ??
                                                  '',
                                            ),
                                          ),
                                        );
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            articles[index]['author'] ?? '',
                                            style:const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                       const   SizedBox(height: 4),
                                          Text(
                                            articles[index]['title'] ?? '',
                                            style:const TextStyle(fontSize: 13),
                                          ),
                                        const  SizedBox(height: 4),
                                          Text(
                                            'Published at: ${DateFormat('d MMM yyyy').format(DateTime.parse(articles[index]['publishedAt'] ?? ''))}',
                                            style:
                                              const  TextStyle(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                    trailing: IconButton(
                                      icon:
                                        const  Icon(Icons.bookmark_border_outlined),
                                      onPressed: () {
                                        onSavePressed(articles[index]);
                                      },
                                    ),
                                  );
                                },
                              );
                            }
                          },
                        ),
                        // // Content for Tab 3
                         FutureBuilder<List<dynamic>>(
                          future: _newsService.getHealth(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else {
                              List<dynamic> articles = snapshot.data ?? [];
                              return ListView.builder(
                                itemCount: articles.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    leading: articles[index]['urlToImage'] !=
                                            null
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                15), // Adjust radius as needed
                                            child: Image.network(
                                              articles[index]
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
                                    title: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DetailsPage(
                                              author: articles[index]
                                                      ['author'] ??
                                                  '',
                                              title: articles[index]['title'] ??
                                                  '',
                                              publishedAt: articles[index]
                                                      ['publishedAt'] ??
                                                  '',
                                              description: articles[index]
                                                      ['description'] ??
                                                  '',
                                              urlToImage: articles[index]
                                                      ['urlToImage'] ??
                                                  '',
                                              content: articles[index]
                                                      ['content'] ??
                                                  '',
                                            ),
                                          ),
                                        );
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            articles[index]['author'] ?? '',
                                            style:const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                       const   SizedBox(height: 4),
                                          Text(
                                            articles[index]['title'] ?? '',
                                            style:const TextStyle(fontSize: 13),
                                          ),
                                        const  SizedBox(height: 4),
                                          Text(
                                            'Published at: ${DateFormat('d MMM yyyy').format(DateTime.parse(articles[index]['publishedAt'] ?? ''))}',
                                            style:
                                              const  TextStyle(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                    trailing: IconButton(
                                      icon:
                                        const  Icon(Icons.bookmark_border_outlined),
                                      onPressed: () {
                                        onSavePressed(articles[index]);
                                      },
                                    ),
                                  );
                                },
                              );
                            }
                          },
                        ),
                        // // Content for Tab 4
                        FutureBuilder<List<dynamic>>(
                          future: _newsService.getSports(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else {
                              List<dynamic> articles = snapshot.data ?? [];
                              return ListView.builder(
                                itemCount: articles.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    leading: articles[index]['urlToImage'] !=
                                            null
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                15), // Adjust radius as needed
                                            child: Image.network(
                                              articles[index]
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
                                    title: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DetailsPage(
                                              author: articles[index]
                                                      ['author'] ??
                                                  '',
                                              title: articles[index]['title'] ??
                                                  '',
                                              publishedAt: articles[index]
                                                      ['publishedAt'] ??
                                                  '',
                                              description: articles[index]
                                                      ['description'] ??
                                                  '',
                                              urlToImage: articles[index]
                                                      ['urlToImage'] ??
                                                  '',
                                              content: articles[index]
                                                      ['content'] ??
                                                  '',
                                            ),
                                          ),
                                        );
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            articles[index]['author'] ?? '',
                                            style:const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                       const   SizedBox(height: 4),
                                          Text(
                                            articles[index]['title'] ?? '',
                                            style:const TextStyle(fontSize: 13),
                                          ),
                                        const  SizedBox(height: 4),
                                          Text(
                                            'Published at: ${DateFormat('d MMM yyyy').format(DateTime.parse(articles[index]['publishedAt'] ?? ''))}',
                                            style:
                                              const  TextStyle(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                    trailing: IconButton(
                                      icon:
                                        const  Icon(Icons.bookmark_border_outlined),
                                      onPressed: () {
                                        onSavePressed(articles[index]);
                                      },
                                    ),
                                  );
                                },
                              );
                            }
                          },
                        ),
                        // // Content for Tab 5
                         FutureBuilder<List<dynamic>>(
                          future: _newsService.getEntertainment(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else {
                              List<dynamic> articles = snapshot.data ?? [];
                              return ListView.builder(
                                itemCount: articles.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    leading: articles[index]['urlToImage'] !=
                                            null
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                15), // Adjust radius as needed
                                            child: Image.network(
                                              articles[index]
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
                                    title: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DetailsPage(
                                              author: articles[index]
                                                      ['author'] ??
                                                  '',
                                              title: articles[index]['title'] ??
                                                  '',
                                              publishedAt: articles[index]
                                                      ['publishedAt'] ??
                                                  '',
                                              description: articles[index]
                                                      ['description'] ??
                                                  '',
                                              urlToImage: articles[index]
                                                      ['urlToImage'] ??
                                                  '',
                                              content: articles[index]
                                                      ['content'] ??
                                                  '',
                                            ),
                                          ),
                                        );
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            articles[index]['author'] ?? '',
                                            style:const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                       const   SizedBox(height: 4),
                                          Text(
                                            articles[index]['title'] ?? '',
                                            style:const TextStyle(fontSize: 13),
                                          ),
                                        const  SizedBox(height: 4),
                                          Text(
                                            'Published at: ${DateFormat('d MMM yyyy').format(DateTime.parse(articles[index]['publishedAt'] ?? ''))}',
                                            style:
                                              const  TextStyle(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                    trailing: IconButton(
                                      icon:
                                        const  Icon(Icons.bookmark_border_outlined),
                                      onPressed: () {
                                        onSavePressed(articles[index]);
                                      },
                                    ),
                                  );
                                },
                              );
                            }
                          },
                        ),
                        // // Content for Tab 6
                        FutureBuilder<List<dynamic>>(
                          future: _newsService.getTechnology(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else {
                              List<dynamic> articles = snapshot.data ?? [];
                              return ListView.builder(
                                itemCount: articles.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    leading: articles[index]['urlToImage'] !=
                                            null
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                15), // Adjust radius as needed
                                            child: Image.network(
                                              articles[index]
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
                                    title: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DetailsPage(
                                              author: articles[index]
                                                      ['author'] ??
                                                  '',
                                              title: articles[index]['title'] ??
                                                  '',
                                              publishedAt: articles[index]
                                                      ['publishedAt'] ??
                                                  '',
                                              description: articles[index]
                                                      ['description'] ??
                                                  '',
                                              urlToImage: articles[index]
                                                      ['urlToImage'] ??
                                                  '',
                                              content: articles[index]
                                                      ['content'] ??
                                                  '',
                                            ),
                                          ),
                                        );
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            articles[index]['author'] ?? '',
                                            style:const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                       const   SizedBox(height: 4),
                                          Text(
                                            articles[index]['title'] ?? '',
                                            style:const TextStyle(fontSize: 13),
                                          ),
                                        const  SizedBox(height: 4),
                                          Text(
                                            'Published at: ${DateFormat('d MMM yyyy').format(DateTime.parse(articles[index]['publishedAt'] ?? ''))}',
                                            style:
                                              const  TextStyle(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                    trailing: IconButton(
                                      icon:
                                        const  Icon(Icons.bookmark_border_outlined),
                                      onPressed: () {
                                        onSavePressed(articles[index]);
                                      },
                                    ),
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Set the type to fixed
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            label: 'Discover',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_add),
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.white, // Color for selected item
        onTap: _onItemTapped,
        backgroundColor:
            Color(0xFF1D52A9), // Background color for unselected items
      ),
    );
  }

  onSavePressed(dynamic article) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedArticles = prefs.getStringList('savedArticles') ?? [];
    savedArticles.add(jsonEncode(article)); // Convert article to JSON string
    prefs.setStringList('savedArticles', savedArticles);
      setState(() {
      // Toggle the selection
      if (_selectedItems.contains(article)) {
        _selectedItems.remove(article);
      } else {
        _selectedItems.add(article);
      }
    });
     final snackBar = SnackBar(
    content: Text(
      _selectedItems.contains(article) ? 'Article Saved' : 'Token Removed',
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
