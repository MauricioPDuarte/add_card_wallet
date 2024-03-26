import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'add_card_wallet_method_channel.dart';

abstract class AddCardWalletPlatform extends PlatformInterface {
  /// Constructs a AddCardWalletPlatform.
  AddCardWalletPlatform() : super(token: _token);

  static final Object _token = Object();

  static AddCardWalletPlatform _instance = MethodChannelAddCardWallet();

  /// The default instance of [AddCardWalletPlatform] to use.
  ///
  /// Defaults to [MethodChannelAddCardWallet].
  static AddCardWalletPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AddCardWalletPlatform] when
  /// they register themselves.
  static set instance(AddCardWalletPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
