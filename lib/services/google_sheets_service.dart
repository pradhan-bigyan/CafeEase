import 'dart:convert';
import 'package:googleapis/sheets/v4.dart' as sheets;
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class GoogleSheetsService {
  static const _scopes = [sheets.SheetsApi.spreadsheetsScope];
  final String _spreadsheetId;
  final String _range;
  final String _credentialsFile;

  GoogleSheetsService({
    required String spreadsheetId,
    required String range,
    required String credentialsFile,
  })  : _spreadsheetId = spreadsheetId,
        _range = range,
        _credentialsFile = credentialsFile;

  Future<sheets.SheetsApi> _getSheetsApi() async {
    final credentials = json.decode(await rootBundle.loadString(_credentialsFile));
    final authClient = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson(credentials), _scopes);
    return sheets.SheetsApi(authClient);
  }

  Future<void> appendOrderData(List<List<Object>> values) async {
    final api = await _getSheetsApi();
    final request = sheets.ValueRange.fromJson({
      'range': _range,
      'values': values,
    });
    await api.spreadsheets.values.append(
      request,
      _spreadsheetId,
      _range,
      valueInputOption: 'RAW',
    );
  }
}