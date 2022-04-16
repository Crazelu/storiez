import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:throtty/models/api/error/api_error_response.dart';
import 'package:throtty/models/api/server_response.dart';
import 'package:http/http.dart' as http;
import 'package:throtty/utils/locator.dart';
import 'package:throtty/utils/parser_util.dart';

abstract class ApiService {
  late http.Client _client;
  final String _baseUrl;

  ApiService(this._baseUrl) {
    _client = http.Client();
  }

  Future<Map<String, dynamic>> _getAuthorizationHeader() async {
    // final accessToken = await locator<LocalCache>().getToken();

    return {
      "Authorization": "Bearer "
      // + accessToken,
    };
  }

  Future<Either<Failure, Success>> get({
    required String path,
    bool useToken = false,
  }) async {
    return await _runWithErrorHandler(
      () async => await _client.get(
        Uri.parse(_baseUrl + path),
        headers: {
          if (useToken) ...await _getAuthorizationHeader(),
        },
      ),
    );
  }

  Future<Either<Failure, Success>> post({
    required String path,
    bool useToken = false,
    Map<String, dynamic>? body,
  }) async {
    return await _runWithErrorHandler(
      () async => await _client.post(
        Uri.parse(_baseUrl + path),
        headers: {
          if (useToken) ...await _getAuthorizationHeader(),
        },
        body: body,
      ),
    );
  }

  Future<Either<Failure, Success>> put({
    required String path,
    bool useToken = false,
    Map<String, dynamic>? body,
  }) async {
    return await _runWithErrorHandler(
      () async => await _client.put(
        Uri.parse(_baseUrl + path),
        headers: {
          if (useToken) ...await _getAuthorizationHeader(),
        },
        body: body,
      ),
    );
  }

  Future<Either<Failure, Success>> delete({
    required String path,
    bool useToken = false,
  }) async {
    return await _runWithErrorHandler(
      () async => await _client.delete(
        Uri.parse(_baseUrl + path),
        headers: {
          if (useToken) ...await _getAuthorizationHeader(),
        },
      ),
    );
  }

  Future<Either<Failure, Success>> _runWithErrorHandler(
    Future<http.Response> Function() request,
  ) async {
    try {
      final response = await request();
      final data = jsonDecode(response.body);

      if ("${response.statusCode}".startsWith('2')) {
        //CHECK THAT STATUS IS NOT FALSE
        if (ParserUtil.parseJsonString(data, "status") != "false") {
          return Right(Success(data));
        } else {
          return Left(
            Failure(
              ApiErrorResponse(
                message: ParserUtil.parseJsonString(data, "message"),
                type: ParserUtil.parseApiErrorCode(data),
              ),
            ),
          );
        }
      }

      return Left(Failure.fromMap(data));
    } on SocketException catch (_) {
      return Left(
        Failure(
          const ApiErrorResponse(
            message: "Oops. Check your internet connection and try again.",
          ),
        ),
      );
    } catch (e) {
      return Left(Failure(
        ApiErrorResponse(message: e.toString()),
      ));
    }
  }
}
