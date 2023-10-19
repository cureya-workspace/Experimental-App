import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

// ignore: constant_identifier_names
enum HTTPMethod { GET, POST, PUT, DELETE }

class HttpServiceSingleton {
  final _storage = const FlutterSecureStorage();
  static HttpServiceSingleton? _httpServiceSingleton;
  late http.Client _client;

  factory HttpServiceSingleton() {
    // ignore: prefer_conditional_assignment, unnecessary_null_comparison
    if (_httpServiceSingleton == null) {
      _httpServiceSingleton = HttpServiceSingleton._init();
    }
    return _httpServiceSingleton!;
  }

  HttpServiceSingleton._init() {
    _client = http.Client();
  }

  void dispose() {
    _client.close();
  }

  Future<Map> makeRequest(
      {required String url,
      Map<String, String>? queryParameters,
      required HTTPMethod method,
      Map<String, dynamic>? body,
      required Map<String, String> headers,
      bool includeAuthCredentials = false}) async {
    http.Response? response;

    if (includeAuthCredentials) {
      final authToken = await _storage.read(key: 'Authorization');
      headers['Authorization'] = authToken!;
    }

    try {
      switch (method) {
        case HTTPMethod.GET:
          response = await _client.get(Uri.parse(url), headers: headers);
          break;

        case HTTPMethod.POST:
          response = await _client.post(Uri.parse(url),
              headers: headers, body: json.encode(body));
          break;
        case HTTPMethod.PUT:
          response =
              await _client.put(Uri.parse(url), headers: headers, body: body);
          break;
        case HTTPMethod.DELETE:
          response = await _client.delete(Uri.parse(url),
              headers: headers, body: body);
          break;
        default:
          throw "Invalid method";
      }
    } catch (e) {
      if (e is SocketException) {
        throw "Could not connect to server!";
      } else {
        rethrow;
      }
    }

    if (kDebugMode) {
      print('Status Code ${response.statusCode}');
      print('Res ${response.body}');
    }

    Map resultBody = json.decode(response.body);

    if (response.statusCode == 200) {
      return resultBody;
    } else {
      if (kDebugMode) {
        print('Status Code ${response.statusCode}');
      }
      throw resultBody['message'];
    }
  }
}
