//
//  AssemblyModuleBuilder.swift
//  github-repositories
//
//  Created by vlsuv on 05.08.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

protocol AssemblyModuleBuilderProtocol {
    func createSearchController(coordinator: SearchCoordinator) -> UIViewController
    func createDownloadController(coordinator: DownloadCoordinator) -> UIViewController
}

final class AssemblyModuleBuilder: AssemblyModuleBuilderProtocol {
    func createSearchController(coordinator: SearchCoordinator) -> UIViewController {
        let view = SearchController()
        let presenter = SearchPresenter(view: view, coordinator: coordinator)
        view.presenter = presenter
        return view
    }
    
    func createDownloadController(coordinator: DownloadCoordinator) -> UIViewController {
        let view = DownloadsController()
        let presenter = DownloadPresenter(view: view, coordinator: coordinator)
        view.presenter = presenter
        return view
    }
}
