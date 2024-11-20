import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let homeVC = HomeViewController()
        let navController = UINavigationController(rootViewController: homeVC)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        return true
    }
}

