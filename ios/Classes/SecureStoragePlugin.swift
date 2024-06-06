import Flutter
import UIKit

public class SecureStoragePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "plugin.krootl.com/keychain/method", binaryMessenger: registrar.messenger())
    let instance = SecureStoragePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "put" {
            guard let args = call.arguments as? [String: Any],
                  let service = args["service"] as? String,
                  let account = args["account"] as? String,
                  let dataString = args["data"] as? String,
                  let data = dataString.data(using: .utf8) else {
                result(false)
                return
            }

            var success: Bool = false

            let retrievedString = KeychainHelper.get(forService: service, account: account)
            if (retrievedString != nil) {
                success = KeychainHelper.update(data: data, forService: service, account: account)
            } else {
                success = KeychainHelper.put(data: data, forService: service, account: account)
            }

            result(success)
        } else if call.method == "get" {
            guard let args = call.arguments as? [String: Any],
                  let service = args["service"] as? String,
                  let account = args["account"] as? String else {
                result(false)
                return
            }

            let retrievedString = KeychainHelper.get(forService: service, account: account)
            result(retrievedString)
        } else if call.method == "delete" {
            guard let args = call.arguments as? [String: Any],
                  let service = args["service"] as? String,
                  let account = args["account"] as? String else {
                result(false)
                return
            }
            result(KeychainHelper.delete(forService: service, account: account))
        } else {
            result(FlutterMethodNotImplemented)
        }
    }
}
