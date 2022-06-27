import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    GeneratedPluginRegistrant.register(with: self)
    [GMSServices provideAPIKey:@"AIzaSyBCMfjbP_2xy5TY5t6ILqNgFadSuBRDeEY"];
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
