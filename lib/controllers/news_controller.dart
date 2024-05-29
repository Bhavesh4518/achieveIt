// lib/controllers/news_controller.dart
import 'package:get/get.dart';

import '../models/article_model.dart';
import '../services/news_service.dart';

class NewsController extends GetxController {
  var articles = <Article>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNews();
  }

  void fetchNews() async {
    try {
      isLoading(true);
      var fetchedArticles = await NewsService().fetchArticles('technology');
      if (fetchedArticles != null) {
        articles.assignAll(fetchedArticles);
      }
    } finally {
      isLoading(false);
    }
  }
}
