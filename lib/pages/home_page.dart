// pages/home_page.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/article.dart';
import '../dialogs/add_article_dialog.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Liste de Courses',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

enum SortOption { name, category, quantity }

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Article> articles = [];
  SortOption currentSortOption = SortOption.name;

  @override
  void initState() {
    super.initState();
    loadArticles();
  }

  void loadArticles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? articlesJson = prefs.getStringList('articles');

    if (articlesJson != null) {
      setState(() {
        articles = articlesJson.map((json) {
          return Article.fromMap(jsonDecode(json));
        }).toList();
      });
    }
  }

  void saveArticles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> articlesJson =
        articles.map((e) => jsonEncode(e.toMap())).toList();
    prefs.setStringList('articles', articlesJson);
  }

  void sortArticles() {
    switch (currentSortOption) {
      case SortOption.name:
        articles.sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        break;
      case SortOption.category:
        articles.sort((a, b) =>
            a.category.toLowerCase().compareTo(b.category.toLowerCase()));
        break;
      case SortOption.quantity:
        articles.sort((a, b) => a.quantity.compareTo(b.quantity));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    sortArticles(); // Appeler la méthode de tri avant de construire l'interface utilisateur

    return Scaffold(
      appBar: AppBar(
        title: Text('Liste de Courses'),
        actions: [
          PopupMenuButton<SortOption>(
            onSelected: (option) {
              setState(() {
                currentSortOption = option;
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: SortOption.name,
                child: Text('Trier par Nom'),
              ),
              PopupMenuItem(
                value: SortOption.category,
                child: Text('Trier par Catégorie'),
              ),
              PopupMenuItem(
                value: SortOption.quantity,
                child: Text('Trier par Quantité'),
              ),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: UniqueKey(),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
            ),
            onDismissed: (direction) {
              setState(() {
                articles.removeAt(index);
                saveArticles();
              });
            },
            child: Card(
              elevation: 4.0,
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: ListTile(
                title: Text(
                  articles[index].name,
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '${articles[index].category} - ${articles[index].quantity}',
                  style: TextStyle(fontSize: 16.0),
                ),
                trailing: Checkbox(
                  value: articles[index].isBought,
                  onChanged: (value) {
                    setState(() {
                      articles[index].isBought = value!;
                      saveArticles();
                    });
                  },
                ),
                onTap: () async {
                  Article? updatedArticle = await showDialog(
                    context: context,
                    builder: (context) =>
                        AddArticleDialog(initialArticle: articles[index]),
                  );

                  if (updatedArticle != null) {
                    setState(() {
                      articles[index] = updatedArticle;
                      saveArticles();
                    });
                  }
                },
              ),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Article? newArticle = await showDialog(
            context: context,
            builder: (context) => AddArticleDialog(),
          );

          if (newArticle != null) {
            setState(() {
              articles.add(newArticle);
              saveArticles();
            });
          }
        },
        backgroundColor:
            Color.fromRGBO(76, 39, 161, 1), 
        elevation: 8.0, // Élévation du bouton
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100.0), 
        ),
        heroTag: 'add_button', 
        child: Icon(Icons.add),
      ),

    );
  }
}
