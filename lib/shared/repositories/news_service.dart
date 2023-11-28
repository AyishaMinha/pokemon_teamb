import 'dart:convert';

import 'package:app/shared/models/news_model.dart';
import 'package:app/shared/utils/api_constants.dart';
import 'package:dio/dio.dart';

class NewsService {
  static final _dio = Dio();

  Dio getDioInstance() {
    return _dio;
  }

  Future<List<News>> fetchAllArticles(int page, {int pageSize = 5}) async {
    try {
      Response response = await _dio.get(
        '${ApiConstants.baseURL}/news?page=$page&pageSize=$pageSize',
      );

      if (response.statusCode == 200) {
        await Future.delayed(const Duration(milliseconds: 200));
        final List<dynamic> responseData = response.data;
        final List<News> result = newsFromJson(json.encode(responseData));
        print('$result.length, $page');
        return result;
      } else {
        print('Failed to fetch articles. Status code: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      print('Error fetching articles: $error');
      throw Exception(error);
    }
  }
}

// // Inside your NewsService class
// Future<List<News>> fetchAllArticles({int page = 1, int pageSize = 10}) async {
//   try {
//     final response = await _dio.get('http://your-api-url/news?page=$page&pageSize=$pageSize');
//     final List<News> newsList = response.data; // Adjust based on your API response structure
//     return newsList;
//   } catch (error) {
//     throw Exception('Failed to fetch news: $error');
//   }
// }
