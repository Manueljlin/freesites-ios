/*
 *  Copyright 2023 -- Manuel Jesús de la Fuente Pereira
 *
 *  Use of this source code is governed by an MIT-style
 *  license that can be found in the LICENSE file or at
 *  https://opensource.org/licenses/MIT.
 */


import SwiftUI


class AppDelegateCoordinator: NSObject, UIApplicationDelegate {
  let apnsTokenService: ApnsTokenService

  init(apnsTokenService: ApnsTokenService) {
    self.apnsTokenService = apnsTokenService
    super.init()
  }
}


@main
struct RestauranteApp: App {
  
  //--------------------------------------------------------------------------//
  // Legacy cruft required to enable notifications /jk :D
  
  @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
  private let apnsTokenService: ApnsTokenService
  
  
  //--------------------------------------------------------------------------//
  // View Models
  
  @StateObject private var sharedAccountViewModel:    AccountViewModel
  @StateObject private var sharedRestaurantViewModel: RestaurantViewModel
  
  
  //--------------------------------------------------------------------------//
  // Custom ViewModel(s) init to enable dependency injection
  
  init() {
    let accountTokenService = AccountTokenService(tokenKey: "accountToken")
    let apnsTokenService    = ApnsTokenService(tokenKey: "apnsToken")
    self.apnsTokenService   = apnsTokenService // to pass to AppDelegate
    let gpsLocationService  = GpsLocationService()
    
    // inject in apiService
    
    let apiService          = NetworkApiService(
      baseUrl: "https://test2.qastusoft.com.es/free_site2/public/v1",
//      baseUrl: "https://justbackend-production.up.railway.app/api/v1",
      accountTokenService: accountTokenService,
      apnsTokenService: apnsTokenService
    )
    
    // inject in VMs
    let accountViewModel    = AccountViewModel(apiService: apiService)
    let restaurantViewModel = RestaurantViewModel(
      apiService: apiService,
      locationService: gpsLocationService
    )
    
    // initialize the property wrapper by hand
    self._sharedAccountViewModel    = StateObject(wrappedValue: accountViewModel)
    self._sharedRestaurantViewModel = StateObject(wrappedValue: restaurantViewModel)
  }
  
  
  //--------------------------------------------------------------------------//
  // View
  
  var body: some Scene {
    WindowGroup {
      Group {
        if self.sharedAccountViewModel.logged {
          MainView()
            .environmentObject(self.sharedAccountViewModel)
            .environmentObject(self.sharedRestaurantViewModel)
        } else {
          LoginView()
            .environmentObject(self.sharedAccountViewModel)
        }
      }
      .onAppear {
        self.appDelegate.apnsTokenService    = self.apnsTokenService
        self.appDelegate.restaurantViewModel = self.sharedRestaurantViewModel
      }
    }
  }
}


//----------------------------------------------------------------------------//
// Push notifications setup

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
  
  public var apnsTokenService: ApnsTokenService?
  public var restaurantViewModel: RestaurantViewModel?
  
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
  ) -> Bool {
    self.askPerms()

    return true
  }
  
  
  //--------------------------------------------------------------------------//
  // Getting the perms
  
  //
  // First, we ask the user for push notification permissions
  func askPerms() {
    let notifCenter = UNUserNotificationCenter.current()
    notifCenter.delegate = self
    
    // literally as soon as the app opens lol
    // ux 9000
    notifCenter.requestAuthorization(options: [.alert]) { granted, error in
      if error != nil {
        print("[ERROR] AppDelegate: Notification permission error\n\(error!)")
      }
      guard granted else {
        print("[ERROR] AppDelegate: Notification permission not granted")
        return
      }
      
      DispatchQueue.main.async {
        self.setPushSettings()
      }
      
      print("[OK]    AppDelegate: Notification permission granted\n")
    }
  }
  
  
  //
  // After the user grants the push notification permissions, we register
  // the device in APNs
  func setPushSettings() {
    UNUserNotificationCenter.current().getNotificationSettings { settings in
      guard settings.authorizationStatus == .authorized else {
        print("[INFO]  AppDelegate: Notification permission not granted (yet, at least)")
        return
      }
      
      DispatchQueue.main.async {
        UIApplication.shared.registerForRemoteNotifications()
        print("[INFO]  AppDelegate: Attempting to register device in APNs")
      }
    }
  }
  
  
  //
  // After we get registered in APNs, we store the token
  func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    print("[INFO]  AppDelegate: Got token! -- \(deviceToken.formattedApnsToken())")
    self.apnsTokenService?.setToken(deviceToken)
  }

  
  //
  // If we couldn't get registered in APNs, we print a shitty log instead. Too bad.
  func application(
    _ application: UIApplication,
    didFailToRegisterForRemoteNotificationsWithError error: Error
  ) {
    print("[ERROR] AppDelegate: Couldn't register in APNs:\n\(error)")
  }
  
  
  //--------------------------------------------------------------------------//
  // Intercepting the notifications
  
  func application(
    _ application: UIApplication,
    didReceiveRemoteNotification userInfo: [AnyHashable : Any],
    fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
  ) {
    print("[INFO]  AppDelegate: Got new notification")
    
    guard let aps = userInfo["aps"] as? [String: AnyObject] else {
      completionHandler(.failed)
      return
    }
    
    // This will execute stuff on both background and foreground
    if let _ = aps["content-available"] {
      if let contentUpdated = userInfo["content-updated"] as? Bool, contentUpdated {
        print("[INFO]  AppDelegate: Notification marked as updating reservation content. Firing events...")
        self.restaurantViewModel?.fetchReservations() // poor mans websocket :p
      }
    }
  }
  

  //--------------------------------------------------------------------------//
  // This might be useful
  
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    completionHandler([.banner, .badge, .sound])
    
    print("[INFO]  AppDelegate: You might want to do something with this, future me")
  }
}
