import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:news_api/Data/remote/repositories/news_repository.dart';
import 'package:news_api/Presentation/cubits/other/country_news_state.dart';

class CountryNewsCubit extends Cubit<CountryNewsState> {
  CountryNewsCubit() : super(CountryNewsInitial());

  fetchCountryNews(String country, String catogory) async {
    emit(CountryNewsLoading());
    try {
      await NewsRepository().fetchCountryNews(country, catogory).then((value) {
        emit(CountryNewsLoaded(articles: value));
        return value;
      });
    } on SocketException catch (e) {
      emit(CountryNewsError(message: e.toString()));
    } on HttpException catch (e) {
      emit(CountryNewsError(message: e.toString()));
    } catch (e) {
      emit(CountryNewsError(message: e.toString()));
    }
  }
}
