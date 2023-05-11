import 'dart:async';
import 'package:news_api/Domain/article.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database? _db;

  DatabaseHelper._instance();

  String articlesTable = 'articles_table';
  String colId = 'id';
  String colAuthor = 'author';
  String colTitle = 'title';
  String colDescription = 'description';
  String colUrl = 'url';
  String colUrlToImage = 'urlToImage';
  String colPublishedAt = 'publishedAt';
  String colContent = 'content';

  Future<Database> get db async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    String dbPath = join(await getDatabasesPath(), 'articles.db');
    Database db = await openDatabase(dbPath, version: 1, onCreate: _createDb);
    return db;
  }

  void _createDb(Database db, int version) async {
    String createArticlesTableQuery = '''
      CREATE TABLE $articlesTable(
        $colId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colAuthor TEXT,
        $colTitle TEXT,
        $colDescription TEXT,
        $colUrl TEXT,
        $colUrlToImage TEXT,
        $colPublishedAt TEXT,
        $colContent TEXT
      )
    ''';
    await db.execute(createArticlesTableQuery);
  }

  Future<List<Map<String, dynamic>>> getArticlesMapList() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(articlesTable);
    return result;
  }

  Future<List<Articles>> getArticlesList() async {
    final List<Map<String, dynamic>> articlesMapList =
        await getArticlesMapList();
    final List<Articles> articlesList = [];
    for (var articleMap in articlesMapList) {
      articlesList.add(Articles.fromJson(articleMap));
    }
    return articlesList;
  }

  Future<int> insertArticle(Articles article) async {
    Database db = await this.db;
    int result = await db.insert(articlesTable, article.toJson());
    return result;
  }

  // Future<int> updateArticle(Articles article) async {
  //   Database db = await this.db;
  //   int result = await db.update(articlesTable, article.toJson(),
  //       where: '$colId = ?', whereArgs: [article.source!.id.toString()]);
  //   return result;
  // }

  Future<int> deleteArticle(int id) async {
    Database db = await this.db;
    int result =
        await db.delete(articlesTable, where: '$colId = ?', whereArgs: [id]);
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.db;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $articlesTable');
    int result = Sqflite.firstIntValue(x)!;
    return result;
  }

  Future<void> deleteAllArticles() async {
    Database db = await this.db;
    await db.execute('DELETE FROM $articlesTable');
  }
}
