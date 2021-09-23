import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/nintendo-switch/onsales_strings.dart';
import '../models/nintendo-switch/onsales.dart';
import './onsales_request.dart';

class APIManager {
  Future<OnSalesModel> getNSOnSales(NSOnSalesRequestConfig config) async {
    var client = http.Client();
    var onSalesModel = null;
    var response = await client.post(
        Uri.parse(ONSALES.BASE_URL +
            ONSALES.PATH +
            "?pageno=${config.page}&itemno=${config.limit}"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(config.option));

    try {
      var jsonMap = json.decode(response.body);
      onSalesModel = OnSalesModel.fromJson(jsonMap);
      if (onSalesModel.statusCode != 200) {}
    } catch (Exception) {
      print(Exception);
    } finally {
      client.close();
    }
    return onSalesModel;
  }
}
