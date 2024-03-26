import 'package:flutter_test/flutter_test.dart';
import 'package:add_card_wallet/add_card_wallet.dart';
import 'package:add_card_wallet/add_card_wallet_platform_interface.dart';
import 'package:add_card_wallet/add_card_wallet_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAddCardWalletPlatform
    with MockPlatformInterfaceMixin
    implements AddCardWalletPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final AddCardWalletPlatform initialPlatform = AddCardWalletPlatform.instance;

  test('$MethodChannelAddCardWallet is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAddCardWallet>());
  });

  test('getPlatformVersion', () async {
    AddCardWallet addCardWalletPlugin = AddCardWallet();
    MockAddCardWalletPlatform fakePlatform = MockAddCardWalletPlatform();
    AddCardWalletPlatform.instance = fakePlatform;

    expect(await addCardWalletPlugin.getPlatformVersion(), '42');
  });
}
