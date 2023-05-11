import 'package:news_api/Domain/article.dart';

abstract class CountryNewsState {
  CountryNewsState();
}

class CountryNewsInitial extends CountryNewsState {
  CountryNewsInitial();
}

class CountryNewsLoading extends CountryNewsState {
  CountryNewsLoading();
}

class CountryNewsLoaded extends CountryNewsState {
  final List<Articles> articles;
  CountryNewsLoaded({required this.articles});
}

class CountryNewsError extends CountryNewsState {
  final String message;
  CountryNewsError({required this.message});
}
