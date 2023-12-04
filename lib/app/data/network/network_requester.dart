import 'dart:developer';
import 'dart:io';

import 'package:demo/app/data/values/constants.dart';
import 'package:demo/app/data/values/env.dart';
import 'package:demo/utils/exception_handler.dart';
import 'package:demo/utils/storage_utils.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';


class NetworkRequester {
  late Dio _dio;

  NetworkRequester() {
    prepareRequest();
  }

  NetworkRequester.authenticatedRequest() {
    prepareAuthenticatedRequest();
  }

  void prepareRequest() {
    BaseOptions dioOptions = BaseOptions(
      connectTimeout: Duration(milliseconds: Timeouts.CONNECT_TIMEOUT),
      receiveTimeout: Duration(milliseconds: Timeouts.RECEIVE_TIMEOUT),
      baseUrl: Env.baseURL,
      contentType: Headers.formUrlEncodedContentType,
      responseType: ResponseType.json,
      headers: {'Accept': Headers.jsonContentType},
    );

    _dio = Dio(dioOptions);

    _dio.interceptors.clear();

    _dio.interceptors.add(LogInterceptor(
      error: true,
      request: true,
      requestBody: true,
      requestHeader: true,
      responseBody: true,
      responseHeader: true,
      logPrint: _printLog,
    ));
  }

  void prepareAuthenticatedRequest() {
    BaseOptions dioOptions = BaseOptions(
      baseUrl: Env.baseURL,
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      headers: {
        'Accept': Headers.jsonContentType,
        'Authorization': 'Bearer ${Storage.getUserToken()}',
      },
    );

    _dio = Dio(dioOptions);

    _dio.interceptors.clear();

    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };

    _dio.interceptors.addAll([
      LogInterceptor(
        error: true,
        request: true,
        requestBody: true,
        requestHeader: true,
        responseBody: true,
        responseHeader: true,
        logPrint: _printLog,
      ),
    ]);
  }

  static NetworkRequester authenticated =
      NetworkRequester.authenticatedRequest();

  _printLog(Object object) => log(object.toString());

  Future<dynamic> get({
    required String path,
    Map<String, dynamic>? query,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: query);
      return response.data;
    } on Exception catch (exception) {
      return ExceptionHandler.handleError(exception);
    }
  }

  Future<dynamic> post(
      {required String path,
      Map<String, dynamic>? query,
      Map<String, dynamic>? data,
      FormData? formData}) async {
    try {
      final response = await _dio.post(
        path,
        queryParameters: query,
        data: formData ?? data,
      );
      return response.data;
    } on Exception catch (error) {
      return ExceptionHandler.handleError(error);
    }
  }

  Future<dynamic> put({
    required String path,
    Map<String, dynamic>? query,
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await _dio.put(path, queryParameters: query, data: data);
      return response.data;
    } on Exception catch (error) {
      return ExceptionHandler.handleError(error);
    }
  }

  Future<dynamic> patch({
    required String path,
    Map<String, dynamic>? query,
    Map<String, dynamic>? data,
  }) async {
    try {
      final response =
          await _dio.patch(path, queryParameters: query, data: data);
      return response.data;
    } on Exception catch (error) {
      return ExceptionHandler.handleError(error);
    }
  }

  Future<dynamic> delete({
    required String path,
    Map<String, dynamic>? query,
    Map<String, dynamic>? data,
  }) async {
    try {
      final response =
          await _dio.delete(path, queryParameters: query, data: data);
      return response.data;
    } on Exception catch (error) {
      return ExceptionHandler.handleError(error);
    }
  }
}
