//
//  SearchCoordinator.swift
//  github-repositories
//
//  Created by vlsuv on 05.08.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit
import SafariServices

class SearchCoordinator: Coordinator {
    
    // MARK: - Properties
    private(set) var childCoordinators: [Coordinator] = []
    
    private let navigationController: UINavigationController
    
    private let assemblyBuilder: AssemblyModuleBuilderProtocol
    
    // MARK: - Init
    init(navigationController: UINavigationController, assemblyBuilder: AssemblyModuleBuilderProtocol = AssemblyModuleBuilder()) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }
    
    // MARK: - Handlers
    func start() {
        let searchController = assemblyBuilder.createSearchController(coordinator: self)
        
        navigationController.viewControllers = [searchController]
    }
    
    func showSafari(for url: URL) {
        let safariViewController = SFSafariViewController(url: url)
        
        navigationController.present(safariViewController, animated: true, completion: nil)
    }
    
    func showDownloads() {
        let downloadCoordinator = DownloadCoordinator(navigationController: navigationController)
        
        childCoordinators.append(downloadCoordinator)
        downloadCoordinator.parentCoordinator = self
        
        downloadCoordinator.start()
    }
    
    func childDidFinish(_ childCoordinator: Coordinator) {
        guard let index = childCoordinators.firstIndex(where: { $0 === childCoordinator }) else { return }
        
        childCoordinators.remove(at: index)
    }
}
