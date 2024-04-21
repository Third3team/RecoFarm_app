import UIKit
import Flutter
import GoogleMaps
/*
  Description : IOS setting 
  Date        : 2024.04.21 Sun
  Author      : Forrest DongGeun Park. (PDG)
  Updates     : 
	  2024.04.21 Sun by pdg
		  - google map setting 을 위한 ios 설정 추가 
  Detail      : - 

*/
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: 
    [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
        GMSServices.provideAPIKey("AIzaSyDslR-okT6JXHWhMmrOXaNxXhA6C0LxJHo")
        GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
