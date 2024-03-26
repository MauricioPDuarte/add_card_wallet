import 'package:flutter/services.dart';

import 'add_card_wallet_platform_interface.dart';

/// An implementation of [AddCardWalletPlatform] that uses method channels.
class MethodChannelAddCardWallet extends AddCardWalletPlatform {
  final methodChannel = const MethodChannel('add_card_wallet');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');

    return version;
  }
}
