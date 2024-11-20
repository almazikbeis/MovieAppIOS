import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Настраиваем контроллеры для каждой вкладки
        let collectionVC = UINavigationController(rootViewController: HomeViewController())
        collectionVC.tabBarItem = UITabBarItem(title: "Коллекция", image: UIImage(systemName: "film"), tag: 0)
        
        let searchVC = UINavigationController(rootViewController: SearchViewController())
        searchVC.tabBarItem = UITabBarItem(title: "Поиск", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        
        let accountVC = UINavigationController(rootViewController: AccountViewController())
        accountVC.tabBarItem = UITabBarItem(title: "Аккаунт", image: UIImage(systemName: "person"), tag: 2)
        
        let moreVC = UINavigationController(rootViewController: MoreViewController())
        moreVC.tabBarItem = UITabBarItem(title: "Еще", image: UIImage(systemName: "ellipsis.circle"), tag: 3)
        
        // Добавляем контроллеры во вкладки
        viewControllers = [collectionVC, searchVC, accountVC, moreVC]
        
        // Настраиваем стиль TabBar
        configureTabBarAppearance()
    }
    
    private func configureTabBarAppearance() {
        // Настраиваем внешний вид для iOS 15 и новее
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .black // Устанавливаем черный фон
            
            // Настраиваем цвета иконок и текста
            appearance.stackedLayoutAppearance.selected.iconColor = .orange
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.orange]
            appearance.stackedLayoutAppearance.normal.iconColor = .gray
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.gray]
            
            // Применяем стиль
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        } else {
            // Для более старых версий iOS
            tabBar.tintColor = .orange
            tabBar.unselectedItemTintColor = .gray
            tabBar.barTintColor = .black
        }
    }
}


