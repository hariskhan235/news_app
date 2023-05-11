import 'package:news_api/Data/remote/services/api_service.dart';

class NewsRepository {
  Future fetchNews(query) async {
    try {
      return await NewsApiService().fetchNewsArticles(query);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

 Future fetchCountryNews(country, catogory) async {
    try {
      return await NewsApiService().fetchCountryNews(country, catogory);
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
