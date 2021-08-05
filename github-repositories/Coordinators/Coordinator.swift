//
//  Coordinator.swift
//  github-repositories
//
//  Created by vlsuv on 05.08.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import Foundation

protocol Coordinator: class {
    var childCoordinators: [Coordinator] { get }
    func childDidFinish(_ childCoordinator: Coordinator)
    
    func start()
}
extension Coordinator {
    func childDidFinish(_ childCoordinator: Coordinator) {}
}
