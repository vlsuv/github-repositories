//
//  DownloadCoordinator.swift
//  github-repositories
//
//  Created by vlsuv on 05.08.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

class DownloadCoordinator: Coordinator {
    
    // MARK: - Properties
    private(set) var childCoordinators: [Coordinator] = []
    
    var parentCoordinator: Coordinator?
    
    private let navigationController: UINavigationController
    
    private let assemblyBuilder: AssemblyModuleBuilderProtocol
    
    // MARK: - Init
    init(navigationController: UINavigationController, assemblyBuilder: AssemblyModuleBuilderProtocol = AssemblyModuleBuilder()) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }
    
    deinit {
        print("deinit: \(self)")
    }
    
    // MARK: - Handlers
    func start() {
        let downloadController = assemblyBuilder.createDownloadController(coordinator: self)
        
        navigationController.pushViewController(downloadController, animated: true)
    }
    
    func viewDidDisappear() {
        parentCoordinator?.childDidFinish(self)
    }
}
