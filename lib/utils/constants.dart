import 'package:flutter/foundation.dart';

const String _webBaseUrl = 'http://localhost:8000';
const String _emulatorBaseUrl = 'http://10.0.2.2:8000';

String get baseUrl => kIsWeb ? _webBaseUrl : _emulatorBaseUrl;

String get loginUrl => '$baseUrl/auth/login/';
String get logoutUrl => '$baseUrl/auth/logout/';
String get registerUrl => '$baseUrl/auth/register/';
String get newsListAllUrl => '$baseUrl/json/';
String get newsListMineUrl => '$baseUrl/json/user/';
String get proxyImageUrl => '$baseUrl/proxy-image/';
String get createNewsUrl => '$baseUrl/create-flutter/';
