import 'package:news_api/Domain/article.dart';

abstract class LocalDatabaseState {
  LocalDatabaseState();
}

class LocalDatabaseInitialState extends LocalDatabaseState {
  LocalDatabaseInitialState();
}

class LocalDatabaseErrorState extends LocalDatabaseState {
  final String message;
  LocalDatabaseErrorState({required this.message});
}

class LocalDatabaseSuccessState extends LocalDatabaseState {
  List<Articles> data;
  LocalDatabaseSuccessState({required this.data});
}

class LocalDatabaseArticleAdded extends LocalDatabaseState {
  final int value;
  LocalDatabaseArticleAdded({required this.value});
}

class LocalDatabaseLoadingState extends LocalDatabaseState {
  LocalDatabaseLoadingState();
}
