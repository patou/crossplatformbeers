import 'dart:convert';

import 'package:crossplatformbeers/exceptions/custom_exceptions.dart';
import 'package:crossplatformbeers/models/beer.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

const kApiBaseUrl = 'https://api.punkapi.com/v2';
const kBeerResource = 'beers';

@immutable
class BeersRepository {
  final http.Client client;

  const BeersRepository({required this.client});

  Future<List<Beer>> getBeers({
    int pageNumber = 1,
    int itemsPerPage = 10,
  }) async {
    var url = Uri.parse(
        '$kApiBaseUrl/$kBeerResource?page=$pageNumber&per_page=$itemsPerPage');
    final response = await client.get(url);

    if (response.statusCode != 200) {
      return Future.error(FetchDataException(
          'error occurred when fetch beers from punk API: {$response.statusCode}'));
    }

    final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
    try {
      // something
      return parsed.map<Beer>((json) => Beer.fromJson(json)).toList();
    } catch (e, stacktrace) {
      if (kDebugMode) {
        print(e);
        print(stacktrace);
      }
      rethrow;
    }
  }
}
