import 'package:news_api/Domain/article.dart';

abstract class NewsState {
  NewsState();
}

class NewsInitial extends NewsState {
  NewsInitial();
}

class NewsLoading extends NewsState {
  NewsLoading();
}

class NewsLoaded extends NewsState {
  final List<Articles> articles;

  NewsLoaded({required this.articles});
}

class NewsError extends NewsState {
  final String errorMessage;

  NewsError({required this.errorMessage});
}
