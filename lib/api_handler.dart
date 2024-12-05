import 'dart:convert';
import 'package:http/http.dart';

const stockApiKey = "5LWOLM37683SJFJ8";
const stockEndpoint = "https://alphavantage.co/query";

Future<List<dynamic>> getData(String stock, String time) async {
  try {
    var prev = await prevDayPrice(stock, time);
    var prevPrev = await prevPrevDayPrice(stock, time);
    var diff = prev - prevPrev;
    late String downOrUp;
    if (diff.isNegative) {
      downOrUp = "went down";
    } else if (diff.isNegative == false) {
      downOrUp = "went up";
    }
    diff = diff.abs();
    var diffPercent = (diff / prev) * 100;
    return ["ok", prev, prevPrev, diffPercent, downOrUp];
  } catch (e) {
    print(e.toString());
    return ["error", e.toString()];
  }
}

Future<double> prevDayPrice(String stock, String time) async {
  if (time == "D") {
    var response = await get(
      Uri.parse(
        "$stockEndpoint?function=TIME_SERIES_DAILY&symbol=$stock&apikey=$stockApiKey",
      ),
    );
    final Map<String, dynamic> responseJSON = json.decode(response.body);
    var entries = responseJSON["Time Series (Daily)"].entries.toList();
    return double.parse(
        responseJSON["Time Series (Daily)"][entries[0].key]["4. close"]
            .toString());
  }
  else if (time == "W") {
    var response = await get(
      Uri.parse(
        "$stockEndpoint?function=TIME_SERIES_WEEKLY&symbol=$stock&apikey=$stockApiKey",
      ),
    );
    final Map<String, dynamic> responseJSON = json.decode(response.body);
    var entries = responseJSON["Weekly Time Series"].entries.toList();
    return double.parse(
        responseJSON["Weekly Time Series"][entries[0].key]["4. close"]
            .toString());
  }
  else {
    var response = await get(
      Uri.parse(
        "$stockEndpoint?function=TIME_SERIES_MONTHLY&symbol=$stock&apikey=$stockApiKey",
      ),
    );
    final Map<String, dynamic> responseJSON = json.decode(response.body);
    var entries = responseJSON["Monthly Time Series"].entries.toList();
    return double.parse(
        responseJSON["Monthly Time Series"][entries[0].key]["4. close"]
            .toString());
  }
}

Future<double> prevPrevDayPrice(String stock, String time) async {
  if (time == "D") {
    var response = await get(
      Uri.parse(
        "$stockEndpoint?function=TIME_SERIES_DAILY&symbol=$stock&apikey=$stockApiKey",
      ),
    );
    final Map<String, dynamic> responseJSON = json.decode(response.body);
    var entries = responseJSON["Time Series (Daily)"].entries.toList();
    return double.parse(
        responseJSON["Time Series (Daily)"][entries[1].key]["4. close"]
            .toString());
  }
  else if (time == "W") {
    var response = await get(
      Uri.parse(
        "$stockEndpoint?function=TIME_SERIES_WEEKLY&symbol=$stock&apikey=$stockApiKey",
      ),
    );
    final Map<String, dynamic> responseJSON = json.decode(response.body);
    var entries = responseJSON["Weekly Time Series"].entries.toList();
    return double.parse(
        responseJSON["Weekly Time Series"][entries[1].key]["4. close"]
            .toString());
  }
  else {
    var response = await get(
      Uri.parse(
        "$stockEndpoint?function=TIME_SERIES_MONTHLY&symbol=$stock&apikey=$stockApiKey",
      ),
    );
    final Map<String, dynamic> responseJSON = json.decode(response.body);
    var entries = responseJSON["Monthly Time Series"].entries.toList();
    return double.parse(
        responseJSON["Monthly Time Series"][entries[1].key]["4. close"]
            .toString());
  }
}
