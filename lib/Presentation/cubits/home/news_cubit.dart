import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:news_api/Data/remote/repositories/news_repository.dart';
import 'package:news_api/Presentation/cubits/home/news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  NewsCubit() : super(NewsInitial());

  Future fetchNews(String query) async {
    emit(NewsLoading());
    try {
      await NewsRepository().fetchNews(query).then((value) {
        emit(NewsLoaded(articles: value));
        return value;
      });
    } on SocketException catch (e) {
      emit(NewsError(errorMessage: e.toString()));
    } on HttpException catch (e) {
      emit(NewsError(errorMessage: e.toString()));
    } catch (e) {
      emit(NewsError(errorMessage: e.toString()));
    }
  }

  
}
