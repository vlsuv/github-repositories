//
//  ViewController.swift
//  github-repositories
//
//  Created by vlsuv on 04.08.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit
import SafariServices

class SearchController: UIViewController {
    
    // MARK: - Properties
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.sizeToFit()
        searchBar.delegate = self
        searchBar.showsCancelButton = false
        return searchBar
    }()
    
    private var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = Color.black
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    private var apiManager: APIManagerProtocol = APIManager()
    
    var repositories: [Repository] = []
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.white
        
        configureNavigationController()
        configureTableView()
        configureActivityIndicator()
    }
    
    // MARK: - Targets
    @objc private func didTapDownloadsButton(_ sender: UIBarButtonItem) {
        let downloadsController = DownloadsController()
        
        navigationController?.pushViewController(downloadsController, animated: true)
    }
    
    // MARK: - Configures
    private func configureNavigationController() {
        navigationItem.titleView = searchBar
        
        let downloadsButton = UIBarButtonItem(image: Image.squareAndArrowDownFill, style: .plain, target: self, action: #selector(didTapDownloadsButton(_:)))
        
        navigationItem.leftBarButtonItem = downloadsButton
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(RepositoryCell.self, forCellReuseIdentifier: RepositoryCell.identifier)
        
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         left: view.leftAnchor,
                         right: view.rightAnchor,
                         bottom: view.bottomAnchor)
    }
    
    private func configureActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}

// MARK: - UITableViewDataSource
extension SearchController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryCell.identifier, for: indexPath) as? RepositoryCell else { return UITableViewCell() }
        
        let repository = repositories[indexPath.row]
        cell.configure(repository)
        cell.delegate = self
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SearchController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let repository = repositories[indexPath.row]
        
        guard let url = URL(string: repository.htmlURL) else { return }
        
        let safariViewController = SFSafariViewController(url: url)
        
        present(safariViewController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
}

// MARK: - UISearchBarDelegate
extension SearchController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        
        searchBar.showsCancelButton = false
        
        searchBar.resignFirstResponder()
        
        activityIndicator.startAnimating()
        
        apiManager.fetchRepositories(for: query) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .Succes(let repos):
                    self?.repositories = repos
                    
                    self?.tableView.reloadData()
                case .Failure(let error):
                    print(error)
                }
                
                self?.activityIndicator.stopAnimating()
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.searchTextField.resignFirstResponder()
        
        searchBar.searchTextField.text = ""
        
        searchBar.showsCancelButton = false
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
}

// MARK: - RepositoryCellDelegate
extension SearchController: RepositoryCellDelegate {
    func didTapGetButton(cell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        let repository = repositories[indexPath.row]
        
        DownloadManager.shared.getZip(for: repository)
    }
}
