//
//  DownloadPresenter.swift
//  github-repositories
//
//  Created by vlsuv on 05.08.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

protocol DownloadViewProtocol: class {
    func reloadRows(at indexPaths: [IndexPath])
    func reloadView()
}

protocol DownloadPresenterType {
    var downloads: [Download] { get }
    func viewDidDisappear()
}

class DownloadPresenter: DownloadPresenterType {
    
    // MARK: - Properties
    private weak var view: DownloadViewProtocol?
    
    private var coordinator: DownloadCoordinator?
    
    var downloads: [Download] = []
    
    // MARK: - Init
    init(view: DownloadViewProtocol, coordinator: DownloadCoordinator) {
        self.view = view
        self.coordinator = coordinator
        
        getDownloads()
    }
    
    deinit {
        print("deinit: \(self)")
    }
    
    // MARK: - Handlers
    func viewDidDisappear() {
        coordinator?.viewDidDisappear()
    }
    
    func getDownloads() {
        downloads = DownloadManager.shared.downloads
        
        DownloadManager.shared.didFinishDownload = { [weak self] download in
            
            guard let index = self?.downloads.firstIndex(where: { $0.repository.name == download.repository.name }) else { return }
            
            let indexPath = IndexPath(row: index, section: 0)
            
            self?.view?.reloadRows(at: [indexPath])
        }
    }
    
    func didTapClear() {
        DownloadManager.shared.deleteDownloads()
        
        downloads = []
        
        view?.reloadView()
    }
}
