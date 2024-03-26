
import 'add_card_wallet_platform_interface.dart';

class AddCardWallet {
  Future<String?> getPlatformVersion() {
    return AddCardWalletPlatform.instance.getPlatformVersion();
  }
}
