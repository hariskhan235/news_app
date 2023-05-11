import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_api/Data/local/db_helper.dart';
import 'package:news_api/Domain/article.dart';
import 'package:news_api/Presentation/cubits/home/Local/local_state.dart';

class LocalDatabaseCubit extends Cubit<LocalDatabaseState> {
  LocalDatabaseCubit() : super(LocalDatabaseInitialState());

  DatabaseHelper databaseHelper = DatabaseHelper.instance;

  getListArticles() async {
    emit(LocalDatabaseLoadingState());
    try {
      await databaseHelper.getArticlesList().then((value) {
        emit(LocalDatabaseSuccessState(data: value));
        return value;
      });
    } catch (e) {
      emit(LocalDatabaseErrorState(message: e.toString()));
      return Future.error(e.toString());
    }
  }

  saveArticle(Articles article) async {
    emit(LocalDatabaseLoadingState());
    try {
      await databaseHelper.insertArticle(article).then((value) {
        emit(LocalDatabaseArticleAdded(value: value));
      });
    } catch (e) {
      emit(LocalDatabaseErrorState(message: e.toString()));
      return Future.error(e.toString());
    }
  }
}
