import Flutter
import PassKit
import UIKit


class PKAddPassButtonNativeViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger
    private var channel: FlutterMethodChannel

    init(messenger: FlutterBinaryMessenger, channel: FlutterMethodChannel) {
        self.messenger = messenger
        self.channel = channel
        super.init()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return PKAddPassButtonNativeView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args as! [String: Any],
            binaryMessenger: messenger,
            channel: channel)
    }
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
          return FlutterStandardMessageCodec.sharedInstance()
    }
}

class PKAddPassButtonNativeView: NSObject, FlutterPlatformView {
    private var _view: UIView
   // private var _pass: FlutterStandardTypedData
    private var _width: CGFloat
    private var _height: CGFloat
    private var _key: String
    private var _channel: FlutterMethodChannel
    private var topController : UIViewController?

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: [String: Any],
        binaryMessenger messenger: FlutterBinaryMessenger?,
        channel: FlutterMethodChannel
    ) {
        _view = UIView()
       // _pass = args["pass"] as! FlutterStandardTypedData
        _width = args["width"] as? CGFloat ?? 140
        _height = args["height"] as? CGFloat ?? 48
        _key = args["key"] as! String
        _channel = channel
        super.init()
        createAddPassButton()
    }

    func view() -> UIView {
        _view
    }

    func createAddPassButton() {
        let passButton = PKAddPassButton(addPassButtonStyle: .blackOutline)
        passButton.frame = CGRect(x: 0, y: 0, width: _width, height: _height)
        passButton.addTarget(self, action: #selector(addCardToAppleWallet), for: .touchUpInside)
        _view.addSubview(passButton)
    }

    @objc func addCardToAppleWallet() {
      guard PKAddPaymentPassViewController.canAddPaymentPass() else {
        print("InApp enrollment is not available for this device")
        return
       }

      initEnrollmentProcess()
    }
    
    func initEnrollmentProcess() {
       guard let configuration = PKAddPaymentPassRequestConfiguration(encryptionScheme: .ECC_V2) else {
        print("InApp enrollment configuraton fails")
        return
      }
      
      configuration.cardholderName = "Mauricio"
      configuration.primaryAccountSuffix = "4334"
      configuration.paymentNetwork = .visa // or visa, Amex, .mastercart
      
      guard let enrollViewController = PKAddPaymentPassViewController(requestConfiguration: configuration, delegate: self) else {
          print("InApp enrollment controller configuration fails")
          return
      }
      
      let frontViewController = UINavigationController(rootViewController: enrollViewController)

      guard let window = UIApplication.shared.keyWindow, let rootViewController = window.rootViewController else {
              return
      }

      topController = rootViewController

      while let newTopController = topController!.presentedViewController {
        topController = newTopController
      }
      
      topController!.present(frontViewController, animated: true, completion: nil)
    }
}

public class AddCardWalletPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "method/add_card_wallet", binaryMessenger: registrar.messenger())
    let instance = AddCardWalletPlugin()

      let factory = PKAddPassButtonNativeViewFactory(messenger: registrar.messenger(), channel: channel)
      registrar.register(factory, withId: "PKAddPassButton")
    


    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    // case "buttonAddCardWalletApple":
    //   break
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
