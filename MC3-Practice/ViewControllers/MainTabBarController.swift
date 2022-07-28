//
//  MainTabBarController.swift
//  MC3-Practice
//
//  Created by Kim Insub on 2022/07/27.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: UserViewController())

        vc1.tabBarItem.image = UIImage(systemName: "music.note.house.fill")
        vc2.tabBarItem.image = UIImage(systemName: "person.fill")

        vc1.title = "Home"
        vc2.title = "User"

        tabBar.tintColor = .label

        setViewControllers([vc1, vc2], animated: true)
    }
}
