//
//  AppCoordinator.swift
//  github-repositories
//
//  Created by vlsuv on 05.08.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator {
    
    // MARK: - Properties
    private(set) var childCoordinators: [Coordinator] = []
    
    private let window: UIWindow
    
    private let navigationController: UINavigationController
    
    // MARK: - Init
    init(window: UIWindow, navigationController: UINavigationController = UINavigationController()) {
        self.window = window
        self.navigationController = navigationController
    }
    
    // MARK: - Handlers
    func start() {
        let searchCoordinator = SearchCoordinator(navigationController: navigationController)
        searchCoordinator.start()
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
