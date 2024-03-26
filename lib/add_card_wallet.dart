import 'dart:async';

import 'package:add_card_wallet/add_card_wallet_response.dart';
import 'package:flutter/services.dart';

export 'widgets/add_to_wallet_button.dart';

class AddCardWallet {
  static const MethodChannel _channel = MethodChannel('wallet_card');

  static final AddCardWallet _instance = AddCardWallet._internal();

  /// Associate each rendered Widget to its `onPressed` event handler
  static final Map<String, FutureOr<dynamic> Function(MethodCall)> _handlers =
      {};

  factory AddCardWallet() {
    return _instance;
  }

  AddCardWallet._internal() {
    _initMethodCallHandler();
  }

  void _initMethodCallHandler() => _channel.setMethodCallHandler(_handleCalls);

  Future<dynamic> _handleCalls(MethodCall call) async {
    var handler = _handlers[call.arguments['key']];
    return handler != null ? await handler(call) : null;
  }

  Future<void> addHandler<T>(
    String key,
    FutureOr<T>? Function(MethodCall) handler,
  ) async {
    _handlers[key] = handler;
  }

  void removeHandler(String key) {
    _handlers.remove(key);
  }

  Future<bool> canAddPass(Map<String, String> params) async {
    final method = await _channel.invokeMethod('canAddPass', params);
    final response = AddCardWalletPluginResponse.fromMap(method);
    return response.status;
  }

  Future<AddCardWalletPluginResponse> saveAndroidPass(
      String holderName, String suffix, String pass) async {
    final method = await _channel.invokeMethod('savePass', <String, String>{
      'holderName': holderName,
      'suffix': suffix,
      'pass': pass,
    });
    final response = AddCardWalletPluginResponse.fromMap(method);
    return response;
  }
}
