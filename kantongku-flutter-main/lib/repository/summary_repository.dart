import 'dart:convert';
import 'package:http/http.dart';
import 'package:kantongku/component/url_server.dart';
import 'package:kantongku/model/summary_all_model.dart';
import 'package:kantongku/model/summary_monthly_model.dart';

class SummaryRepository {
  static String urlServer = UrlServer.urlServer;

  static Future<SummaryFinancial?> getData(userId, category) async {
    Uri url = Uri.parse(
        "$urlServer/transactions/sum-by-category/$userId?category=$category");

    var response = await get(
      url,
      headers: {
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body) as String;

      return SummaryFinancial.createFromJson(jsonResponse);
    }
    return null;
  }

  static Future<List<SummaryMonthly>> getMonthlyData(userId, category) async {
    Uri url = Uri.parse(
        "$urlServer/transactions/sum-by-category/graph/$userId?category=$category");

    var response = await get(
      url,
      headers: {
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body) as List;

      return jsonResponse.map((e) => SummaryMonthly.createFromJson(e)).toList();
    }
    return [];
  }
}
