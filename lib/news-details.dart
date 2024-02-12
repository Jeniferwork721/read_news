import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailsPage extends StatefulWidget {
  final String author;
    final String title;
      final String publishedAt;
        final String description;
          final String urlToImage;
            final String content;
  const DetailsPage({super.key, required this.author, required this.title, required this.publishedAt, required this.description, required this.urlToImage, required this.content});

  @override
 _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color(0xFFFFFFF0),
          foregroundColor: Color(0xFF1D52A9),
          title: Text( 'Happy Reading',style: TextStyle(fontWeight: FontWeight.bold),),
          centerTitle: true,),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
            SizedBox(height: 16.0),
             widget.urlToImage.isNotEmpty
                ? Image.network(
                     widget.urlToImage,
                    height: 200.0,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : SizedBox(height: 0.0), // If imageUrl is empty, hide the image
            SizedBox(height: 16.0),
            Text(
              'Published at: ${DateFormat('d MMM yyyy').format(DateTime.parse( widget.publishedAt))}',
              style: TextStyle(color: Colors.grey),
            ),
           
             SizedBox(height: 16.0),
            Text(
               widget.description,
              style: TextStyle(fontSize: 16.0),
            ),
             SizedBox(height: 16.0),
            Text(
               widget.content,
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  
  }
}