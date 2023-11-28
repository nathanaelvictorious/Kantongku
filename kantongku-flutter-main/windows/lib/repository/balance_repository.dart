import 'dart:convert';

import 'package:http/http.dart';
import 'package:kantongku/component/url_server.dart';
import 'package:kantongku/model/balance_model.dart';

class BalanceRepository {
  static String urlServer = UrlServer.urlServer;

  static Future<Balance?> getData(userId) async {
    Uri url = Uri.parse("$urlServer/balance/$userId");

    var response = await get(
      url,
      headers: {
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;

      return Balance.createFromJson(jsonResponse);
    }
    return null;
  }
}
