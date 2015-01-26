library model_service;

import 'account.dart';
import 'package:kaif_web/util.dart';
import 'dart:html';
import 'dart:convert';
import 'dart:async';

class RestErrorResponse extends Error {
  final int code;
  final String reason;

  static RestErrorResponse tryDecode(String text) {
    try {
      var json = JSON.decode(text);
      if (json is Map) {
        Map raw = json;
        if (raw.containsKey('code') && raw.containsKey('reason')) {
          return new RestErrorResponse(raw['code'], raw['reason']);
        }
      }
    } catch (e) {
    }
    return null;
  }

  RestErrorResponse(this.code, this.reason);

  String toString() => "$reason (code:$code)";
}

typedef String accessTokenProvider();

abstract class _AbstractService {
  _populateAccessToken(Map<String, String> headers) {
    String token = _accessTokenProvider();
    if (token != null) {
      headers['X-KAIF-ACCESS-TOKEN'] = token;
    }
  }

  ServerType _serverType;
  accessTokenProvider _accessTokenProvider;

  _AbstractService(this._serverType, this._accessTokenProvider);

  String _getAccountUrl(String path) => '/api/account$path';

  Future<HttpRequest> _postJson(String url, dynamic json, {Map<String, String> header}) {
    return _requestJson('POST', url, json, header:header);
  }

  Future<HttpRequest> _putJson(String url, dynamic json, {Map<String, String> header}) {
    return _requestJson('PUT', url, json, header:header);
  }

  Future<HttpRequest> _get(String url,
                           {Map<String, Object> params:const {
                           },
                           Map<String, String> header}) {
    var parts = [];
    params.forEach((key, value) {
      if (value != null) {
        String strValue = value.toString();
        parts.add('${Uri.encodeQueryComponent(key)}=' '${Uri.encodeQueryComponent(strValue)}');
      }
    });
    var query = parts.join('&');
    String getUrl = query.isEmpty ? url : '${url}?${query}';

    var requestHeaders = header == null ? {
    } : header;
    _populateAccessToken(requestHeaders);
    return HttpRequest.request(getUrl, requestHeaders:requestHeaders)
    .catchError(_onHandleRequestError);
  }

  Future<HttpRequest> _getPlanTextWithoutHandleError(String url) {
    var requestHeaders = {
    };
    _populateAccessToken(requestHeaders);
    return HttpRequest.request(url, requestHeaders:requestHeaders);
  }

  void _onHandleRequestError(ProgressEvent event) {
    HttpRequest req = event.target;
    var restErrorResponse = RestErrorResponse.tryDecode(req.responseText);
    if (restErrorResponse == null) {
      throw new RestErrorResponse(500, 'Unexpected error response, status:${req.status}');
    }
    throw restErrorResponse;
  }

  Future<HttpRequest> _requestJson(String method,
                                   String url,
                                   dynamic json,
                                   {Map<String, String> header}) {
    var requestHeaders = header == null ? {
    } : header;
    requestHeaders['Content-Type'] = 'application/json';
    _populateAccessToken(requestHeaders);
    return HttpRequest.request(
        url,
        method:method,
        sendData:JSON.encode(json),
        requestHeaders:requestHeaders)
    .catchError(_onHandleRequestError);
  }

}

class PartService extends _AbstractService {
  PartService(ServerType serverType, accessTokenProvider _provider)
  : super(serverType, _provider);

  /**
   * throw PermissionError if auth failed
   * or StateError if any server render problem
   */
  Future<String> loadPart(String partPath) {
    return _getPlanTextWithoutHandleError(partPath)
    .then((req) => req.responseText)
    .catchError((ProgressEvent event) {
      HttpRequest request = event.target;
      if (request.status == 401 || request.status == 403) {
        throw new PermissionError();
      } else {
        if (_serverType.isDevMode) {
          throw new StateError('[DEBUG] render $partPath error, response:\n ${request.responseText}');
        }
        throw new StateError('Unexpected error, status:${request.status}');
      }
    });
  }
}

class AccountService extends _AbstractService {

  AccountService(ServerType serverType, accessTokenProvider _provider)
  : super(serverType, _provider);

  Future createAccount(String name, String email, String password) {
    var json = {
        'name':name, 'email':email, 'password':password
    };
    return _putJson(_getAccountUrl('/'), json)
    .then((res) => null);
  }

  Future<bool> isNameAvailable(String name) {
    var params = {
        'name':name
    };
    return _get(_getAccountUrl('/name-available'), params:params)
    .then((req) => JSON.decode(req.responseText))
    .then((raw) => raw['data']);
  }

  Future<bool> isEmailAvailable(String email) {
    var params = {
        'email':email
    };
    return _get(_getAccountUrl('/email-available'), params:params)
    .then((req) => JSON.decode(req.responseText))
    .then((raw) => raw['data']);
  }

  Future<AccountAuth> authenticate(String name, String password) {
    var json = {
        'name':name, 'password':password
    };
    return _postJson(_getAccountUrl('/authenticate'), json)
    .then((req) => JSON.decode(req.responseText))
    .then((raw) => new AccountAuth.decode(raw));
  }

  Future resendActivation() {
    return _postJson(_getAccountUrl('/resend-activation'), {
    }).then((req) => null);
  }

  Future resetPassword(String name, String email) {
    var json = {
        'name':name, 'email':email
    };
    return _postJson(_getAccountUrl('/reset-password'), json)
    .then((req) => null);
  }
}