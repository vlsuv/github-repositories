//
//  SearchPresenter.swift
//  github-repositories
//
//  Created by vlsuv on 05.08.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

protocol SearchViewProtocol: class {
    func succes()
    func failure()
}

protocol SearchPresenterType {
    var repositories: [Repository] { get }
    func didSelectRepo(at indexPath: IndexPath)
    func didTapGet(at indexPath: IndexPath)
    func didTapDownloads()
}

class SearchPresenter: SearchPresenterType {
    
    // MARK: - Properties
    private weak var view: SearchViewProtocol?
    
    private var coordinator: SearchCoordinator?
    
    private var apiManager: APIManagerProtocol
    
    var repositories: [Repository] = []
    
    // MARK: - Init
    init(view: SearchViewProtocol, coordinator: SearchCoordinator, apiManager: APIManagerProtocol = APIManager()) {
        self.view = view
        self.apiManager = apiManager
        self.coordinator = coordinator
    }
    
    // MARK: - Handlers
    func didSelectRepo(at indexPath: IndexPath) {
        let repository = repositories[indexPath.row]
        
        guard let url = URL(string: repository.htmlURL) else { return }
        
        coordinator?.showSafari(for: url)
    }
    
    func didTapSearch(with query: String) {
        apiManager.fetchRepositories(for: query) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .Succes(let repos):
                    self?.repositories = repos
                    
                    self?.view?.succes()
                case .Failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func didTapGet(at indexPath: IndexPath) {
        let repository = repositories[indexPath.row]
        
        DownloadManager.shared.getZip(for: repository)
    }
    
    func didTapDownloads() {
        coordinator?.showDownloads()
    }
}
