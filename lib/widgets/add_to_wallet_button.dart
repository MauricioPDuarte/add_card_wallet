import 'dart:async';

import 'package:add_card_wallet/add_card_wallet.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

class AddToWalletButton extends StatefulWidget {
  static const viewType = 'PKAddPassButton';

  final List<int> pkPass;
  final double width;
  final double height;
  final Widget? unsupportedPlatformChild;
  final FutureOr<void> Function()? onPressed;
  final String _id = const Uuid().v4();

  AddToWalletButton(
      {super.key,
      required this.pkPass,
      required this.width,
      required this.height,
      this.onPressed,
      this.unsupportedPlatformChild});

  @override
  _AddToWalletButtonState createState() => _AddToWalletButtonState();
}

class _AddToWalletButtonState extends State<AddToWalletButton> {
  get uiKitCreationParams => {
        'width': widget.width,
        'height': widget.height,
        'pass': widget.pkPass,
        'key': widget._id,
      };

  @override
  void initState() {
    super.initState();
    AddCardWallet().addHandler(widget._id, (_) => widget.onPressed?.call());
  }

  @override
  void dispose() {
    AddCardWallet().removeHandler(widget._id);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: platformWidget(context),
    );
  }

  Widget platformWidget(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return UiKitView(
          viewType: AddToWalletButton.viewType,
          layoutDirection: Directionality.of(context),
          creationParams: uiKitCreationParams,
          creationParamsCodec: const StandardMessageCodec(),
        );
      default:
        if (widget.unsupportedPlatformChild == null) {
          throw UnsupportedError('Unsupported platform view');
        }
        return widget.unsupportedPlatformChild!;
    }
  }
}
