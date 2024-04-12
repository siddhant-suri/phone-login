


import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:phone_auth_firebase_tutorial/controllers/auth_service.dart';
import 'package:phone_auth_firebase_tutorial/pages/login_page.dart';
import 'package:url_launcher/url_launcher.dart';

import '../consts.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Dio dio = Dio();

  List<Article> articles = [];
  String? selectedCategory = 'business'; // Default category
  String? selectedCountry = 'in'; // Default country

  @override
  void initState() {
    super.initState();
    _getNews(selectedCategory!, selectedCountry!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 195, 201, 201), // App bar color
        title: const Text("Today's News"),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: Icon(Icons.logout),
          ),
          IconButton(
            onPressed: _refreshNews,
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: Container(
        color: Color.fromARGB(255, 195, 201, 201), // Background color
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(child: _buildCategoryDropdown()),
                Expanded(child: _buildCountryDropdown()),
              ],
            ),
            Expanded(
              child: _buildUI(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedCategory,
      decoration: InputDecoration(
        labelText: 'Select Category',
        border: OutlineInputBorder(),
      ),
      items: <String>[
        'business',
        'science',
        'technology',
        'health',
      ].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedCategory = newValue;
          if (selectedCategory != null && selectedCountry != null) {
            _getNews(selectedCategory!, selectedCountry!);
          }
        });
      },
    );
  }

  Widget _buildCountryDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedCountry,
      decoration: InputDecoration(
        labelText: 'Select Country',
        border: OutlineInputBorder(),
      ),
      items: <String>[
        'in',
        'gb',
        'us',
        // Add more countries as needed
      ].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value.toUpperCase()),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedCountry = newValue;
          if (selectedCategory != null && selectedCountry != null) {
            _getNews(selectedCategory!, selectedCountry!);
          }
        });
      },
    );
  }

  Widget _buildUI() {
    return ListView.builder(
      itemCount: articles.length,
      itemBuilder: (context, index) {
        final article = articles[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              _launchUrl(Uri.parse(article.url ?? ""));
            },
            child: Card(
              color: Color.fromARGB(255, 195, 201, 201), // Card color
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildArticleImage(article.urlToImage),
                    SizedBox(height: 8),
                    Text(
                      article.title ?? "",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      article.description ?? "",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      article.publishedAt ?? "",
                      style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Author: ${article.author ?? 'Unknown'}",
                      style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Source: ${article.source?.name ?? 'Unknown'}",
                      style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildArticleImage(String? urlToImage) {
    if (urlToImage != null) {
      return Image.network(
        urlToImage,
        height: 150,
        fit: BoxFit.cover,
      );
    } else {
      return SizedBox(
        height: 150,
        child: Center(
          child: Text(
            'Image Preview Not Available',
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }
  }

  Future<void> _getNews(String category, String country) async {
    final response = await dio.get(
      'https://newsapi.org/v2/top-headlines?country=$country&category=$category&apiKey=${NEWS_API_KEY}',
    );
    final articlesJson = response.data["articles"] as List;
    setState(() {
      List<Article> newsArticle =
          articlesJson.map((a) => Article.fromJson(a)).toList();
      newsArticle = newsArticle.where((a) => a.title != "[Removed]").toList();
      articles = newsArticle;
    });
  }

  Future<void> _launchUrl(Uri url) async {
    try {
      if (!await launch(url.toString())) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
  }

  void _logout() {
    AuthService.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  void _refreshNews() {
    _getNews(selectedCategory!, selectedCountry!);
  }

  @override
  void dispose() {
    dio.close();
    super.dispose();
  }
}

class Article {
  Source? source;
  String? author;
  String? title;
  String? description;
  String? url;
  String? urlToImage;
  String? publishedAt;
  String? content;

  Article({
    this.source,
    this.author,
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
  });

  Article.fromJson(Map<String, dynamic> json) {
    source = json['source'] != null ? Source.fromJson(json['source']) : null;
    author = json['author'];
    title = json['title'];
    description = json['description'];
    url = json['url'];
    urlToImage = json['urlToImage'];
    publishedAt = json['publishedAt'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (source != null) {
      data['source'] = source!.toJson();
    }
    data['author'] = author;
    data['title'] = title;
    data['description'] = description;
    data['url'] = url;
    data['urlToImage'] = urlToImage;
    data['publishedAt'] = publishedAt;
    data['content'] = content;
    return data;
  }
}

class Source {
  String? id;
  String? name;

  Source({this.id, this.name});

  Source.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
